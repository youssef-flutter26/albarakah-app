import 'cart_model.dart';
import 'cart_api_service.dart';

class CartRepository {
  final CartApiService _apiservice;

  CartRepository(this._apiservice);

  Future<CartModel> getCart({String region = 'IN'}) async {
    final response = await _apiservice.getCart(region: region);
    return CartModel.fromJson(response['data']);
  }

  Future<CartModel> addToCart(String productId, int qty) async {
    final response = await _apiservice.addToCart(productId, qty);
    return CartModel.fromJson(response['data']);
  }

  Future<CartModel> updateItem(String productId, int qty) async {
    final response = await _apiservice.updateCartItem(productId, qty);
    return CartModel.fromJson(response['data']);
  }

  Future<CartModel> removeItem(String productId) async {
    final response = await _apiservice.removeFromCart(productId);
    return CartModel.fromJson(response['data']);
  }

  // إضافة دالة تفريغ السلة بالكامل في الـ Repository
  Future<CartModel> clearCart() async {
    final response = await _apiservice.clearCart();
    return CartModel.fromJson(response['data']);
  }
}
