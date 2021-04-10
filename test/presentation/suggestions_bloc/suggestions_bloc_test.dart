// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/domain/entities/suggestion.dart';
import 'package:interview_app/domain/repositories_contracts/suggestions_repository.dart';
import 'package:interview_app/presentation/home_screen/suggestions_bloc/suggestions_bloc.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockSuggestionsRepository extends Mock implements SuggestionsRepository {}

void main() {
  MockSuggestionsRepository mockSuggestionsRepository;
  SuggestionsBloc suggestionsBloc;

  setUp(() {
    mockSuggestionsRepository = MockSuggestionsRepository();
    suggestionsBloc =
        SuggestionsBloc(suggestionsRepository: mockSuggestionsRepository);
  });

  final String tInput = "New";
  final List<Suggestion> tSuggestions = [
    Suggestion(
      city: "New York",
      description: 'test description',
    )
  ];
  test(
    'should emit [SuggestionsLoading, SuggestionsLoaded] states when FetchSuggestions event happens and data fetching goes well ',
    () async {
      // arrange
      when(mockSuggestionsRepository.fetchSuggestions(tInput))
          .thenAnswer((_) async => Right(tSuggestions));
      // assert later
      expectLater(
          suggestionsBloc.stream,
          emitsInOrder(
              [SuggestionsLoading(), SuggestionsLoaded(tSuggestions)]));
      // act
      suggestionsBloc.add(FetchSuggestions(tInput));
    },
  );

  test(
    'should emit [SuggestionsLoading, Error] states with MESSAGE_SERVER_FAILURE when FetchSuggestions event happens and ServerFailure is returned',
    () async {
      // arrange
      when(mockSuggestionsRepository.fetchSuggestions(tInput))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      expectLater(
          suggestionsBloc.stream,
          emitsInOrder([
            SuggestionsLoading(),
            SuggestionsError(MESSAGE_SERVER_FAILURE)
          ]));
      // act
      suggestionsBloc.add(FetchSuggestions(tInput));
    },
  );
}
