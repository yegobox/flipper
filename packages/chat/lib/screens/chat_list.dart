import 'package:chat/flat_widgets/flat_action_btn.dart';
import 'package:chat/flat_widgets/flat_add_story_btn.dart';
import 'package:chat/flat_widgets/flat_chat_item.dart';
import 'package:chat/flat_widgets/flat_counter.dart';
import 'package:chat/flat_widgets/flat_page_header.dart';
import 'package:chat/flat_widgets/flat_page_wrapper.dart';
import 'package:chat/flat_widgets/flat_profile_image.dart';
import 'package:chat/flat_widgets/flat_section_header.dart';
import 'package:chat/screens/messa_view_model.dart';
import 'package:flipper/localization.dart';
import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper/constants.dart';
import 'chatpage.dart';
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
            body: FlatPageWrapper(
              scrollType: ScrollType.floatingHeader,
              children: [
                Container(
                  height: 76.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                        ),
                        child: FlatAddStoryBtn(),
                      ),
                      FlatProfileImage(
                        imageUrl:
                            "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=80",
                        onlineIndicator: true,
                        outlineIndicator: true,
                      ),
                      FlatProfileImage(
                        outlineIndicator: true,
                        onlineIndicator: true,
                        imageUrl:
                            "https://images.unsplash.com/photo-1502323777036-f29e3972d82f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                      ),
                      FlatProfileImage(
                        outlineIndicator: true,
                        imageUrl:
                            "https://images.unsplash.com/photo-1582721244958-d0cc82a417da?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2179&q=80",
                      ),
                      FlatProfileImage(
                        onlineIndicator: true,
                        outlineIndicator: true,
                        imageUrl:
                            "https://images.unsplash.com/photo-1583243567239-3727551e0c59?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1112&q=80",
                      ),
                      FlatProfileImage(
                        outlineIndicator: true,
                      ),
                      FlatProfileImage(
                        outlineIndicator: true,
                      ),
                      FlatProfileImage(
                        outlineIndicator: true,
                      )
                    ],
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
                                        child: chatItem(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, KChatPage.id);
                                          },
                                          name: message.senderName,
                                          profileImage: FlatProfileImage(
                                            imageUrl:
                                                "https://images.unsplash.com/photo-1521235042493-c5bef89dc2c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1385&q=80",
                                            onlineIndicator: true,
                                          ),
                                          message: message.message,
                                          multiLineMessage: true,
                                          counter: FlatCounter(
                                            text: timeago.format(DateTime.parse(
                                                message.createdAt)),
                                          ),
                                        ),
                                        // child: ConversationList(
                                        //   name: message.senderName,
                                        //   messageText: message.message,
                                        //   imageUrl: null,
                                        // time: timeago.format(DateTime.parse(
                                        //     message.createdAt)),
                                        //   isMessageRead: (0 == 0 || 0 == 3)
                                        //       ? true
                                        //       : false,
                                        //   onPressed: () {
                                        //     ProxyService.nav
                                        //         .navigateTo(Routes.chatPage);
                                        //   },
                                        // ),
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
