import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:pocketbase/pocketbase.dart';
part 'jtenant.g.dart';

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
  });

  int id;
  String name;
  String phoneNumber;
  String? email;
  @JsonKey()
  List<Permission> permissions;
  @JsonKey()
  List<Branch> branches;
  @JsonKey()
  List<Business> businesses;

  factory Tenant.fromRecord(RecordModel record) =>
      Tenant.fromJson(record.toJson());

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}
