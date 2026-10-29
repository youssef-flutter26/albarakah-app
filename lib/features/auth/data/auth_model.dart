class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class AuthModel {
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final String? message;

  AuthModel({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthModel(
      accessToken: data['token'] ??
          data['accessToken'] ??
          data['access_token'] ??
          json['token'],
      refreshToken:
          data['refreshToken'] ?? data['refresh_token'] ?? json['refreshToken'],
      user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
      message: json['message'] ?? data['message'] ?? '',
    );
  }
}
