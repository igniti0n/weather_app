// @dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/data/datasources/local_data_source.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  LocalDataSource localDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LocalDataSource(mockSharedPreferences);
  });

  group('retriving data', () {
    final WeatherDataModel tWeathedDataModel = WeatherDataModel(
        prediction: 'test',
        city: "London",
        humidity: 4,
        pressure: 4,
        temperature: 4,
        tempMax: 4,
        tempMin: 4);

    test(
      'should call SharedPreferences to get the data',
      () async {
        // arrange
        when(mockSharedPreferences.getString(SHARED_PREF_WEATHER_KEY))
            .thenReturn(json.encode(tWeathedDataModel));
        // act
        await localDataSource.getWeatherData();
        // assert
        verify(mockSharedPreferences.getString(SHARED_PREF_WEATHER_KEY))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should return correct weather data model',
      () async {
        // arrange
        when(mockSharedPreferences.getString(SHARED_PREF_WEATHER_KEY))
            .thenReturn(json.encode(tWeathedDataModel));
        // act
        final res = await localDataSource.getWeatherData();
        // assert
        expect(res, equals(tWeathedDataModel));
      },
    );

    test(
      'should throw CasheException when no data exists',
      () async {
        // arrange
        when(mockSharedPreferences.getString(SHARED_PREF_WEATHER_KEY))
            .thenReturn(null);
        // act
        final call = localDataSource.getWeatherData;
        // assert
        expect(() => call(), throwsA(isInstanceOf<CasheException>()));
      },
    );
  });

  group('storing data', () {
    final WeatherDataModel tWeathedDataModel = WeatherDataModel(
        prediction: 'test',
        city: "London",
        humidity: 4,
        pressure: 4,
        temperature: 4,
        tempMax: 4,
        tempMin: 4);

    test(
      'should call SharedPreferences to store the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(
                SHARED_PREF_WEATHER_KEY, json.encode(tWeathedDataModel)))
            .thenAnswer((_) async => true);
        // act
        await localDataSource.storeWeatherData(tWeathedDataModel);
        // assert
        verify(mockSharedPreferences.setString(
                SHARED_PREF_WEATHER_KEY, json.encode(tWeathedDataModel)))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should throw CasheException saving data went wrong',
      () async {
        // arrange
        when(mockSharedPreferences.setString(SHARED_PREF_WEATHER_KEY,
                json.encode(tWeathedDataModel.toJson())))
            .thenAnswer((_) async => false);
        // act
        final call = localDataSource.storeWeatherData;
        // assert
        expect(() => call(tWeathedDataModel),
            throwsA(isInstanceOf<CasheException>()));
      },
    );
  });
}
