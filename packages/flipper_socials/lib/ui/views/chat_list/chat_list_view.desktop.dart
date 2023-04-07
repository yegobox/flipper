import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/chat_model.dart';
import 'package:flipper_socials/ui/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_list_viewmodel.dart';

class ChatListViewDesktop extends ViewModelWidget<ChatListViewModel> {
  ChatListViewDesktop({super.key});
  final _routerService = locator<RouterService>();
  final List<Chat> chats = [
    Chat(
      from: "me",
      name: 'Alice',
      message: 'Hi, how are you?',
      avatar: 'assets/a.png',
      source: 'assets/whatsapp.png',
    ),
    Chat(
      from: "other",
      name: 'Bob',
      message: 'Hello, nice to meet you.',
      avatar: 'assets/b.png',
      source: 'assets/instagram.png',
    ),
    Chat(
      from: "me",
      name: 'Charlie',
      message: 'Hey, whats up?',
      avatar: 'assets/c.png',
      source: 'assets/whatsapp.png',
    ),
  ];
  @override
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    // Use a row widget to split the screen into two parts
    return Scaffold(
      body: Row(
        children: [
          // The left part with the list of messages
          StreamBuilder<List<Conversation>>(
              stream: ProxyService.isarApi.conversations(),
              builder: (context, snapshot) {
                return SizedBox(
                  width: size.width * 0.3,
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ListTile(
                        leading: Stack(
                          children: [
                            // A circle avatar that shows the chat image
                            CircleAvatar(
                              backgroundImage: AssetImage(chat.avatar,
                                  package: "flipper_socials"),
                              radius: 20,
                            ),
                            // A positioned widget that shows the source image at the bottom right corner
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage: AssetImage(chat.source,
                                    package: "flipper_socials"),
                              ),
                            ),
                          ],
                        ),
                        title: Text(chat.name),
                        subtitle: Text(chat.message),
                        trailing: const Text("11:12"),
                        onTap: () {
                          // Select the chat and update the state
                        },
                      );
                    },
                  ),
                );
              }),
          // The right part with the selected chat details and messages
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              children: [
                // The app bar with profile picture, username, and status
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Row(
                      children: [
                        Stack(
                          children: const [
                            // A circle avatar that shows the chat image
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/b.png',
                                  package: "flipper_socials"),
                              radius: 20,
                            ),
                            // A positioned widget that shows the source image at the bottom right corner
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage: AssetImage(
                                    'assets/whatsapp.png',
                                    package: "flipper_socials"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: const [],
                ),
                // The list of messages for the selected chat
                Flexible(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      // Use the ChatWidget to display the message
                      return ChatWidget(chat: chats[index]);
                    },
                  ),
                ),
                // The text field for sending messages
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 10),
                  child: TextFormField(
                      decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type a message',
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
