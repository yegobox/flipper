
import 'package:json_annotation/json_annotation.dart';
part 'Email.g.dart';

@JsonSerializable()
class Mail {
  late String to;
  late String subject;
  late String messageBody;
  String? bcc;

  Mail(
      {required String to,
      required String subject,
      required String messageBody,
      String? bcc}) {
    this.to = to;
    this.subject = subject;
    this.messageBody = messageBody;
    this.bcc = bcc;
  }
}
