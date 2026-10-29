import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/data/cart_cubit.dart';
import '../../payment/presentation/payment_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final line1Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();

  String selectedPaymentMethod = 'online';
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(BuildContext context, CartLoaded cartState) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final apiClient = context.read<Apiclient>();

      final itemsList = cartState.cart.items.map((item) {
        return {
          'slug': item.slug,
          'qty': item.qty,
        };
      }).toList();

      // 1. إرسال الطلب لإنشائه في الباك اند
      final response = await apiClient.post(
        'orders',
        {
          'region': 'IN',
          'paymentMethod': selectedPaymentMethod,
          'items': itemsList,
          'customer': {
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'address': {
              'line1': line1Controller.text.trim(),
              'city': cityController.text.trim(),
              'state': stateController.text.trim(),
              'postalCode': postalCodeController.text.trim(),
            },
          },
          'giftNote': {
            'enabled': false,
          },
        },
      );

      print('📦 [CHECKOUT FULL RESPONSE]: $response');

      final responseMap =
          response is Map<String, dynamic> ? response : <String, dynamic>{};

      // استخراج مباشر لرقم الأوردر من أي مكان محتمل في الـ Response
      String orderNumber = '';

      if (responseMap.containsKey('orderNumber')) {
        orderNumber = responseMap['orderNumber'].toString();
      } else if (responseMap.containsKey('data')) {
        final data = responseMap['data'];
        if (data is Map) {
          if (data.containsKey('orderNumber')) {
            orderNumber = data['orderNumber'].toString();
          } else if (data.containsKey('order')) {
            final order = data['order'];
            if (order is Map && order.containsKey('orderNumber')) {
              orderNumber = order['orderNumber'].toString();
            } else if (order is Map && order.containsKey('id')) {
              orderNumber = order['id'].toString();
            }
          }
        }
      }

      print('🏷️ [EXTRACTED ORDER NUMBER]: $orderNumber');

      final customerEmail = emailController.text.trim();

      if (orderNumber.isEmpty) {
        throw Exception('Server did not return a valid order number.');
      }

      // مسح السلة بعد نجاح إنشاء الطلب
      await context.read<CartCubit>().clearCart();

      if (!mounted) return;

      // 2. التوجيه الفوري لصفحة الدفع وتمرير رقم الأوردر وطريقة الدفع
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentMethodsPage(
            orderNumber: orderNumber,
            email: customerEmail,
            initialPaymentMethod: selectedPaymentMethod,
          ),
        ),
      );
    } catch (e) {
      print('❌ [CHECKOUT ERROR]: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
        title: const Text(
          'Checkout',
          style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          String currency = 'INR';
          num total = 0;

          if (state is CartLoaded) {
            currency = state.cart.currency;
            total = state.cart.total;
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Customer details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your phone number'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Address details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: line1Controller,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  decoration: const InputDecoration(
                      labelText: 'Street address (Line 1)'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter street address'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter city'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stateController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter state'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: postalCodeController,
                  style: const TextStyle(color: AppTheme.gold),
                  cursorColor: AppTheme.gold,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter postal code'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // 1. خيار Razorpay
                GestureDetector(
                  onTap: () => setState(() => selectedPaymentMethod = 'online'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedPaymentMethod == 'online'
                            ? AppTheme.gold
                            : Colors.white24,
                        width: selectedPaymentMethod == 'online' ? 1.5 : 1.0,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.credit_card_rounded, color: AppTheme.gold),
                        SizedBox(width: 14),
                        Text(
                          'Online Payment (Razorpay)',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 2. خيار الدفع عند الاستلام (COD)
                GestureDetector(
                  onTap: () => setState(() => selectedPaymentMethod = 'cod'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedPaymentMethod == 'cod'
                            ? AppTheme.gold
                            : Colors.white24,
                        width: selectedPaymentMethod == 'cod' ? 1.5 : 1.0,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping_rounded,
                            color: AppTheme.gold),
                        SizedBox(width: 14),
                        Text(
                          'Cash on Delivery (COD)',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 28, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payable',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.white70),
                    ),
                    Text(
                      '$currency $total',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: AppTheme.ink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading || state is! CartLoaded
                      ? null
                      : () => _submitOrder(context, state),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: AppTheme.ink, strokeWidth: 2),
                        )
                      : const Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
