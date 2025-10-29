import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/pokemon_service.dart';
import '../models/pokemon_model.dart';

class PokemonFinder extends StatefulWidget {
  @override
  _PokemonFinderState createState() => _PokemonFinderState();
}

class _PokemonFinderState extends State<PokemonFinder> {
  final TextEditingController _nameController = TextEditingController();
  final PokemonService _pokemonService = PokemonService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Pokemon? _pokemon;
  bool _isLoading = false;
  String _error = '';

  void _searchPokemon() async {
    if (_nameController.text.isEmpty) {
      setState(() {
        _error = 'Por favor ingresa el nombre de un Pokémon';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
      _pokemon = null;
    });

    try {
      final pokemon = await _pokemonService.getPokemon(_nameController.text);
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: Pokémon no encontrado';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playPokemonSound() async {
    // Usar un sonido genérico o buscar uno específico del Pokémon
    try {
      await _audioPlayer.play(UrlSource('https://www.soundjay.com/button/beep-07.wav'));
    } catch (e) {
      print('Error reproduciendo sonido: $e');
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'grass': return Colors.green;
      case 'electric': return Colors.yellow[700]!;
      case 'psychic': return Colors.purple;
      case 'ice': return Colors.cyan;
      case 'dragon': return Colors.indigo;
      case 'dark': return Colors.brown;
      case 'fairy': return Colors.pink;
      case 'fighting': return Colors.orange;
      case 'flying': return Colors.lightBlue;
      case 'poison': return Colors.purple;
      case 'ground': return Colors.brown;
      case 'rock': return Colors.grey;
      case 'bug': return Colors.lightGreen;
      case 'ghost': return Colors.deepPurple;
      case 'steel': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Pokémon'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Ingresa el nombre de un Pokémon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Pokémon',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.catching_pokemon),
                hintText: 'pikachu, charmander, bulbasaur, etc.',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchPokemon,
              child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Buscar Pokémon'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            if (_error.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            if (_pokemon != null) ...[
              SizedBox(height: 20),
              Expanded(  // 👈 ESTO ARREGLA EL OVERFLOW
                child: SingleChildScrollView(  // 👈 Y ESTO PERMITE SCROLL
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_pokemon!.spriteUrl.isNotEmpty)
                            Image.network(
                              _pokemon!.spriteUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.catching_pokemon, size: 80, color: Colors.grey);
                              },
                            ),
                          SizedBox(height: 15),
                          Text(
                            '${_pokemon!.name.toUpperCase()} #${_pokemon!.id}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Experiencia base: ${_pokemon!.baseExperience}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 15),
                          if (_pokemon!.types.isNotEmpty) ...[
                            Text(
                              'Tipos:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: _pokemon!.types.map((type) {
                                return Chip(
                                  label: Text(
                                    type.toUpperCase(),
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  backgroundColor: _getTypeColor(type),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 15),
                          ],
                          if (_pokemon!.abilities.isNotEmpty) ...[
                            Text(
                              'Habilidades:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: _pokemon!.abilities.map((ability) {
                                return Chip(
                                  label: Text(
                                    ability.replaceAll('-', ' ').toUpperCase(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.grey[300],
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                          ],
                          ElevatedButton.icon(
                            onPressed: _playPokemonSound,
                            icon: Icon(Icons.volume_up),
                            label: Text('Reproducir Sonido'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ] else if (!_isLoading) ...[
              SizedBox(height: 40),
              Icon(Icons.catching_pokemon, size: 80, color: Colors.grey[400]),
              SizedBox(height: 20),
              Text(
                'Busca tu Pokémon favorito',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}