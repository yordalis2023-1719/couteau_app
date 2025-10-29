class GenderPrediction {
  final String name;
  final String gender;
  final double probability;
  final int count;

  GenderPrediction({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  factory GenderPrediction.fromJson(Map<String, dynamic> json) {
    return GenderPrediction(
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'unknown',
      probability: (json['probability'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}