// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessImpl _$$BusinessImplFromJson(Map<String, dynamic> json) =>
    _$BusinessImpl(
      serverId: (json['serverId'] as num?)?.toInt(),
      name: json['name'] as String?,
      currency: json['currency'] as String?,
      categoryId: json['categoryId'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      timeZone: json['timeZone'] as String?,
      country: json['country'] as String?,
      businessUrl: json['businessUrl'] as String?,
      hexColor: json['hexColor'] as String?,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
      active: json['active'] as bool?,
      chatUid: json['chatUid'] as String?,
      metadata: json['metadata'] as String?,
      role: json['role'] as String?,
      lastSeen: (json['lastSeen'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      createdAt: json['createdAt'] as String?,
      deviceToken: json['deviceToken'] as String?,
      backUpEnabled: json['backUpEnabled'] as bool?,
      subscriptionPlan: json['subscriptionPlan'] as String?,
      nextBillingDate: json['nextBillingDate'] as String?,
      previousBillingDate: json['previousBillingDate'] as String?,
      isLastSubscriptionPaymentSucceeded:
          json['isLastSubscriptionPaymentSucceeded'] as bool?,
      backupFileId: json['backupFileId'] as String?,
      email: json['email'] as String?,
      lastDbBackup: json['lastDbBackup'] as String?,
      fullName: json['fullName'] as String?,
      tinNumber: (json['tinNumber'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      dvcSrlNo: json['dvcSrlNo'] as String?,
      adrs: json['adrs'] as String?,
      taxEnabled: json['taxEnabled'] as bool?,
      taxServerUrl: json['taxServerUrl'] as String?,
      isDefault: json['isDefault'] as bool?,
      businessTypeId: (json['businessTypeId'] as num?)?.toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      encryptionKey: json['encryptionKey'] as String?,
    );

const _$$BusinessImplFieldMap = <String, String>{
  'serverId': 'serverId',
  'name': 'name',
  'currency': 'currency',
  'categoryId': 'categoryId',
  'latitude': 'latitude',
  'longitude': 'longitude',
  'userId': 'userId',
  'timeZone': 'timeZone',
  'country': 'country',
  'businessUrl': 'businessUrl',
  'hexColor': 'hexColor',
  'imageUrl': 'imageUrl',
  'type': 'type',
  'active': 'active',
  'chatUid': 'chatUid',
  'metadata': 'metadata',
  'role': 'role',
  'lastSeen': 'lastSeen',
  'firstName': 'firstName',
  'lastName': 'lastName',
  'createdAt': 'createdAt',
  'deviceToken': 'deviceToken',
  'backUpEnabled': 'backUpEnabled',
  'subscriptionPlan': 'subscriptionPlan',
  'nextBillingDate': 'nextBillingDate',
  'previousBillingDate': 'previousBillingDate',
  'isLastSubscriptionPaymentSucceeded': 'isLastSubscriptionPaymentSucceeded',
  'backupFileId': 'backupFileId',
  'email': 'email',
  'lastDbBackup': 'lastDbBackup',
  'fullName': 'fullName',
  'tinNumber': 'tinNumber',
  'bhfId': 'bhfId',
  'dvcSrlNo': 'dvcSrlNo',
  'adrs': 'adrs',
  'taxEnabled': 'taxEnabled',
  'taxServerUrl': 'taxServerUrl',
  'isDefault': 'isDefault',
  'businessTypeId': 'businessTypeId',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'encryptionKey': 'encryptionKey',
};

// ignore: unused_element
abstract class _$$BusinessImplPerFieldToJson {
  // ignore: unused_element
  static Object? serverId(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? currency(String? instance) => instance;
  // ignore: unused_element
  static Object? categoryId(String? instance) => instance;
  // ignore: unused_element
  static Object? latitude(String? instance) => instance;
  // ignore: unused_element
  static Object? longitude(String? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? timeZone(String? instance) => instance;
  // ignore: unused_element
  static Object? country(String? instance) => instance;
  // ignore: unused_element
  static Object? businessUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? hexColor(String? instance) => instance;
  // ignore: unused_element
  static Object? imageUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? chatUid(String? instance) => instance;
  // ignore: unused_element
  static Object? metadata(String? instance) => instance;
  // ignore: unused_element
  static Object? role(String? instance) => instance;
  // ignore: unused_element
  static Object? lastSeen(int? instance) => instance;
  // ignore: unused_element
  static Object? firstName(String? instance) => instance;
  // ignore: unused_element
  static Object? lastName(String? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? deviceToken(String? instance) => instance;
  // ignore: unused_element
  static Object? backUpEnabled(bool? instance) => instance;
  // ignore: unused_element
  static Object? subscriptionPlan(String? instance) => instance;
  // ignore: unused_element
  static Object? nextBillingDate(String? instance) => instance;
  // ignore: unused_element
  static Object? previousBillingDate(String? instance) => instance;
  // ignore: unused_element
  static Object? isLastSubscriptionPaymentSucceeded(bool? instance) => instance;
  // ignore: unused_element
  static Object? backupFileId(String? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? lastDbBackup(String? instance) => instance;
  // ignore: unused_element
  static Object? fullName(String? instance) => instance;
  // ignore: unused_element
  static Object? tinNumber(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? dvcSrlNo(String? instance) => instance;
  // ignore: unused_element
  static Object? adrs(String? instance) => instance;
  // ignore: unused_element
  static Object? taxEnabled(bool? instance) => instance;
  // ignore: unused_element
  static Object? taxServerUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? isDefault(bool? instance) => instance;
  // ignore: unused_element
  static Object? businessTypeId(int? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? encryptionKey(String? instance) => instance;
}

Map<String, dynamic> _$$BusinessImplToJson(_$BusinessImpl instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'name': instance.name,
      'currency': instance.currency,
      'categoryId': instance.categoryId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'userId': instance.userId,
      'timeZone': instance.timeZone,
      'country': instance.country,
      'businessUrl': instance.businessUrl,
      'hexColor': instance.hexColor,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'active': instance.active,
      'chatUid': instance.chatUid,
      'metadata': instance.metadata,
      'role': instance.role,
      'lastSeen': instance.lastSeen,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'createdAt': instance.createdAt,
      'deviceToken': instance.deviceToken,
      'backUpEnabled': instance.backUpEnabled,
      'subscriptionPlan': instance.subscriptionPlan,
      'nextBillingDate': instance.nextBillingDate,
      'previousBillingDate': instance.previousBillingDate,
      'isLastSubscriptionPaymentSucceeded':
          instance.isLastSubscriptionPaymentSucceeded,
      'backupFileId': instance.backupFileId,
      'email': instance.email,
      'lastDbBackup': instance.lastDbBackup,
      'fullName': instance.fullName,
      'tinNumber': instance.tinNumber,
      'bhfId': instance.bhfId,
      'dvcSrlNo': instance.dvcSrlNo,
      'adrs': instance.adrs,
      'taxEnabled': instance.taxEnabled,
      'taxServerUrl': instance.taxServerUrl,
      'isDefault': instance.isDefault,
      'businessTypeId': instance.businessTypeId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'encryptionKey': instance.encryptionKey,
    };
