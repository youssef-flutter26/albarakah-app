class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.topNotes = const [],
    this.heartNotes = const [],
    this.baseNotes = const [],
    this.rating = 4.8,
    this.volumeMl = 100,
  });

  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> topNotes;
  final List<String> heartNotes;
  final List<String> baseNotes;
  final double rating;
  final int volumeMl;

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
        'topNotes': topNotes,
        'heartNotes': heartNotes,
        'baseNotes': baseNotes,
        'rating': rating,
        'volumeMl': volumeMl,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        brand: json['brand'] ?? 'Albera',
        category: json['category'] ?? 'Unisex',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        imageUrl: json['imageUrl'] ?? '',
        description: json['description'] ?? '',
        topNotes: List<String>.from(json['topNotes'] ?? const []),
        heartNotes: List<String>.from(json['heartNotes'] ?? const []),
        baseNotes: List<String>.from(json['baseNotes'] ?? const []),
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        volumeMl: (json['volumeMl'] as num?)?.toInt() ?? 100,
      );
}
