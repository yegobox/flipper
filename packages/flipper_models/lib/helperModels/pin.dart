import 'package:json_annotation/json_annotation.dart';

part 'pin.g.dart';

/// because this model will not be synced then there is no need to
/// extends IJsonSerializable and have sync properties
@JsonSerializable()
class IPin {
  IPin({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.pin,
    required this.branchId,
    required this.businessId,
    required this.ownerName,
    required this.tokenUid,
  });
  String? id;
  late String userId;
  late String phoneNumber;
  late int pin;
  late int branchId;
  late int businessId;
  String? ownerName;
  String? tokenUid;

  factory IPin.fromJson(Map<String, dynamic> json) {
    return _$IPinFromJson(json);
  }

  Map<String, dynamic> toJson() => _$IPinToJson(this);
}
