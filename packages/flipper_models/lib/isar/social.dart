import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'social.g.dart';

@JsonSerializable()
@Collection()
class Social extends IJsonSerializable {
  @JsonKey(includeToJson: false, includeFromJson: false)
  Id? id;

  bool isAccountSet;

  String socialType;

  String socialUrl;

  int businessId;

  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;

  String? message;
  @Index()
  DateTime? deletedAt;
  Social({
    required this.isAccountSet,
    required this.socialType,
    required this.businessId,
    required this.message,
    required this.socialUrl,
    this.lastTouched,
    this.remoteID,
    this.localId,
    this.deletedAt,
  });
  factory Social.fromRecord(RecordModel record) =>
      Social.fromJson(record.toJson());

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
