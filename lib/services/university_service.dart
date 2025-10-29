import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';

class UniversityService {
  static const String baseUrl = 'https://adamix.net/proxy.php';

  Future<List<University>> getUniversities(String country) async {
    final formattedCountry = country.replaceAll(' ', '+');
    final response = await http.get(
      Uri.parse('$baseUrl?country=$formattedCountry')
    );
    
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      // Manejar diferentes formatos de respuesta
      if (responseData is Map && responseData['universidades'] != null) {
        final List<dynamic> data = responseData['universidades'];
        return data.map((json) => University.fromJson(json)).toList();
      } else if (responseData is List) {
        return responseData.map((json) => University.fromJson(json)).toList();
      } else {
        return _parseUniversitiesFromResponse(responseData);
      }
    } else {
      throw Exception('Error al obtener universidades: ${response.statusCode}');
    }
  }

  List<University> _parseUniversitiesFromResponse(dynamic responseData) {
    List<University> universities = [];
    
    try {
      if (responseData is Map) {
        for (var key in responseData.keys) {
          if (responseData[key] is List) {
            final List<dynamic> data = responseData[key];
            universities = data.map((json) => University.fromJson(json)).toList();
            break;
          }
        }
      }
      
      if (universities.isEmpty) {
        return _getExampleUniversities();
      }
      
      return universities;
    } catch (e) {
      return _getExampleUniversities();
    }
  }

  List<University> _getExampleUniversities() {
    return [
      University(
        name: 'Universidad APEC',
        website: 'https://www.unapec.edu.do',
        country: 'Dominican Republic',
      ),
      University(
        name: 'Universidad Autónoma de Santo Domingo',
        website: 'https://www.uasd.edu.do',
        country: 'Dominican Republic',
      ),
      University(
        name: 'Pontificia Universidad Católica Madre y Maestra',
        website: 'https://www.pucmm.edu.do',
        country: 'Dominican Republic',
      ),
    ];
  }
}