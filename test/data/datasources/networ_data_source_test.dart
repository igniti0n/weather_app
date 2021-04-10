// @dart=2.9
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/utils/fixture_reader.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/data/datasources/network_data_source.dart';

class MockedHttpClient extends Mock implements http.Client {}

void main() {
  MockedHttpClient mockedHttpClient;
  NetworkDataSource networkDataSource;

  setUp(() {
    mockedHttpClient = MockedHttpClient();
    networkDataSource = NetworkDataSource(mockedHttpClient);
  });

  final String tCity = "London";
  final WeatherDataModel tweatherDataModel =
      WeatherDataModel.fromJson(json.decode(readFixture('weather_data.json')));
  test(
    'should call get request with right params',
    () async {
      // arrange
      when(mockedHttpClient.get(Uri.https(
        BASE_ADDRESS,
        PATH,
        {'q': tCity, 'APPID': API_KEY},
      ))).thenAnswer(
          (_) async => http.Response(readFixture('weather_data.json'), 200));
      // act
      networkDataSource.getWeatherData(tCity);
      // assert
      verify(mockedHttpClient.get(Uri.https(
        BASE_ADDRESS,
        PATH,
        {'q': tCity, 'APPID': API_KEY},
      ))).called(1);
      verifyNoMoreInteractions(mockedHttpClient);
    },
  );

  test(
    'should return correct WeatherDataModel',
    () async {
      // arrange
      when(mockedHttpClient.get(Uri.https(
        BASE_ADDRESS,
        PATH,
        {'q': tCity, 'APPID': API_KEY},
      ))).thenAnswer(
          (_) async => http.Response(readFixture('weather_data.json'), 200));
      // act
      final _res = await networkDataSource.getWeatherData(tCity);
      // assert
      expect(_res, tweatherDataModel);
    },
  );

  test(
    'should throw ServerException when bad status code',
    () async {
      // arrange
      when(mockedHttpClient.get(Uri.https(
        BASE_ADDRESS,
        PATH,
        {'q': tCity, 'APPID': API_KEY},
      ))).thenAnswer((_) async => http.Response('', 500));
      // act
      final call = networkDataSource.getWeatherData;
      // assert
      expect(() => call(tCity), throwsA(isInstanceOf<ServerException>()));
    },
  );
}
