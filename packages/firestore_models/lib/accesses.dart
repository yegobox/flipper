import 'package:freezed_annotation/freezed_annotation.dart';

part 'accesses.freezed.dart';
part 'accesses.g.dart';

@freezed
class Accesses with _$Accesses {
  const factory Accesses({
    int? id,
    int? branchId,
    int? businessId,
    int? userId,
    String? featureName,
    String? userType,
    String? accessLevel,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? status,
  }) = _Accesses;

  factory Accesses.fromJson(Map<String, dynamic> json) =>
      _$AccessesFromJson(json);
}
