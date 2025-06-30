part of 'weather_loctaion_bloc.dart';

@immutable
sealed class WeatherLoctaionEvent {
  const WeatherLoctaionEvent();
  
 
  List<Object> get props => [];
  }
  class FetchWeatherLoctaion extends WeatherLoctaionEvent {
    final  Position position;
    const FetchWeatherLoctaion(this.position);
    @override
    List<Object> get props => [position];
  }