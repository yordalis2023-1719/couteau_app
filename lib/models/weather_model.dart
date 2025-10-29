class WeatherData {
  final String location;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final String condition;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final current = json['current'] ?? {};
    final condition = current['condition'] ?? {};

    // Manejar diferentes formatos de icono
    String iconUrl = condition['icon'] ?? '';
    if (iconUrl.isNotEmpty && !iconUrl.startsWith('http')) {
      iconUrl = 'https:${condition['icon']}';
    }

    return WeatherData(
      location: location['name'] ?? 'Santo Domingo',
      temperature: (current['temp_c'] ?? 0.0).toDouble(),
      description: condition['text'] ?? 'Desconocido',
      icon: iconUrl,
      humidity: (current['humidity'] ?? 0.0).toDouble(),
      windSpeed: (current['wind_kph'] ?? 0.0).toDouble(),
      condition: condition['text'] ?? 'Desconocido',
    );
  }
}