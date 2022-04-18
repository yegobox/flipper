// To parse this JSON data, do
//
//     final ebm = ebmFromJson(jsonString);

import 'dart:convert';

Ebm ebmFromJson(String str) => Ebm.fromJson(json.decode(str));

String ebmToJson(Ebm data) => json.encode(data.toJson());

class Ebm {
  Ebm({
    required this.bhfId,
    required this.tinNumber,
    required this.dvcSrlNo,
    required this.userId,
  });

  String bhfId;
  int tinNumber;
  String dvcSrlNo;
  String? userId;

  factory Ebm.fromJson(Map<String, dynamic> json) => Ebm(
        bhfId: json["bhfId"],
        tinNumber: json["tinNumber"],
        dvcSrlNo: json["dvcSrlNo"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "bhfId": bhfId,
        "tinNumber": tinNumber,
        "dvcSrlNo": dvcSrlNo,
        "userId": userId,
      };
}
