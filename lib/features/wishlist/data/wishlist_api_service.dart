import '../../../core/network/api_client.dart';

class WishlistApiService {
  final Apiclient _apiClient;

  WishlistApiService(this._apiClient);

  Future<dynamic> getWishlist() async {
    final response = await _apiClient.get('wishlist');
    return response;
  }

  Future<dynamic> addToWishlist(String productId) async {
    final response = await _apiClient.post(
      'wishlist',
      {'productId': productId},
    );
    return response;
  }

  Future<dynamic> removeFromWishlist(String productId) async {
    final response = await _apiClient.delete(
      'wishlist/$productId',
    );
    return response;
  }
}
