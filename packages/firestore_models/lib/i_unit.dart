import 'package:freezed_annotation/freezed_annotation.dart';

part 'i_unit.freezed.dart';
part 'i_unit.g.dart';

@freezed
class IUnit with _$IUnit {
  const factory IUnit({
    int? id,
    int? branchId,
    String? name,
    String? value,
    bool? active ,
    DateTime? lastTouched,
    String? createdAt,
    DateTime? deletedAt,
  }) = _IUnit;

  factory IUnit.fromJson(Map<String, dynamic> json) => _$IUnitFromJson(json);
}