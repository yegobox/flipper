import 'package:chat/flat_widgets/flat_action_btn.dart';
import 'package:chat/flat_widgets/flat_chat_message.dart';
import 'package:chat/flat_widgets/flat_message_input_box.dart';
import 'package:chat/flat_widgets/flat_page_header.dart';
import 'package:chat/flat_widgets/flat_page_wrapper.dart';
import 'package:chat/flat_widgets/flat_profile_image.dart';
import 'package:flutter/material.dart';

class KChatPage extends StatelessWidget {
  final int receiverId;

  const KChatPage({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatPageWrapper(
        scrollType: ScrollType.floatingHeader,
        reverseBodyList: true,
        // header: FlatPageHeader(
        //   prefixWidget: FlatActionButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   title: "Mr Peace ",
        //   suffixWidget: FlatProfileImage(
        //     size: 35.0,
        //     onlineIndicator: true,
        //     imageUrl:
        //         'https://images.pexels.com/photos/3866555/pexels-photo-3866555.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        //     onPressed: () {
        //       print("Clicked Profile Image");
        //     },
        //   ),
        // ),
        children: [
          chatMessage(
            message: "Final Message in the list.",
            showTime: true,
            messageType: MessageType.received,
            time: "2 mins ago",
          ),
        ],
        footer: FlatMessageInputBox(
          prefix: FlatActionButton(
            iconData: Icons.add,
            iconSize: 24.0,
          ),
          roundedCorners: true,
          suffix: FlatActionButton(
            iconData: Icons.image,
            iconSize: 24.0,
          ),
        ),
      ),
    );
  }
}
