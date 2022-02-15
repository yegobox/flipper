library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';

import 'branch.dart';
import 'permission.dart';
part 'tenant.g.dart';

TenantSync stenantFromJson(String str) => TenantSync.fromJson(json.decode(str));
String stenantToJson(TenantSync data) => json.encode(data.toJson());

List<TenantSync> tenantFromJson(String str) =>
    List<TenantSync>.from(json.decode(str).map((x) => TenantSync.fromJson(x)));

String tenantToJson(List<TenantSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class TenantSync {
  TenantSync({
    this.id = 0,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });
  late int id = Isar.autoIncrement;
  late String name;
  late String phoneNumber;
  late String email;
  final branches = IsarLink<BranchSync>();
  final permissions = IsarLink<Permissionsync>();

  factory TenantSync.fromJson(Map<String, dynamic> json) => TenantSync(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}
