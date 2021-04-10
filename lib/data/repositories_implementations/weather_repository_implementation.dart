import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/core/network/network_info.dart';
import 'package:interview_app/data/datasources/local_data_source.dart';
import 'package:interview_app/data/datasources/network_data_source.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:interview_app/domain/entities/weather_data.dart';
import 'package:interview_app/core/error/failure.dart';
import 'package:interview_app/domain/repositories_contracts/weather_repository.dart';

class WeatherRepositoryImplementation extends WeatherRepository {
  final LocalSource localDataSource;
  final NetworkSource networkDataSource;
  final NetworkChecker networkInfo;

  const WeatherRepositoryImplementation({
    required this.localDataSource,
    required this.networkDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherData>> getWeatherData(String city) async {
    try {
      late final WeatherDataModel result;
      if (await networkInfo.hasConnection) {
        result = await networkDataSource.getWeatherData(city);
        await localDataSource.storeWeatherData(result);
      } else {
        result = await localDataSource.getWeatherData();
      }
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on CasheException {
      return Left(CasheFailure());
    }
  }
}
