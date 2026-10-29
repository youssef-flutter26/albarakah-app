import 'package:flutter/material.dart';
import '../../../core/storage/local_storage.dart';
import '../../../data/models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1});
  final Product product;
  int quantity;
  double get total => (product.price ?? 0) * quantity;
}

class CartController extends ChangeNotifier {
  CartController(this.storage);
  final LocalStorage storage;
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  void add(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
