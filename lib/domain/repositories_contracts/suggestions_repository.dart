import 'package:dartz/dartz.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/domain/entities/suggestion.dart';

abstract class SuggestionsRepository {
  Future<Either<Failure, List<Suggestion>>> fetchSuggestions(String input);
  const SuggestionsRepository();
}
