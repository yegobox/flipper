import 'package:flipper_socials/ui/widgets/chat_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final List<Chat> chats = [
    Chat(
      name: 'Alice',
      message: 'Hi, how are you?',
      avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/1200px-WhatsApp.svg.png',
    ),
    Chat(
      name: 'Bob',
      message: 'Hello, nice to meet you.',
      avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/1200px-Instagram_logo_2016.svg.png',
    ),
    Chat(
      name: 'Charlie',
      message: 'Hey, whats up?',
      avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Facebook_icon_2013.svg/1200px-Facebook_icon_2013.svg.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    // Use a row widget to split the screen into two parts
    return Scaffold(
      body: Row(
        children: [
          // The left part with the list of messages
          SizedBox(
            width: size.width * 0.3,
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat.source),
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
          ),
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
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/1200px-WhatsApp.svg.png"),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Richard Muragijimana"),
                            Text("online"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: const [],
                ),
                // The list of messages for the selected chat
                Center(
                  child: Flexible(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        // final message = selectedChat.messages[index];
                        return const Text("hello");
                      },
                    ),
                  ),
                ),
                // The text field for sending messages
                const TextField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
