import 'package:chat/flat_widgets/flat_action_btn.dart';
import 'package:chat/flat_widgets/flat_add_story_btn.dart';
import 'package:chat/flat_widgets/flat_chat_item.dart';
import 'package:chat/flat_widgets/flat_counter.dart';
import 'package:chat/flat_widgets/flat_page_header.dart';
import 'package:chat/flat_widgets/flat_page_wrapper.dart';
import 'package:chat/flat_widgets/flat_profile_image.dart';
import 'package:chat/flat_widgets/flat_section_header.dart';
import 'package:chat/screens/chatpage.dart';
import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

import 'conversation_list.dart';

class KHomepage extends StatefulWidget {
  static final String id = "Homepage";

  @override
  _KHomepageState createState() => _KHomepageState();
}

class _KHomepageState extends State<KHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
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
                                fontSize: 14, fontWeight: FontWeight.bold),
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
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ConversationList(
              name: "Richard",
              messageText: "Hello world",
              imageUrl:
                  "https://cdn.dribbble.com/users/1281912/avatars/normal/febecc326c76154551f9d4bbab73f97b.jpg?1468927304",
              time: "Yesterday",
              isMessageRead: (0 == 0 || 0 == 3) ? true : false,
              onPressed: () {
                ProxyService.nav.navigateTo(Routes.chatPage);
              },
            )
          ],
        ),
      ),
    );
  }
}
