import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../orders/presentation/order_success_page.dart';
import '../data/payment_cubit.dart';
import '../data/payment_model.dart';
import '../data/payment_state.dart';

class PaymentMethodsPage extends StatefulWidget {
  final String? orderNumber;
  final String? email;
  final String initialPaymentMethod;

  const PaymentMethodsPage({
    super.key,
    this.orderNumber,
    this.email,
    this.initialPaymentMethod = 'online',
  });

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  late Razorpay _razorpay;
  late String _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialPaymentMethod;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // عند نجاح الدفع داخل نافذة Razorpay
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final orderNo = widget.orderNumber ?? '';
    final userEmail = widget.email ?? '';

    // توثيق وتأكيد الدفع لدى السيرفر
    context.read<PaymentCubit>().verifyRazorpayPayment(
          orderNumber: orderNo,
          email: userEmail,
          razorpayOrderId: response.orderId ?? '',
          razorpayPaymentId: response.paymentId ?? '',
          razorpaySignature: response.signature ?? '',
        );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  // فتح بوابة Razorpay باستخدام بيانات PaymentResponseModel
  void _openRazorpayCheckout(dynamic responseData) {
    PaymentResponseModel? model;

    if (responseData is PaymentResponseModel) {
      model = responseData;
    } else if (responseData is Map<String, dynamic>) {
      model = PaymentResponseModel.fromJson(responseData);
    }

    final key = model?.keyId ?? '';
    final razorpayOrderId = model?.razorpayOrderId ?? '';
    final amount = model?.amount ?? 0;
    final currency = model?.currency ?? 'INR';

    print('========================================');
    print('🔑 [RAZORPAY DEBUG] Key: $key');
    print('🆔 [RAZORPAY DEBUG] Order ID: $razorpayOrderId');
    print('💰 [RAZORPAY DEBUG] Amount: $amount');
    print('💱 [RAZORPAY DEBUG] Currency: $currency');
    print('========================================');

    var options = {
      'key': key,
      'amount': amount,
      'name': 'Albarakah Perfume',
      'description': 'Order #${widget.orderNumber}',
      'order_id': razorpayOrderId,
      'currency': currency,
      'prefill': {
        'email': widget.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening Razorpay: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        title: const Text(
          'PAYMENT METHOD',
          style: TextStyle(
            color: AppTheme.gold,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.ink,
              Color(0xFF141210),
            ],
          ),
        ),
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            // عند نجاح إنشاء أمر الدفع بالسيرفر، فتح بوابة الدفع فوراً
            if (state is PaymentSuccess) {
              _openRazorpayCheckout(state.data);
            }
            // عند توثيق وتأكيد الدفع بنجاح لدى السيرفر (PaymentVerifiedSuccess)
            else if (state is PaymentVerifiedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment verified and order confirmed!'),
                  backgroundColor: Colors.green,
                ),
              );

              // التوجيه لصفحة نجاح الطلب
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderSuccessPage(),
                ),
                (route) => false,
              );
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // خيار 1: الدفع أونلاين
                  GestureDetector(
                    onTap: () => setState(() => _selectedMethod = 'online'),
                    child: _buildPaymentOptionCard(
                      icon: Icons.credit_card_rounded,
                      title: 'Online Payment (Razorpay)',
                      subtitle:
                          'Pay securely via Credit Card, Debit Card, or UPI',
                      isSelected: _selectedMethod == 'online',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // خيار 2: الدفع عند الاستلام
                  GestureDetector(
                    onTap: () => setState(() => _selectedMethod = 'cod'),
                    child: _buildPaymentOptionCard(
                      icon: Icons.local_shipping_rounded,
                      title: 'Cash on Delivery (COD)',
                      subtitle: 'Pay with cash upon delivery to your doorstep',
                      isSelected: _selectedMethod == 'cod',
                    ),
                  ),

                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.gold.withOpacity(0.35),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: AppTheme.ink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: state is PaymentLoading
                          ? null
                          : () {
                              if (_selectedMethod == 'cod') {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderSuccessPage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                final orderNo = widget.orderNumber ?? '';
                                final userEmail = widget.email ?? '';

                                if (orderNo.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order number is missing!'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                  return;
                                }

                                context.read<PaymentCubit>().startRazorpayOrder(
                                      orderNumber: orderNo,
                                      email: userEmail,
                                    );
                              }
                            },
                      child: state is PaymentLoading
                          ? const CircularProgressIndicator(
                              color: AppTheme.ink,
                            )
                          : Text(
                              _selectedMethod == 'cod'
                                  ? 'CONFIRM COD ORDER'
                                  : 'PAY ONLINE NOW',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSelected = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppTheme.gold : Colors.white24,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.gold.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.gold : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppTheme.ink : Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isSelected ? AppTheme.gold : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: isSelected ? AppTheme.gold : Colors.white38,
          ),
        ],
      ),
    );
  }
}
