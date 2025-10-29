class FaceAnalysis {
  final String id;
  final String userId;
  final String imageUrl;
  final Map<String, dynamic> features;
  final String analysis;
  final double confidence;
  final DateTime createdAt;

  FaceAnalysis({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.features,
    required this.analysis,
    required this.confidence,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'imageUrl': imageUrl,
        'features': features,
        'analysis': analysis,
        'confidence': confidence,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FaceAnalysis.fromJson(Map<String, dynamic> json) => FaceAnalysis(
        id: json['id'] as String,
        userId: json['userId'] as String,
        imageUrl: json['imageUrl'] as String,
        features: json['features'] as Map<String, dynamic>,
        analysis: json['analysis'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
