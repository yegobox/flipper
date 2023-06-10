import 'package:flipper_dashboard/preview_sale_button.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';

class SalesButtonsController extends StatelessWidget {
  SalesButtonsController(
      {Key? key,
      this.amount = 0.0,
      this.note,
      this.ticketsEnabled = true,
      required this.controller,
      this.payable,
      required this.tab,
      required this.model})
      : super(key: key);
  final double amount;
  final String? note;
  final TextEditingController controller;
  final Widget? payable;
  final int tab;
  final bool ticketsEnabled;
  final BusinessHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: ticketsEnabled ? payable : PreviewSaleButton(model: model),
        ),
      ],
    );
  }
}
