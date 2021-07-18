import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Message sMessageJson(String str) => Message.fromJson(json.decode(str));

@Entity()
class Message {
  Message(
      {this.id = 0,
      required this.message,
      required this.createdAt,
      required this.receiverId,
      required this.senderId,
      required this.senderName,
      required this.lastActiveId});
  @Id(assignable: true)
  int id;
  @Property(uid: 1)
  String message;
  // @Property(uid: 2)
  String createdAt;
  // @Property(uid: 2)
  int receiverId;
  int lastActiveId;
  @Property(uid: 2)
  int senderId;
  String senderName;

  // add extra field

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      message: json["message"],
      createdAt: json["createdAt"],
      receiverId: json["receiverId"],
      lastActiveId: json["lastActiveId"],
      senderName: json["senderName"],
      senderId: json["senderId"]);
  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "message": message,
        "senderName": senderName,
        "createdAt": createdAt,
        "receiverId": receiverId,
        "lastActiveId": lastActiveId,
        "senderId": senderId
      };
}
