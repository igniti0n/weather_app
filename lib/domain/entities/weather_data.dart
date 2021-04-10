import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final String city;
  final String prediction;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double pressure;
  final double humidity;

  const WeatherData({
    required this.city,
    required this.humidity,
    required this.pressure,
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.prediction,
  });

  @override
  List<Object?> get props => [
        city,
        temperature,
        pressure,
        humidity,
        tempMax,
        tempMin,
        prediction,
      ];
}
