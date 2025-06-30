
import 'package:bloc/bloc.dart' as bloc_lib; 
import 'package:meta/meta.dart';
import 'package:weather/weather.dart';

part 'search_event.dart';
part 'search_state.dart';

class WeatherSearchBloc extends bloc_lib.Bloc<WeatherSearchEvent, WeatherSearchState> { // <--- Use bloc_lib.Bloc here
  final WeatherFactory weatherFactory;

  WeatherSearchBloc({required this.weatherFactory}) : super(WeatherSearchInitial()) {
    on<SearchCityWeather>(_onSearchCityWeather);
  }

  Future<void> _onSearchCityWeather(
    SearchCityWeather event,
    bloc_lib.Emitter<WeatherSearchState> emit,
  ) async {
    if (event.cityName.isEmpty) {
      emit(WeatherSearchError('City name cannot be empty.'));
      return;
    }
    emit(WeatherSearchLoading());
    try {
      print('BLOC (Search): Searching weather for city: ${event.cityName}');
      final Weather weather = await weatherFactory.currentWeatherByCityName(event.cityName);
      final List<Weather> forecast = await weatherFactory.fiveDayForecastByCityName(event.cityName);
      print('BLOC (Search): Weather fetched successfully for ${event.cityName}. Forecast items: ${forecast.length}');
      emit(WeatherSearchLoaded(weather, forecast));
    } catch (e) {
      print('BLOC (Search): Error fetching weather for ${event.cityName}: $e');
      emit(WeatherSearchError('Failed to fetch weather for ${event.cityName}. Error: ${e.toString()}'));
    }
  }
}
