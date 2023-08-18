import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import 'chat_list_view.desktop.dart';
import 'chat_list_view.tablet.dart';
import 'chat_list_view.mobile.dart';
import 'chat_list_viewmodel.dart';

class ChatListView extends StackedView<ChatListViewModel> {
  const ChatListView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ChatListViewModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: ScreenTypeLayout.builder(
        mobile: (_) => const ChatListViewMobile(),
        tablet: (_) => const ChatListViewTablet(),
        desktop: (_) => const ChatListViewDesktop(),
      ),
    );
  }

  @override
  ChatListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatListViewModel();
}
