// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iaccess.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IAccess _$IAccessFromJson(Map<String, dynamic> json) => IAccess(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      branchId: json['branch_id'] as String?,
      businessId: json['business_id'] as String?,
      featureName: json['feature_name'] as String?,
      userType: json['user_type'] as String?,
      accessLevel: json['access_level'] as String?,
      createdAt: json['created_at'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$IAccessToJson(IAccess instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'branch_id': instance.branchId,
      'business_id': instance.businessId,
      'feature_name': instance.featureName,
      'user_type': instance.userType,
      'access_level': instance.accessLevel,
      'created_at': instance.createdAt,
      'status': instance.status,
    };
