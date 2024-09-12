import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_news_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherNewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: provider.unit,
              items: ['metric', 'imperial']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.unit = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
