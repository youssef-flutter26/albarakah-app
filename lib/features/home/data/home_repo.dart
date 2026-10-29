import 'package:alberaperfume/features/home/data/home_api_service.dart';
import 'package:alberaperfume/features/home/data/home_model.dart';

class HomeRepository {
  final HomeApiService _homeApiService;

  HomeRepository(this._homeApiService);

  Future<HomeData> fetchHomeContent() async {
    final response = await _homeApiService.getHomeData();
    if (response.success && response.data != null) {
      print('✅ [HOME REPO SUCCESS]: Fetched data successfully');
      return response.data!;
    } else {
      print('❌ [HOME REPO ERROR]: ${response.message}');
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Failed to load home data',
      );
    }
  }
}
