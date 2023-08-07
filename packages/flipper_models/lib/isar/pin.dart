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
    this.id,
    required this.userId,
    required this.phoneNumber,
    required this.pin,
    required this.branchId,
    required this.businessId,
  });
  Id? id;
  late String userId;
  late String phoneNumber;
  late int pin;
  late int branchId;
  late int businessId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  String? remoteId;
  String action;
  int? localId;
  @Index()
  DateTime? deletedAt;

  factory Pin.fromRecord(RecordModel record) => Pin.fromJson(record.toJson());
  factory Pin.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$PinFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$PinToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
