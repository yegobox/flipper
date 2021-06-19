import 'package:chat/flat_widgets/flat_action_btn.dart';
import 'package:chat/flat_widgets/flat_chat_message.dart';
import 'package:chat/flat_widgets/flat_message_input_box.dart';
import 'package:chat/flat_widgets/flat_page_wrapper.dart';
import 'package:chat/screens/messa_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/message.dart';

class KChatPage extends StatelessWidget {
  final int receiverId;

  const KChatPage({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
        viewModelBuilder: () => MessageViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            body: FlatPageWrapper(
              scrollType: ScrollType.floatingHeader,
              reverseBodyList: true,
              children: [
                StreamBuilder<List<Message>>(
                    stream: ProxyService.api.messages(),
                    builder: (context, snapshot) {
                      List<Message>? messages = snapshot.data;
                      return (messages != null && messages.length != 0)
                          ? Column(
                              children: messages
                                  .map((message) => chatMessage(
                                        message: "Final Message in the list.",
                                        showTime: true,
                                        messageType: MessageType.received,
                                        time: "2 mins ago",
                                      ))
                                  .toList(),
                            )
                          : Center(
                              child: Text(
                                'No Messages',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                    })
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
        });
  }
}
