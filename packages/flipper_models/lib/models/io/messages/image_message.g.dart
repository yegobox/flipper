// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageMessage _$ImageMessageFromJson(Map<String, dynamic> json) => ImageMessage(
      createdAt: json['createdAt'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      id: json['id'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      name: json['name'] as String,
      remoteId: json['remoteId'] as int?,
      roomId: json['roomId'] as int?,
      size: json['size'] as int,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
      uri: json['uri'] as String,
      width: (json['width'] as num?)?.toDouble(),
    )
      ..roleOB = json['roleOB'] as String?
      ..typeOB = json['typeOB'] as String?;

Map<String, dynamic> _$ImageMessageToJson(ImageMessage instance) =>
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
      'height': instance.height,
      'name': instance.name,
      'size': instance.size,
      'uri': instance.uri,
      'width': instance.width,
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
