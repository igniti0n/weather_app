import 'package:dartz/dartz.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/domain/entities/weather_data.dart';

abstract class WeatherRepository {
  const WeatherRepository();
  Future<Either<Failure, WeatherData>> getWeatherData(String city);
}
