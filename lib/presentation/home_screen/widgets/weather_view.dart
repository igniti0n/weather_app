import 'package:flutter/material.dart';

import '../../../domain/entities/weather_data.dart';
import 'data_visualizer.dart';
import 'details_visualizer.dart';

class WeatherView extends StatefulWidget {
  final WeatherData weatherData;
  final ThemeData theme;
  const WeatherView({
    Key? key,
    required this.weatherData,
    required this.theme,
  }) : super(key: key);

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 1000,
        ));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            widget.weatherData.city,
            style: widget.theme.textTheme.headline1,
          ),
          DataVisualizer(
            title: "Temperature",
            data: widget.weatherData.temperature,
            maxTemperature: widget.weatherData.tempMax,
            minTemperature: widget.weatherData.tempMin,
            theme: widget.theme,
            animationController: _animationController,
            beginAnimating: 0,
            endAnimating: .3,
          ),
          DataVisualizer(
            title: "Maximum",
            data: widget.weatherData.tempMax,
            maxTemperature: widget.weatherData.tempMax,
            minTemperature: widget.weatherData.tempMin,
            theme: widget.theme,
            animationController: _animationController,
            beginAnimating: 0,
            endAnimating: .6,
          ),
          DataVisualizer(
            title: "Minimum",
            data: widget.weatherData.tempMin,
            maxTemperature: widget.weatherData.tempMax,
            minTemperature: widget.weatherData.tempMin,
            theme: widget.theme,
            animationController: _animationController,
            beginAnimating: 0,
            endAnimating: 1,
          ),
          DetailsVisualizer(
            animationController: _animationController,
            beginAnimating: 0,
            endAnimating: 1,
            theme: widget.theme,
            weatherData: widget.weatherData,
          ),
        ],
      ),
    );
  }
}
