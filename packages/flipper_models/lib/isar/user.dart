import 'dart:convert';

import 'package:flipper_models/isar_models.dart';

class IUser {
  IUser({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    required this.channels,
  });

  int id;
  String phoneNumber;
  String token;
  List<Tenant> tenants;
  List<String> channels;

  factory IUser.fromRawJson(String str) => IUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IUser.fromJson(Map<String, dynamic> json) => IUser(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        tenants:
            List<Tenant>.from(json["tenants"].map((x) => Tenant.fromJson(x))),
        channels: List<String>.from(json["channels"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "token": token,
        "tenants": List<dynamic>.from(tenants.map((x) => x.toJson())),
        "channels": List<dynamic>.from(channels.map((x) => x)),
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
    required this.businessId,
    required this.nfcEnabled,
  });

  int id;
  String name;
  String phoneNumber;
  String? email;
  List<Permission> permissions;
  List<Branch> branches;
  List<Business> businesses;
  int businessId;
  bool nfcEnabled;

  factory Tenant.fromRawJson(String str) => Tenant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"] ?? json["phoneNumber"],
        permissions: List<Permission>.from(
            json["permissions"].map((x) => Permission.fromJson(x))),
        branches:
            List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
        businesses: List<Business>.from(
            json["businesses"].map((x) => Business.fromJson(x))),
        businessId: json["businessId"],
        nfcEnabled: json["nfcEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email ?? phoneNumber,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
        "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
        "businesses": List<dynamic>.from(businesses.map((x) => x.toJson())),
        "businessId": businessId,
        "nfcEnabled": nfcEnabled,
      };
}
