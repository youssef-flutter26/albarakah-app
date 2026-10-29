import 'package:alberaperfume/features/home/data/home_api_service.dart';
import 'package:alberaperfume/features/home/data/home_model.dart';

import '../../features/products/presentation/data/product_model.dart';

class ProductRepository {
  final HomeApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      // بما أن الـ Naming والـ Return Type في الـ HomeApiService بترجع HomeResponseModel جاهزة
      final homeResponse = await _apiService.getHomeData();

      // نأخذ الـ featuredProducts مباشرة من الـ data
      return homeResponse.data?.featuredProducts ?? [];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
