import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/news_model.dart';
import '../services/weather_service.dart';
import '../services/news_service.dart';

class WeatherNewsProvider with ChangeNotifier {
  Weather? _weather;
  List<NewsArticle>? _newsArticles;
  String _unit = 'metric'; // Default unit: Celsius
  String _category = 'general'; // Default news category

  Weather? get weather => _weather;
  List<NewsArticle>? get newsArticles => _newsArticles;
  String get unit => _unit;

  set unit(String newUnit) {
    _unit = newUnit;
    notifyListeners();
  }

  Future<void> fetchWeatherAndNews(String city) async {
    final weatherService = WeatherService();
    final newsService = NewsService();

    _weather = await weatherService.fetchWeather(city);
    _newsArticles = await newsService.fetchNews(determineNewsCategory());
    notifyListeners();
  }

  String determineNewsCategory() {
    if (_weather == null) return 'general';

    switch (_weather!.condition.toLowerCase()) {
      case 'cold':
        return 'depressing';
      case 'hot':
        return 'fear';
      case 'cool':
        return 'happiness';
      default:
        return 'general';
    }
  }
}
