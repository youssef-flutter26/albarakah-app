import 'package:flutter/material.dart';
import '../../../core/storage/local_storage.dart';
import '../../products/presentation/data/product_model.dart';

class WishlistController extends ChangeNotifier {
  WishlistController(this.storage) {
    _loadStoredWishlist();
  }

  final LocalStorage storage;
  final Set<String> _ids = {};

  bool contains(ProductModel product) => _ids.contains(product.id);

  void _loadStoredWishlist() {
    // يمكنك استرجاع الـ IDs المحفوظة محلياً إن وجدت
    notifyListeners();
  }

  void toggle(ProductModel product) {
    if (_ids.contains(product.id)) {
      _ids.remove(product.id);
    } else {
      _ids.add(product.id);
    }
    notifyListeners();
  }
}
