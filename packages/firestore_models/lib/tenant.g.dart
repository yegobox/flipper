// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantImpl _$$TenantImplFromJson(Map<String, dynamic> json) => _$TenantImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      nfcEnabled: json['nfcEnabled'] as bool?,
      businessId: (json['businessId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      pin: (json['pin'] as num?)?.toInt(),
      sessionActive: json['sessionActive'] as bool?,
      isDefault: json['isDefault'] as bool?,
      isLongPressed: json['isLongPressed'] as bool?,
      type: json['type'] as String?,
    );

const _$$TenantImplFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'phoneNumber': 'phoneNumber',
  'email': 'email',
  'nfcEnabled': 'nfcEnabled',
  'businessId': 'businessId',
  'userId': 'userId',
  'imageUrl': 'imageUrl',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'pin': 'pin',
  'sessionActive': 'sessionActive',
  'isDefault': 'isDefault',
  'isLongPressed': 'isLongPressed',
  'type': 'type',
};

// ignore: unused_element
abstract class _$$TenantImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? nfcEnabled(bool? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? imageUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? pin(int? instance) => instance;
  // ignore: unused_element
  static Object? sessionActive(bool? instance) => instance;
  // ignore: unused_element
  static Object? isDefault(bool? instance) => instance;
  // ignore: unused_element
  static Object? isLongPressed(bool? instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
}

Map<String, dynamic> _$$TenantImplToJson(_$TenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nfcEnabled': instance.nfcEnabled,
      'businessId': instance.businessId,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'pin': instance.pin,
      'sessionActive': instance.sessionActive,
      'isDefault': instance.isDefault,
      'isLongPressed': instance.isLongPressed,
      'type': instance.type,
    };
