import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/search_bloc.dart';

import 'package:weather/weather.dart';

import 'package:weather_app/bloc/weather_loctaion_bloc.dart';

class WeatherBackground extends StatelessWidget {
  final Widget child;

  const WeatherBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherSearchBloc, WeatherSearchState>(
      builder: (context, searchState) {
        return BlocBuilder<WeatherLoctaionBloc, WeatherLoctaionState>(
          builder: (context, locationState) {
            // Determine which weather to use
            Weather? weatherData;

            // Prioritize search results if available
            if (searchState is WeatherSearchLoaded) {
              weatherData = searchState.weather;
            }
            // Fall back to location weather
            else if (locationState is WeatherLoctaionSuccess) {
              weatherData = locationState.weather;
            }

            Color startColor = Colors.purple; // Default
            Color endColor = Colors.pink; // Default

            if (weatherData != null) {
              final main = weatherData.weatherMain?.toLowerCase() ?? "";

              switch (main) {
                case 'clouds':
                  startColor = Colors.grey;
                  endColor = Colors.lightBlue;
                  break;
                case 'clear':
                  startColor = Colors.blue;
                  endColor = Colors.lightGreen;
                  break;
                case 'rain':
                  startColor = Colors.blue;
                  endColor = const Color.fromARGB(255, 152, 143, 143);
                  break;
                case 'thunderstorm':
                  startColor = Colors.yellow;
                  endColor = const Color.fromARGB(255, 71, 69, 69);
                  break;
                case 'snow':
                  // WHITE for snow
                  startColor = Colors.blueAccent;
                  endColor = Colors.grey.shade200;
                  break;
                case 'mist':
                case 'fog':
                case 'haze':
                  startColor = Colors.orange;
                  endColor = Colors.deepOrange;
                  break;
                default:
                  startColor = Colors.purple;
                  endColor = Colors.deepPurple;
              }
            }
            return Stack(
              children: [
                // Background gradient
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [startColor, endColor],
                    ),
                  ),
                ),
                //
                child,
              ],
            );
          },
        );
      },
    );
  }
}
