class TarotCard {
  final String id;
  final String name;
  final String nameKo;
  final String description;
  final String imageUrl;
  final bool isReversed;

  TarotCard({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.description,
    required this.imageUrl,
    this.isReversed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameKo': nameKo,
        'description': description,
        'imageUrl': imageUrl,
        'isReversed': isReversed,
      };

  factory TarotCard.fromJson(Map<String, dynamic> json) => TarotCard(
        id: json['id'] as String,
        name: json['name'] as String,
        nameKo: json['nameKo'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        isReversed: json['isReversed'] as bool? ?? false,
      );
}

class TarotReading {
  final String id;
  final String userId;
  final String spreadType;
  final List<TarotCard> cards;
  final String question;
  final String analysis;
  final DateTime createdAt;

  TarotReading({
    required this.id,
    required this.userId,
    required this.spreadType,
    required this.cards,
    required this.question,
    required this.analysis,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'spreadType': spreadType,
        'cards': cards.map((c) => c.toJson()).toList(),
        'question': question,
        'analysis': analysis,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TarotReading.fromJson(Map<String, dynamic> json) => TarotReading(
        id: json['id'] as String,
        userId: json['userId'] as String,
        spreadType: json['spreadType'] as String,
        cards: (json['cards'] as List).map((c) => TarotCard.fromJson(c as Map<String, dynamic>)).toList(),
        question: json['question'] as String,
        analysis: json['analysis'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
