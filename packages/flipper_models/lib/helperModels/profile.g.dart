// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String,
      pincode: json['pincode'] as String?,
      profilePic: json['profilePic'] as String?,
      coverPic: json['coverPic'] as String?,
      about: json['about'] as String?,
      vaccinationCode: json['vaccinationCode'] as String,
      livingAt: json['livingAt'] as String,
      cell: json['cell'] as String,
      district: json['district'] as String,
      businessId: (json['businessId'] as num).toInt(),
      nationalId: json['nationalId'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..action = json['action'] as String
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

const _$ProfileFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'name': 'name',
  'email': 'email',
  'phone': 'phone',
  'address': 'address',
  'city': 'city',
  'state': 'state',
  'country': 'country',
  'pincode': 'pincode',
  'profilePic': 'profilePic',
  'coverPic': 'coverPic',
  'about': 'about',
  'vaccinationCode': 'vaccinationCode',
  'livingAt': 'livingAt',
  'cell': 'cell',
  'district': 'district',
  'businessId': 'businessId',
  'nationalId': 'nationalId',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$ProfilePerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? phone(String? instance) => instance;
  // ignore: unused_element
  static Object? address(String? instance) => instance;
  // ignore: unused_element
  static Object? city(String? instance) => instance;
  // ignore: unused_element
  static Object? state(String? instance) => instance;
  // ignore: unused_element
  static Object? country(String instance) => instance;
  // ignore: unused_element
  static Object? pincode(String? instance) => instance;
  // ignore: unused_element
  static Object? profilePic(String? instance) => instance;
  // ignore: unused_element
  static Object? coverPic(String? instance) => instance;
  // ignore: unused_element
  static Object? about(String? instance) => instance;
  // ignore: unused_element
  static Object? vaccinationCode(String instance) => instance;
  // ignore: unused_element
  static Object? livingAt(String instance) => instance;
  // ignore: unused_element
  static Object? cell(String instance) => instance;
  // ignore: unused_element
  static Object? district(String instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? nationalId(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
      'profilePic': instance.profilePic,
      'coverPic': instance.coverPic,
      'about': instance.about,
      'vaccinationCode': instance.vaccinationCode,
      'livingAt': instance.livingAt,
      'cell': instance.cell,
      'district': instance.district,
      'businessId': instance.businessId,
      'nationalId': instance.nationalId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
