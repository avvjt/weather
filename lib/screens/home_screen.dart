import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_news_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherNewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather & News Aggregator'),
      ),
      body: provider.weather == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text('Current Weather: ${provider.weather!.description}'),
                Text('Temperature: ${provider.weather!.temperature}°C'),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.newsArticles?.length ?? 0,
                    itemBuilder: (context, index) {
                      final article = provider.newsArticles![index];
                      return ListTile(
                        title: Text(article.title),
                        subtitle: Text(article.description),
                        onTap: () => _launchURL(article.url),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          provider.fetchWeatherAndNews('New York'); // Replace with actual user location
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
