import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/search_bloc.dart';

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const WeatherSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter city name',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final city = controller.text.trim();
                if (city.isNotEmpty) {
                  context.read<WeatherSearchBloc>().add(SearchCityWeather(city));
                }
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<WeatherSearchBloc, WeatherSearchState>(
          builder: (context, state) {
            if (state is WeatherSearchLoading) {
              return const CircularProgressIndicator();
            } else if (state is WeatherSearchLoaded) {
              return Text(
                'Weather in ${state.weather.areaName}: ${state.weather.temperature?.celsius?.toStringAsFixed(1)}°C',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            } else if (state is WeatherSearchError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
