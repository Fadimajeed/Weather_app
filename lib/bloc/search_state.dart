part of 'search_bloc.dart';

@immutable
abstract class WeatherSearchState {}

class WeatherSearchInitial extends WeatherSearchState {}

class WeatherSearchLoading extends WeatherSearchState {}

// State holds the Weather object from the 'weather' package
class WeatherSearchLoaded extends WeatherSearchState {
  final Weather weather;
  final List <Weather> forecast;

  WeatherSearchLoaded(this.weather, this.forecast);
}

class WeatherSearchError extends WeatherSearchState {
  final String message;

  WeatherSearchError(this.message);
}