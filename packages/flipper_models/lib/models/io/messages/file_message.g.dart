// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileMessage _$FileMessageFromJson(Map<String, dynamic> json) => FileMessage(
      createdAt: json['createdAt'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      mimeType: json['mimeType'] as String?,
      name: json['name'] as String,
      remoteId: json['remoteId'] as int?,
      roomId: json['roomId'] as int?,
      size: json['size'] as int,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
      uri: json['uri'] as String,
      id: json['id'] as int? ?? 0,
    )
      ..roleOB = json['roleOB'] as String?
      ..typeOB = json['typeOB'] as String?;

Map<String, dynamic> _$FileMessageToJson(FileMessage instance) =>
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
      'mimeType': instance.mimeType,
      'name': instance.name,
      'size': instance.size,
      'uri': instance.uri,
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
