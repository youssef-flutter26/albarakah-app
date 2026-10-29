class PaymentResponseModel {
  final bool? ok;
  final String? orderNumber;
  final String? paymentStatus;
  final String? status;
  final String? provider;
  final String? keyId;
  final String? razorpayOrderId;
  final num? amount;
  final String? currency;

  PaymentResponseModel({
    this.ok,
    this.orderNumber,
    this.paymentStatus,
    this.status,
    this.provider,
    this.keyId,
    this.razorpayOrderId,
    this.amount,
    this.currency,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      ok: json['ok'],
      orderNumber: json['orderNumber']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      status: json['status']?.toString(),
      provider: json['provider']?.toString(),
      keyId: json['keyId']?.toString(),
      razorpayOrderId: json['razorpayOrderId']?.toString(),
      amount: json['amount'],
      currency: json['currency']?.toString(),
    );
  }
}
