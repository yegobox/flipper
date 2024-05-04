library flipper_models;

import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'token.g.dart';

@JsonSerializable()
class Token extends IJsonSerializable {
  Token({
    required this.id,
    required this.type,
    this.token,
    required this.businessId,
    this.validFrom,
    this.validUntil,
    this.deletedAt,
  });
  int? id;
  String type;
  String? token;
  DateTime? validFrom;
  DateTime? validUntil;

  int businessId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  DateTime? deletedAt;
  factory Token.fromRecord(RecordModel record) =>
      Token.fromJson(record.toJson());

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
