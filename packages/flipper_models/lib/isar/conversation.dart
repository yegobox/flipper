import 'dart:convert';

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'conversation.g.dart';

@JsonSerializable()
@Collection()
class Conversation extends IJsonSerializable {
  @JsonKey(includeToJson: false, includeFromJson: false)
  Id? id = null;
  final String userName;
  final String body;
  final String avatar;
  final String channelType;
  @Index(caseSensitive: true)
  final String fromNumber;
  @Index(caseSensitive: true)
  final String toNumber;

  String? createdAt;
  String? messageType;
  String? phoneNumberId;
  @Index()
  String? messageId;
  String? respondedBy;
  String? conversationId;

  /// properties that are here only useful when replying
  String? businessPhoneNumber;
  String? businessId;

  Conversation(
      {required this.userName,
      required this.body,
      required this.avatar,
      required this.channelType,
      required this.fromNumber,
      required this.toNumber,
      this.createdAt,
      this.respondedBy,
      this.messageType,
      this.phoneNumberId,
      this.conversationId,
      this.businessPhoneNumber,
      this.businessId,
      this.messageId});
  factory Conversation.fromRecord(RecordModel record) =>
      Conversation.fromJson(record.toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  static List<Conversation> fromJsonList(String str) => List<Conversation>.from(
      json.decode(str).map((x) => Conversation.fromJson(x)));
  @override
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
