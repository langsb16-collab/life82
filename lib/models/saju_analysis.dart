class SajuAnalysis {
  final String id;
  final String userId;
  final DateTime birthDate;
  final String birthTime;
  final String gender;
  final Map<String, dynamic> pillars;
  final Map<String, dynamic> elements;
  final String analysis;
  final Map<String, String> categoryAnalysis;
  final DateTime createdAt;

  SajuAnalysis({
    required this.id,
    required this.userId,
    required this.birthDate,
    required this.birthTime,
    required this.gender,
    required this.pillars,
    required this.elements,
    required this.analysis,
    required this.categoryAnalysis,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'birthDate': birthDate.toIso8601String(),
        'birthTime': birthTime,
        'gender': gender,
        'pillars': pillars,
        'elements': elements,
        'analysis': analysis,
        'categoryAnalysis': categoryAnalysis,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SajuAnalysis.fromJson(Map<String, dynamic> json) => SajuAnalysis(
        id: json['id'] as String,
        userId: json['userId'] as String,
        birthDate: DateTime.parse(json['birthDate'] as String),
        birthTime: json['birthTime'] as String,
        gender: json['gender'] as String,
        pillars: json['pillars'] as Map<String, dynamic>,
        elements: json['elements'] as Map<String, dynamic>,
        analysis: json['analysis'] as String,
        categoryAnalysis: Map<String, String>.from(json['categoryAnalysis'] as Map),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
