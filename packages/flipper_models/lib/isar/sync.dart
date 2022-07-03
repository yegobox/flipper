library flipper_models;

import 'dart:convert';

import 'package:flipper_models/isar_models.dart';

SyncF syncFFromJson(String str) => SyncF.fromJson(json.decode(str));

String syncFToJson(SyncF data) => json.encode(data.toJson());

class SyncF {
  SyncF({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    required this.channels,
    required this.points,
  });

  int id;
  String phoneNumber;
  String token;
  List<Tenant> tenants;
  List<String> channels;
  int points;

  factory SyncF.fromJson(Map<dynamic, dynamic> json) => SyncF(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        tenants:
            List<Tenant>.from(json["tenants"].map((x) => Tenant.fromJson(x))),
        channels: List<String>.from(json["channels"].map((x) => x)),
        points: json["points"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "token": token,
        "tenants": List<dynamic>.from(tenants.map((x) => x.toJson())),
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "points": points,
      };
}

class Tenant {
  Tenant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.permissions,
    required this.branches,
    required this.businesses,
  });

  int id;
  String name;
  String phoneNumber;
  String? email;
  List<Permission> permissions;
  List<Branch> branches;
  List<Business> businesses;

  factory Tenant.fromJson(Map<dynamic, dynamic> json) => Tenant(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        permissions: List<Permission>.from(
            json["permissions"].map((x) => Permission.fromJson(x))),
        branches:
            List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
        businesses: List<Business>.from(
            json["businesses"].map((x) => Business.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
        "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
        "businesses": List<dynamic>.from(businesses.map((x) => x.toJson())),
      };
}
