import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/backscreencolors/allcolors.dart';
import 'package:weather_app/bloc/search_bloc.dart';
import 'package:weather_app/extras/charts.dart';
import 'package:weather_app/bloc/weather_loctaion_bloc.dart';
import 'package:weather_app/extras/forecast.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/shapes/sunset_arc.dart';
import 'package:weather_app/shapes/all_shapes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    print("Home screen build");
    return Scaffold(
      body: WeatherBackground(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<WeatherLoctaionBloc, WeatherLoctaionState>(
                builder: (context, locState) {
                  print(
                    "Location BlocBuilder called with state: ${locState.runtimeType}",
                  );

                  if (locState is WeatherLoctaionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (locState is WeatherLoctaionError) {
                    return const Center(
                      child: Text('Failed to load initial weather data.'),
                    );
                  } else if (locState is WeatherLoctaionSuccess) {
                    Weather initialWeather = locState.weather;

                    return SafeArea(
                      child: SingleChildScrollView(
                        child: BlocBuilder<WeatherSearchBloc, WeatherSearchState>(
                          builder: (context, searchState) {
                            Weather displayWeather =
                                initialWeather; // Default to location weather
                            List<Weather> forecastList =
                                []; // Initialize empty forecast list

                            if (searchState is WeatherSearchLoaded) {
                              displayWeather =
                                  searchState.weather; 
                              forecastList = searchState.forecast;
                            }

                            final DateTime now = DateTime.now();

                            // Prepare data for the chart (next 5 hours)
                            List<double> chartTemperatures = [];
                            List<String> chartTimeLabels = [];

                            // Add current weather as the first point
                            chartTemperatures.add(
                              displayWeather.temperature?.celsius ?? 0.0,
                            );
                            chartTimeLabels.add('Now');

                            // Filter forecast for the Chart (Next 5 hours)
                            int count = 1;
                            for (
                              var i = 0;
                              i < forecastList.length && count < 6;
                              i++
                            ) {
                              final forecastItem = forecastList[i];
                              if (forecastItem.date != null &&
                                  forecastItem.date!.isAfter(now)) {
                                //  take the first 5 available forecast items after 'now'
                                chartTemperatures.add(
                                  forecastItem.temperature?.celsius ?? 0.0,
                                );
                                chartTimeLabels.add(
                                  DateFormat(
                                    'HH:mm',
                                  ).format(forecastItem.date!),
                                );
                                count++;
                              }
                            }

                            while (chartTemperatures.length < 5) {
                              chartTemperatures.add(0.0); // Dummy temperature
                              chartTimeLabels.add(''); // Empty label
                            }
                            // Trim to exactly 5 points if more were collected
                            chartTemperatures = chartTemperatures.sublist(0, 5);
                            chartTimeLabels = chartTimeLabels.sublist(0, 5);

                            String cityName =
                                displayWeather.areaName ?? 'Unknown Location';
                            String conditionText =
                                displayWeather.weatherDescription ?? 'N/A';
                            double currentTemp =
                                displayWeather.temperature?.celsius ?? 0.0;
                            double windSpeed = displayWeather.windSpeed ?? 0.0;
                            int humidity =
                                displayWeather.humidity?.toInt() ?? 0;
                            double tempMax =
                                displayWeather.tempMax?.celsius ?? 0.0;

                            double pressure = displayWeather.pressure ?? 0.0;

                            // Filter forecast for 5 days
                            List<Weather> fiveDayForecast = [];
                            Set<String> seenDays = {};
                            for (var item in forecastList) {
                              String day = DateFormat('yyyy-MM-dd').format(
                                item.date!,
                              ); // Use full date to distinguish days
                              if (!seenDays.contains(day)) {
                                fiveDayForecast.add(item);
                                seenDays.add(day);
                                if (fiveDayForecast.length >= 5)
                                  break; // Get up to 5 unique days
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.search,
                                          size: 28,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showSearchBar = !_showSearchBar;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Search Bar
                                if (_showSearchBar) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter city name',
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 12.0,
                                            ),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () {
                                            final city = _searchController.text
                                                .trim();
                                            if (city.isNotEmpty) {
                                              context
                                                  .read<WeatherSearchBloc>()
                                                  .add(SearchCityWeather(city));
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onSubmitted: (city) {
                                        if (city.trim().isNotEmpty) {
                                          context.read<WeatherSearchBloc>().add(
                                            SearchCityWeather(city.trim()),
                                          );
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                    ),
                                  ),
                                  if (searchState is WeatherSearchLoading)
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: LinearProgressIndicator(),
                                      ),
                                    ),
                                  if (searchState is WeatherSearchError)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          searchState.message,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                ],

                                // City & Date Line
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    cityName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 250, child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20.0,
                                    top: 4.0,
                                    right: 20.0,
                                  ),
                                  child: Text(
                                    'Today  ${DateFormat('dd.MM.yyyy').format(now)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Main Weather Card
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 24.0,
                                          horizontal: 20.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Top row: temperature & icon/details
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Temperature
                                                Text(
                                                  '${currentTemp.round()}°',
                                                  style: const TextStyle(
                                                    fontSize: 60,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        conditionText,
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      AllShapes(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Details:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),

                                // Detail Chips (Wind, Humidity, Max temp, Pressure)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return GridView.count(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            (constraints.maxWidth / 2) /
                                            70, 
                                        mainAxisSpacing: 8.0,
                                        crossAxisSpacing: 8.0,
                                        children: [
                                          _buildDetailChip(
                                            Icons.air,
                                            'Wind',
                                            '${windSpeed.toStringAsFixed(1)} km/h',
                                          ),
                                          _buildDetailChip(
                                            Icons.water_drop,
                                            'Humidity',
                                            '${humidity}%',
                                          ),
                                          _buildDetailChip(
                                            Icons.thermostat_sharp,
                                            'Max temp',
                                            '${tempMax.round()} C',
                                          ),
                                          _buildDetailChip(
                                            Icons.compress,
                                            'Pressure',
                                            '${pressure.round()} hPa',
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Divider(),
                                SizedBox(height: 10),
                                // 5-Day Forecast Section
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fiveDayForecast
                                        .length, // Display up to 5 days
                                    itemBuilder: (context, index) {
                                      return ForecastCard(
                                        weather: fiveDayForecast[index],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(),

                                WeatherLineChart(
                                  temperatures: chartTemperatures,
                                  timeLabels: chartTimeLabels,
                                ),
                                Divider(),
                                SunriseSunsetArcWidget(
                                  sunriseTime: TimeOfDay.fromDateTime(
                                    displayWeather.sunrise!,
                                  ), // Convert to TimeOfDay
                                  sunsetTime: TimeOfDay.fromDateTime(
                                    displayWeather.sunset!,
                                  ),
                                  currentTime: TimeOfDay.now(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
