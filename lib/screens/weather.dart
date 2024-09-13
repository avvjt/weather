import 'package:flutter/material.dart';
import 'package:weather_app/sections/news.dart';
import 'package:weather_app/sections/weather.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: const WeatherComponent(),
    );
  }
}
