import 'dart:convert';
import 'dart:developer';
import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/data/models/suggestion_model.dart';
import 'package:http/http.dart' as http;

const String BASE_ADDRESS_SUGGESTIONS = "maps.googleapis.com";
const String PATH_SUGGESTIONS = "/maps/api/place/autocomplete/json";

const String API_KEY_SUGGESTIONS = "AIzaSyDDS3G-Pgsov93krU9YNst092FCQxMGwsU";

abstract class SuggestionSource {
  Future<List<SuggestionModel>> fetchSuggestions(String input);
  const SuggestionSource();
}

class SuggestionDataSource extends SuggestionSource {
  final http.Client httpClient;
  const SuggestionDataSource(this.httpClient);

  @override
  Future<List<SuggestionModel>> fetchSuggestions(String input) async {
    final http.Response _response = await httpClient
        .get(Uri.https(BASE_ADDRESS_SUGGESTIONS, PATH_SUGGESTIONS, {
      'input': input,
      'types': '(cities)',
      'key': API_KEY_SUGGESTIONS,
    }));
    final dataResponse = json.decode(_response.body);
    print(dataResponse["status"].toString());
    if (dataResponse["status"] != "ZERO_RESULTS" &&
        dataResponse["status"] != "OK") throw ServerException();
    final List _dataList = (dataResponse["predictions"] as Iterable).toList();
    return _dataList
        .map<SuggestionModel>(
            (suggestion) => SuggestionModel.fromJson(suggestion))
        .toList();
  }
}
