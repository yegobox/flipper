// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IConversation _$IConversationFromJson(Map<String, dynamic> json) =>
    IConversation(
      userName: json['userName'] as String? ?? 'Awesome Richie',
      body: json['body'] as String,
      avatar: json['avatar'] as String?,
      channelType: json['channelType'] as String?,
      fromNumber: json['fromNumber'] as String?,
      toNumber: json['toNumber'] as String?,
      businessId: (json['businessId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      respondedBy: json['respondedBy'] as String?,
      messageType: json['messageType'] as String?,
      phoneNumberId: json['phoneNumberId'] as String?,
      conversationId: json['conversationId'] as String?,
      businessPhoneNumber: json['businessPhoneNumber'] as String?,
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      delivered: json['delivered'] as bool?,
      messageId: json['messageId'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      id: (json['id'] as num?)?.toInt() ?? 0,
    )
      ..action = json['action'] as String
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$IConversationToJson(IConversation instance) =>
    <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'userName': instance.userName,
      'body': instance.body,
      'avatar': instance.avatar,
      'channelType': instance.channelType,
      'fromNumber': instance.fromNumber,
      'toNumber': instance.toNumber,
      'createdAt': instance.createdAt,
      'messageType': instance.messageType,
      'phoneNumberId': instance.phoneNumberId,
      'messageId': instance.messageId,
      'respondedBy': instance.respondedBy,
      'conversationId': instance.conversationId,
      'businessPhoneNumber': instance.businessPhoneNumber,
      'businessId': instance.businessId,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'delivered': instance.delivered,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
