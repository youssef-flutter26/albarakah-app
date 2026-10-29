import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_repo.dart';
import 'wishlist_state.dart';
import 'wishlist_model.dart'; // تأكد من استيراد الـ Model

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistCubit(this._wishlistRepository) : super(WishlistInitial());

  Future<void> fetchWishlist() async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepository.getWishlistItems();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      if (state is WishlistLoaded) {
        final currentState = state as WishlistLoaded;
        final items = List<WishlistItemModel>.from(currentState.items);

        final existingIndex = items.indexWhere(
          (item) => item.id.toString() == productId.toString(),
        );

        if (existingIndex != -1) {
          // 1. حذف العنصر فوراً محلياً ليتغير زر القلب لحظياً
          items.removeAt(existingIndex);
          emit(WishlistLoaded(items));

          // 2. إرسال طلب الحذف للسيرفر في الخلفية
          await _wishlistRepository.removeProductFromWishlist(productId);
        } else {
          // لو المنتج مش موجود، بنضيفه على السيرفر ونحدث القائمة
          await _wishlistRepository.addProductToWishlist(productId);
          await fetchWishlist();
        }
      } else {
        await _wishlistRepository.addProductToWishlist(productId);
        await fetchWishlist();
      }
    } catch (e) {
      // في حال حدث خطأ نعمل Re-fetch لإعادة الحالة الصحيحة من السيرفر
      await fetchWishlist();
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      if (state is WishlistLoaded) {
        final currentState = state as WishlistLoaded;
        final items = List<WishlistItemModel>.from(currentState.items);

        items.removeWhere(
          (item) => item.id.toString() == productId.toString(),
        );
        emit(WishlistLoaded(items)); // تحديث فوري
      }

      await _wishlistRepository.removeProductFromWishlist(productId);
    } catch (e) {
      await fetchWishlist();
    }
  }
}
