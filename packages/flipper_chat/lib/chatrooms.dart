library flipper_chat;

import 'package:flipper_chat/chat_view.dart';
import 'package:flipper_chat/chat_room_viewmodel.dart';
import 'package:flipper_chat/theme.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

// import 'package:flipper/routes/router.gr.dart';
class ChatRoom extends StatelessWidget {
  Widget chatRoomsList() {
    return const Center(child: Text('No Chats'));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ChatRoomViewModel model, Widget child) {
          return model.contactPermissionGrated
              ? Scaffold(
                  body: Container(
                    child: chatRoomsList(),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.message),
                    onPressed: () {
                      ProxyService.sharedState.navigateTo(path: 'contacts');
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'Please allow the permission to access your contact',
                  ),
                );
        },
        onModelReady: (ChatRoomViewModel model) {
          model.contactPermissions();
          model.loadMessages();
        },
        viewModelBuilder: () => ChatRoomViewModel());
  }
}

class ChatRoomsTile extends StatelessWidget {
  const ChatRoomsTile({this.userName, @required this.chatRoomId});
  final String userName;
  final String chatRoomId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              chatRoomId: chatRoomId,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: CustomTheme.colorAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                userName.substring(0, 1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              userName,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
