class CartItemModel {
  final String productId;
  final String slug;
  final String name;
  final String? image;
  final String sizeLabel;
  int qty;
  final num unitPrice;
  final num lineTotal;
  final int stock;
  final bool available;
  final String? message;

  CartItemModel({
    required this.productId,
    required this.slug,
    required this.name,
    this.image,
    required this.sizeLabel,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    required this.stock,
    required this.available,
    this.message,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'https://albarakah.me';

    String imageUrl = '';

    // تحويل آمن لمصفوفة الصور لمنع الـ Exception في الـ Release
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

    return CartItemModel(
      productId: json['productId'] ?? json['_id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      image: imageUrl.isNotEmpty ? imageUrl : null,
      sizeLabel: json['sizeLabel'] ?? '',
      qty: json['qty'] ?? 1,
      unitPrice: json['unitPrice'] ?? 0,
      lineTotal: json['lineTotal'] ?? 0,
      stock: json['stock'] ?? 0,
      available: json['available'] ?? true,
      message: json['message'],
    );
  }
}

class CartModel {
  final String region;
  final String currency;
  final List<CartItemModel> items;
  final int count;
  final num subtotal;
  final num shipping;
  final num total;
  final num freeShippingOver;

  CartModel({
    required this.region,
    required this.currency,
    required this.items,
    required this.count,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.freeShippingOver,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];

    // تحويل العناصر بأمان تام
    List<CartItemModel> itemsList = list
        .where((i) => i is Map)
        .map((i) => CartItemModel.fromJson(Map<String, dynamic>.from(i as Map)))
        .toList();

    return CartModel(
      region: json['region'] ?? 'IN',
      currency: json['currency'] ?? 'INR',
      items: itemsList,
      count: json['count'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      shipping: json['shipping'] ?? 0,
      total: json['total'] ?? 0,
      freeShippingOver: json['freeShippingOver'] ?? 0,
    );
  }
}
