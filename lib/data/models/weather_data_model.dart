import 'package:interview_app/domain/entities/weather_data.dart';

class WeatherDataModel extends WeatherData {
  WeatherDataModel({
    required String city,
    required String prediction,
    required double humidity,
    required double pressure,
    required double temperature,
    required double tempMax,
    required double tempMin,
  }) : super(
          city: city,
          humidity: humidity,
          pressure: pressure,
          temperature: temperature,
          tempMax: tempMax,
          tempMin: tempMin,
          prediction: prediction,
        );

  factory WeatherDataModel.fromJson(Map<String, dynamic> jsonData) {
    return WeatherDataModel(
      city: jsonData['name'],
      prediction: jsonData['weather'][0]['description'].toString(),
      humidity: (jsonData['main']['humidity'] as num).toDouble(),
      pressure: (jsonData['main']['pressure'] as num).toDouble(),
      temperature: (jsonData['main']['temp'] as num).toDouble(),
      tempMax: (jsonData['main']['temp_max'] as num).toDouble(),
      tempMin: (jsonData['main']['temp_min'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.city,
      'main': {
        'humidity': this.humidity,
        'pressure': this.pressure,
        'temp': this.temperature,
        'temp_max': this.tempMax,
        'temp_min': this.tempMin,
      },
      'weather': [
        {
          'description': this.prediction,
        }
      ],
    };
  }
}
