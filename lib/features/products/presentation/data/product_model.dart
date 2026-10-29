class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String subtitle;
  final String image;
  final num price;
  final num? compareAtPrice;
  final String sizeLabel;
  final int stock;
  final bool available;
  final bool inStock;
  final String description;
  final String category;
  final String brand;
  final List<ProductModel> related;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.subtitle,
    required this.image,
    required this.price,
    this.compareAtPrice,
    required this.sizeLabel,
    required this.stock,
    required this.available,
    required this.inStock,
    required this.description,
    required this.category,
    required this.brand,
    required this.related,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'https://albarakah.me';

    String imageUrl = '';

    if (json['images'] != null && json['images'] is List) {
      for (var img in (json['images'] as List)) {
        if (img is Map) {
          final safeImg = Map<String, dynamic>.from(img);
          if (safeImg['src'] != null && safeImg['src'].toString().isNotEmpty) {
            imageUrl = safeImg['src'].toString();
            break;
          }
        }
      }
    }

    if (imageUrl.isEmpty) {
      imageUrl = json['image']?.toString() ?? '';
    }

    if (imageUrl.startsWith('/')) {
      imageUrl = '$baseUrl$imageUrl';
    }

    num parseNum(dynamic value, num defaultValue) {
      if (value == null) return defaultValue;
      if (value is num) return value;
      return num.tryParse(value.toString()) ?? defaultValue;
    }

    int parseInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    bool parseBool(dynamic value, bool defaultValue) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is num) return value != 0;
      final str = value.toString().toLowerCase();
      if (str == 'true' || str == '1') return true;
      if (str == 'false' || str == '0') return false;
      return defaultValue;
    }

    var relatedList = <ProductModel>[];
    if (json['related'] != null && json['related'] is List) {
      for (var item in (json['related'] as List)) {
        try {
          if (item is Map) {
            relatedList.add(
              ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
            );
          }
        } catch (e) {
          print('⚠️ [RELATED PRODUCT PARSE ERROR]: $e');
        }
      }
    }

    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: imageUrl,
      price: parseNum(json['price'], 0),
      compareAtPrice: json['compareAtPrice'] != null
          ? parseNum(json['compareAtPrice'], 0)
          : null,
      sizeLabel: json['sizeLabel']?.toString() ?? '100 ML',
      stock: parseInt(json['stock'], 0),
      available: parseBool(json['available'], true),
      inStock: parseBool(json['inStock'] ?? json['available'], true),
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      related: relatedList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'subtitle': subtitle,
      'image': image,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'sizeLabel': sizeLabel,
      'stock': stock,
      'available': available,
      'inStock': inStock,
      'description': description,
      'category': category,
      'brand': brand,
    };
  }
}
