import 'dart:convert';

class Conversation {
  Conversation(
      {this.id = 0,
      this.avatars,
      this.initials,
      this.lastMessage,
      required this.receiverId,
      required this.senderId,
      required this.senderName,
      required this.status,
      this.delivered = false,
      required this.createdAt});
  int id;

  Map<String, dynamic>? avatars;

  ///  a list of the names initials of the people in the conversation
  Map<String, dynamic>? initials;

  String? lastMessage;

  int receiverId;
  int senderId;

  String senderName;

  String status;

  int createdAt;

  bool delivered;

  String? get dbAvatars => avatars == null ? null : json.encode(avatars);
  set dbAvatars(String? value) {
    if (value == null) {
      avatars = null;
    } else {
      avatars = Map.from(json.decode(value).map((k, v) => MapEntry(k, v)));
    }
  }

  String? get dbInitials => initials == null ? null : json.encode(initials);
  set dbInitials(String? value) {
    if (value == null) {
      initials = null;
    } else {
      initials = Map.from(json.decode(value).map((k, v) => MapEntry(k, v)));
    }
  }
}
