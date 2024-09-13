import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import '../providers/news_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _temperatureUnit = 'Celsius';
  String _selectedCategory = 'General'; // Default category selection

  final List<String> _categories = [
    'General',
    'Business',
    'Technology',
    'Sports',
    'Entertainment'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _temperatureUnit = prefs.getString('temperatureUnit') ?? 'Celsius';
      _selectedCategory = prefs.getString('selectedCategory') ?? 'General';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperatureUnit', _temperatureUnit);
    await prefs.setString('selectedCategory', _selectedCategory);

    // Store temperature unit before async call to avoid context issues
    String newTemperatureUnit = _temperatureUnit;
    String newSelectedCategory = _selectedCategory;

    // After saving, call the providers outside the async block
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .setTemperatureUnit(newTemperatureUnit);

      Provider.of<NewsProvider>(context, listen: false)
          .setCategory(newSelectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature Unit',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: const Text('Celsius'),
              leading: Radio<String>(
                value: 'Celsius',
                groupValue: _temperatureUnit,
                onChanged: (value) {
                  setState(() {
                    _temperatureUnit = value!;
                    _saveSettings();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Fahrenheit'),
              leading: Radio<String>(
                value: 'Fahrenheit',
                groupValue: _temperatureUnit,
                onChanged: (value) {
                  setState(() {
                    _temperatureUnit = value!;
                    _saveSettings();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'News Category',
              style: Theme.of(context).textTheme.headline6,
            ),
            ..._categories.map((category) {
              return RadioListTile<String>(
                title: Text(category),
                value: category,
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _saveSettings();
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
