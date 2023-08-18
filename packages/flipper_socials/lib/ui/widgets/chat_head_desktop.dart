import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ChatList extends StatelessWidget {
  // A list of dummy chat data
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

  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // A variable that holds the selected chat index
    int selectedChatIndex = 0;
    // A variable that holds the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // A variable that holds the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        // An icon button that shows a plus icon to initiate a new chat
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.add_24_regular),
            onPressed: () {
              // TODO: implement the logic to initiate a new chat
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // A sliver app bar that shows the top recent chat heads
          SliverAppBar(
            // Make the app bar pinned so it stays visible
            pinned: true,
            // Make the app bar expanded so it takes more space
            expandedHeight: 100,
            // Make the app bar transparent so it blends with the background
            backgroundColor: Colors.transparent,
            // A flexible space widget that shows the chat heads in a row
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: chats.map((chat) {
                    // A circle avatar that shows the chat image
                    return CircleAvatar(
                      backgroundImage: NetworkImage(chat.avatar),
                      radius: 30,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // A sliver list that displays the chat heads and the selected chat on bigger screens
          SliverList(
            delegate: SliverChildListDelegate([
              // A row that contains the chat heads and the selected chat on bigger screens
              Row(
                children: [
                  // A container that shows the chat heads in a column
                  SizedBox(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.8,
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        // Get the chat data at the current index
                        final chat = chats[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          // A row that contains the chat head and the message
                          child: Row(
                            children: [
                              // A stack that shows the chat image and the source image
                              Stack(
                                children: [
                                  // A circle avatar that shows the chat image
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(chat.avatar),
                                    radius: 30,
                                  ),
                                  // A positioned widget that shows the source image at the bottom right corner
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Image.network(chat.source,
                                        width: 16, height: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // A column that shows the chat name and message
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(chat.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(chat.message,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // A container that shows the selected chat on bigger screens
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.8,
                    child: Column(
                      children: [
                        // A text widget that shows the selected chat name
                        Text(
                          chats[selectedChatIndex].name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // A divider widget that separates the chat name and the chat messages
                        const Divider(),
                        // A flexible widget that shows the chat messages in a list view
                        Flexible(
                          child: ListView(
                            children: const [
                              // TODO: implement the logic to show the chat messages in the selected chat
                            ],
                          ),
                        ),
                        // A divider widget that separates the chat messages and the input field
                        const Divider(),
                        // A text field widget that allows the user to type a message
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            suffixIcon: IconButton(
                              icon: const Icon(FluentIcons.send_24_regular),
                              onPressed: () {
                                // TODO: implement the logic to send a message in the selected chat
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// A class that represents a chat data
class Chat {
  final String name;
  final String message;
  final String avatar;
  final String source;

  Chat({
    required this.name,
    required this.message,
    required this.avatar,
    required this.source,
  });
}
