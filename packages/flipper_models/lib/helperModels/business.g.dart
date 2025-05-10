// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBusiness _$IBusinessFromJson(Map<String, dynamic> json) => IBusiness(
      id: json['id'] as String,
      serverId: (json['serverId'] as num).toInt(),
      name: json['name'] as String?,
      currency: json['currency'] as String?,
      categoryId: json['categoryId'],
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userId: json['userId'],
      timeZone: json['timeZone'],
      channels: json['channels'],
      country: json['country'] as String?,
      businessUrl: json['businessUrl'],
      hexColor: json['hexColor'],
      imageUrl: json['imageUrl'],
      type: json['type'] as String?,
      referredBy: json['referredBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'],
      metadata: json['metadata'],
      role: json['role'],
      lastSeen: (json['lastSeen'] as num?)?.toInt(),
      firstName: json['firstName'],
      lastName: json['lastName'],
      reported: json['reported'],
      phoneNumber: json['phoneNumber'] as String?,
      deviceToken: json['deviceToken'],
      chatUid: json['chatUid'],
      backUpEnabled: json['backUpEnabled'] as bool?,
      subscriptionPlan: json['subscriptionPlan'],
      nextBillingDate: json['nextBillingDate'],
      previousBillingDate: json['previousBillingDate'],
      isLastSubscriptionPaymentSucceeded:
          json['isLastSubscriptionPaymentSucceeded'] as bool?,
      backupFileId: json['backupFileId'],
      email: json['email'],
      lastDbBackup: json['lastDbBackup'],
      fullName: json['fullName'] as String?,
      referralCode: json['referralCode'],
      authId: json['authId'],
      tinNumber: (json['tinNumber'] as num?)?.toInt(),
      dvcSrlNo: json['dvcSrlNo'],
      bhfId: json['bhfId'],
      adrs: json['adrs'],
      taxEnabled: json['taxEnabled'] as bool?,
      isDefault: json['isDefault'] as bool?,
      businessTypeId: (json['businessTypeId'] as num?)?.toInt(),
      encryptionKey: json['encryptionKey'] as String?,
      businessDefault: json['businessDefault'] as bool?,
      lastSubscriptionPaymentSucceeded:
          json['lastSubscriptionPaymentSucceeded'] as bool?,
      validCurrency: json['validCurrency'] as bool?,
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$IBusinessToJson(IBusiness instance) => <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'id': instance.id,
      'serverId': instance.serverId,
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
      'referredBy': instance.referredBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt,
      'metadata': instance.metadata,
      'role': instance.role,
      'lastSeen': instance.lastSeen,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'reported': instance.reported,
      'phoneNumber': instance.phoneNumber,
      'deviceToken': instance.deviceToken,
      'chatUid': instance.chatUid,
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
      'referralCode': instance.referralCode,
      'authId': instance.authId,
      'tinNumber': instance.tinNumber,
      'dvcSrlNo': instance.dvcSrlNo,
      'bhfId': instance.bhfId,
      'adrs': instance.adrs,
      'taxEnabled': instance.taxEnabled,
      'isDefault': instance.isDefault,
      'businessTypeId': instance.businessTypeId,
      'encryptionKey': instance.encryptionKey,
      'businessDefault': instance.businessDefault,
      'lastSubscriptionPaymentSucceeded':
          instance.lastSubscriptionPaymentSucceeded,
      'validCurrency': instance.validCurrency,
    };
