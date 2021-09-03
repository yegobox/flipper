import 'package:objectbox/objectbox.dart';
import 'dart:convert';

import 'message.dart';

@Entity()
class Conversation {
  Conversation({
    this.id = 0,
    required this.avatars,
    required this.initials,
  });
  @Id(assignable: true)
  int id;

  /// list of avatars urls in json format for the people in the conversation
  Map<String, dynamic>? avatars;

  ///  a list of the names initials of the people in the conversation
  Map<String, dynamic>? initials;

  /// a conversation has many messages
  @Backlink()
  final messages = ToMany<Message>();

  String? get dbAvatars => avatars == null ? null : json.encode(avatars);
  set dbAvatars(String? value) {
    if (value == null) {
      avatars = null;
    } else {
      avatars = Map.from(json.decode(value).map((k, v) => MapEntry(k, v)));
    }
  }

  String? get dbInitials => avatars == null ? null : json.encode(avatars);
  set dbInitials(String? value) {
    if (value == null) {
      avatars = null;
    } else {
      avatars = Map.from(json.decode(value).map((k, v) => MapEntry(k, v)));
    }
  }
}
