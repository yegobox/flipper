import 'dart:convert';

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'conversation.g.dart';

@JsonSerializable()
@Collection()
class Conversation extends IJsonSerializable {
  Id? id = null;
  final String name;
  final String message;
  final String avatar;
  final String source;
  final int from;
  final int to;

  late String createdAt;

  Conversation({
    required this.name,
    required this.message,
    required this.avatar,
    required this.source,
    required this.from,
    required this.to,
    required this.createdAt,
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
