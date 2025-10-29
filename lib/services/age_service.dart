import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/age_model.dart';

class AgeService {
  static const String baseUrl = 'https://api.agify.io';

  Future<AgePrediction> predictAge(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/?name=$name'));
    
    if (response.statusCode == 200) {
      return AgePrediction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al predecir la edad');
    }
  }
}