import 'package:objectbox/objectbox.dart';

@Entity()
class Message {
  Message(
      {this.id = 0,
      required this.message,
      required this.createdAt,
      required this.receiverId,
      required this.senderId,
      required this.lastActiveId});

  int id;
  @Property(uid: 2)
  String message;
  @Property(uid: 2)
  String createdAt;
  @Property(uid: 2)
  int receiverId;
  int lastActiveId;
  @Property(uid: 2)
  int senderId;
}
