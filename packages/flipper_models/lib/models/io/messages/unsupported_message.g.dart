// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsupported_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnsupportedMessage _$UnsupportedMessageFromJson(Map<String, dynamic> json) =>
    UnsupportedMessage(
      createdAt: json['createdAt'] as int?,
      id: json['id'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      remoteId: json['remoteId'] as int?,
      roomId: json['roomId'] as int?,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
    )
      ..roleOB = json['roleOB'] as String?
      ..typeOB = json['typeOB'] as String?;

Map<String, dynamic> _$UnsupportedMessageToJson(UnsupportedMessage instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'roomId': instance.roomId,
      'status': _$StatusEnumMap[instance.status],
      'roleOB': instance.roleOB,
      'type': _$MessageTypeEnumMap[instance.type],
      'typeOB': instance.typeOB,
      'updatedAt': instance.updatedAt,
      'id': instance.id,
    };

const _$StatusEnumMap = {
  Status.delivered: 'delivered',
  Status.error: 'error',
  Status.seen: 'seen',
  Status.sending: 'sending',
  Status.sent: 'sent',
};

const _$MessageTypeEnumMap = {
  MessageType.custom: 'custom',
  MessageType.file: 'file',
  MessageType.image: 'image',
  MessageType.text: 'text',
  MessageType.unsupported: 'unsupported',
};
