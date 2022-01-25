// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) => TextMessage(
      createdAt: json['createdAt'] as int?,
      id: json['id'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      previewData: json['previewData'] == null
          ? null
          : PreviewData.fromJson(json['previewData'] as Map<String, dynamic>),
      remoteId: json['remoteId'] as int?,
      roomId: json['roomId'] as int?,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      text: json['text'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
    )
      ..roleOB = json['roleOB'] as String?
      ..typeOB = json['typeOB'] as String?;

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) =>
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
      'previewData': instance.previewData?.toJson(),
      'id': instance.id,
      'text': instance.text,
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
