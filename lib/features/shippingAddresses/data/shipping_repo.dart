import 'shipping_api_service.dart';
import 'shipping_model.dart';

class ShippingRepo {
  final ShippingApiService _shippingApiService;

  ShippingRepo(this._shippingApiService);

  // جلب القائمة
  Future<List<ShippingAddressModel>> getAddresses() async {
    final response = await _shippingApiService.getAddresses();
    return response.data ?? [];
  }

  // إضافة
  Future<ShippingAddressModel> addAddress(Map<String, dynamic> body) async {
    final response = await _shippingApiService.addAddress(body);
    return response.data!;
  }

  // تعديل
  Future<ShippingAddressModel> updateAddress(
      String id, Map<String, dynamic> body) async {
    final response = await _shippingApiService.updateAddress(id, body);
    return response.data!;
  }

  // حذف
  Future<void> deleteAddress(String id) async {
    await _shippingApiService.deleteAddress(id);
  }
}
