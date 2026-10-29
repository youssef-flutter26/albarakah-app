import 'package:alberaperfume/features/wishlist/data/wishlist_api_service.dart';
import 'package:alberaperfume/features/wishlist/data/wishlist_model.dart';

class WishlistRepository {
  final WishlistApiService _apiService;

  WishlistRepository(this._apiService);

  Future<List<WishlistItemModel>> getWishlistItems() async {
    try {
      final response = await _apiService.getWishlist();
      final wishlistModel = WishlistResponseModel.fromJson(response);
      return wishlistModel.data ?? [];
    } catch (e) {
      throw Exception('Failed to load wishlist: $e');
    }
  }

  Future<void> addProductToWishlist(String productId) async {
    try {
      await _apiService.addToWishlist(productId);
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeProductFromWishlist(String productId) async {
    try {
      await _apiService.removeFromWishlist(productId);
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }
}
