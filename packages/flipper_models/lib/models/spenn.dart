import 'dart:convert';

Spenn spennFromJson(String str) => Spenn.fromJson(json.decode(str));

String spennToJson(Spenn data) => json.encode(data.toJson());
SpennpaymentStatus spennpaymentStatusFromJson(String str) =>
    SpennpaymentStatus.fromJson(json.decode(str));

String spennPaymentStatusToJson(SpennpaymentStatus data) =>
    json.encode(data.toJson());

class SpennpaymentStatus {
  SpennpaymentStatus({
    required this.userId,
    required this.paymentSuccess,
  });

  String userId;
  int paymentSuccess;

  // ignore: sort_constructors_first
  factory SpennpaymentStatus.fromJson(Map<String, dynamic> json) =>
      SpennpaymentStatus(
        userId: json['user_id'],
        paymentSuccess: json['PaymentSuccess'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'PaymentSuccess': paymentSuccess,
      };
}

class Spenn {
  Spenn({
    required this.id,
    required this.requestId,
    required this.status,
  });

  String id;
  String requestId;
  String status;

  factory Spenn.fromJson(Map<String, dynamic> json) => Spenn(
        id: json['\u0024id'],
        requestId: json['requestId'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        '\u0024id': id,
        'requestId': requestId,
        'status': status,
      };
}
