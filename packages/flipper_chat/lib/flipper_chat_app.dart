import 'package:flipper_chat/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flipper_chat/calls_page.dart';
import 'package:flipper_chat/chat_page.dart';
import 'package:flipper_chat/theme/colors.dart';

class FlipperChatApp extends StatefulWidget {
  @override
  _FlipperChatAppState createState() => _FlipperChatAppState();
}

class _FlipperChatAppState extends State<FlipperChatApp> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [CallsPage(), ChatPage(), SettingsPage()],
    );
  }

  Widget getFooter() {
    List iconItems = [
      LineIcons.phoneSquare,
      LineIcons.comment,
      LineIcons.comment,
    ];
    List textItems = ["Status", "Messages", "Settings"];
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(color: greyColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(textItems.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = index;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      iconItems[index],
                      color:
                          pageIndex == index ? primary : white.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(textItems[index],
                        style: TextStyle(
                            fontSize: 10,
                            color: pageIndex == index
                                ? primary
                                : white.withOpacity(0.5).withOpacity(0.5))),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
