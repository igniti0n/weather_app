import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/network/network_info.dart';
import 'package:interview_app/data/datasources/suggestions_datasource.dart';
import 'package:interview_app/data/models/suggestion_model.dart';
import 'package:interview_app/domain/entities/suggestion.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:interview_app/domain/repositories_contracts/suggestions_repository.dart';

class SuggestionsRepositoryImplementation extends SuggestionsRepository {
  final SuggestionSource dataSource;
  final NetworkChecker networkChecker;
  const SuggestionsRepositoryImplementation(
      this.dataSource, this.networkChecker);
  @override
  Future<Either<Failure, List<Suggestion>>> fetchSuggestions(
      String input) async {
    if (await networkChecker.hasConnection) {
      try {
        final List<SuggestionModel> _response =
            await dataSource.fetchSuggestions(input);
        return Right(_response);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.value(Right([]));
  }
}
