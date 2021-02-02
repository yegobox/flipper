library flipper_chat;

import 'package:flipper_chat/chat_view.dart';
import 'package:flipper_chat/chat_room_viewmodel.dart';
import 'package:flipper_chat/theme.dart';
import 'package:flipper_models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:stacked/stacked.dart';

class ChatRoomItem extends StatelessWidget {
  const ChatRoomItem(
      {this.searchKeyword, this.onProfileTap, this.onTap, this.chat});

  final Chat chat;
  final Function onProfileTap;
  final Function onTap;
  final String searchKeyword;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).copyWith(canvasColor: Colors.white).canvasColor,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: SizedBox(
          width: 45.0,
          height: 45.0,
          child: TextDrawable(
            text: chat
                .message, //FIXME: add a name in message object to be shown on chat heads
            isTappable: true,
            onTap: null,
            boxShape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          chat.message,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline5,
        ),
        onTap: onTap,
      ),
    );
  }
}

class ChatRoom extends StatelessWidget {
  Widget chatRoomsList({ChatRoomViewModel model}) {
    return model.chats.isNotEmpty
        ? ListView.builder(
            itemCount: model.chats.length,
            itemBuilder: (context, index) {
              return ChatRoomItem(
                chat: model.chats[index],
              );
            },
          )
        : const Center(
            child: Text(
              'Start business conversation',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ChatRoomViewModel model, Widget child) {
          return model.contactPermissionGrated
              ? Scaffold(
                  backgroundColor: Theme.of(context)
                      .copyWith(canvasColor: Colors.white)
                      .canvasColor,
                  body: Container(
                    child: chatRoomsList(model: model),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.message),
                    onPressed: () {
                      ProxyService.inAppNav.navigateTo(path: 'contacts');
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
          model.loadChatRooms();
          // model.loadMessages(); //this will load chat heads
        },
        viewModelBuilder: () => ChatRoomViewModel());
  }
}

class ChatRoomsTile extends StatelessWidget {
  const ChatRoomsTile({this.userName, @required this.chatRoomId});

  final String chatRoomId;
  final String userName;

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
