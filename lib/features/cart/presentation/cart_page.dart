import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/cart_cubit.dart';
import '../../checkout/presentation/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        elevation: 0,
        title: const Text(
          'Your Bag',
          style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final cartState = context.read<CartCubit>().state;
              if (cartState is CartLoaded && cartState.cart.items.isNotEmpty) {
                context.read<CartCubit>().clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared successfully')),
                );
              }
            },
            icon: const Icon(Icons.delete_outline, color: AppTheme.gold),
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.gold));
          } else if (state is CartLoaded) {
            final cart = state.cart;

            if (cart.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 64, color: AppTheme.gold),
                    SizedBox(height: 12),
                    Text(
                      'Your bag is waiting for something beautiful.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.items.map((item) {
                  String imageUrl = item.image ?? '';
                  if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                    imageUrl = 'https://albara-perfume.com$imageUrl';
                  }

                  return Card(
                    color: const Color(0xFF1E1B18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppTheme.gold.withOpacity(0.2)),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 78,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 78,
                                      height: 90,
                                      color: Colors.grey[850],
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.white54),
                                    ),
                                  )
                                : Container(
                                    width: 78,
                                    height: 90,
                                    color: Colors.grey[850],
                                    child: const Icon(Icons.image_not_supported,
                                        color: Colors.white54),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${cart.currency} ${item.unitPrice}',
                                  style: const TextStyle(
                                      color: AppTheme.gold,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Size: ${item.sizeLabel}',
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CartCubit>()
                                            .updateQuantity(
                                              item.productId,
                                              item.qty - 1,
                                            );
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: AppTheme.gold,
                                          size: 20),
                                    ),
                                    Text(
                                      '${item.qty}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<CartCubit>()
                                            .updateQuantity(
                                              item.productId,
                                              item.qty + 1,
                                            );
                                      },
                                      icon: const Icon(Icons.add_circle_outline,
                                          color: AppTheme.gold, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CartCubit>()
                                  .removeItem(item.productId);
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    num calculatedSubtotal = 0;
                    for (var item in cart.items) {
                      calculatedSubtotal += (item.unitPrice * item.qty);
                    }
                    num shippingCost = cart.shipping;
                    num calculatedTotal = calculatedSubtotal + shippingCost;

                    return Column(
                      children: [
                        _summary(
                            'Subtotal', '${cart.currency} $calculatedSubtotal'),
                        _summary(
                          'Shipping',
                          shippingCost == 0
                              ? 'FREE'
                              : '${cart.currency} $shippingCost',
                        ),
                        const Divider(height: 28, color: Colors.white24),
                        _summary(
                          'Total',
                          '${cart.currency} $calculatedTotal',
                          true,
                        ),
                      ],
                    );
                  },
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    );
                  },
                  child: const Text(
                    'PROCEED TO CHECKOUT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text(
              'Start by adding items to your cart!',
              style: TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
    );
  }

  Widget _summary(String label, String value, [bool bold = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? Colors.white : Colors.white70,
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: bold ? AppTheme.gold : Colors.white,
              fontSize: bold ? 18 : 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
