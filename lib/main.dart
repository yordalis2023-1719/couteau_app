import 'package:flutter/material.dart';
import 'widgets/gender_predictor.dart';
import 'widgets/age_predictor.dart';
import 'widgets/university_finder.dart';
import 'widgets/weather_widget.dart';
import 'widgets/pokemon_finder.dart';
import 'widgets/news_reader.dart';
import 'widgets/about_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couteau - Herramientas Múltiples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Couteau - Herramientas Múltiples'),
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[100]!, Colors.orange[100]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/toolbox.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 30),
                Text(
                  'Caja de Herramientas Digital',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Selecciona una herramienta para comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildToolCard(
                      context,
                      'Predicción de Género',
                      Icons.person,
                      Colors.pink,
                      GenderPredictor(),
                    ),
                    _buildToolCard(
                      context,
                      'Predicción de Edad',
                      Icons.cake,
                      Colors.blue,
                      AgePredictor(),
                    ),
                    _buildToolCard(
                      context,
                      'Buscar Universidades',
                      Icons.school,
                      Colors.green,
                      UniversityFinder(),
                    ),
                    _buildToolCard(
                      context,
                      'Clima en RD',
                      Icons.cloud,
                      Colors.cyan,
                      WeatherWidget(),
                    ),
                    _buildToolCard(
                      context,
                      'Buscar Pokémon',
                      Icons.catching_pokemon,
                      Colors.red,
                      PokemonFinder(),
                    ),
                    _buildToolCard(
                      context,
                      'Noticias WordPress',
                      Icons.article,
                      Colors.purple,
                      NewsReader(),
                    ),
                    _buildToolCard(
                      context,
                      'Acerca de',
                      Icons.info,
                      Colors.orange,
                      AboutWidget(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}