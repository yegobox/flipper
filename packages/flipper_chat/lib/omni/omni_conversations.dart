import 'package:flipper_chat/omni/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_chat/omni/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'omni_conversation.dart';
import 'right_to_left_route.dart';

// ignore: must_be_immutable
/// chats is considered to be like a room as per flutter_firebase_chat_core terms
class OmnConversations extends StatefulWidget {
  OmnConversations({Key? key, required this.model}) : super(key: key);
  final MessageViewModel model;

  @override
  _OmnConversationsState createState() => _OmnConversationsState();
}

class _OmnConversationsState extends State<OmnConversations> {
  User? _user;
  final log = getLogger('_ChatsPageState');

  @override
  void initState() {
    initializeFlutterFire();
    // ProxyService.notification.initialize();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      //final user = await ProxyService.auth.getCurrentUserId();

      // setState(() {
      //   _user = user;
      // });
    } catch (e) {}
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
        /// case where a user is chatting with himself
        /// for this case, we will add our bot's iD in the room
        /// this way we can be able to integract with the user's message
        color = getUserAvatarNameColor(room.users.first);
        // Do nothing if other user is not found
      }
    }

    // final hasImage = room.imageUrl != null;
    final name = room.name ?? 'MeOwner';

    return Container(
      child: TextDrawable(
        backgroundColor: color,
        text: name,
        isTappable: true,
        onTap: null,
        boxShape: BoxShape.rectangle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('No conversations'),
          );
        }

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
                    endActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: omniHandle(
                              context, room.id, widget.model, 'delete'),
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          RightToLeftRoute(
                            page: OmniConversation(room: room),
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
                              // primary is used for unread message will implement later.
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(right: 3),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 55,
                                      height: 55,
                                      child: _buildAvatar(room),
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
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
                                          senderName,
                                          style: Helpers.txtDefault.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .color,
                                          ),
                                        ),
                                        Text(
                                          room.updatedAt != null
                                              ? timeago.format(
                                                  DateTime.parse(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                      room.updatedAt!,
                                                      isUtc: true,
                                                    ).toIso8601String(),
                                                  ),
                                                )
                                              : '',
                                          style: Helpers.txtDefault,
                                        ),
                                      ],
                                    ),
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

  omniHandle(BuildContext context, id, model, String action) {
    // widget.model.deleteConversation(room.id);
  }
}
