import 'package:objectbox/objectbox.dart';

@Entity()
class Message {
  Message({
    this.id = 0,
    required this.messageBody,
    required this.time,
    required this.sender,
    required this.receiver,
  });

  int id;
  String messageBody;
  String time;
  int sender;
  int receiver;
}
