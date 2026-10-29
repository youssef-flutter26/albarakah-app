import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_repo.dart';
import 'cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(CartInitial());

  Future<void> fetchCart({String region = 'IN'}) async {
    emit(CartLoading());
    try {
      final cart = await _repository.getCart(region: region);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addToCart(String productId, int qty) async {
    try {
      final cart = await _repository.addToCart(productId, qty);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateQuantity(String productId, int qty) async {
    try {
      final cart = await _repository.updateItem(productId, qty);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      final cart = await _repository.removeItem(productId);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // دالة تفريغ السلة بالكامل المضافة حديثاً
  Future<void> clearCart() async {
    try {
      final cart = await _repository.clearCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
