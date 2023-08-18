import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';

class SupplyPrice extends StatelessWidget {
  const SupplyPrice(
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
          onChanged: (value) => onModelUpdate(value),
          decoration: InputDecoration(
              enabled: true,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(FluentIcons.money_24_regular),
              hintText: FLocalization.of(context).supplyPrice),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
