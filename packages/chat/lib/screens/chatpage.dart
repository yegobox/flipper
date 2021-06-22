import 'package:chat/flat_widgets/flat_action_btn.dart';
import 'package:chat/flat_widgets/flat_chat_message.dart';
import 'package:chat/flat_widgets/flat_message_input_box.dart';
import 'package:chat/flat_widgets/flat_page_wrapper.dart';
import 'package:chat/screens/messa_view_model.dart';
import 'package:flipper/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:timeago/timeago.dart' as timeago;

class KChatPage extends StatelessWidget {
  final int receiverId;

  const KChatPage({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('KChatPage');
    return ViewModelBuilder<MessageViewModel>.reactive(
        viewModelBuilder: () => MessageViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () async {
                ProxyService.nav.back();
              },
              title: '',
              showActionButton: false,
              onPressedCallback: () async {
                ProxyService.nav.back();
              },
              rightActionButtonName: '',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 50,
            ),
            body: FlatPageWrapper(
              scrollType: ScrollType.floatingHeader,
              reverseBodyList: true,
              children: [
                StreamBuilder<List<Message>>(
                    stream: ProxyService.api.messages(receiverId: receiverId),
                    builder: (context, snapshot) {
                      List<Message>? messages = snapshot.data;
                      return (messages != null && messages.length != 0)
                          ? Column(
                              children: messages
                                  .map((message) => chatMessage(
                                        message: message.message,
                                        showTime: true,
                                        messageType:
                                            message.senderId == receiverId
                                                ? MessageType.received
                                                : MessageType.sent,
                                        time: timeago.format(
                                            DateTime.parse(message.createdAt)),
                                      ))
                                  .toList(),
                            )
                          : Center(
                              child: Text(
                                'No Messages($receiverId)',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                    })
              ],
              footer: FlatMessageInputBox(
                prefix: FlatActionButton(
                  iconData: Icons.add,
                  iconSize: 24.0,
                  onPressed: () {
                    log.i('+ button clicked');
                  },
                ),
                roundedCorners: true,
                onSubmitted: (message) {
                  log.i(message);
                  model.sendMessage(receiverId: receiverId, message: message);
                },
                // suffix: FlatActionButton(
                //   iconData: Icons.image,
                //   iconSize: 24.0,
                // ),
              ),
            ),
          );
        });
  }
}
