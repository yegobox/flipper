// To parse this JSON data, do
//
//

import 'dart:convert';

SubscriptionError subscriptionErrorFromJson(String str) =>
    SubscriptionError.fromJson(json.decode(str));

String subscriptionErrorToJson(SubscriptionError data) =>
    json.encode(data.toJson());

class SubscriptionError {
  Message message;

  SubscriptionError({
    this.message,
  });

  factory SubscriptionError.fromJson(Map<String, dynamic> json) =>
      SubscriptionError(
        message: Message.fromJson(json['message']),
      );

  Map<String, dynamic> toJson() => {
        'message': message.toJson(),
      };
}

class Message {
  String status;
  String message;
  Data data;

  Message({
    this.status,
    this.message,
    this.data,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        status: json['status'],
        message: json['message'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class Data {
  String message;

  Data({
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
