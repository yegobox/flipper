import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> variantsWidget({required CoreViewModel model}) {
  final List<Widget> list = <Widget>[];

  for (Variant variant in model.variants) {
    list.add(SingleChildScrollView(
      child: InkWell(
        onTap: () {
          model.loadVariantStock(variantId: variant.id!);
          model.handleCustomQtySetBeforeSelectingVariation();

          model.keypad.setAmount(amount: variant.retailPrice * model.quantity);
          model.toggleCheckbox(variantId: variant.id!);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2.0, top: 4),
          child: Column(
            children: [
              Divider(
                color: Colors.grey.shade400,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<Variant?>(
                      future: model.getVariant(variantId: variant.id!),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Expanded(
                                child: Text(
                                  snapshot.data!.name == 'Regular'
                                      ? snapshot.data!.productName! +
                                          "(" +
                                          snapshot.data!.name! +
                                          ")"
                                      : snapshot.data!.name!,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.grey.shade800),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                  Row(children: [
                    Text(
                      'Frw${variant.retailPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade400),
                      ),
                    ),
                    Radio<String>(
                      // toggleable: true,
                      value: variant.id!.toString(),
                      groupValue: model.checked.toString(),
                      onChanged: (value) {
                        model.toggleCheckbox(variantId: variant.id!);
                        model.loadVariantStock(variantId: variant.id!);
                        model.handleCustomQtySetBeforeSelectingVariation();

                        model.keypad.setAmount(
                            amount: variant.retailPrice * model.quantity);
                        model.toggleCheckbox(variantId: variant.id!);
                      },
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
  return list;
}
