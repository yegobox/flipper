import 'package:chat/screens/messa_view_model.dart';
import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper/constants.dart';
import 'conversation_list.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_ui/src/shared/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatList extends StatefulWidget {
  static final String id = "Homepage";

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
      onModelReady: (model) {
        // model.messages();
      },
      // UnSubscribe to stream when disposed
      // onDispose: ,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: GestureDetector(
              onTap: () {
                ProxyService.box.remove(key: pageKey);
                ProxyService.nav.navigateTo(Routes.startUpView);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: kcPrimaryColor,
                      width: 1,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: const Icon(
                        Icons.sync_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Switch back to business',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Conversations",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.pink[50],
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "Add New",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
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
                            borderSide:
                                BorderSide(color: Colors.grey.shade100)),
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
                                    .map((message) => ConversationList(
                                          name: "Richard",
                                          messageText: message.message,
                                          imageUrl:
                                              "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
                                          time: timeago.format(DateTime.parse(
                                              message.createdAt)),
                                          isMessageRead:
                                              (0 == 0 || 0 == 3) ? true : false,
                                          onPressed: () {
                                            ProxyService.nav
                                                .navigateTo(Routes.chatPage);
                                          },
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
          ),
        );
      },
      viewModelBuilder: () => MessageViewModel(),
    );
  }
}
