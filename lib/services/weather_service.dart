import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$WEATHER_API_KEY&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
