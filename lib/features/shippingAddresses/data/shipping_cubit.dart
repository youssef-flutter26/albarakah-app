import 'package:flutter_bloc/flutter_bloc.dart';
import 'shipping_model.dart';
import 'shipping_repo.dart';
import 'shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingRepo _shippingRepo;

  ShippingCubit(this._shippingRepo) : super(ShippingInitial());

  List<ShippingAddressModel> addressesList = [];

  // جلب العناوين
  void getAddresses() async {
    emit(ShippingLoading());
    try {
      addressesList = await _shippingRepo.getAddresses();
      emit(ShippingLoaded(addressesList));
    } catch (error) {
      emit(ShippingError(error.toString()));
    }
  }

  // إضافة عنوان جديد
  void addAddress(Map<String, dynamic> body) async {
    emit(ShippingAddUpdateLoading());
    try {
      await _shippingRepo.addAddress(body);
      emit(ShippingAddSuccess());
      getAddresses(); // تحديث القائمة فوراً
    } catch (error) {
      emit(ShippingError(error.toString()));
    }
  }

  // تعديل عنوان
  void updateAddress(String id, Map<String, dynamic> body) async {
    emit(ShippingAddUpdateLoading());
    try {
      await _shippingRepo.updateAddress(id, body);
      emit(ShippingUpdateSuccess());
      getAddresses(); // تحديث القائمة فوراً
    } catch (error) {
      emit(ShippingError(error.toString()));
    }
  }

  // حذف عنوان
  void deleteAddress(String id) async {
    emit(ShippingDeleteLoading(id));
    try {
      await _shippingRepo.deleteAddress(id);
      emit(ShippingDeleteSuccess());
      getAddresses(); // تحديث القائمة فوراً
    } catch (error) {
      emit(ShippingError(error.toString()));
    }
  }
}
