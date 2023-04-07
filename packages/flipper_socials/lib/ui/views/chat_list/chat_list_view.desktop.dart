import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_list_viewmodel.dart';
import 'experiment.dart';

class ChatListViewDesktop extends ViewModelWidget<ChatListViewModel> {
  ChatListViewDesktop({super.key});
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    return ChatScreen();
  }
}
