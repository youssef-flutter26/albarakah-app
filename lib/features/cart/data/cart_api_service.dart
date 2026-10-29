import '../../../core/network/api_client.dart';

class CartApiService {
  final Apiclient _apiclient;

  CartApiService(this._apiclient);

  // جلب السلة
  Future<Map<String, dynamic>> getCart({String region = 'IN'}) async {
    final response = await _apiclient.get(
      'cart',
      query: {'region': region},
    );
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  // إضافة منتج للسلة
  Future<Map<String, dynamic>> addToCart(String productId, int qty) async {
    final response = await _apiclient.post(
      'cart/items',
      {
        'productId': productId,
        'qty': qty,
      },
    );
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  // تعديل كمية منتج في السلة
  Future<Map<String, dynamic>> updateCartItem(String productId, int qty) async {
    final response = await _apiclient.patch(
      'cart/items/$productId',
      {
        'qty': qty,
      },
    );
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  // حذف منتج من السلة
  Future<Map<String, dynamic>> removeFromCart(String productId) async {
    final response = await _apiclient.delete(
      'cart/items/$productId',
    );
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  // تفريغ السلة بالكامل
  Future<Map<String, dynamic>> clearCart() async {
    final response = await _apiclient.delete(
      'cart',
    );
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {};
  }
}
