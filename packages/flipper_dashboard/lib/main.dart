import 'package:flipper_dashboard/page_switcher.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

class Main extends StatelessWidget {
  const Main({
    super.key,
    required this.controller,
    required this.tabselected,
    required this.model,
  });

  final TextEditingController controller;
  final int tabselected;
  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        // this is a phone

        return PageSwitcher(
          controller: controller,
          model: model,
          currentPage: tabselected,
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              child: SizedBox.shrink(),
            ),
            // Left menu
            // ignore: todo
            // TODO: left menu will be essential when we add socials feature
            // by the time I implement it I will remove the above SizedBox as it is helping me
            // to keep the design consistent for now.
            // Container(
            //   width: 150,
            //   child: SideMenu(
            //     style: SideMenuStyle(
            //       showTooltip: false,
            //       displayMode: SideMenuDisplayMode.compact,
            //       compactSideMenuWidth: 60,
            //       openSideMenuWidth: 150,
            //     ),
            //     items: [
            //       SideMenuItem(
            //         // Priority of item to show on SideMenu, lower value is displayed at the top
            //         priority: 0,
            //         title: 'Dashboard',
            //         icon: Icon(Icons.home),
            //         badgeContent: Text(
            //           '3',
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       )
            //     ],
            //     controller: sideMenu,
            //   ),
            // ),

            // Middle menu
            Expanded(
              flex: 2,
              child: Container(
                child: ProductView.normalMode(),
              ),
            ),

            // Right menu
            Expanded(
              flex: 1,
              child: Container(
                child: PageSwitcher(
                  isBigScreen: true,
                  controller: controller,
                  model: model,
                  currentPage: tabselected,
                ),
              ),
            ),
          ],
        );
      }
    });
  }
}
