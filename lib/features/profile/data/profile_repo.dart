import 'package:alberaperfume/features/profile/data/profile_model.dart';
import '../../../../core/network/api_client.dart';

class ProfileRepository {
  final Apiclient apiclient;

  ProfileRepository(this.apiclient);

  // جلب البيانات الحالية للبروفايل
  Future<ProfileModel> getCurrentProfile() async {
    final response = await apiclient.get('/me');

    // بما أن الـ ApiClient بيرجع الـ JSON بعد الـ decode مباشرة
    // فـ response هنا عبارة عن Map<String, dynamic> جاهزة
    final Map<String, dynamic> jsonMap;

    if (response is Map<String, dynamic>) {
      if (response.containsKey('data') &&
          response['data'] is Map<String, dynamic>) {
        jsonMap = response['data'];
      } else if (response.containsKey('user') &&
          response['user'] is Map<String, dynamic>) {
        jsonMap = response['user'];
      } else {
        jsonMap = response;
      }
    } else {
      jsonMap = {};
    }

    return ProfileModel.fromJson(jsonMap);
  }

  // تحديث بيانات البروفايل
  Future<void> updateProfile(ProfileModel profileModel) async {
    await apiclient.patch('/me', profileModel.toJson());
  }
}
