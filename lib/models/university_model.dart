class University {
  final String name;
  final String website;
  final String country;

  University({
    required this.name,
    required this.website,
    required this.country,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['nombre'] ?? json['name'] ?? 'Universidad',
      website: json['sitio_web'] ?? json['website'] ?? json['web'] ?? 'No disponible',
      country: json['pais'] ?? json['country'] ?? 'Desconocido',
    );
  }
}