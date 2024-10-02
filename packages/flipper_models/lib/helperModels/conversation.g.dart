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

const _$IConversationFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'userName': 'userName',
  'body': 'body',
  'avatar': 'avatar',
  'channelType': 'channelType',
  'fromNumber': 'fromNumber',
  'toNumber': 'toNumber',
  'createdAt': 'createdAt',
  'messageType': 'messageType',
  'phoneNumberId': 'phoneNumberId',
  'messageId': 'messageId',
  'respondedBy': 'respondedBy',
  'conversationId': 'conversationId',
  'businessPhoneNumber': 'businessPhoneNumber',
  'businessId': 'businessId',
  'scheduledAt': 'scheduledAt',
  'delivered': 'delivered',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$IConversationPerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? userName(String instance) => instance;
  // ignore: unused_element
  static Object? body(String instance) => instance;
  // ignore: unused_element
  static Object? avatar(String? instance) => instance;
  // ignore: unused_element
  static Object? channelType(String? instance) => instance;
  // ignore: unused_element
  static Object? fromNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? toNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? messageType(String? instance) => instance;
  // ignore: unused_element
  static Object? phoneNumberId(String? instance) => instance;
  // ignore: unused_element
  static Object? messageId(String? instance) => instance;
  // ignore: unused_element
  static Object? respondedBy(String? instance) => instance;
  // ignore: unused_element
  static Object? conversationId(String? instance) => instance;
  // ignore: unused_element
  static Object? businessPhoneNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? scheduledAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? delivered(bool? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

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
