import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/chat_model.dart';
import 'package:flipper_socials/ui/widgets/list_of_messages.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_list_viewmodel.dart';

class ChatListViewMobile extends StatefulWidget {
  const ChatListViewMobile({super.key});

  @override
  State<ChatListViewMobile> createState() => _ChatListViewMobileState();
}

class _ChatListViewMobileState extends State<ChatListViewMobile> {
  final _routerService = locator<RouterService>();
  List<Conversation>? conversations;
  final List<Chat> chats = [
    Chat(
      from: "me",
      name: 'Alice',
      message: 'Hi, how are you?',
      avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/1200px-WhatsApp.svg.png',
    ),
    Chat(
      from: "me",
      name: 'Bob',
      message: 'Hello, nice to meet you.',
      avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/1200px-Instagram_logo_2016.svg.png',
    ),
    Chat(
      from: "me",
      name: 'Charlie',
      message: 'Hey, whats up?',
      avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Facebook_icon_2013.svg/1200px-Facebook_icon_2013.svg.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ViewModelBuilder<ChatListViewModel>.reactive(
        viewModelBuilder: () => ChatListViewModel(),
        onViewModelReady: (model) {},
        builder: (build, viewModel, child) {
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
                // A sliver list that displays the chat conversations
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Get the chat data at the current index
                      return StreamBuilder<List<Conversation>>(
                          stream: ProxyService.isarApi.conversations(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              log(snapshot.data!.length.toString());
                              final _conversations = snapshot.data;
                              conversations = _conversations!;
                              return ListOfMessages(
                                size: size,
                                viewModel: viewModel,
                                conversations: _conversations,
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No conversations to show, wait for your customers!",
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }
                          });
                    },
                    // The child count is the length of the chat list
                    childCount:
                        conversations == null ? 0 : conversations!.length,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
