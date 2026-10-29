import 'edit_profile_model.dart';
import 'edit_profile_service.dart';

class EditProfileRepository {
  final EditProfileService service;

  EditProfileRepository(this.service);

  Future<UserProfileModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    required EditAddressModel address,
  }) async {
    final responseData = await service.updateProfileApi(
      name: name,
      email: email,
      phone: phone,
      address: address,
    );

    // استخراج بيانات الـ User من الـ Response المتوقع
    final userData =
        responseData['data']?['user'] ?? responseData['user'] ?? responseData;
    return UserProfileModel.fromJson(userData);
  }

  Future<void> changeEmail({
    required String email,
    required String password,
  }) async {
    await service.changeEmailApi(
      email: email,
      password: password,
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    await service.changePasswordApi(
      currentPassword: currentPassword,
      nextPassword: nextPassword,
    );
  }
}
