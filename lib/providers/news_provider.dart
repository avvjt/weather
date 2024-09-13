import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/news_service.dart';
import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle>? _newsData;
  String _selectedCategory = 'General'; // Default category

  List<NewsArticle>? get newsData => _newsData;
  String get selectedCategory => _selectedCategory;

  final NewsService _newsService = NewsService();

  NewsProvider() {
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCategory = prefs.getString('selectedCategory') ?? 'General';
    notifyListeners(); // Notify listeners to update UI
    fetchNews(_selectedCategory); // Fetch news for the loaded category
  }

  Future<void> setCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCategory', category);
    _selectedCategory = category;
    notifyListeners(); // Notify listeners to update UI
    fetchNews(category); // Fetch news for the new category
  }

  Future<void> fetchNews(String category) async {
    try {
      final data = await _newsService.fetchNews(category);
      _newsData = data;
      notifyListeners();
    } catch (error) {
      print('Error fetching news data: $error');
    }
  }
}
