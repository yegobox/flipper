import 'package:flipper_dashboard/preview_sale_button.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';

class SalesButtonsController extends StatelessWidget {
  SalesButtonsController(
      {Key? key,
      this.note,
      this.ticketsEnabled = true,
      required this.controller,
      this.payable,
      required this.tab,
      required this.model})
      : super(key: key);
  final String? note;
  final TextEditingController controller;
  final Widget? payable;
  final int tab;
  final bool ticketsEnabled;
  final CoreViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: ticketsEnabled
              ? payable
              : PreviewSaleButton(
                  completeTransaction: () {},
                ),
        ),
      ],
    );
  }
}
