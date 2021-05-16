// To parse this JSON data, do
//
//     final b = bFromJson(jsonString);

import 'dart:convert';

import 'a.dart';

B sbFromJson(String str) => B.fromJson(json.decode(str));

String sbToJson(B data) => json.encode(data.toJson());

List<B> bFromJson(String str) =>
    List<B>.from(json.decode(str).map((x) => B.fromJson(x)));

String bToJson(List<B> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class B {
  B({
    required this.id,
    required this.name,
    required this.asi,
  });

  String id;
  String name;
  List<Asi> asi;

  factory B.fromJson(Map<String, dynamic> json) => B(
        id: json["id"],
        name: json["name"],
        asi: List<Asi>.from(json["asi"].map((x) => Asi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "asi": List<dynamic>.from(asi.map((x) => x.toJson())),
      };
}

class Asi {
  Asi({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Asi.fromJson(Map<String, dynamic> json) => Asi(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
