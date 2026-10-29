import 'package:alberaperfume/core/network/api_client.dart';
import 'home_model.dart';

class HomeApiService {
  final Apiclient _apiClient;

  HomeApiService(this._apiClient);

  Future<HomeResponseModel> getHomeData() async {
    try {
      final response = await _apiClient.get('/home');

      print('🏠 [HOME API RAW RESPONSE]: $response');

      // ✅ التحويل الآمن المضمون للـ Response لتفادي Type Casting Error في الـ Release
      final safeResponse = Map<String, dynamic>.from(response as Map);

      return HomeResponseModel.fromJson(safeResponse);
    } catch (e) {
      print('❌ [HOME API ERROR]: $e');
      throw Exception('Failed to fetch home data: ${e.toString()}');
    }
  }
}
