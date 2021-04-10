import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../weather_bloc/weather_bloc.dart';
import 'weather_view.dart';

class WeatherPresentation extends StatelessWidget {
  const WeatherPresentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return SingleChildScrollView(
      child: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            log('Weather state:' + state.toString());

            if (state is WeatherLoading)
              return _buildLoading();
            else if (state is WeatherLoaded)
              return WeatherView(
                weatherData: state.weatherData,
                theme: _theme,
              );
            else if (state is WeatherError)
              return _buildError(state.message, _theme);
            else
              return _buildInitial(_theme);
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message, ThemeData theme) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Text(
            'Uups!',
            style: theme.textTheme.headline1,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            message + '\nPlease check if you entered the city name correctly.',
            style: theme.textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Text(
          'Select a city to see the weather!',
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}
