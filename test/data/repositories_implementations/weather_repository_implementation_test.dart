// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/core/network/network_info.dart';
import 'package:interview_app/data/datasources/local_data_source.dart';
import 'package:interview_app/data/datasources/network_data_source.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:interview_app/data/repositories_implementations/weather_repository_implementation.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

class MockedNetworkDataSource extends Mock implements NetworkSource {}

class MockedLocalDataSource extends Mock implements LocalSource {}

class MockedNetworkInfo extends Mock implements NetworkChecker {}

void main() {
  MockedNetworkInfo mockedNetworkInfo;
  MockedNetworkDataSource mockedNetworkDataSource;
  MockedLocalDataSource mockedLocalDataSource;

  WeatherRepositoryImplementation weatherRepositoryImplementation;

  setUp(() {
    mockedNetworkInfo = MockedNetworkInfo();
    mockedNetworkDataSource = MockedNetworkDataSource();
    mockedLocalDataSource = MockedLocalDataSource();
    weatherRepositoryImplementation = WeatherRepositoryImplementation(
      localDataSource: mockedLocalDataSource,
      networkDataSource: mockedNetworkDataSource,
      networkInfo: mockedNetworkInfo,
    );
  });

  test(
    'should check if device has data',
    () async {
      //arrange
      when(mockedNetworkInfo.hasConnection).thenAnswer((_) async => true);
      // act
      await weatherRepositoryImplementation.getWeatherData("London");
      // assert

      verify(mockedNetworkInfo.hasConnection).called(1);
      verifyNoMoreInteractions(mockedNetworkInfo);
    },
  );

  group('device has internet connection', () {
    final String tCity = "London";
    final WeatherDataModel tWeathedDataModel = WeatherDataModel(
        prediction: 'test',
        city: "London",
        humidity: 4,
        pressure: 4,
        temperature: 4,
        tempMax: 4,
        tempMin: 4);
    final WeatherData tWeatherData = tWeathedDataModel;
    test(
      'should call Network data source with rigth returned data',
      () async {
        //arrane
        when(mockedNetworkInfo.hasConnection).thenAnswer((_) async => true);
        when(mockedNetworkDataSource.getWeatherData(tCity)).thenAnswer(
          (_) async => tWeathedDataModel,
        );
        // act
        final res = await weatherRepositoryImplementation.getWeatherData(tCity);
        // assert
        expect(res, equals(Right(tWeatherData)));
        verify(mockedNetworkDataSource.getWeatherData(tCity)).called(1);
        verifyNoMoreInteractions(mockedNetworkDataSource);
      },
    );

    test(
      'should return ServerFailure when exception occurres',
      () async {
        //arrane
        when(mockedNetworkInfo.hasConnection).thenAnswer((_) async => true);
        when(mockedNetworkDataSource.getWeatherData(tCity))
            .thenThrow(ServerException());
        // act
        final res = await weatherRepositoryImplementation.getWeatherData(tCity);
        // assert
        expect(res, equals(Left(ServerFailure())));
        verify(mockedNetworkDataSource.getWeatherData(tCity)).called(1);
        verifyNoMoreInteractions(mockedNetworkDataSource);
      },
    );
  });

  group('device does NOT have internet connection', () {
    final String tCity = "London";
    final WeatherDataModel tWeathedDataModel = WeatherDataModel(
        prediction: 'test',
        city: "London",
        humidity: 4,
        pressure: 4,
        temperature: 4,
        tempMax: 4,
        tempMin: 4);
    final WeatherData tWeatherData = tWeathedDataModel;
    test(
      'should call Local data source with rigth returned data',
      () async {
        //arrane
        when(mockedNetworkInfo.hasConnection).thenAnswer((_) async => false);
        when(mockedLocalDataSource.getWeatherData()).thenAnswer(
          (_) async => tWeathedDataModel,
        );
        // act
        final res = await weatherRepositoryImplementation.getWeatherData(tCity);
        // assert
        expect(res, equals(Right(tWeatherData)));
        verify(mockedLocalDataSource.getWeatherData()).called(1);
        verifyNoMoreInteractions(mockedLocalDataSource);
      },
    );

    test(
      'should return CasheFailure when exception occurres',
      () async {
        //arrane
        when(mockedNetworkInfo.hasConnection).thenAnswer((_) async => false);
        when(mockedLocalDataSource.getWeatherData())
            .thenThrow(CasheException());
        // act
        final res = await weatherRepositoryImplementation.getWeatherData(tCity);
        // assert
        expect(res, equals(Left(CasheFailure())));
        verify(mockedLocalDataSource.getWeatherData()).called(1);
        verifyNoMoreInteractions(mockedNetworkDataSource);
      },
    );
  });
}
