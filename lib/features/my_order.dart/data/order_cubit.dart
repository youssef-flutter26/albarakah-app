import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_model.dart';
import 'order_repo.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;

  OrderLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;

  OrderCubit(this._repository) : super(OrderInitial());

  Future<void> fetchOrders() async {
    emit(OrderLoading());

    try {
      final orders = await _repository.getMyOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      if (orderId.trim().isEmpty) {
        emit(OrderError('Order ID is missing'));
        return;
      }

      await _repository.cancelOrder(orderId);

      // إعادة تحميل الطلبات بعد تأكيد نجاح الإلغاء من السيرفر.
      await fetchOrders();
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
