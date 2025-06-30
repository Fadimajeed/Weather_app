

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/search_bloc.dart';
import 'package:weather_app/bloc/weather_loctaion_bloc.dart';
import 'package:weather_app/shapes/sun.dart';
import 'package:weather_app/shapes/cloud.dart';
import 'package:weather_app/shapes/rain.dart';
import 'package:weather_app/shapes/snow.dart';
import 'package:weather_app/shapes/thunderstorm.dart';
import 'package:weather_app/shapes/moon.dart';

class AllShapes extends StatelessWidget {
  const AllShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherSearchBloc, WeatherSearchState>(
      builder: (context, searchState) {
        return BlocBuilder<WeatherLoctaionBloc, WeatherLoctaionState>(
          builder: (context, locationState) {
            Weather? weatherData;
            bool isNight = false; 

            // Prioritize search results if available
            if (searchState is WeatherSearchLoaded) {
              weatherData = searchState.weather;
            } 
            // Fall back to location weather
            else if (locationState is WeatherLoctaionSuccess) {
              weatherData = locationState.weather;
            }

            if (weatherData == null) {
              return Container(); // Or a default empty state
            }

            // Determine if it's night // didn't use the weather call here becase i made it wrong in the sunset_arc
           
            final now = DateTime.now();
            if (now.hour < 6 || now.hour >= 18) {
              isNight = true;
            }

            // Get main weather condition
            final String? weatherMain = weatherData.weatherMain?.toLowerCase();

            // Define a size for the CustomPaint widget
            const Size shapeSize = Size(110, 100); 

            Widget currentShapeWidget;

            switch (weatherMain) {
              case 'clear':
                currentShapeWidget = CustomPaint(
                  size: shapeSize,
                  painter: isNight ? MoonPainter() : SunPainter(),
                );
                break;
              case 'clouds':
              case 'drizzle':
              case 'mist':
              case 'fog':
              case 'haze':
                currentShapeWidget = CustomPaint(
                  size: shapeSize,
                  painter: CloudPainter(),
                );
                break;
              case 'rain':
                currentShapeWidget = CustomPaint(
                  size: shapeSize,
                  painter: RainPainter(),
                );
                break;
              case 'snow':
                currentShapeWidget = CustomPaint(
                  size: shapeSize,
                  painter: SnowPainter(),
                );
                break;
              case 'thunderstorm':
                currentShapeWidget = CustomPaint(
                  size: shapeSize,
                  painter: ThunderstormPainter(),
                );
                break;
              default:
                currentShapeWidget = Container(); 
                break;
            }

            return currentShapeWidget;
          },
        );
      },
    );
  }
}


