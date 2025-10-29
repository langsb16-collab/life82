class PalmAnalysis {
  final String id;
  final String userId;
  final String imageUrl;
  final Map<String, dynamic> lines;
  final String analysis;
  final double confidence;
  final DateTime createdAt;

  PalmAnalysis({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.lines,
    required this.analysis,
    required this.confidence,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'imageUrl': imageUrl,
        'lines': lines,
        'analysis': analysis,
        'confidence': confidence,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PalmAnalysis.fromJson(Map<String, dynamic> json) => PalmAnalysis(
        id: json['id'] as String,
        userId: json['userId'] as String,
        imageUrl: json['imageUrl'] as String,
        lines: json['lines'] as Map<String, dynamic>,
        analysis: json['analysis'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
