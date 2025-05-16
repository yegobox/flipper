import 'dart:convert';
import 'dart:developer' as developer;
import 'package:json_annotation/json_annotation.dart';
import 'branch.dart';
import 'business.dart';

part 'tenant.g.dart';

ITenant iTenantFromJson(String str) => ITenant.fromJson(json.decode(str));

String iTenantToJson(ITenant data) => json.encode(data.toJson());

@JsonSerializable()
class ITenant {
  String? id;
  String? name;
  String? phoneNumber;
  dynamic email;
  dynamic imageUrl;
  List<dynamic>? permissions;
  List<IBranch>? branches;
  List<IBusiness>? businesses;
  int? businessId;
  bool? nfcEnabled;
  int? userId;
  int? pin;

  ITenant({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    this.permissions,
    this.branches,
    this.businesses,
    this.businessId,
    this.nfcEnabled,
    this.userId,
    this.pin,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "imageUrl": imageUrl,
        "branches": branches == null
            ? []
            : List<dynamic>.from(branches!.map((x) => x.toJson())),
        "businesses": businesses == null
            ? []
            : List<dynamic>.from(businesses!.map((x) => x.toJson())),
        "businessId": businessId,
        "nfcEnabled": nfcEnabled,
        "userId": userId,
        "pin": pin
      };

  static List<ITenant> fromJsonList(String str) {
    final dynamic decoded = json.decode(str);

    // Handle case where the response is a user object with tenants property
    if (decoded is Map<String, dynamic> && decoded.containsKey('tenants')) {
      final List<dynamic> tenants = decoded['tenants'] as List<dynamic>;
      return tenants
          .map((item) => ITenant.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Handle case where the response is directly a list of tenants
    if (decoded is List<dynamic>) {
      return decoded
          .map((item) => ITenant.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // If we can't parse it as either format, return an empty list
    developer.log('Could not parse tenant list from response', name: 'ITenant');
    return [];
  }

  factory ITenant.fromRawJson(String str) => ITenant.fromJson(json.decode(str));

  factory ITenant.fromJson(Map<String, dynamic> json) =>
      _$ITenantFromJson(json);
}