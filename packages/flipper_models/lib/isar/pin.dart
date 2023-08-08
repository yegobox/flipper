import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'pin.g.dart';

@JsonSerializable()
@Collection()
class Pin extends IJsonSerializable {
  Pin({
    required this.action,
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.pin,
    required this.branchId,
    required this.businessId,
  });
  late String id;
  late String userId;
  late String phoneNumber;
  late int pin;
  late int branchId;
  late int businessId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;

  factory Pin.fromRecord(RecordModel record) => Pin.fromJson(record.toJson());
  factory Pin.fromJson(Map<String, dynamic> json) {
    return _$PinFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$PinToJson(this);
}
