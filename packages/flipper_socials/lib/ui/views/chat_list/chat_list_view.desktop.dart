import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'chat_list_viewmodel.dart';

class ChatListViewDesktop extends ViewModelWidget<ChatListViewModel> {
  const ChatListViewDesktop({super.key});

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
                if (snapshot.hasData) {
                  final chats = snapshot.data;
                  return SizedBox(
                    width: size.width * 0.3,
                    child: ListView.builder(
                      itemCount: chats!.length,
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
                            viewModel.focusedConversation = true;
                            viewModel.conversationId = chats[index].id;
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(" No conversations to show"),
                  );
                }
              }),
          // The right part with the selected chat details and messages
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              children: [
                // The app bar with profile picture, username, and status
                viewModel.focusedConversation
                    ? AppBar(
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
                      )
                    : const SizedBox.shrink(),
                // The list of messages for the selected chat
                viewModel.focusedConversation
                    ? StreamBuilder<List<Conversation>>(
                        stream: ProxyService.isarApi.conversations(
                            conversationId: viewModel.conversationId!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data;
                            return Flexible(
                              child: ListView.builder(
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  // Use the ChatWidget to display the message
                                  return ChatWidget(chat: data[index]);
                                },
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        })
                    : const SizedBox.shrink(),
                // The text field for sending messages
                viewModel.focusedConversation
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 10),
                        child: TextFormField(
                            decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type a message',
                        )),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text("No conversation choosen"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
