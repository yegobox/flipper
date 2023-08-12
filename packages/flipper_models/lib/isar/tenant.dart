import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flipper_models/isar_models.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  Tenant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email, // Allow nullable email
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
  String? email; // Make email nullable
  List<Permission> permissions;
  List<Branch> branches;
  List<Business> businesses;
  int businessId;
  bool nfcEnabled;

  int userId;

  factory Tenant.fromRawJson(String str) => Tenant.fromJson(json.decode(str));

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);

  static List<Tenant> fromJsonList(String str) {
    final List<Map<String, dynamic>> jsonData = json.decode(str);
    return jsonData.map((item) => Tenant.fromJson(item)).toList();
  }
}
