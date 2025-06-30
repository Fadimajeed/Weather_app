import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
part 'weather_loctaion_event.dart';
part 'weather_loctaion_state.dart';

class WeatherLoctaionBloc
    extends Bloc<WeatherLoctaionEvent, WeatherLoctaionState> {
  final WeatherFactory weatherFactory;

  WeatherLoctaionBloc({required this.weatherFactory})
    : super(WeatherLoctaionInitial()) {
    on<FetchWeatherLoctaion>((event, emit) async {
      emit(WeatherLoctaionLoading());
      try {
        final weather = await weatherFactory.currentWeatherByLocation(
          event.position.latitude,
          event.position.longitude,
        );
        emit(WeatherLoctaionSuccess(weather));
      } catch (e) {
        emit(WeatherLoctaionError('Failed to fetch weather: ${e.toString()}'));
      }
    });
  }
}
