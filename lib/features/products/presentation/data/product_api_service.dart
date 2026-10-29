import '../../../../core/network/api_client.dart';

class ProductApiService {
  final Apiclient apicliemt;

  ProductApiService({required this.apicliemt});

  // إضافة منتج للسلة
  Future<dynamic> addToCart(
      {required String slug, required int qty, String region = 'IN'}) async {
    final response = await apicliemt.post(
      'cart/items?region=$region',
      {'slug': slug, 'qty': qty},
    );
    return response;
  }

  // إضافة منتج للمفضلة
  Future<dynamic> addToWishlist(String productId) async {
    final response = await apicliemt.post(
      'wishlist',
      {'productId': productId},
    );
    return response;
  }

  // إزالة منتج من المفضلة
  Future<dynamic> removeFromWishlist(String productId) async {
    final response = await apicliemt.delete('wishlist/$productId');
    return response;
  }

  // جلب قائمة المفضلة
  Future<dynamic> getwishlist() async {
    final response = await apicliemt.get('wishlist');
    return response;
  }

  // جلب تفاصيل المنتج (مهم لصفحة تفاصيل المنتج UI)
  Future<dynamic> getProductDetails(String idOrSlug) async {
    final response = await apicliemt.get('products/$idOrSlug');
    return response;
  }
}
