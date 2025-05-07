import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:flipper_models/helper_models.dart';

part 'tenant.g.dart';

@JsonSerializable()
class ITenant {
  String? id;
  String name;
  String? phoneNumber;
  dynamic email;
  dynamic imageUrl;
  List<IPermission> permissions;
  List<IBranch> branches;
  List<IBusiness> businesses;
  int? businessId;
  bool? nfcEnabled;
  int? userId;
  int? pin;
  bool? isDefault;

  ITenant({
    this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    required this.permissions,
    required this.branches,
    required this.businesses,
    this.businessId,
    this.nfcEnabled,
    this.userId,
    this.pin,
    this.isDefault,
  });
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
