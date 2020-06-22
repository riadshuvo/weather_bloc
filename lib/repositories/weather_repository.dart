

import 'package:flutter/cupertino.dart';
import 'package:weather_bloc/model/weather.dart';
import 'package:weather_bloc/repositories/repositories.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient}):assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async{
    final int getLocationId = await weatherApiClient.getLocationId(city);
    return weatherApiClient.fetchWeather(getLocationId);
  }

}