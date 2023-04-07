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
  final String name;
  final String body;
  final String avatar;
  final String source;
  final String fromNumber;
  final String toNumber;

  late String createdAt;
  String? messageType;
  String? phoneNumberId;
  String? messageId;

  Conversation(
      {required this.name,
      required this.body,
      required this.avatar,
      required this.source,
      required this.fromNumber,
      required this.toNumber,
      required this.createdAt,
      this.messageType,
      this.phoneNumberId,
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
