import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_list_viewmodel.dart';

class ChatListViewMobile extends ViewModelWidget<ChatListViewModel> {
  ChatListViewMobile({super.key});
  final _routerService = locator<RouterService>();
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
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat List'),
        // An icon button that shows a plus icon to initiate a new chat
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.qr_code_24_regular),
            onPressed: () {
              _routerService.navigateTo(ScannViewRoute(intent: "login"));
            },
          ),
          IconButton(
            icon: const Icon(FluentIcons.add_24_regular),
            onPressed: () {
              // TODO: implement the logic to initiate a new chat
            },
          ),
          // An icon button that shows a logout icon to sign out
          IconButton(
            icon: const Icon(FluentIcons.sign_out_24_regular),
            onPressed: () {
              ProxyService.isarApi.logOut();
              // navigate to login page
              _routerService.navigateTo(const LoginViewRoute());
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // A sliver app bar that shows the top recent chat heads
          SliverAppBar(
            automaticallyImplyLeading: false,
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
          // A sliver list that displays the chat heads
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
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
                            child: Image.network(
                              chat.source,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // A column that shows the chat name and message
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            chat.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              // The child count is the length of the chat list
              childCount: chats.length,
            ),
          ),
        ],
      ),
    );
  }
}
