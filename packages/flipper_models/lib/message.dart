import 'dart:convert';

import 'package:flipper_models/conversation.dart';
import 'package:objectbox/objectbox.dart';

Message sMessageJson(String str) => Message.fromJson(json.decode(str));

@Entity()
class Message {
  Message({
    this.id = 0,
    required this.text,
    required this.createdAt,
    required this.receiverId,
    required this.senderId,
    this.status = 'offline',
    this.senderImage,
    required this.senderName,
    this.author,
    required this.type,
    required this.lastActiveId,
  });
  @Id(assignable: true)
  int id;
  @Property(uid: 1)
  String text;
  @Property(uid: 1832585454190011486)
  int createdAt;
  int receiverId;
  int lastActiveId;
  @Property(uid: 2)

  /// this is a business Id from business table.
  int senderId;
  String senderName;
  @Property(uid: 2033045415914865953)
  String status;
  String? senderImage;
  // the docs for managing unhandled data types
  // https://stackoverflow.com/questions/68889444/flutter-objectbox-how-to-store-a-map-attribute
  // https://docs.objectbox.io/advanced/custom-types
  @Property(uid: 3366924579294648620)
  Map<String, dynamic>? author;

  String type;

  // a message belongs to a conversation
  final conversation = ToOne<Conversation>();

  String get dbId => id.toString();
  set dbId(String id) {
    id = id;
  }

  String? get dbAuthor => author == null ? null : json.encode(author);
  set dbAuthor(String? value) {
    if (value == null) {
      author = null;
    } else {
      author = Map.from(json.decode(value).map((k, v) => MapEntry(k, v)));
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        type: json["type"],
        text: json["text"],
        author: json["author"],
        createdAt: json["createdAt"],
        receiverId: json["receiverId"],
        lastActiveId: json["lastActiveId"],
        senderName: json["senderName"],
        status: json["status"],
        senderImage: json["senderImage"],
        senderId: json["senderId"],
      );
  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "text": text,
        "author": author,
        "type": type,
        "senderName": senderName,
        "createdAt": createdAt,
        "receiverId": receiverId,
        "lastActiveId": lastActiveId,
        "senderId": senderId,
        "status": status,
        "senderImage": senderImage
      };
}
