// To parse this JSON data, do
//
//     final uploadResponse = uploadResponseFromJson(jsonString);

import 'dart:convert';

UploadResponse uploadResponseFromJson(String str) =>
    UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

class UploadResponse {
  String url;
  dynamic productId;

  UploadResponse({
    this.url,
    this.productId,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        url: json['url'],
        productId: json['product_id'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'product_id': productId,
      };
}
