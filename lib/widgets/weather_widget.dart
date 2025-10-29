import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  WeatherData? _weatherData;
  bool _isLoading = false;
  String _error = '';
  bool _isRealData = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final weatherData = await _weatherService.getWeatherInDominicanRepublic();
      setState(() {
        _weatherData = weatherData;
        _isRealData = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el clima: $e';
        _isRealData = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  IconData _getWeatherIcon(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('soleado') || cond.contains('sunny') || cond.contains('clear')) {
      return Icons.wb_sunny;
    } else if (cond.contains('nublado') || cond.contains('cloudy') || cond.contains('overcast')) {
      return Icons.cloud;
    } else if (cond.contains('lluvia') || cond.contains('rain') || cond.contains('drizzle')) {
      return Icons.umbrella;
    } else if (cond.contains('tormenta') || cond.contains('storm') || cond.contains('thunder')) {
      return Icons.flash_on;
    } else if (cond.contains('nieve') || cond.contains('snow')) {
      return Icons.ac_unit;
    } else if (cond.contains('niebla') || cond.contains('fog') || cond.contains('mist')) {
      return Icons.cloud_queue;
    } else {
      return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor(String condition) {
    final cond = condition.toLowerCase();
    if (cond.contains('soleado') || cond.contains('sunny') || cond.contains('clear')) {
      return Colors.orange;
    } else if (cond.contains('nublado') || cond.contains('cloudy')) {
      return Colors.blueGrey;
    } else if (cond.contains('lluvia') || cond.contains('rain')) {
      return Colors.blue;
    } else if (cond.contains('tormenta') || cond.contains('storm')) {
      return Colors.purple;
    } else {
      return Colors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en República Dominicana'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWeather,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Cargando clima actual...'),
                ],
              ),
            )
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 60, color: Colors.red),
                      SizedBox(height: 20),
                      Text(
                        _error,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        child: Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _weatherData != null
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue[300]!, Colors.cyan[100]!],
                        ),
                      ),
                      child: Center(
                        child: Card(
                          elevation: 8,
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icono del clima
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      _getWeatherIcon(_weatherData!.condition),
                                      size: 80,
                                      color: _getWeatherColor(_weatherData!.condition),
                                    ),
                                    if (_weatherData!.icon.isNotEmpty)
                                      Image.network(
                                        _weatherData!.icon,
                                        width: 60,
                                        height: 60,
                                        errorBuilder: (context, error, stackTrace) {
                                          return SizedBox(); // Fallback al icono
                                        },
                                      ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Ubicación
                                Text(
                                  _weatherData!.location,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: 15),
                                
                                // Temperatura
                                Text(
                                  '${_weatherData!.temperature.toStringAsFixed(1)}°C',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                
                                SizedBox(height: 10),
                                
                                // Descripción
                                Text(
                                  _weatherData!.description,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: 30),
                                
                                // Información adicional
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildWeatherInfo(
                                      'Humedad', 
                                      '${_weatherData!.humidity.toStringAsFixed(0)}%', 
                                      Icons.water_drop,
                                      Colors.blue
                                    ),
                                    _buildWeatherInfo(
                                      'Viento', 
                                      '${_weatherData!.windSpeed.toStringAsFixed(1)} km/h', 
                                      Icons.air,
                                      Colors.green
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Mensaje de actualización
                                Text(
                                  'Actualizado: ${DateTime.now().toString().substring(11, 16)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                
                                // Indicador de datos reales
                                if (_isRealData) ...[
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 14),
                                        SizedBox(width: 6),
                                        Text(
                                          'Datos en tiempo real',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay datos del clima disponibles'),
                    ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}