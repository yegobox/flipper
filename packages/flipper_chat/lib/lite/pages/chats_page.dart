import 'package:flipper_chat/lite/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_chat/lite/pages/right_to_left_route.dart';
import 'package:flipper_chat/lite/pages/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/view_models/message_view_model.dart';
import 'package:flipper_models/avatar.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper/localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jovial_svg/jovial_svg.dart';

import 'chat_page.dart';

// ignore: must_be_immutable
/// chats is considered to be like a room as per flutter_firebase_chat_core terms
class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key, required this.model}) : super(key: key);
  MessageViewModel model;

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  User? _user;
  bool _error = false;
  bool _initialized = false;
  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      final user = await ProxyService.auth.getCurrentUserId();

      setState(() {
        _user = user;
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

// ScalableImageWidget.fromSISource(
//   si: ScalableImageSource.fromSvgHttpUrl(
//       Uri.parse(conversation.avatars !=
//               null
//           ? conversation
//               .avatars!.entries
//               .map((entry) => Avatar(
//                   entry.key,
//                   entry.value))
//               .toList()[0]
//               .url
//           : "https://avatars.dicebear.com/api/avataaars/$senderName.svg")))
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 80,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(
            child: Text('No conversations'),
          );

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemExtent: 70,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final room = snapshot.data![index];
                  String senderName = room.name ?? '';
                  return Slidable(
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: Localization.of(context)!.delete,
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          // widget.model.deleteConversation(conversation);
                        },
                      ),
                    ],
                    actionPane: SlidableDrawerActionPane(),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          RightToLeftRoute(
                            page: ChatPage(room: room),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              // TODOwill work on this to mark if message has unread message(s)
                              color: primary,
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
                                      child: _buildAvatar(room),
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Helpers.greenColor,
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
                                          '${senderName}',
                                          style: Helpers.txtDefault.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          timeago.format(DateTime.parse(DateTime
                                              .fromMillisecondsSinceEpoch(
                                            room.createdAt!,
                                            isUtc: true,
                                          ).toIso8601String())),
                                          style: Helpers.txtDefault,
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //   conversation.lastMessage ?? '',
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 1,
                                    //   softWrap: true,
                                    //   style: Helpers.txtDefault,
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
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
