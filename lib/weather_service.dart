import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = '8d7715ecb6e05b33bc4656cb0ea95087'; // thay bằng API key của bạn
  final String _city = 'Hanoi';
  final String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast?q=';

  Future<List<dynamic>> fetchWeatherData() async {
    final url = '$_baseUrl$_city&units=metric&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['list'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
