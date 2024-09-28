// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBusiness _$IBusinessFromJson(Map<String, dynamic> json) => IBusiness(
      id: (json['id'] as num?)?.toInt(),
      action: json['action'] as String,
      encryptionKey: json['encryptionKey'] as String,
      name: json['name'] as String?,
      currency: json['currency'] as String?,
      categoryId: json['categoryId'] as String? ?? "1",
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      timeZone: json['timeZone'] as String?,
      channels: (json['channels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      country: json['country'] as String?,
      businessUrl: json['businessUrl'] as String?,
      hexColor: json['hexColor'] as String?,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
      active: json['active'] as bool? ?? false,
      metadata: json['metadata'] as String?,
      lastSeen: (json['lastSeen'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      deviceToken: json['deviceToken'] as String?,
      chatUid: json['chatUid'] as String?,
      backUpEnabled: json['backUpEnabled'] as bool? ?? false,
      subscriptionPlan: json['subscriptionPlan'] as String?,
      nextBillingDate: json['nextBillingDate'] as String?,
      previousBillingDate: json['previousBillingDate'] as String?,
      isLastSubscriptionPaymentSucceeded:
          json['isLastSubscriptionPaymentSucceeded'] as bool?,
      backupFileId: json['backupFileId'] as String?,
      email: json['email'] as String?,
      lastDbBackup: json['lastDbBackup'] as String?,
      fullName: json['fullName'] as String?,
      role: json['role'] as String?,
      tinNumber: (json['tinNumber'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      dvcSrlNo: json['dvcSrlNo'] as String?,
      adrs: json['adrs'] as String?,
      taxEnabled: json['taxEnabled'] as bool?,
      taxServerUrl: json['taxServerUrl'] as String?,
      isDefault: json['isDefault'] as bool?,
      businessTypeId: (json['businessTypeId'] as num?)?.toInt(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..createdAt = json['createdAt'] as String?
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$IBusinessToJson(IBusiness instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'currency': instance.currency,
      'categoryId': instance.categoryId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'userId': instance.userId,
      'timeZone': instance.timeZone,
      'channels': instance.channels,
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
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'encryptionKey': instance.encryptionKey,
    };
