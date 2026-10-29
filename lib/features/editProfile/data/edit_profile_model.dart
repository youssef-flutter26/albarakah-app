class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final EditAddressModel? address;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      // ✅ تحويل آمن للـ Nested Map لمنع الانهيار في الـ Release
      address: json['address'] != null && json['address'] is Map
          ? EditAddressModel.fromJson(
              Map<String, dynamic>.from(json['address']))
          : null,
    );
  }
}

class EditAddressModel {
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String postalCode;
  final String region;

  EditAddressModel({
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.region,
  });

  factory EditAddressModel.fromJson(Map<String, dynamic> json) {
    return EditAddressModel(
      line1: json['line1'] ?? '',
      line2: json['line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      region: json['region'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'region': region,
    };
  }
}
