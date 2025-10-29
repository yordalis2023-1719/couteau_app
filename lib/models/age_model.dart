class AgePrediction {
  final String name;
  final int age;
  final int count;

  AgePrediction({
    required this.name,
    required this.age,
    required this.count,
  });

  factory AgePrediction.fromJson(Map<String, dynamic> json) {
    return AgePrediction(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      count: json['count'] ?? 0,
    );
  }

  String getAgeCategory() {
    if (age < 30) return 'Joven';
    if (age < 60) return 'Adulto';
    return 'Anciano';
  }

  String getAgeImage() {
    if (age < 30) return 'assets/images/joven.png';
    if (age < 60) return 'assets/images/adulto.png';
    return 'assets/images/anciano.png';
  }
}