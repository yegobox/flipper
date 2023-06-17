import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

import 'checkout.dart';
import 'notifications.dart';
import 'settings.dart';
import 'transactions.dart';

class PageSwitcher extends StatelessWidget {
  const PageSwitcher(
      {Key? key,
      required this.model,
      required this.controller,
      required this.tabController,
      this.isBigScreen = false,
      required this.currentPage})
      : super(key: key);
  final BusinessHomeViewModel model;
  final TextEditingController controller;
  final TabController tabController;
  final int currentPage;
  final bool isBigScreen;
  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case 0:
        return CheckOut(
          controller: controller,
          model: model,
          tabController: tabController,
          isBigScreen: isBigScreen,
        );
      case 1:
        return Transactions(model: model);
      case 2:
        return SettingPage(business: model.businesses, tenant: model.tenant!);
      default:
        return CheckOut(
            controller: controller,
            model: model,
            tabController: tabController,
            isBigScreen: isBigScreen);
    }
  }
}
