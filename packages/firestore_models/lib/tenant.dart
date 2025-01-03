import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool? nfcEnabled,
    int? businessId,
    int? userId,
    String? imageUrl,
    // DateTime? lastTouched,
    // DateTime? deletedAt,
    int? pin,
    bool? sessionActive,
    bool? isDefault,
    // Helper properties (not persisted)
    bool? isLongPressed,
    String? type,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
