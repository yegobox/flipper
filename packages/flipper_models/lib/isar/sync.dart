library flipper_models;

import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:pocketbase/pocketbase.dart';

import 'jtenant.dart';
part 'sync.g.dart';

@JsonSerializable()
class SyncF {
  SyncF({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    required this.businesses,
    required this.channels,
  });

  int id;
  String phoneNumber;
  String token;
  List<Tenant> tenants;
  List<Business> businesses;
  List<String> channels;

  factory SyncF.fromRecord(RecordModel record) =>
      SyncF.fromJson(record.toJson());

  factory SyncF.fromJson(Map<String, dynamic> json) => _$SyncFFromJson(json);

  Map<String, dynamic> toJson() => _$SyncFToJson(this);
}
