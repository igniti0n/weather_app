// @dart=2.9
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/core/network/network_info.dart';
import 'package:interview_app/data/datasources/suggestions_datasource.dart';
import 'package:interview_app/data/models/suggestion_model.dart';
import 'package:interview_app/data/repositories_implementations/suggestions_repository_implementation.dart';
import 'package:interview_app/domain/entities/suggestion.dart';

import 'package:mockito/mockito.dart';

class MockedSuggestionSource extends Mock implements SuggestionSource {}

class MockNetworkInfo extends Mock implements NetworkChecker {}

void main() {
  MockedSuggestionSource mockedSuggestionSource;
  MockNetworkInfo mockNetworkInfo;
  SuggestionsRepositoryImplementation suggestionRepositoryImplementation;

  setUp(() {
    mockedSuggestionSource = MockedSuggestionSource();
    mockNetworkInfo = MockNetworkInfo();
    suggestionRepositoryImplementation = SuggestionsRepositoryImplementation(
      mockedSuggestionSource,
      mockNetworkInfo,
    );
  });

  final String tInput = "New";
  final List<SuggestionModel> tModelList = [
    SuggestionModel(city: 'New York', description: 'test description'),
  ];
  final List<Suggestion> tList = tModelList;

  test(
    'should check for internet connection',
    () async {
      // arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      // act
      suggestionRepositoryImplementation.fetchSuggestions(tInput);
      // assert
      verify(mockNetworkInfo.hasConnection).called(1);
      verifyNoMoreInteractions(mockNetworkInfo);
    },
  );

  test(
    'should call mockedSuggestionSource to fetch data with right input',
    () async {
      // arrange

      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      when(mockedSuggestionSource.fetchSuggestions(tInput))
          .thenAnswer((_) async => tModelList);
      // act
      await suggestionRepositoryImplementation.fetchSuggestions(tInput);
      // assert
      verify(mockedSuggestionSource.fetchSuggestions(tInput)).called(1);
      verifyNoMoreInteractions(mockedSuggestionSource);
    },
  );

  test(
    'should return correct data',
    () async {
      // arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      when(mockedSuggestionSource.fetchSuggestions(tInput))
          .thenAnswer((_) async => tModelList);
      // act
      final result =
          await suggestionRepositoryImplementation.fetchSuggestions(tInput);
      // assert
      expect(result, Right(tList));
    },
  );

  test(
    'should return [ServerFailure] on ServerException',
    () async {
      // arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      when(mockedSuggestionSource.fetchSuggestions(tInput))
          .thenThrow(ServerException());
      // act
      final result =
          await suggestionRepositoryImplementation.fetchSuggestions(tInput);
      // assert
      expect(result, Left(ServerFailure()));
    },
  );
}
