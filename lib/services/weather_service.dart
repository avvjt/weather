import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants.dart';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeatherData(
      String city, String unit) async {
    final currentWeatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$WEATHER_API_KEY&units=$unit';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$WEATHER_API_KEY&units=$unit';

    try {
      final currentResponse = await http.get(Uri.parse(currentWeatherUrl));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (currentResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        final currentWeatherData = json.decode(currentResponse.body);
        final forecastData = json.decode(forecastResponse.body);

        return {
          'current': currentWeatherData,
          'forecast': forecastData['list'],
        };
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
      throw Exception('Error fetching weather: $error');
    }
  }
}
