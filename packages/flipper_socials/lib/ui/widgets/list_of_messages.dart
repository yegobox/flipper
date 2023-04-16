import 'package:flipper_models/isar_models.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter/material.dart';

class ListOfMessages extends StatelessWidget {
  const ListOfMessages(
      {super.key,
      required this.size,
      required this.viewModel,
      required this.conversations});

  final Size size;
  final ChatListViewModel viewModel;
  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.3,
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final chat = conversations[index];
          return ListTile(
            leading: Stack(
              children: [
                // A circle avatar that shows the chat image
                CircleAvatar(
                  backgroundImage: NetworkImage(chat.avatar),
                  radius: 20,
                ),
                // A positioned widget that shows the channelType image at the bottom right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage(
                      "assets/${chat.channelType}.png",
                      package: 'flipper_socials',
                    ),
                  ),
                ),
              ],
            ),
            title: Text(chat.userName),
            subtitle: Text(chat.body),
            trailing: const Text("11:12"),
            onTap: () {
              viewModel.focusedConversation = true;
              viewModel.conversationId = conversations[index].conversationId;
            },
          );
        },
      ),
    );
  }
}
