// To parse this JSON data, do
//
//     final a = aFromJson(jsonString);

import 'dart:convert';

List<Asi> aFromJson(String str) =>
    List<Asi>.from(json.decode(str).map((x) => Asi.fromJson(x)));

String aToJson(List<Asi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Asi {
  Asi({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Asi.fromJson(Map<String, dynamic> json) => Asi(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
