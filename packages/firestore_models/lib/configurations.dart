import 'package:freezed_annotation/freezed_annotation.dart';

part 'configurations.freezed.dart';
part 'configurations.g.dart';

@freezed
class Configurations with _$Configurations {
  const factory Configurations({
    int? id,
    String? taxType,
    double? taxPercentage,
    int? businessId,
    int? branchId,
  }) = _Configurations;

  factory Configurations.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationsFromJson(json);
}