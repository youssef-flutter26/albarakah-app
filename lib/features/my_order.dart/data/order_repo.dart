import '../../../core/network/api_client.dart';
import 'order_model.dart';

class OrderRepository {
  final Apiclient apiClient;

  OrderRepository(this.apiClient);

  Future<List<OrderModel>> getMyOrders() async {
    final response = await apiClient.get('orders/mine');

    dynamic rawOrders;

    if (response is List) {
      rawOrders = response;
    } else if (response is Map) {
      rawOrders =
          response['items'] ?? response['data'] ?? response['orders'] ?? [];
    }

    if (rawOrders is! List) {
      throw Exception('Invalid orders response from server');
    }

    return rawOrders
        .where((json) => json is Map)
        .map(
          (json) => OrderModel.fromJson(
            Map<String, dynamic>.from(json as Map),
          ),
        )
        .toList();
  }

  Future<void> cancelOrder(String orderId) async {
    if (orderId.trim().isEmpty) {
      throw Exception('Order ID is missing');
    }

    await apiClient.post(
      'orders/mine/$orderId/cancel',
      {
        'reason': 'Cancelled by user',
      },
    );
  }
}
