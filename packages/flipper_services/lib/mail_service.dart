library flipper_services;

import 'package:flipper_models/fuser.dart';
import 'package:flipper_services/logger.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
// ignore: implementation_imports
import 'package:mailer/src/entities/problem.dart';

class MailService {
  Future<void> sendEmail({FUser user}) async {
    final Logger log = Logging.getLogger('Mail service:');

    final String username = "";
    final String password = "";
    // log.i(username);
    // log.i(password);
    final SmtpServer smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.
    // Create our message.
    final Message message = Message()
      ..from = Address(username, 'Flipper')
      ..recipients.add('yegobox@gmail.com')
      ..ccRecipients.addAll(['beastar457@gmail.com', 'murag.richard@gmail.com'])
      ..bccRecipients.add(Address('beastar457@gmail.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final SendReport sendReport = await send(message, smtpServer);
      log.i('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      log.d('Message not sent.');
      for (Problem p in e.problems) {
        log.d('Problem: ${p.code}: ${p.msg}');
      }
    }

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    final PersistentConnection connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // close the connection
    await connection.close();
  }
}
