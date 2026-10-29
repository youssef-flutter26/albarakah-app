class WishlistResponseModel {
  final bool? success;
  final String? message;
  final List<WishlistItemModel>? data;

  WishlistResponseModel({this.success, this.message, this.data});

  factory WishlistResponseModel.fromJson(dynamic json) {
    if (json is List) {
      return WishlistResponseModel(
        success: true,
        message: '',
        data: json
            .where((item) => item is Map)
            .map((item) => WishlistItemModel.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
    }

    if (json is Map) {
      final safeJson = Map<String, dynamic>.from(json);
      var listSource =
          safeJson['data'] ?? safeJson['wishlist'] ?? safeJson['items'];

      if (listSource != null &&
          listSource is Map &&
          listSource['items'] is List) {
        listSource = listSource['items'];
      }

      List<WishlistItemModel>? items;
      if (listSource is List) {
        items = listSource
            .where((item) => item is Map)
            .map((item) => WishlistItemModel.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      return WishlistResponseModel(
        success: safeJson['success'] ?? true,
        message: safeJson['message']?.toString() ?? '',
        data: items ?? [],
      );
    }

    return WishlistResponseModel(
      success: false,
      message: 'Invalid format',
      data: [],
    );
  }
}

class WishlistItemModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? subtitle;
  final String? image;
  final dynamic price;
  final bool? inStock;

  WishlistItemModel({
    this.id,
    this.name,
    this.slug,
    this.subtitle,
    this.image,
    this.price,
    this.inStock,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final productMap = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : null;

    final extractedId = json['productId']?.toString() ??
        json['id']?.toString() ??
        json['_id']?.toString() ??
        (productMap != null
            ? productMap['id']?.toString() ?? productMap['_id']?.toString()
            : null);

    final extractedName = json['name']?.toString() ??
        (productMap != null ? productMap['name']?.toString() : null) ??
        'Luxury Fragrance';

    String? rawImage = json['image']?.toString() ??
        json['image_url']?.toString() ??
        json['imageUrl']?.toString();
    if (rawImage == null && productMap != null) {
      rawImage = productMap['image']?.toString() ??
          productMap['image_url']?.toString();
    }

    dynamic rawPrice = json['price'];
    if (rawPrice == null && productMap != null) {
      rawPrice = productMap['price'];
    }

    dynamic finalPriceValue = 0.0;
    if (rawPrice is Map) {
      final safePriceMap = Map<String, dynamic>.from(rawPrice);
      finalPriceValue = safePriceMap['INR'] ??
          safePriceMap['AED'] ??
          (safePriceMap.isNotEmpty ? safePriceMap.values.first : 0.0);
    } else {
      finalPriceValue = rawPrice;
    }

    return WishlistItemModel(
      id: extractedId,
      name: extractedName,
      slug: json['slug']?.toString() ??
          (productMap != null ? productMap['slug']?.toString() : ''),
      subtitle: json['subtitle']?.toString() ??
          (productMap != null ? productMap['subtitle']?.toString() : ''),
      image: rawImage,
      price: finalPriceValue,
      inStock: json['inStock'] ??
          (productMap != null ? productMap['inStock'] : true),
    );
  }
}
