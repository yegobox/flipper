import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/chat_list/chat_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            backgroundImage: NetworkImage(conversations![index].avatar ?? ""),
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
      title: Text(conversations![index].userName!,
          style: GoogleFonts.poppins(
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          )),
      subtitle: StreamBuilder(
        stream: ProxyService.isar.conversations(
            conversationId: conversations![index].conversationId!),
        builder:
            (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
          if (snapshot.hasData) {
            final List<Conversation> conversations = snapshot.data!;
            final Conversation? lastConversation =
                conversations.isNotEmpty ? conversations.last : null;
            return Text(
              lastConversation!.body!.length > 40
                  ? lastConversation.body!.substring(0, 40) + "..."
                  : lastConversation.body!,
              style: GoogleFonts.poppins(
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            );
          } else {
            return const SizedBox(); // return an empty SizedBox if there is no data yet
          }
        },
      ),
      trailing: StreamBuilder(
        stream: ProxyService.isar.conversations(
            conversationId: conversations![index].conversationId!),
        builder:
            (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot) {
          if (snapshot.hasData) {
            final List<Conversation> conversations = snapshot.data!;
            final Conversation? lastConversation =
                conversations.isNotEmpty ? conversations.last : null;
            return Text(
              timeago.format(DateTime.parse(lastConversation!.createdAt!)),
              style: GoogleFonts.poppins(
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            );
          } else {
            return const SizedBox(); // return an empty SizedBox if there is no data yet
          }
        },
      ),
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
                backgroundImage: NetworkImage(chat.avatar ?? ""),
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
          title: Text(chat.userName!),
          subtitle: Text(conversations[index].body!),
          trailing: Text(
              timeago.format(DateTime.parse(conversations[index].createdAt!))),
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
