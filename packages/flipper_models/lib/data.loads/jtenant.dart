import 'dart:convert';

import 'package:flipper_models/isar_models.dart';

JTenant jTenantFromJson(String str) => JTenant.fromJson(json.decode(str));
List<JTenant> jListTenantFromJson(String str) =>
    List<JTenant>.from(json.decode(str).map((x) => JTenant.fromJson(x)));

String jTenantToJson(List<JTenant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JTenant {
  JTenant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.permissions,
    required this.branches,
    required this.businesses,
    required this.businessId,
    required this.nfcEnabled,
    required this.userId,
  });

  late int id;
  String name;
  String phoneNumber;
  String email;
  List<Permission> permissions;
  List<Branch> branches;
  List<Business> businesses;
  int businessId;
  int userId;
  bool nfcEnabled;

  factory JTenant.fromJson(Map<dynamic, dynamic> json) => JTenant(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      email: json["email"] ?? "",
      permissions: List<Permission>.from(
          json["permissions"].map((x) => Permission.fromJson(x))),
      branches:
          List<Branch>.from(json["branches"].map((x) => Branch.fromJson(x))),
      businesses: List<Business>.from(
          json["businesses"].map((x) => Business.fromJson(x))),
      businessId: json["businessId"],
      nfcEnabled: json["nfcEnabled"],
      userId: json["userId"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "permissions": List<dynamic>.from(permissions.map((x) => x.toJson())),
        "branches": List<dynamic>.from(branches.map((x) => x.toJson())),
        "businesses": List<dynamic>.from(businesses.map((x) => x.toJson())),
        "businessId": businessId,
        "nfcEnabled": nfcEnabled,
        "userId": userId
      };
}
