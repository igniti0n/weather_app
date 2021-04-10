part of 'suggestions_bloc.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();
}

class SuggestionsInitial extends SuggestionsState {
  @override
  List<Object?> get props => [];
}

class SuggestionsLoading extends SuggestionsState {
  @override
  List<Object?> get props => [];
}

class SuggestionsLoaded extends SuggestionsState {
  final List<Suggestion> suggestions;
  const SuggestionsLoaded(this.suggestions);

  @override
  List<Object?> get props => [];
}

class SuggestionsError extends SuggestionsState {
  final String message;
  const SuggestionsError(this.message);

  @override
  List<Object?> get props => [message];
}
