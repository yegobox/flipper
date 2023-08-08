import 'package:json_annotation/json_annotation.dart';

import 'package:flipper_models/isar_models.dart';

part 'tenant.g.dart';

@JsonSerializable()
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

  late int id;
  String name;
  String phoneNumber;
  String? email;
  List<Permission> permissions;
  List<Branch> branches;
  List<Business> businesses;
  int businessId;
  bool nfcEnabled;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}
