import 'dart:convert';
import 'package:isar/isar.dart';

part 'conversation.g.dart';

@Collection()
class Conversation {
  late int id = Isar.autoIncrement;

  Map<String, dynamic>? avatars;

  ///  a list of the names initials of the people in the conversation
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
