library flipper_chat;

import 'package:flipper_chat/constants.dart';
import 'package:flipper_chat/widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_chat/chat_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:built_collection/built_collection.dart';

class ChatView extends StatefulWidget {
  const ChatView({this.chatRoomId, this.channels});
  final String chatRoomId;
  final BuiltList channels;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageEditingController = TextEditingController();

  Widget chatMessages({ChatViewModel model}) {
    return model.chats.isNotEmpty
        ? ListView.builder(
            itemCount: model.chats.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: model.chats[index].message,
                sendByMe: ProxyService.sharedState.user.name ==
                    model.chats[index].sendBy,
              );
            })
        : const Center(
            child: Text(
              'Start business conversation',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          );
  }

  void addMessage({ChatViewModel model}) async {
    if (messageEditingController.text.isNotEmpty) {
      final Map<String, dynamic> chatMessageMap = {
        'sendBy': ProxyService.sharedState.user.name,
        'message': messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      model.sendMessage(message: chatMessageMap, channels: widget.channels);

      setState(() {
        messageEditingController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, ChatViewModel model, Widget child) {
          return Scaffold(
            body: Container(
              child: Stack(
                children: [
                  chatMessages(model: model),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      color: const Color(0xff005AE4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageEditingController,
                              style: simpleTextStyle(),
                              decoration: const InputDecoration(
                                hintText: 'Type your message ...',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              addMessage(model: model);
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff005AE4),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff145C9E),
                                    Color(0xff005AE4)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                'assets/images/send.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => ChatViewModel(),
        onModelReady: (ChatViewModel model) {
          model.loadMessages();
        });
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({@required this.message, @required this.sendByMe});
  final String message;
  final bool sendByMe;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
            colors: sendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0xFF00B0FF),  const Color(0xFF80D8FF)],
          ),
        ),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
