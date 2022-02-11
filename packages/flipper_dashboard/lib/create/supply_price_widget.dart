import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:google_ui/google_ui.dart';

class SupplyPrice extends StatelessWidget {
  const SupplyPrice(
      {Key? key, required this.onModelUpdate, required this.controller})
      : super(key: key);
  final Function onModelUpdate;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: GTextFormField(
          controller: controller,
          onChanged: (value) {
            onModelUpdate(value);
          },
          suffixIcon: const Icon(Icons.book),
          hintText: FLocalization.of(context).supplyPrice,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
