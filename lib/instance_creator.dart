import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/core/network/network_info.dart';
import 'package:interview_app/data/datasources/local_data_source.dart';
import 'package:interview_app/data/datasources/suggestions_datasource.dart';
import 'package:interview_app/data/repositories_implementations/suggestions_repository_implementation.dart';
import 'package:interview_app/data/repositories_implementations/weather_repository_implementation.dart';
import 'package:interview_app/domain/repositories_contracts/suggestions_repository.dart';
import 'package:interview_app/domain/repositories_contracts/weather_repository.dart';
import 'package:interview_app/presentation/home_screen/suggestions_bloc/suggestions_bloc.dart';
import 'package:interview_app/presentation/home_screen/weather_bloc/weather_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/network_data_source.dart';

Future<void> createInstances() async {
  final creator = GetIt.instance;

  //!datasources
  creator.registerLazySingleton<LocalSource>(() => LocalDataSource(creator()));
  creator
      .registerLazySingleton<NetworkSource>(() => NetworkDataSource(creator()));
  creator.registerLazySingleton<SuggestionSource>(
      () => SuggestionDataSource(creator()));

  //!repositories
  creator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImplementation(
            localDataSource: creator(),
            networkDataSource: creator(),
            networkInfo: creator(),
          ));

  creator.registerLazySingleton<SuggestionsRepository>(
      () => SuggestionsRepositoryImplementation(creator(), creator()));
  //!blocs
  creator.registerFactory(() => WeatherBloc(weatherRepository: creator()));
  creator
      .registerFactory(() => SuggestionsBloc(suggestionsRepository: creator()));

  //!other
  creator.registerLazySingleton<NetworkChecker>(() => NetworkInfo());
  final sharedPrefs = await SharedPreferences.getInstance();
  creator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  creator.registerLazySingleton<http.Client>(() => http.Client());
}
