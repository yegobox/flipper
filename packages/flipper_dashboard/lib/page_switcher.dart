import 'package:flipper_dashboard/apps.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

import 'checkout.dart';
import 'settings.dart';
import 'transactions.dart';

class PageSwitcher extends StatelessWidget {
  const PageSwitcher(
      {Key? key,
      required this.model,
      required this.controller,
      this.isBigScreen = false,
      required this.currentPage})
      : super(key: key);
  final HomeViewModel model;
  final TextEditingController controller;
  final int currentPage;
  final bool isBigScreen;
  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case 0:
        return Apps(
            model: model, controller: controller, isBigScreen: isBigScreen);
      // return CheckOut(
      //   controller: controller,
      //   model: model,
      //   tabController: tabController,
      //   isBigScreen: isBigScreen,
      // );
      case 1:
        return Transactions();
      case 2:
        return SettingPage();
      default:
        return CheckOut(isBigScreen: isBigScreen);
    }
  }
}
