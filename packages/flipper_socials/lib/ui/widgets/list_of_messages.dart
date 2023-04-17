import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class ListOfMessages extends StatelessWidget {
  ListOfMessages(
      {super.key,
      required this.size,
      required this.viewModel,
      required this.conversations,
      this.index});

  final Size size;
  final ChatListViewModel viewModel;
  final List<Conversation> conversations;
  final _routerService = locator<RouterService>();
  final int? index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.3,
      child: isDesktopOrWeb
          ? MessagesDisplayDesktop(
              conversations: conversations,
              viewModel: viewModel,
              routerService: _routerService)
          : MessageDisplayMobile(
              conversations: conversations,
              viewModel: viewModel,
              routerService: _routerService,
              index: index!,
            ),
    );
  }
}

class MessageDisplayMobile extends StatelessWidget {
  const MessageDisplayMobile({
    super.key,
    required this.conversations,
    required this.viewModel,
    required RouterService routerService,
    required this.index,
  }) : _routerService = routerService;

  final List<Conversation>? conversations;
  final ChatListViewModel viewModel;
  final RouterService _routerService;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          // A circle avatar that shows the chat image
          CircleAvatar(
            backgroundImage: NetworkImage(conversations![index].avatar),
            radius: 20,
          ),
          // A positioned widget that shows the channelType image at the bottom right corner
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage(
                "assets/${conversations![index].channelType}.png",
                package: 'flipper_socials',
              ),
            ),
          ),
        ],
      ),
      title: Text(conversations![index].userName),
      subtitle: Text(conversations!.last.body),
      trailing:
          Text(timeago.format(DateTime.parse(conversations!.last.createdAt!))),
      onTap: () {
        if (isDesktopOrWeb) {
          viewModel.focusedConversation = true;
          viewModel.conversationId = conversations![index].conversationId;
        } else {
          _routerService.navigateTo(ConversationHistoryRoute(
              conversationId: conversations![index].conversationId!));
        }
      },
    );
  }
}

class MessagesDisplayDesktop extends StatelessWidget {
  const MessagesDisplayDesktop({
    super.key,
    required this.conversations,
    required this.viewModel,
    required RouterService routerService,
  }) : _routerService = routerService;

  final List<Conversation> conversations;
  final ChatListViewModel viewModel;
  final RouterService _routerService;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
          subtitle: Text(conversations.last.body),
          trailing: Text(
              timeago.format(DateTime.parse(conversations.last.createdAt!))),
          onTap: () {
            if (isDesktopOrWeb) {
              viewModel.focusedConversation = true;
              viewModel.conversationId = conversations[index].conversationId;
            } else {
              _routerService.navigateTo(ConversationHistoryRoute(
                  conversationId: conversations[index].conversationId!));
            }
          },
        );
      },
    );
  }
}