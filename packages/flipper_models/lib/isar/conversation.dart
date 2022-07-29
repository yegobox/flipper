import 'dart:convert';
import 'package:isar/isar.dart';

part 'conversation.g.dart';

@Collection()
class Conversation {
  Id id = Isar.autoIncrement;
  @Ignore()
  Map<String, dynamic>? avatars;
  @Ignore()
  Map<String, dynamic>? initials;

  late String? lastMessage;

  late int receiverId;
  late int senderId;

  late String senderName;

  late String status;

  late int createdAt;

  late bool delivered;

  String? get dbAvatars => avatars == null ? null : json.encode(avatars);
}
