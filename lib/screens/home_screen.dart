import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/sections/news.dart';
import 'package:weather_app/sections/weather.dart';
import 'package:weather_app/widget/drawer_widget.dart';
import '../providers/news_provider.dart'; // Import your provider if needed

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWeather = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather and News'),
        actions: [
          Switch(
            value: _showWeather,
            onChanged: (value) {
              setState(() {
                _showWeather = value;
              });
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _showWeather ? const WeatherComponent() : const NewsComponent(),
    );
  }
}
