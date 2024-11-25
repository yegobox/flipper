import 'package:freezed_annotation/freezed_annotation.dart';

part 'l_permission.freezed.dart';
part 'l_permission.g.dart';

@freezed
class LPermission with _$LPermission {
  const factory LPermission({
    int? id,
    String? name,
    int? userId,
  }) = _LPermission;

  factory LPermission.fromJson(Map<String, dynamic> json) =>
      _$LPermissionFromJson(json);
}
