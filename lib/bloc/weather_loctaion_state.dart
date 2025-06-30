part of 'weather_loctaion_bloc.dart';

@immutable
sealed class WeatherLoctaionState {
  const WeatherLoctaionState();

  List<Object> get props => [];
}

final class WeatherLoctaionInitial extends WeatherLoctaionState {}
final class WeatherLoctaionSuccess extends WeatherLoctaionState {
  
  final Weather weather;
  const WeatherLoctaionSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}
final class WeatherLoctaionError extends WeatherLoctaionState {
  WeatherLoctaionError(String s);
}
final class WeatherLoctaionLoading extends WeatherLoctaionState {}