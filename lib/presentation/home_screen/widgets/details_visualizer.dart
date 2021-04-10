import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../domain/entities/weather_data.dart';

class DetailsVisualizer extends StatelessWidget {
  final WeatherData weatherData;
  final ThemeData theme;
  final AnimationController animationController;
  final double beginAnimating;
  final double endAnimating;
  const DetailsVisualizer({
    Key? key,
    required this.theme,
    required this.weatherData,
    required this.animationController,
    required this.beginAnimating,
    required this.endAnimating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(beginAnimating, endAnimating, curve: Curves.easeInCubic),
    ));

    return AnimatedBuilder(
      animation: opacityAnimation,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: medium,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              padding: EdgeInsets.all(8),
              child: Text(
                weatherData.prediction,
                style: theme.textTheme.headline1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Humidity ',
                  style: theme.textTheme.headline1,
                ),
                SizedBox(
                  width: 100,
                ),
                Text(
                  '${weatherData.humidity}',
                  style: theme.textTheme.headline1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Pressure ',
                  style: theme.textTheme.headline1,
                ),
                SizedBox(
                  width: 100,
                ),
                Text(
                  '${weatherData.pressure}',
                  style: theme.textTheme.headline1,
                ),
              ],
            ),
          ),
        ],
      ),
      builder: (ctx, child) => Opacity(
        opacity: opacityAnimation.value,
        child: child,
      ),
    );
  }
}
