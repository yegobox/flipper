import 'package:flipper_socials/ui/widgets/chat_head_mobile.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chat_list_viewmodel.dart';

class ChatListViewMobile extends ViewModelWidget<ChatListViewModel> {
  const ChatListViewMobile({super.key});

  @override
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    return ChatList();
  }
}
