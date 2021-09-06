import 'package:flipper_chat/lite/helpers.dart';
import 'package:flipper_chat/lite/pages/chat_page.dart';
import 'package:flipper_chat/lite/pages/right_to_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/view_models/message_view_model.dart';
import 'package:flipper_models/avatar.dart';
import 'package:flipper_models/conversation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key, required this.model}) : super(key: key);
  MessageViewModel model;

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Conversation>>(
      stream: widget.model.conversations(),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.length == 0)
          return Center(
            child: Text('No conversations'),
          );
        List<Conversation> messages = snapshot.data!;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemExtent: 70,
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Conversation conversation = messages[index];
                  String senderName = messages[index].senderName;
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        RightToLeftRoute(
                          page: ChatPage(conversation: conversation),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            color: conversation.status == 'online'
                                ? primary
                                : Colors.transparent,
                            margin: const EdgeInsets.only(right: 3),
                          ),
                          Container(
                            width: 60,
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    child: SvgPicture.network(conversation
                                                .avatars ==
                                            null
                                        ? conversation.avatars!.entries
                                            .map((entry) =>
                                                Avatar(entry.key, entry.value))
                                            .toList()[0]
                                            .url
                                        : "https://avatars.dicebear.com/api/micah/$senderName.svg"),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: conversation.status == 'online'
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
                                        '${conversation.senderName}',
                                        style: Helpers.txtDefault.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(DateTime.parse(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    conversation.createdAt,
                                                    isUtc: true)
                                                .toIso8601String())),
                                        style: Helpers.txtDefault,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    conversation.lastMessage ?? '',
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
