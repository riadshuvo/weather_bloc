
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/model/weather.dart';
import 'package:weather_bloc/repositories/repositories.dart';
import 'blocs_file.dart';

class WeatherBloc extends Bloc<WeatherEvent,WeatherState>{
  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository}) : assert (weatherRepository != null);

  @override
  // TODO: implement initialState
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherRequested) {
      yield* _mapWeatherRequestedToState(event);
    } else if (event is WeatherRefreshRequested) {
      yield* _mapWeatherRefreshRequestedToState(event);
    }
  }

  Stream<WeatherState> _mapWeatherRequestedToState(WeatherRequested event) async* {
    yield WeatherLoadInProgress();
    try {
      final Weather weather = await weatherRepository.getWeather(event.city);
      yield WeatherLoadSuccess(weather: weather);
    } catch (_) {
      yield WeatherLoadFailure();
    }
  }

  Stream<WeatherState> _mapWeatherRefreshRequestedToState(WeatherRefreshRequested event) async* {
    try {
      final Weather weather = await weatherRepository.getWeather(event.city);
      yield WeatherLoadSuccess(weather: weather);
    } catch (_) {
      yield state;
    }
  }

}