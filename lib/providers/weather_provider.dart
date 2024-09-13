import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  String _temperatureUnit = 'metric'; // Default to Celsius (metric)

  Map<String, dynamic>? get weatherData => _weatherData;
  List<dynamic>? get forecastData => _forecastData;
  String get temperatureUnit => _temperatureUnit;

  final WeatherService _weatherService = WeatherService();

  WeatherProvider() {
    _loadTemperatureUnit();
  }

  Future<void> _loadTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    _temperatureUnit = prefs.getString('temperatureUnit') ?? 'metric';
    notifyListeners(); // Notify to update components
  }

  Future<void> setTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperatureUnit', unit);
    _temperatureUnit = unit == 'Celsius' ? 'metric' : 'imperial';
    notifyListeners();
    // Re-fetch weather to apply the new temperature unit
    if (_weatherData != null) {
      fetchWeather(_weatherData!['name']); // Fetch for current city
    }
  }

  Future<void> fetchWeather(String city) async {
    try {
      final data =
          await _weatherService.fetchWeatherData(city, _temperatureUnit);
      _weatherData = data['current'];
      _forecastData = data['forecast'];
      notifyListeners();
    } catch (error) {
      print('Error fetching weather data: $error');
      throw Exception('Error fetching weather: $error');
    }
  }
}
