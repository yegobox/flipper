import 'package:flipper_chat/lite/widgets/appbarw.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarW(
        'Whatsapp chat',
        // btnBack: false,
      ),
    );
  }
}
