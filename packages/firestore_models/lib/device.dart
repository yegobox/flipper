import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class Device with _$Device {
  const factory Device({
    int? id,
    String? linkingCode,
    String? deviceName,
    String? deviceVersion,
    bool? pubNubPublished,
    String? phone,
    int? branchId,
    int? businessId,
    int? userId,
    String? defaultApp,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}
