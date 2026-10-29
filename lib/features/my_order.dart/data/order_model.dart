class OrderItemModel {
  final String slug;
  final String name;
  final String image;
  final int qty;
  final num unitPrice;
  final num lineTotal;

  OrderItemModel({
    required this.slug,
    required this.name,
    required this.image,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['image']?.toString() ?? '';
    const String baseUrl = 'https://albarakah.me';

    if (imageUrl.startsWith('/')) {
      imageUrl = '$baseUrl$imageUrl';
    }

    return OrderItemModel(
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: imageUrl,
      qty: (json['qty'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?) ?? 0,
      lineTotal: (json['lineTotal'] as num?) ?? 0,
    );
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String trackingId;
  final String status;
  final String createdAt;
  final num total;
  final String currency;
  final List<OrderItemModel> items;

  /// وقت إلغاء الطلب، مستخرج من history في الـ API.
  final DateTime? cancelledAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.trackingId,
    required this.status,
    required this.createdAt,
    required this.total,
    required this.currency,
    required this.items,
    this.cancelledAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['items'] as List? ?? [];

    final itemsList = rawList
        .where((item) => item is Map)
        .map(
          (item) => OrderItemModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    DateTime? parsedCancelledAt;

    // محاولة قراءة وقت الإلغاء من سجل الأحداث.
    final rawHistory = json['history'] as List? ?? [];

    for (final entry in rawHistory) {
      if (entry is! Map) continue;

      final historyEntry = Map<String, dynamic>.from(entry);
      final historyStatus =
          historyEntry['status']?.toString().toLowerCase().trim() ?? '';

      if (historyStatus == 'cancelled' || historyStatus == 'canceled') {
        final rawDate = historyEntry['at']?.toString();

        if (rawDate != null) {
          final parsedDate = DateTime.tryParse(rawDate);

          if (parsedDate != null &&
              (parsedCancelledAt == null ||
                  parsedDate.isAfter(parsedCancelledAt))) {
            parsedCancelledAt = parsedDate;
          }
        }
      }
    }

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      trackingId: json['trackingId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Order Placed',
      createdAt: json['createdAt']?.toString() ?? '',
      total: (json['total'] as num?) ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      items: itemsList,
      cancelledAt: parsedCancelledAt,
    );
  }

  bool get isCancelled {
    final normalizedStatus = status.toLowerCase().trim();
    return normalizedStatus == 'cancelled' || normalizedStatus == 'canceled';
  }

  /// الطلب الملغي يظل ظاهرًا لمدة 24 ساعة من وقت الإلغاء.
  bool get shouldBeVisible {
    if (!isCancelled) return true;

    // لو الـ API لم يرجع وقت الإلغاء، نخفيش الطلب تلقائيًا
    // حتى لا تختفي بياناته بشكل غير متوقع.
    if (cancelledAt == null) return true;

    final elapsed = DateTime.now().difference(cancelledAt!.toLocal());
    return elapsed < const Duration(hours: 24);
  }
}
