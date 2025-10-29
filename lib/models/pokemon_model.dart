class Pokemon {
  final String name;
  final int id;
  final int baseExperience;
  final String spriteUrl;
  final List<String> abilities;
  final List<String> types;

  Pokemon({
    required this.name,
    required this.id,
    required this.baseExperience,
    required this.spriteUrl,
    required this.abilities,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final abilities = json['abilities'] != null
        ? List<Map<String, dynamic>>.from(json['abilities'])
            .map((ability) => ability['ability']['name'] as String)
            .toList()
        : <String>[];

    final types = json['types'] != null
        ? List<Map<String, dynamic>>.from(json['types'])
            .map((type) => type['type']['name'] as String)
            .toList()
        : <String>[];

    return Pokemon(
      name: json['name'] ?? 'Desconocido',
      id: json['id'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      spriteUrl: json['sprites'] != null && json['sprites']['front_default'] != null
          ? json['sprites']['front_default'] as String
          : '',
      abilities: abilities,
      types: types,
    );
  }
}