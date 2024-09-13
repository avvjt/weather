import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/location_service.dart';
import '../providers/weather_provider.dart';

class WeatherComponent extends StatefulWidget {
  const WeatherComponent({super.key});

  @override
  State<WeatherComponent> createState() => _WeatherStateComponent();
}

class _WeatherStateComponent extends State<WeatherComponent> {
  String _city = 'delhi';
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final status = await Permission.locationWhenInUse.request();

      if (status.isGranted) {
        String currentCity = await LocationService().getCurrentCity();
        setState(() {
          _city = currentCity;
        });

        context.read<WeatherProvider>().fetchWeather(_city);
      } else {
        _handlePermissionDenied(status);
      }
    } catch (e) {
      print('Error during location request: $e');
    }
  }

  void _handlePermissionDenied(PermissionStatus status) {
    if (status.isDenied) {
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCityInputSection(),
            const SizedBox(height: 20),
            Expanded(
              child: weatherProvider.weatherData == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWeatherInfo(weatherProvider),
                          const SizedBox(height: 20),
                          _buildForecastList(weatherProvider),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _city = _cityController.text;
                });
                context.read<WeatherProvider>().fetchWeather(_city);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _getCurrentLocation,
          icon: const Icon(Icons.my_location),
          label: const Text('Use Current Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(WeatherProvider weatherProvider) {
    final temperatureUnit =
        weatherProvider.temperatureUnit == 'metric' ? 'C' : 'F';
    return Card(
      color: Colors.blue.shade100,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Temperature in $_city: ${weatherProvider.weatherData!['main']['temp']} °$temperatureUnit',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Weather: ${weatherProvider.weatherData!['weather'][0]['description']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastList(WeatherProvider weatherProvider) {
    final temperatureUnit =
        weatherProvider.temperatureUnit == 'metric' ? 'C' : 'F';
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: weatherProvider.forecastData!.length,
      itemBuilder: (context, index) {
        final forecast = weatherProvider.forecastData![index];
        final date = DateTime.parse(forecast['dt_txt']);
        final temp = forecast['main']['temp'];
        final description = forecast['weather'][0]['description'];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(
              Icons.calendar_today,
              color: Colors.blueAccent,
            ),
            title: Text(
              '${date.day}/${date.month} ${date.hour}:00 - $temp°$temperatureUnit',
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(description),
          ),
        );
      },
    );
  }
}
