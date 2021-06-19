import 'package:chat/screens/messa_view_model.dart';
import 'package:flipper/localization.dart';
import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper/constants.dart';
import 'conversation_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_models/message.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flipper_dashboard/custom_rect_tween.dart';
import 'package:flipper_dashboard/bottom_menu_bar.dart';
import 'package:flipper_dashboard/flipper_drawer.dart';
import 'package:flipper_dashboard/hero_dialog_route.dart';
import 'package:flipper_dashboard/popup_modal.dart';

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
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) {
                      return const OptionModal(
                        child: Text('hello world'),
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: addProductHero,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 1,
                        child: const Icon(
                          Icons.qr_code_scanner,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: BottomMenuBar(
                switchTab: (index) {
                  setState(() {
                    // model.setTab(tab: index);
                  });
                },
              ),
            ),
            drawer: FlipperDrawer(
              businesses: model.businesses,
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
                          GestureDetector(
                            onTap: () {
                              ProxyService.nav.navigateTo(Routes.addConvo);
                            },
                            child: Container(
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
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          child: ConversationList(
                                            name: message.senderName,
                                            messageText: message.message,
                                            imageUrl: null,
                                            time: timeago.format(DateTime.parse(
                                                message.createdAt)),
                                            isMessageRead: (0 == 0 || 0 == 3)
                                                ? true
                                                : false,
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
          ),
        );
      },
      viewModelBuilder: () => MessageViewModel(),
    );
  }
}
