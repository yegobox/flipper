// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      id: (json['id'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      s3Url: json['s3Url'] as String?,
      downloaded: json['downloaded'] as bool?,
    );

const _$$ReportImplFieldMap = <String, String>{
  'id': 'id',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'filename': 'filename',
  's3Url': 's3Url',
  'downloaded': 'downloaded',
};

// ignore: unused_element
abstract class _$$ReportImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? filename(String? instance) => instance;
  // ignore: unused_element
  static Object? s3Url(String? instance) => instance;
  // ignore: unused_element
  static Object? downloaded(bool? instance) => instance;
}

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'filename': instance.filename,
      's3Url': instance.s3Url,
      'downloaded': instance.downloaded,
    };
