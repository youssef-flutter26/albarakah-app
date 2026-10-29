import 'shipping_model.dart';

abstract class ShippingState {}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingLoaded extends ShippingState {
  final List<ShippingAddressModel> addresses;

  ShippingLoaded(this.addresses);
}

class ShippingAddUpdateLoading extends ShippingState {}

class ShippingAddSuccess extends ShippingState {}

class ShippingUpdateSuccess extends ShippingState {}

class ShippingDeleteLoading extends ShippingState {
  final String id;

  ShippingDeleteLoading(this.id);
}

class ShippingDeleteSuccess extends ShippingState {}

class ShippingError extends ShippingState {
  final String message;

  ShippingError(this.message);
}
