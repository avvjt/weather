import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_app/constants.dart';
import 'package:weather_app/models/news_model.dart';

class NewsService {
  Future<List<NewsArticle>> fetchNews(String category) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$NEWS_API_KEY'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print('API Response Data: $data'); // Log the parsed response data
      if (data['articles'] != null && data['articles'].isNotEmpty) {
        List<dynamic> articlesJson = data['articles'];
        return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
      } else {
        print('No articles found');
        return [];
      }
    } else {
      throw Exception('Failed to load news');
    }
  }
}
