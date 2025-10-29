class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final Map<String, dynamic> attributes;
  final int stockCount;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.attributes,
    required this.stockCount,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrls': imageUrls,
        'attributes': attributes,
        'stockCount': stockCount,
        'rating': rating,
        'reviewCount': reviewCount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String,
        imageUrls: List<String>.from(json['imageUrls'] as List),
        attributes: json['attributes'] as Map<String, dynamic>,
        stockCount: json['stockCount'] as int,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
