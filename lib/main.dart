
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart'; 
import 'package:weather_app/bloc/search_bloc.dart';
import 'package:weather_app/bloc/weather_loctaion_bloc.dart';
import 'package:weather_app/main_screens/home_screen.dart';

// .env file to hide API key
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("Dotenv loaded successfully.");
    print("API_KEY from env: ${dotenv.env['API_KEY']}");
  } catch (e) {
    print("Error loading .env file: $e"); 
  }

  final String? apiKey = dotenv.env['API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    print('ERROR: API_KEY not found or is empty.');
   
    return;
  }

  // Initialize WeatherFactory with the API key
  final WeatherFactory weatherFactory = WeatherFactory(apiKey, language: Language.ENGLISH);

  runApp(MyApp(weatherFactory: weatherFactory)); // Pass WeatherFactory to MyApp
}

class MyApp extends StatelessWidget {
  final WeatherFactory weatherFactory; 

  const MyApp({super.key, required this.weatherFactory}); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Position>(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            print("Error getting location: ${snapshot.error}");
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (snapshot.hasData) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<WeatherLoctaionBloc>(
                  create: (context) => WeatherLoctaionBloc(weatherFactory: weatherFactory) // Pass WeatherFactory
                    ..add(FetchWeatherLoctaion(snapshot.data as Position)),
                ),
                BlocProvider<WeatherSearchBloc>(
                  create: (context) => WeatherSearchBloc(weatherFactory: weatherFactory), // Pass WeatherFactory
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('Could not get location.')),
            );
          }
        },
      ),
    );
  }



// this is the package from geolocator and i need it to get the current location
///////////////////////////////////////////////
  Future<Position> _determinePosition() async {
    // ... (your existing _determinePosition method)
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
////////////////////////////////////////////////////