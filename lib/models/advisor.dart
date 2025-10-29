class Advisor {
  final String id;
  final String name;
  final String profileImageUrl;
  final List<String> expertise;
  final String introduction;
  final double rating;
  final int consultationCount;
  final int pricePerMinute;
  final bool isAvailable;
  final DateTime createdAt;

  Advisor({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.expertise,
    required this.introduction,
    required this.rating,
    required this.consultationCount,
    required this.pricePerMinute,
    required this.isAvailable,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profileImageUrl': profileImageUrl,
        'expertise': expertise,
        'introduction': introduction,
        'rating': rating,
        'consultationCount': consultationCount,
        'pricePerMinute': pricePerMinute,
        'isAvailable': isAvailable,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
        id: json['id'] as String,
        name: json['name'] as String,
        profileImageUrl: json['profileImageUrl'] as String,
        expertise: List<String>.from(json['expertise'] as List),
        introduction: json['introduction'] as String,
        rating: (json['rating'] as num).toDouble(),
        consultationCount: json['consultationCount'] as int,
        pricePerMinute: json['pricePerMinute'] as int,
        isAvailable: json['isAvailable'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
