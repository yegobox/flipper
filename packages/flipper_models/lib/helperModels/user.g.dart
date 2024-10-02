// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      phoneNumber: json['phoneNumber'] as String,
      pin: json['pin'] as String?,
    );

const _$UserFieldMap = <String, String>{
  'id': 'id',
  'phoneNumber': 'phoneNumber',
  'pin': 'pin',
};

// ignore: unused_element
abstract class _$UserPerFieldToJson {
  // ignore: unused_element
  static Object? id(int instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String instance) => instance;
  // ignore: unused_element
  static Object? pin(String? instance) => instance;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'pin': instance.pin,
    };
