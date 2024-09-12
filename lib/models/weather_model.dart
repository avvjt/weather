class Weather {
  final double temperature;
  final String description;
  final String condition;
  final List<Forecast> forecast;

  Weather({
    required this.temperature,
    required this.description,
    required this.condition,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
      condition: json['weather'][0]['main'],
      forecast: (json['daily'] as List)
          .map((item) => Forecast.fromJson(item))
          .toList(),
    );
  }
}

class Forecast {
  final double temperature;
  final String condition;

  Forecast({required this.temperature, required this.condition});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      temperature: json['temp']['day'],
      condition: json['weather'][0]['main'],
    );
  }
}
