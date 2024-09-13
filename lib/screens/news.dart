import 'package:flutter/material.dart';
import 'package:weather_app/sections/news.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: const NewsComponent(),
    );
  }
}
