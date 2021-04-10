// @dart=2.9
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/utils/fixture_reader.dart';
import 'package:interview_app/data/datasources/suggestions_datasource.dart';
import 'package:interview_app/data/models/suggestion_model.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  SuggestionDataSource suggestionDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    suggestionDataSource = SuggestionDataSource(mockHttpClient);
  });

  final String tInput = "New";
  final List tList =
      jsonDecode(readFixture('suggestions_data.json'))['predictions'];
  final List<SuggestionModel> tSuggestionModels =
      tList.map((e) => SuggestionModel.fromJson(e)).toList();

  print(tSuggestionModels);
  test(
    'should make http call to right address',
    () async {
      // arrange
      when(mockHttpClient
          .get(Uri.https(BASE_ADDRESS_SUGGESTIONS, PATH_SUGGESTIONS, {
        'input': tInput,
        'types': '(cities)',
        'key': API_KEY_SUGGESTIONS,
      }))).thenAnswer((_) async =>
          http.Response(readFixture('suggestions_data.json'), 200));

      // act
      suggestionDataSource.fetchSuggestions(tInput);

      // assert
      verify(mockHttpClient
          .get(Uri.https(BASE_ADDRESS_SUGGESTIONS, PATH_SUGGESTIONS, {
        'input': tInput,
        'types': '(cities)',
        'key': API_KEY_SUGGESTIONS,
      }))).called(1);
      verifyNoMoreInteractions(mockHttpClient);
    },
  );

  test(
    'should return correct data',
    () async {
      // arrange
      when(mockHttpClient
          .get(Uri.https(BASE_ADDRESS_SUGGESTIONS, PATH_SUGGESTIONS, {
        'input': tInput,
        'types': '(cities)',
        'key': API_KEY_SUGGESTIONS,
      }))).thenAnswer((_) async =>
          http.Response(readFixture('suggestions_data.json'), 200));

      // act
      final _result = await suggestionDataSource.fetchSuggestions(tInput);

      // assert
      expect(_result, tSuggestionModels);
    },
  );

  test(
    'should throw [ServerException] when status is NOT either OK or ZERO_RESULTS',
    () async {
      // arrange
      when(mockHttpClient
          .get(Uri.https(BASE_ADDRESS_SUGGESTIONS, PATH_SUGGESTIONS, {
        'input': tInput,
        'types': '(cities)',
        'key': API_KEY_SUGGESTIONS,
      }))).thenAnswer((_) async =>
          http.Response(readFixture('suggestions_data_error.json'), 200));

      // act
      final call = suggestionDataSource.fetchSuggestions;

      // assert
      expect(() => call(tInput), throwsA(isInstanceOf<ServerException>()));
    },
  );
}
