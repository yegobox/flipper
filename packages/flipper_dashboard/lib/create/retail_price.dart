import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_rw/helpers/utils.dart';
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
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            onModelUpdate(value);
          },
          decoration: InputDecoration(
            hintText: FLocalization.of(context).retailPrice,
            fillColor: Theme.of(context)
                .copyWith(canvasColor: Colors.white)
                .canvasColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#D0D7E3')),
              borderRadius: BorderRadius.circular(5),
            ),
            suffixIcon: const Icon(Icons.book),
          ),
        ),
      ),
    );
  }
}
