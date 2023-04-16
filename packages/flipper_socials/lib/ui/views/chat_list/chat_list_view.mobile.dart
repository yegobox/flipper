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

class ChatListViewMobile extends ViewModelWidget<ChatListViewModel> {
  ChatListViewMobile({super.key});
  final _routerService = locator<RouterService>();
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
  Widget build(BuildContext context, ChatListViewModel viewModel) {
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
            body: ListOfMessages(size: size, viewModel: viewModel),
          );
        });
  }
}
