import 'dart:developer';

import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/apps.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLayoutDrawer extends StatefulWidget {
  const AppLayoutDrawer(
      {Key? key,
      required this.controller,
      required this.tabSelected,
      required this.model,
      required this.focusNode})
      : super(key: key);

  final TextEditingController controller;
  final int tabSelected;
  final CoreViewModel model;
  final FocusNode focusNode;

  @override
  State<AppLayoutDrawer> createState() => _AppLayoutDrawerState();
}

class _AppLayoutDrawerState extends State<AppLayoutDrawer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Apps(
            isBigScreen: false,
            controller: widget.controller,
            model: widget.model,
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: const SizedBox.shrink(),
              ),
              Expanded(
                flex: 2,
                child: ProductView.normalMode(),
              ),
              Expanded(
                flex: 1,
                child: CheckOut(isBigScreen: true),
              ),
            ],
          );
        }
      },
    );
  }
}
