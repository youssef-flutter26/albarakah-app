import 'package:alberaperfume/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../data/order_cubit.dart';
import '../data/order_model.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().fetchOrders();
  }

  void _showCancelConfirmation(
    BuildContext context,
    String orderId,
    String orderNumber,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.gold.withOpacity(0.3)),
        ),
        title: Text(
          'Cancel Order #$orderNumber',
          style: const TextStyle(
            color: AppTheme.gold,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this order?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<OrderCubit>().cancelOrder(orderId);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    if (value.length >= 10) {
      return value.substring(0, 10);
    }
    return value.isEmpty ? 'N/A' : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.gold),
        title: const Text(
          'MY ORDERS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            color: AppTheme.gold,
            fontSize: 20,
          ),
        ),
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
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.gold),
              );
            }

            if (state is OrderLoaded) {
              // عرض كل الأوردرات بدون أي استثناء أو فلترة تخفي الجديد
              final ordersList = state.orders;

              if (ordersList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 72,
                        color: AppTheme.gold.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No orders found.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppTheme.gold,
                backgroundColor: AppTheme.ink,
                onRefresh: () async {
                  await context.read<OrderCubit>().fetchOrders();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ordersList.length,
                  itemBuilder: (context, index) {
                    final order = ordersList[index];
                    return _buildOrderCard(context, order);
                  },
                ),
              );
            }

            if (state is OrderError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Could not load your orders.',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<OrderCubit>().fetchOrders();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    // التحقق من الحالة بناءً على النص القادم من الـ API
    final isCancelledState = order.status.toLowerCase().contains('cancel');
    final statusColor =
        isCancelledState ? Colors.redAccent : Colors.greenAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCancelledState
              ? Colors.redAccent.withOpacity(0.35)
              : AppTheme.gold.withOpacity(0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${order.currency} ${order.total}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppTheme.gold,
                  ),
                ),
                if (!isCancelledState) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Cancel order',
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () => _showCancelConfirmation(
                      context,
                      order.id,
                      order.orderNumber,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Status: ${order.status}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Date: ${_formatDate(order.createdAt)}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
