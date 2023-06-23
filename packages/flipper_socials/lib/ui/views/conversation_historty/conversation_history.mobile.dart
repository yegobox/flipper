import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar/ConversationAdapter.dart';
import 'package:flipper_models/isar_models.dart';
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
            stream: ProxyService.isar.conversations(
              conversationId: widget.conversationId,
            ),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              latestConversation = data.isEmpty ? null : data.last;

              for (Conversation conversation in data) {
                types.Message message =
                    ConversationAdapter.fromConversation(conversation);

                if (!messageList.contains(message)) {
                  messageList.insert(0, message);
                }
              }

              return Chat(
                theme: const DefaultChatTheme(
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
                user: types.User(id: ProxyService.box.getUserPhone()!),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _click(types.PartialText message) async {
    Conversation conversation = await ProxyService.isar.sendMessage(
      message: message.text,
      latestConversation: latestConversation!,
    );
    messageList.insert(0, ConversationAdapter.fromConversation(conversation));
  }
}
