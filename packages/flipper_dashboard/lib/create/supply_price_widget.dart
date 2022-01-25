import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/flipper_localizations.dart'; // Add this line.
import 'package:localize/localize.dart';

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
      child: Container(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          onChanged: (value) {
            onModelUpdate(value);
          },
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: FLocalization.of(context).supplyPrice,
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
