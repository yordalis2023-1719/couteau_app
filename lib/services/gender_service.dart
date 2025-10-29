import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gender_model.dart';

class GenderService {
  static const String baseUrl = 'https://api.genderize.io';

  Future<GenderPrediction> predictGender(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/?name=$name'));
    
    if (response.statusCode == 200) {
      return GenderPrediction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al predecir el género');
    }
  }
}