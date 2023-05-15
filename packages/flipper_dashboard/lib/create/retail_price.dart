import 'package:flipper_localize/flipper_localize.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class RetailPrice extends StatelessWidget {
  const RetailPrice(
      {Key? key, required this.onModelUpdate, required this.controller})
      : super(key: key);
  final Function onModelUpdate;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) => onModelUpdate(value),
          decoration: InputDecoration(
              enabled: true,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(FluentIcons.money_24_regular),
              hintText: FLocalization.of(context).retailPrice),
        ),
      ),
    );
  }
}
