// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// String randomString() {
//   final random = Random.secure();
//   final values = List<int>.generate(16, (i) => random.nextInt(255));
//   return base64UrlEncode(values);
// }

// class KChatPage extends StatefulWidget {
//   static final String id = "ChatPage";

//   @override
//   _KChatPageState createState() => _KChatPageState();
// }

// class _KChatPageState extends State<KChatPage> {
//   List<types.Message> _messages = [];
//   final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: randomString(),
//       text: message.text,
//     );

//     _addMessage(textMessage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Chat(
//         messages: _messages,
//         onSendPressed: _handleSendPressed,
//         user: _user,
//       ),
//     );
//   }
// }
