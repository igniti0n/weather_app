part of 'suggestions_bloc.dart';

abstract class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();
  List<Object?> get props => [];
}

class FetchSuggestions extends SuggestionsEvent {
  final String input;
  const FetchSuggestions(this.input);
}

class CloseSuggestions extends SuggestionsEvent {}
