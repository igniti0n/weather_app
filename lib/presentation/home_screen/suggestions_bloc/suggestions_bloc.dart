import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_app/domain/entities/suggestion.dart';
import 'package:interview_app/domain/repositories_contracts/suggestions_repository.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';

part 'suggestions_event.dart';
part 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  final SuggestionsRepository suggestionsRepository;
  SuggestionsBloc({
    required this.suggestionsRepository,
  }) : super(SuggestionsInitial());

  @override
  Stream<SuggestionsState> mapEventToState(
    SuggestionsEvent event,
  ) async* {
    if (event is FetchSuggestions) {
      yield SuggestionsLoading();
      final data = await suggestionsRepository.fetchSuggestions(event.input);
      yield data.fold((failure) => SuggestionsError(MESSAGE_SERVER_FAILURE),
          (suggestions) => SuggestionsLoaded(suggestions));
    } else if (event is CloseSuggestions) {
      yield SuggestionsInitial();
    }
  }
}
