// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SyncRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRecord _$SyncRecordFromJson(Map<String, dynamic> json) => SyncRecord(
      id: (json['id'] as num?)?.toInt(),
      modelId: json['modelId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      branchId: (json['branchId'] as num).toInt(),
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

const _$SyncRecordFieldMap = <String, String>{
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'action': 'action',
  'id': 'id',
  'modelId': 'modelId',
  'createdAt': 'createdAt',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$SyncRecordPerFieldToJson {
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? modelId(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) => instance.toIso8601String();
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
}

Map<String, dynamic> _$SyncRecordToJson(SyncRecord instance) =>
    <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'id': instance.id,
      'modelId': instance.modelId,
      'createdAt': instance.createdAt.toIso8601String(),
      'branchId': instance.branchId,
    };
