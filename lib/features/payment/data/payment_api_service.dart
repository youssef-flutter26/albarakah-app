import '../../../../core/network/api_client.dart';

class PaymentApiService {
  final Apiclient _apiclient;

  PaymentApiService(this._apiclient);

  Future<Map<String, dynamic>> startRazorpayOrder(
      Map<String, dynamic> body) async {
    final response = await _apiclient.post('payments/razorpay/order', body);

    if (response is Map) {
      // لو الاستجابة فيها مفتاح data يرجع محتواه، لو مفيهاش يرجع الـ response كله
      if (response.containsKey('data') && response['data'] is Map) {
        return Map<String, dynamic>.from(response['data']);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  Future<Map<String, dynamic>> verifyRazorpayPayment(
      Map<String, dynamic> body) async {
    final response = await _apiclient.post('payments/razorpay/verify', body);

    if (response is Map) {
      if (response.containsKey('data') && response['data'] is Map) {
        return Map<String, dynamic>.from(response['data']);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> body) async {
    final response = await _apiclient.post('payments/create-order', body);

    if (response is Map) {
      if (response.containsKey('data') && response['data'] is Map) {
        return Map<String, dynamic>.from(response['data']);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    final response = await _apiclient.get('payments/$paymentId');

    if (response is Map) {
      if (response.containsKey('data') && response['data'] is Map) {
        return Map<String, dynamic>.from(response['data']);
      }
      return Map<String, dynamic>.from(response);
    }
    return {};
  }
}
