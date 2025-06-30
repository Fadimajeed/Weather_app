part of 'search_bloc.dart';


@immutable
abstract class WeatherSearchEvent {}

class SearchCityWeather extends WeatherSearchEvent {
  final String cityName;

  SearchCityWeather(this.cityName);
}
