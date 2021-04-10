import 'dart:convert';

import 'package:interview_app/core/error/exception.dart';
import 'package:interview_app/data/models/weather_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SHARED_PREF_WEATHER_KEY = "weather_data";

abstract class LocalSource {
  Future<WeatherDataModel> getWeatherData();
  Future<void> storeWeatherData(WeatherDataModel weatherDataModel);
  const LocalSource();
}

class LocalDataSource extends LocalSource {
  final SharedPreferences sharedPreferences;
  const LocalDataSource(this.sharedPreferences);

  @override
  Future<WeatherDataModel> getWeatherData() async {
    final _res = sharedPreferences.getString(SHARED_PREF_WEATHER_KEY);
    if (_res == null) throw CasheException();
    final WeatherDataModel _model = WeatherDataModel.fromJson(jsonDecode(_res));
    return _model;
  }

  @override
  Future<void> storeWeatherData(WeatherDataModel weatherDataModel) async {
    final _res = await sharedPreferences.setString(
        SHARED_PREF_WEATHER_KEY, json.encode(weatherDataModel));

    if (_res == false) throw CasheException();
  }
}
