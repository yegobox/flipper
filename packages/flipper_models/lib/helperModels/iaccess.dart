import 'package:json_annotation/json_annotation.dart';

part 'iaccess.g.dart';

@JsonSerializable()
class IAccess {
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @JsonKey(name: 'business_id')
  final String? businessId;
  @JsonKey(name: 'feature_name')
  final String? featureName;
  @JsonKey(name: 'user_type')
  final String? userType;
  @JsonKey(name: 'access_level')
  final String? accessLevel;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? status;

  IAccess({
    this.id,
    this.userId,
    this.branchId,
    this.businessId,
    this.featureName,
    this.userType,
    this.accessLevel,
    this.createdAt,
    this.status,
  });

  factory IAccess.fromJson(Map<String, dynamic> json) =>
      _$IAccessFromJson(json);
  Map<String, dynamic> toJson() => _$IAccessToJson(this);
}
