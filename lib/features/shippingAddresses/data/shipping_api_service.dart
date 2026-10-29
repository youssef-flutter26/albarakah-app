import '../../../core/network/api_client.dart';
import 'shipping_model.dart';

class ShippingApiService {
  final Apiclient _apiclient;

  ShippingApiService(this._apiclient);

  // جلب العناوين مع التحويل الآمن للاستجابة
  Future<ShippingResponse> getAddresses() async {
    final response = await _apiclient.get('addresses');
    final safeResponse = Map<String, dynamic>.from(response as Map);
    return ShippingResponse.fromJson(safeResponse);
  }

  // إضافة عنوان جديد
  Future<ShippingSingleResponse> addAddress(Map<String, dynamic> body) async {
    final response = await _apiclient.post('addresses', body);
    final safeResponse = Map<String, dynamic>.from(response as Map);
    return ShippingSingleResponse.fromJson(safeResponse);
  }

  // تعديل عنوان
  Future<ShippingSingleResponse> updateAddress(
      String id, Map<String, dynamic> body) async {
    final response = await _apiclient.patch('addresses/$id', body);
    final safeResponse = Map<String, dynamic>.from(response as Map);
    return ShippingSingleResponse.fromJson(safeResponse);
  }

  // حذف عنوان
  Future<Map<String, dynamic>> deleteAddress(String id) async {
    final response = await _apiclient.delete('addresses/$id');
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return {'status': true};
  }
}
