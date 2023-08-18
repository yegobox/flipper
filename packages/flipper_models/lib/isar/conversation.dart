import 'dart:convert';

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'conversation.g.dart';

@JsonSerializable()
@Collection()
class Conversation extends IJsonSerializable {
  late String id;
  @JsonKey(defaultValue: 'Awesome Richie')
  String userName;
  String body;
  String avatar;
  String channelType;
  String fromNumber;
  String toNumber;
  @Index()
  String? createdAt;
  String? messageType;
  String? phoneNumberId;
  @Index()
  String? messageId;
  String? respondedBy;
  String? conversationId;

  /// properties that are here only useful when replying
  String? businessPhoneNumber;
  int businessId;

  DateTime? scheduledAt;

  bool? delivered;

  @Index()
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  DateTime? deletedAt;
  Conversation({
    required this.userName,
    required this.body,
    required this.avatar,
    required this.channelType,
    required this.fromNumber,
    required this.toNumber,
    required this.businessId,
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
  });

  factory Conversation.fromRecord(RecordModel record) =>
      Conversation.fromJson(record.toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  static List<Conversation> fromJsonList(String str) => List<Conversation>.from(
      json.decode(str).map((x) => Conversation.fromJson(x)));
  @override
  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
