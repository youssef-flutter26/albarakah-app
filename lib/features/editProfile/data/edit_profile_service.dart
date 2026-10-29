import '../../../core/network/api_client.dart';
import 'edit_profile_model.dart';

class EditProfileService {
  final Apiclient apiClient;

  EditProfileService(this.apiClient);

  Future<Map<String, dynamic>> updateProfileApi({
    required String name,
    required String email,
    required String phone,
    required EditAddressModel address,
  }) async {
    // بناءً على الـ Endpoint في بوستمان (/me)
    final response = await apiClient.patch(
      'me',
       {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address.toJson(),
      },
    );

    return response.data;
  }

  Future<void> changeEmailApi({
    required String email,
    required String password,
  }) async {
    await apiClient.post(
      'auth/me/email',
      {"email": email, "password": password},
    );
  }

  Future<void> changePasswordApi({
    required String currentPassword,
    required String nextPassword,
  }) async {
    await apiClient.post(
      'auth/me/password',
       {"current": currentPassword, "next": nextPassword},
    );
  }
}