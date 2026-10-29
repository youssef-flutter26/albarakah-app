class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final AddressModel? address;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      // ✅ تحويل آمن للـ Nested Map لمنع الانهيار في الـ Release
      address: json['address'] != null && json['address'] is Map
          ? AddressModel.fromJson(Map<String, dynamic>.from(json['address']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (address != null) 'address': address!.toJson(),
    };
  }
}

class AddressModel {
  final String line1;
  final String city;
  final String state;
  final String postalCode;

  AddressModel({
    required this.line1,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      line1: json['line1']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }
}
