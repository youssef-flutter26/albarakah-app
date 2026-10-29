import 'package:alberaperfume/features/products/presentation/data/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo repo;

  ProductCubit({required this.repo}) : super(ProductInitial());

  Future<void> addToCart({required String slug, required int qty}) async {
    emit(ProductActionLoading());
    try {
      await repo.addProductToCart(slug: slug, qty: qty);
      emit(ProductActionSuccess('Added to bag successfully'));
    } catch (e) {
      emit(ProductActionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> toggleWishlist({required String productId, required bool isCurrentlyInWishlist}) async {
    emit(ProductActionLoading());
    try {
      if (isCurrentlyInWishlist) {
        await repo.removeProductFromWishlist(productId);
        emit(ProductActionSuccess('Removed from wishlist'));
      } else {
        await repo.addProductToWishlist(productId);
        emit(ProductActionSuccess('Added to wishlist'));
      }
    } catch (e) {
      emit(ProductActionError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}