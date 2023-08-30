import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'pin.g.dart';
/// because this model will not be synced then there is no need to
/// extends IJsonSerializable and have sync properties
@JsonSerializable()
@Collection()
class Pin  {
  Pin({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.pin,
    required this.branchId,
    required this.businessId,
  });
  late int id;
  late String userId;
  late String phoneNumber;
  late int pin;
  late int branchId;
  late int businessId;

  factory Pin.fromRecord(RecordModel record) => Pin.fromJson(record.toJson());
  factory Pin.fromJson(Map<String, dynamic> json) {
    return _$PinFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PinToJson(this);
}
