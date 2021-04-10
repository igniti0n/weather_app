import 'dart:convert';

import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:http/http.dart';

const String BASE_ADDRESS = "api.openweathermap.org";
const String PATH = "/data/2.5/weather";
const String API_KEY = "61b95595d5feec7ebc1dfcaf5b6f7487";

abstract class NetworkSource {
  Future<WeatherDataModel> getWeatherData(String city);
  const NetworkSource();
}

class NetworkDataSource extends NetworkSource {
  final Client httpClient;
  const NetworkDataSource(this.httpClient);

  @override
  Future<WeatherDataModel> getWeatherData(String city) async {
    final _response = await httpClient.get(Uri.https(
      BASE_ADDRESS,
      PATH,
      {'q': city, 'APPID': API_KEY},
    ));

    if (_response.statusCode != 200) throw ServerException();
    return WeatherDataModel.fromJson(json.decode(_response.body));
  }
}
