class ShippingResponse {
  final bool? success;
  final String? message;
  final List<ShippingAddressModel>? data;

  ShippingResponse({this.success, this.message, this.data});

  factory ShippingResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'] as List? ?? [];
    List<ShippingAddressModel> addressList = rawList
        .where((item) => item is Map)
        .map((item) => ShippingAddressModel.fromJson(
            Map<String, dynamic>.from(item as Map)))
        .toList();

    return ShippingResponse(
      success: json['success'],
      message: json['message']?.toString(),
      data: json['data'] != null ? addressList : null,
    );
  }
}

class ShippingSingleResponse {
  final bool? success;
  final String? message;
  final ShippingAddressModel? data;

  ShippingSingleResponse({this.success, this.message, this.data});

  factory ShippingSingleResponse.fromJson(Map<String, dynamic> json) {
    return ShippingSingleResponse(
      success: json['success'],
      message: json['message']?.toString(),
      data: json['data'] != null && json['data'] is Map
          ? ShippingAddressModel.fromJson(
              Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

class ShippingAddressModel {
  final String? id;
  final String? label;
  final String? fullName;
  final String? phone;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? countryCode;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;

  ShippingAddressModel({
    this.id,
    this.label,
    this.fullName,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      label: json['label']?.toString(),
      fullName: json['fullName']?.toString(),
      phone: json['phone']?.toString(),
      addressLine1: json['addressLine1']?.toString(),
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postalCode']?.toString(),
      countryCode: json['countryCode']?.toString(),
      isDefault: json['isDefault'],
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (label != null) 'label': label,
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (countryCode != null) 'countryCode': countryCode,
      if (isDefault != null) 'isDefault': isDefault,
    };
  }
}
