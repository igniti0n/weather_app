// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:interview_app/domain/repositories_contracts/weather_repository.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  MockWeatherRepository mockWeatherRepository;
  WeatherBloc weatherBloc;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(weatherRepository: mockWeatherRepository);
  });

  final String tCity = "New York";
  final WeatherData tWeatherData = WeatherData(
    prediction: 'test',
    city: tCity,
    humidity: 4,
    pressure: 4,
    temperature: 4,
    tempMax: 4,
    tempMin: 4,
  );

  test(
    'should emit [WeatherLoading, WeatherLoaded] states when FetchWeather event happens and data fetching goes well ',
    () async {
      // arrange
      when(mockWeatherRepository.getWeatherData(tCity))
          .thenAnswer((_) async => Right(tWeatherData));
      // assert
      expectLater(
          weatherBloc.stream,
          emitsInOrder(
            [WeatherLoading(), WeatherLoaded(tWeatherData)],
          ));
      // act
      weatherBloc.add(FetchWeather(city: tCity));
    },
  );

  test(
    'should emit [WeatherLoading, Error] state with MESSAGE_SERVER_FAILURE when FetchWeather event happens and when ServerFailure is returned ',
    () async {
      // arrange
      when(mockWeatherRepository.getWeatherData(tCity))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      expectLater(
          weatherBloc.stream,
          emitsInOrder(
            [WeatherLoading(), WeatherError(MESSAGE_SERVER_FAILURE)],
          ));
      // act
      weatherBloc.add(FetchWeather(city: tCity));
    },
  );
  test(
    'should emit [WeatherLoading, Error] state with MESSAGE_CASHE_FAILURE when FetchWeather event happens and when CasheFailure is returned ',
    () async {
      // arrange
      when(mockWeatherRepository.getWeatherData(tCity))
          .thenAnswer((_) async => Left(CasheFailure()));
      // assert later
      expectLater(
          weatherBloc.stream,
          emitsInOrder(
            [WeatherLoading(), WeatherError(MESSAGE_CASHE_FAILURE)],
          ));
      // act
      weatherBloc.add(FetchWeather(city: tCity));
    },
  );
}
