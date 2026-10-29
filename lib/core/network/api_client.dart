import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apiclient {
  Apiclient([http.Client? client]) : _client = client ?? http.Client();
  final http.Client _client;

  String get baseUrl {
    final url = dotenv.env['API_BASE_URL'] ?? 'https://albarakah.me/api/v1';
    return url.endsWith('/') ? url : '$url/';
  }

  Future<Map<String, String>> _getHeaders(Map<String, String>? headers) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('auth_token') ??
        prefs.getString('token') ??
        prefs.getString('access_token');

    print('==============================');
    print('🔑 [API CLIENT] Current Token Found: $token');
    print('==============================');

    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  Future<dynamic> get(String path,
      {Map<String, String>? query, Map<String, String>? headers}) async {
    try {
      final requestHeaders = await _getHeaders(headers);
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final uri =
          Uri.parse('$baseUrl$cleanPath').replace(queryParameters: query);

      print('🌐 [GET REQUEST] URL: $uri');
      print('📦 [GET HEADERS]: $requestHeaders');

      final response = await _client.get(uri, headers: requestHeaders);
      return _decode(response, 'GET', uri.toString());
    } catch (e) {
      print('⚠️ [GET ERROR HANDLED]: $e');
      return {};
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final requestHeaders = await _getHeaders(headers);
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final uri = Uri.parse('$baseUrl$cleanPath');

      print('🌐 [POST REQUEST] URL: $uri');
      print('📦 [POST HEADERS]: $requestHeaders');
      print('📦 [POST BODY]: $body');

      final response = await _client.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body),
      );
      return _decode(response, 'POST', uri.toString());
    } catch (e) {
      print('⚠️ [POST ERROR HANDLED]: $e');
      return {};
    }
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    try {
      final requestHeaders = await _getHeaders(headers);
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final uri = Uri.parse('$baseUrl$cleanPath');

      print('🌐 [PATCH REQUEST] URL: $uri');
      print('📦 [PATCH HEADERS]: $requestHeaders');
      print('📦 [PATCH BODY]: $body');

      final response = await _client.patch(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body),
      );
      return _decode(response, 'PATCH', uri.toString());
    } catch (e) {
      print('⚠️ [PATCH ERROR HANDLED]: $e');
      return {};
    }
  }

  Future<dynamic> delete(String path, {Map<String, String>? headers}) async {
    try {
      final requestHeaders = await _getHeaders(headers);
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      final uri = Uri.parse('$baseUrl$cleanPath');

      print('🌐 [DELETE REQUEST] URL: $uri');
      print('📦 [DELETE HEADERS]: $requestHeaders');

      final response = await _client.delete(uri, headers: requestHeaders);
      return _decode(response, 'DELETE', uri.toString());
    } catch (e) {
      print('⚠️ [DELETE ERROR HANDLED]: $e');
      return {};
    }
  }

  dynamic _decode(http.Response response, String method, String url) {
    print('📱 [$method RESPONSE] URL: $url');
    print('📊 [STATUS CODE]: ${response.statusCode}');
    print('📦 [RESPONSE BODY]: ${response.body}');
    print('==============================');

    if (response.body.isEmpty) return {};

    try {
      // إرجاع الـ Map حتى لو فيها خطأ لمعرفة التفاصيل بدلاً من Map فارغة
      return jsonDecode(response.body);
    } catch (e) {
      return {};
    }
  }
}
