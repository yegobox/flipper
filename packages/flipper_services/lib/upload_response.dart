// To parse this JSON data, do
//
//     final uploadResponse = uploadResponseFromJson(jsonString);

import 'dart:convert';

UploadResponse uploadResponseFromJson(String str) =>
    UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

class UploadResponse {
  String url;

  UploadResponse({required this.url});

  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {'url': url};
}
