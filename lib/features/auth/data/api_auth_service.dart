import '../../../core/network/api_client.dart';

class AuthApiService {
  final Apiclient _apiclient;

  AuthApiService(this._apiclient);

  Future<dynamic> register(Map<String, dynamic> data) async {
    final response = await _apiclient.post('auth/register', data);
    return response;
  }

  Future<dynamic> login(Map<String, dynamic> data) async {
    final response = await _apiclient.post('auth/login', data);
    return response;
  }

  // التعديل هنا: نبعت الـ data زي ما بتيجي من الـ Repo (فيها phone و purpose)
  Future<dynamic> sendotp(Map<String, dynamic> data) async {
    final response = await _apiclient.post('auth/send-otp', data);
    return response;
  }

  Future<dynamic> verifyotp(Map<String, dynamic> data) async {
    final response = await _apiclient.post('auth/verify-otp', data);
    return response;
  }

  // في بوستمان الـ Endpoint اسمها auth/reset-password مش forgot-password (حسب الصورة 16)
  Future<dynamic> resetPassword(Map<String, dynamic> data) async {
    final response = await _apiclient.post('auth/reset-password', data);
    return response;
  }
}
