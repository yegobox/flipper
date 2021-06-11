import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:chat/screens/messa_view_model.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'conversation_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_models/message.dart';

class AddConversation extends StatelessWidget {
  const AddConversation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Start convo with any business...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                    ),
                  ),
                ),
                StreamBuilder<List<Message>>(
                    stream: ProxyService.api.messages(),
                    builder: (context, snapshot) {
                      List<Message>? messages = snapshot.data;
                      return (messages != null && messages.length != 0)
                          ? Column(
                              children: messages
                                  .map((message) => Slidable(
                                        secondaryActions: <Widget>[
                                          IconSlideAction(
                                            caption: 'Delete',
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () {
                                              model.delete(message.id);
                                            },
                                          ),
                                        ],
                                        actionPane: SlidableDrawerActionPane(),
                                        child: ConversationList(
                                          name: message.senderName,
                                          messageText: message.message,
                                          imageUrl:
                                              "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                          time: "Ago",
                                          isMessageRead:
                                              (0 == 0 || 0 == 3) ? true : false,
                                          onPressed: () {
                                            ProxyService.nav
                                                .navigateTo(Routes.chatPage);
                                          },
                                        ),
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
            ),
          ),
        );
      },
      viewModelBuilder: () => MessageViewModel(),
    );
  }
}
