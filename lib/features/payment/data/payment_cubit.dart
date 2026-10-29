import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_repo.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo _paymentRepo;

  PaymentCubit(this._paymentRepo) : super(PaymentInitial());

  // بدء الدفع أونلاين (Razorpay Order)
  void startRazorpayOrder(
      {required String orderNumber, required String email}) async {
    emit(PaymentLoading());
    try {
      print(
          '🚀 [PAYMENT CUBIT] Starting Razorpay order: orderNumber=$orderNumber, email=$email');

      final response = await _paymentRepo.startRazorpayOrder({
        "orderNumber": orderNumber,
        "email": email,
      });

      print('✅ [PAYMENT CUBIT] Success Response: $response');

      if (response.isNotEmpty) {
        emit(PaymentSuccess(response));
      } else {
        print('⚠️ [PAYMENT CUBIT] Warning: Response map is empty!');
        emit(PaymentError('Received empty response from server'));
      }
    } catch (e, stackTrace) {
      print('❌ [PAYMENT CUBIT EXCEPTION]: $e');
      print('📜 [STACK TRACE]: $stackTrace');
      emit(PaymentError(e.toString()));
    }
  }

  // تأكيد وتوثيق الدفع
  void verifyRazorpayPayment({
    required String orderNumber,
    required String email,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    emit(PaymentLoading());
    try {
      print('🚀 [PAYMENT CUBIT] Verifying payment for order: $orderNumber');

      final response = await _paymentRepo.verifyRazorpayPayment({
        "orderNumber": orderNumber,
        "email": email,
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_signature": razorpaySignature,
      });

      print('✅ [PAYMENT CUBIT] Verify Success Response: $response');
      emit(PaymentVerifiedSuccess(response));
    } catch (e) {
      print('❌ [VERIFY EXCEPTION]: $e');
      emit(PaymentError(e.toString()));
    }
  }

  // فحص حالة الدفع برقم الـ Payment ID
  void getPaymentStatus(String paymentId) async {
    emit(PaymentLoading());
    try {
      final response = await _paymentRepo.getPaymentStatus(paymentId);
      emit(PaymentSuccess(response));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
