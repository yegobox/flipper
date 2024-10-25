import 'package:freezed_annotation/freezed_annotation.dart';

part 'pcolor.freezed.dart';
part 'pcolor.g.dart';

@freezed
class PColor with _$PColor {
  const factory PColor({
    int? id,
    String? name,
    required List<String> colors,
    int? branchId,
    @Default(false) bool active,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) = _PColor;

  factory PColor.fromJson(Map<String, dynamic> json) => _$PColorFromJson(json);
}
