import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class ForecastCard extends StatelessWidget {
  final Weather weather;
  
  const ForecastCard({required this.weather, super.key});

  IconData _getWeatherIcon(String? weatherMain) {
    switch (weatherMain?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.cloud_queue; 
      case 'drizzle':
        return Icons.cloud_queue; 
      case 'thunderstorm':
        return Icons.flash_on; 
      case 'snow':
        return Icons.ac_unit; 
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on; 
      default:
        return Icons.cloud_outlined; 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Mon, Tue, etc.
    final dateText = DateFormat('E').format(weather.date!); 
    final tempText = '${weather.temperature?.celsius?.round() ?? "--"}°';
    final weatherIcon = _getWeatherIcon(weather.weatherMain);

    return Container(
      width: 80, 
      margin: const EdgeInsets.symmetric(horizontal: 4.0), 
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.4), 
        borderRadius: BorderRadius.circular(15), 
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            dateText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            weatherIcon,
            color: Colors.white,
            size: 30,
          ),
          Text(
            tempText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
