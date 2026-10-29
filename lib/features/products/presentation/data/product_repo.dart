import 'product_api_service.dart';
import 'product_model.dart';

class ProductRepo {
  final ProductApiService apiservice;

  ProductRepo({required this.apiservice});

  Future<void> addProductToCart(
      {required String slug, required int qty}) async {
    await apiservice.addToCart(slug: slug, qty: qty);
  }

  Future<void> addProductToWishlist(String productId) async {
    await apiservice.addToWishlist(productId);
  }

  Future<void> removeProductFromWishlist(String productId) async {
    await apiservice.removeFromWishlist(productId);
  }

  // جلب تفاصيل المنتج وإرجاعه كـ ProductModel
  Future<ProductModel> getProductDetails(String idOrSlug) async {
    final response = await apiservice.getProductDetails(idOrSlug);
    // بناءً على شكل الـ Response اللي عندك اللي بيبدأ بـ data
    final data = response['data'] ?? response;
    return ProductModel.fromJson(data);
  }
}
