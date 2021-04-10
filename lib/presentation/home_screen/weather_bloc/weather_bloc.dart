import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/data/datasources/local_data_source.dart';
import 'package:interview_app/data/datasources/network_data_source.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:interview_app/domain/repositories_contracts/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const String MESSAGE_SERVER_FAILURE =
    'Error while fetching weather data from the server.';
const String MESSAGE_CASHE_FAILURE =
    'Error while fetching local data or no local data stored!';
const String MESSAGE_UNKNOWN = 'Unknown error occurred.';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({
    required this.weatherRepository,
  }) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      print(event.city);
      final data = await weatherRepository.getWeatherData(event.city);
      yield data.fold(
        (failure) => WeatherError(_failureToMessage(failure)),
        (weatherData) => WeatherLoaded(weatherData),
      );
    }
  }

  String _failureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return MESSAGE_SERVER_FAILURE;
      case CasheFailure:
        return MESSAGE_CASHE_FAILURE;
      default:
        return MESSAGE_UNKNOWN;
    }
  }
}
