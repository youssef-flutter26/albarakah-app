import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveJson(String key, dynamic value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  dynamic readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  Future<void> remove(String key) => _prefs.remove(key);

  // --- دوال حفظ وإدارة التوكن الجديدة ---

  // حفظ التوكن
  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  // قراءة التوكن المخزن
  String? getToken() {
    return _prefs.getString('auth_token');
  }

  // حذف التوكن (عند تسجيل الخروج مثلاً)
  Future<void> removeToken() async {
    await _prefs.remove('auth_token');
  }

  // --- التحقق هل المستخدم مسجل دخول أم لا ---
  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
