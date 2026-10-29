import 'package:alberaperfume/features/wishlist/data/wishlist_model.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItemModel> items;
  WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
