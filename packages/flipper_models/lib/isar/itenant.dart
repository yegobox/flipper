library flipper_models;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'itenant.g.dart';

@JsonSerializable()
@Collection()
class ITenant extends IJsonSerializable {
  ITenant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.nfcEnabled,
    required this.businessId,
    required this.userId,
    this.deletedAt,
  });
  late int id;
  String name;
  String phoneNumber;
  String? email;
  bool nfcEnabled;
  int businessId;
  int userId;
  String? imageUrl;

  @Index()
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  DateTime? deletedAt;
  factory ITenant.fromRecord(RecordModel record) =>
      ITenant.fromJson(record.toJson());

  factory ITenant.fromJson(Map<String, dynamic> json) =>
      _$ITenantFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ITenantToJson(this);
}
