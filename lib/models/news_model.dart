import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart'; // This is the file that will be generated

@JsonSerializable()
class NewsArticle {
  final String title;
  final String? description; // Allow null values
  final String url;

  NewsArticle({
    required this.title,
    this.description,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);
  Map<String, dynamic> toJson() => _$NewsArticleToJson(this);
}
