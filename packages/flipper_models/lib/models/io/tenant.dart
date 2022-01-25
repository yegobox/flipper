library flipper_models;

import 'dart:convert';

import './branch.dart';
import './permission.dart';
import 'package:objectbox/objectbox.dart';

TenantSync stenantFromJson(String str) => TenantSync.fromJson(json.decode(str));
String stenantToJson(TenantSync data) => json.encode(data.toJson());

List<TenantSync> tenantFromJson(String str) =>
    List<TenantSync>.from(json.decode(str).map((x) => TenantSync.fromJson(x)));

String tenantToJson(List<TenantSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
@Sync()
class TenantSync {
  TenantSync({
    this.id = 0,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });
  @Id(assignable: true)
  int id;
  String name;
  String phoneNumber;
  String email;

  @Backlink()
  final branches = ToMany<BranchSync>();

  @Backlink()
  final permissions = ToMany<Permissionsync>();

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
