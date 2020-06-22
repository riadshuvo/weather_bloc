import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/blocs/blocs_file.dart';
import 'package:weather_bloc/blocs/theme_bloc.dart';
import 'package:weather_bloc/widgets/widgets.dart';
import 'dart:async';

class WeatherUI extends StatefulWidget {
  @override
  _WeatherUIState createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                BlocProvider.of<WeatherBloc>(context)
                    .add(WeatherRequested(city: city));
              }
            },
          )
        ],
      ),
      body: Center(
        child: BlocListener<WeatherBloc,WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoadSuccess) {
              if (state is WeatherLoadSuccess) {
                BlocProvider.of<ThemeBloc>(context).add(
                  WeatherChanged(condition: state.weather.condition),
                );
              }
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherInitial) {
                return Center(child: Text('Please Select a Location'));
              }
              if (state is WeatherLoadInProgress) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is WeatherLoadSuccess) {
                final weather = state.weather;

                return BlocBuilder<ThemeBloc,ThemeState>(
                  builder: (context, themeState){
                   return GradientContainer(
                     color: themeState.color,
                      child: RefreshIndicator(
                        onRefresh: () {
                          BlocProvider.of<WeatherBloc>(context).add(
                              WeatherRefreshRequested(city: weather.location));
                          return _refreshCompleter.future;
                        },
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100.0),
                              child: Center(
                                child: Location(location: weather.location),
                              ),
                            ),
                            Center(
                              child: LastUpdated(dateTime: weather.lastUpdated),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 50.0),
                              child: Center(
                                child: CombinedWeatherTemperature(
                                  weather: weather,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is WeatherLoadFailure) {
                return Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                );
              }
              return Center(
                child: Text("there has some errors"),
              );
            },
          ),
        ),
      ),
    );
  }
}
