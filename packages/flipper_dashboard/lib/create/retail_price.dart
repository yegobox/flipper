import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';

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
        child: GTextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            onModelUpdate(value);
          },
          suffixIcon: const Icon(Icons.book),
          hintText: FLocalization.of(context).retailPrice,
        ),
      ),
    );
  }
}
