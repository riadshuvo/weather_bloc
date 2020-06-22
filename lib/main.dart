
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/repositories/repositories.dart';
import 'package:weather_bloc/simple_bloc_delegate.dart';
import 'package:http/http.dart' as http;

import 'blocs/theme_bloc.dart';
import 'blocs/weather_bloc.dart';
import 'model/weather.dart';
import 'package:weather_bloc/widgets/widgets.dart';
import '';

void main(){
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
    )
  );
  runApp(BlocProvider<ThemeBloc>(
    create: (context) => ThemeBloc(),
    child: App(weatherRepository: weatherRepository),
  ),);
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  App({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Weather',
          home: BlocProvider(
            create: (context) =>
                WeatherBloc(weatherRepository: weatherRepository),
            child: WeatherUI(),
          ),
        );
      },
    );
  }
}
