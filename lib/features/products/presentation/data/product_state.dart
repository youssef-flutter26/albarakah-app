abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductActionLoading extends ProductState {}

class ProductActionSuccess extends ProductState {
  final String message;
  ProductActionSuccess(this.message);
}

class ProductActionError extends ProductState {
  final String message;
  ProductActionError(this.message);
}
