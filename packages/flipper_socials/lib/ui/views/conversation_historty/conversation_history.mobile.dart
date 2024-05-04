import 'dart:developer';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar/ConversationAdapter.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class ConversationHistory extends StatefulWidget {
  const ConversationHistory({Key? key, required this.conversationId})
      : super(key: key);

  final String conversationId;

  @override
  State<ConversationHistory> createState() => _ConversationHistoryState();
}

class _ConversationHistoryState extends State<ConversationHistory>
    with TickerProviderStateMixin {
  Conversation? latestConversation;
  List<Conversation>? conversations;
  List<types.Message> messageList = [];
  final _routerService = locator<RouterService>();
  Set<String> messageIdSet = {};

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatListViewModel>.reactive(
      viewModelBuilder: () => ChatListViewModel(),
      onViewModelReady: (model) {},
      builder: (build, viewModel, child) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Conversations',
            onPop: () async {
              _routerService.back();
            },
          ),
          body: StreamBuilder<List<Conversation>>(
            stream: ProxyService.realm.conversations(
              conversationId: widget.conversationId,
            ),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              latestConversation = data.isEmpty ? null : data.last;

              for (Conversation conversation in data) {
                types.Message message =
                    ConversationAdapter.fromConversation(conversation);

                if (!messageIdSet.contains(message.id)) {
                  messageList.insert(0, message);
                  messageIdSet.add(message.id); // Add message ID to the set
                }
              }

              return Chat(
                theme: const DefaultChatTheme(
                  inputContainerDecoration: BoxDecoration(),
                  inputBorderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  inputTextDecoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  inputBackgroundColor: neutral0,
                ),
                key: const Key('chat_widget'), // Add a unique key
                messages: messageList,
                onSendPressed: _click,
                showUserAvatars: true,
                avatarBuilder: (types.User user) {
                  types.Message m = messageList
                      .where((element) => element.roomId == user.id)
                      .first;
                  log(m.toJson().toString(), name: "messageAvatar");
                  return CircleAvatar(
                    backgroundImage: NetworkImage(m.author.imageUrl!),
                  );
                },
                user: types.User(
                    id: ProxyService.box.getUserPhone()!.replaceAll("+", "")),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _click(types.PartialText message) async {
    Conversation conversation = await ProxyService.realm.sendMessage(
      message: message.text,
      latestConversation: latestConversation!,
    );
    messageIdSet.add(conversation.id.toString()); // Add message ID to the set
    messageList.insert(0, ConversationAdapter.fromConversation(conversation));
  }
}
