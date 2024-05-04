import 'dart:convert';

import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'conversation.g.dart';

@JsonSerializable()
class IConversation extends IJsonSerializable {
  int? id;
  @JsonKey(defaultValue: 'Awesome Richie')
  String userName;
  String body;
  String? avatar;
  String? channelType;
  String? fromNumber;
  String? toNumber;

  String? createdAt;
  String? messageType;
  String? phoneNumberId;

  String? messageId;
  String? respondedBy;
  String? conversationId;

  /// properties that are here only useful when replying
  String? businessPhoneNumber;
  int? businessId;

  DateTime? scheduledAt;

  bool? delivered;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  DateTime? deletedAt;
  IConversation(
      {required this.userName,
      required this.body,
      this.avatar,
      this.channelType,
      this.fromNumber,
      this.toNumber,
      this.businessId,
      this.createdAt,
      this.respondedBy,
      this.messageType,
      this.phoneNumberId,
      this.conversationId,
      this.businessPhoneNumber,
      this.scheduledAt,
      this.delivered,
      this.messageId,
      this.deletedAt,
      this.id = 0});

  IConversation.notificaton(
      {required this.userName, required this.body, required this.id});

  factory IConversation.fromRecord(RecordModel record) =>
      IConversation.fromJson(record.toJson());

  factory IConversation.fromJson(Map<String, dynamic> json) =>
      _$IConversationFromJson(json);

  static List<IConversation> fromJsonList(String str) =>
      List<IConversation>.from(
          json.decode(str).map((x) => IConversation.fromJson(x)));
  @override
  Map<String, dynamic> toJson() => _$IConversationToJson(this);
}
