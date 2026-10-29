import 'payment_api_service.dart';

class PaymentRepo {
  final PaymentApiService _paymentApiService;

  PaymentRepo(this._paymentApiService);

  Future<Map<String, dynamic>> startRazorpayOrder(
      Map<String, dynamic> body) async {
    return await _paymentApiService.startRazorpayOrder(body);
  }

  Future<Map<String, dynamic>> verifyRazorpayPayment(
      Map<String, dynamic> body) async {
    return await _paymentApiService.verifyRazorpayPayment(body);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> body) async {
    return await _paymentApiService.createOrder(body);
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    return await _paymentApiService.getPaymentStatus(paymentId);
  }
}
