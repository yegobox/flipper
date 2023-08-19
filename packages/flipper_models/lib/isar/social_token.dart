import 'dart:convert';

class SocialToken {
  SocialToken({
    required this.statusCode,
    required this.body,
  });

  int statusCode;
  Body body;

  factory SocialToken.fromRawJson(String str) =>
      SocialToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialToken.fromJson(Map<String, dynamic> json) => SocialToken(
        statusCode: json["statusCode"],
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "body": body.toJson(),
      };
}

class Body {
  Body({
    required this.auth,
    required this.token,
    required this.validFrom,
    required this.validUntil,
    required this.status,
  });

  bool auth;
  String token;
  DateTime validFrom;
  DateTime validUntil;
  String status;

  factory Body.fromRawJson(String str) => Body.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        auth: json["auth"],
        token: json["token"],
        validFrom: DateTime.parse(json["validFrom"]),
        validUntil: DateTime.parse(json["validUntil"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "auth": auth,
        "token": token,
        "validFrom": validFrom.toIso8601String(),
        "validUntil": validUntil.toIso8601String(),
        "status": status,
      };
}
