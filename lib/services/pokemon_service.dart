import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon> getPokemon(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/${name.toLowerCase()}'));
    
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Pokémon no encontrado');
    }
  }
}