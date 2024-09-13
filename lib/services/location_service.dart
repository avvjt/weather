import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['address']['city'] ?? 'Unknown City';
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  Future<String> getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return await getCityFromCoordinates(
          position.latitude, position.longitude);
    } catch (e) {
      return 'Error: $e';
    }
  }
}
