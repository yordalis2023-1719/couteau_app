import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // API Key de WeatherAPI.com proporcionada
  static const String apiKey = '9be658cba2a5457b8cf01710252910';
  static const String baseUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<WeatherData> getWeatherInDominicanRepublic() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?key=$apiKey&q=Santo Domingo,Dominican Republic&aqi=no&lang=es')
      );
      
      print('WeatherAPI Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather Data: $data');
        return WeatherData.fromJson(data);
      } else {
        print('Error clima WeatherAPI: ${response.statusCode} - ${response.body}');
        return _getExampleWeather();
      }
    } catch (e) {
      print('Excepción clima: $e');
      return _getExampleWeather();
    }
  }

  // Método alternativo para otras ciudades de RD
  Future<WeatherData> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?key=$apiKey&q=$city,Dominican Republic&aqi=no&lang=es')
      );
      
      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      } else {
        return _getExampleWeather();
      }
    } catch (e) {
      return _getExampleWeather();
    }
  }

  WeatherData _getExampleWeather() {
    // Datos de ejemplo como fallback
    return WeatherData(
      location: 'Santo Domingo, República Dominicana',
      temperature: 28.0,
      description: 'Parcialmente nublado',
      icon: 'https://cdn.weatherapi.com/weather/64x64/day/116.png',
      humidity: 65.0,
      windSpeed: 12.8,
      condition: 'Parcially cloudy',
    );
  }
}