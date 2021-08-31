import 'package:flipper_chat/lite/helpers.dart';
import 'package:flipper_chat/lite/pages/chat_page.dart';
import 'package:flipper_chat/lite/pages/right_to_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/view_models/message_view_model.dart';
import 'package:flipper_models/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key, required this.model}) : super(key: key);
  MessageViewModel model;

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.model.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.length == 0)
          return SizedBox.shrink();
        List<Message> messages = snapshot.data!;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemExtent: 70,
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Message chat = messages[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        RightToLeftRoute(
                          page: ChatPage(message: chat),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            color: chat.status ? primary : Colors.transparent,
                            margin: const EdgeInsets.only(right: 3),
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  maxRadius: 25,
                                  minRadius: 25,
                                  backgroundImage:
                                      NetworkImage(chat.senderImage ?? ""),
                                  backgroundColor: Helpers.greyLigthColor,
                                ),
                                Positioned(
                                  right: 2,
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: chat.status
                                          ? Helpers.greenColor
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${chat.senderName}',
                                        style: Helpers.txtDefault.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(
                                            DateTime.parse(chat.createdAt)),
                                        style: Helpers.txtDefault,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    chat.message,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: Helpers.txtDefault,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
