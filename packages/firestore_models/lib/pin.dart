import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin.freezed.dart';
part 'pin.g.dart';

@freezed
class Pin with _$Pin {
  const factory Pin({
    int? id,
    int? userId,
    String? phoneNumber,
    int? pin,
    int? branchId,
    int? businessId,
    String? ownerName,
    String? tokenUid,
    String? uid,
  }) = _Pin;

  factory Pin.fromJson(Map<String, dynamic> json) => _$PinFromJson(json);
}
