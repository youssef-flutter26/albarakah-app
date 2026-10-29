import 'package:shared_preferences/shared_preferences.dart';
import 'auth_model.dart';

class AuthRepository {
  final dynamic apiservice;

  AuthRepository({required this.apiservice});

  // 1. Login
  Future<dynamic> login(
      {required String identifier, required String password}) async {
    try {
      final response = await apiservice.login({
        'identifier': identifier,
        'password': password,
      });

      print('🚨 [SERVER RESPONSE]: $response');

      dynamic rawData = response;
      if (response != null && response is! Map && response.data != null) {
        rawData = response.data;
      }

      final Map<String, dynamic> responseData = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};

      final model = AuthModel.fromJson(responseData);

      print('🚨 [PARSED ACCESS TOKEN]: ${model.accessToken}');

      final tokenToSave = model.accessToken;

      if (tokenToSave != null && tokenToSave.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', tokenToSave);
        await prefs.setString('access_token', tokenToSave);
        print('✅ [TOKEN SAVED SUCCESSFULLY]: $tokenToSave');
      } else {
        print('❌ [TOKEN IS NULL OR EMPTY!]');
      }

      return model;
    } catch (e) {
      print('❌ [LOGIN ERROR]: $e');
      rethrow;
    }
  }

  // 2. Register
  Future<dynamic> register(Map<String, dynamic> userData) async {
    try {
      final response = await apiservice.register(userData);

      print('🚨 [REGISTER SERVER RESPONSE]: $response');

      dynamic rawData = response;
      if (response != null && response is! Map && response.data != null) {
        rawData = response.data;
      }

      final Map<String, dynamic> responseData = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};

      final model = AuthModel.fromJson(responseData);

      final tokenToSave = model.accessToken;
      if (tokenToSave != null && tokenToSave.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', tokenToSave);
        await prefs.setString('access_token', tokenToSave);
        print('✅ [REGISTER TOKEN SAVED]: $tokenToSave');
      }

      return model;
    } catch (e) {
      print('❌ [REGISTER ERROR]: $e');
      rethrow;
    }
  }

  // 3. Verify OTP
  Future<dynamic> verifyotp(String phone, String otp, String purpose) async {
    try {
      final response = await apiservice.verifyotp({
        'phone': phone,
        'otp': otp,
        'purpose': purpose,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 4. Reset Password
  Future<dynamic> resetPassword(String token, String password) async {
    try {
      final response = await apiservice.resetPassword({
        'token': token,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
