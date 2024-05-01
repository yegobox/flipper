import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flipper_models/isar_models.dart';

part 'tenant.g.dart';

@JsonSerializable()
class ITenant {
  late int id;
  String name;
  String phoneNumber;
  String? email; // Make email nullable
  List<IPermission> permissions;
  List<IBranch> branches;
  List<IBusiness> businesses;
  int businessId;
  bool nfcEnabled;

  int userId;

  int? pin;

  bool isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality
  @ignore
  bool isLongPressed;

  ITenant(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.email, // Allow nullable email
      required this.permissions,
      required this.branches,
      required this.businesses,
      required this.businessId,
      required this.nfcEnabled,
      required this.userId,
      required this.isDefault,
      this.isLongPressed = false,
      this.pin});
  factory ITenant.fromRawJson(String str) => ITenant.fromJson(json.decode(str));

  factory ITenant.fromJson(Map<String, dynamic> json) =>
      _$ITenantFromJson(json);

  Map<String, dynamic> toJson() => _$ITenantToJson(this);

  static List<ITenant> fromJsonList(String str) {
    final List<dynamic> jsonData = json.decode(str);
    return jsonData
        .map((item) => ITenant.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
