import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chat_list_viewmodel.dart';

class ChatListViewTablet extends ViewModelWidget<ChatListViewModel> {
  const ChatListViewTablet({super.key});

  @override
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello, TABLET UI!',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
