library flipper_models;

import 'package:flipper_models/models/models.dart';
import 'dart:convert';

TenantSync stenantFromJson(String str) => TenantSync.fromJson(json.decode(str));
String stenantToJson(TenantSync data) => json.encode(data.toJson());

List<TenantSync> tenantFromJson(String str) =>
    List<TenantSync>.from(json.decode(str).map((x) => TenantSync.fromJson(x)));

String tenantToJson(List<TenantSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TenantSync {
  TenantSync({
    this.id = 0,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.branches,
    required this.permissions,
  });
  int id;
  String name;
  String phoneNumber;
  String email;
  List<BranchSync> branches;
  List<Permissionsync> permissions;

  factory TenantSync.fromJson(Map<String, dynamic> json) => TenantSync(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        branches: List<BranchSync>.from(
            json["branches"].map((x) => BranchSync.fromJson(x))),
        permissions: List<Permissionsync>.from(
            json["permissions"].map((x) => Permissionsync.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}
