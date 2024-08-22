// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as int?,
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
      businessId: json['businessId'] as int,
      nationalId: json['nationalId'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..action = json['action'] as String
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

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
