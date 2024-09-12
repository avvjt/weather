import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/news_model.dart';

class NewsService {
  Future<List<NewsArticle>> fetchNews(String category) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$NEWS_API_KEY'));

    if (response.statusCode == 200) {
      List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
