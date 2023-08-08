library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'token.g.dart';

@JsonSerializable()
@Collection()
class Token extends IJsonSerializable {
  Token({
    required this.type,
    required this.token,
    required this.businessId,
    required this.validFrom,
    required this.validUntil,
    this.deletedAt,
  });
  late String id;
  String type;
  String token;
  DateTime validFrom;
  DateTime validUntil;
  @Index()
  int businessId;

  @Index()
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  DateTime? deletedAt;
  factory Token.fromRecord(RecordModel record) =>
      Token.fromJson(record.toJson());

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
