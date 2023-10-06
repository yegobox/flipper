import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget quantityWidget({
  required CoreViewModel model,
  required BuildContext context,
  required TextEditingController quantityController,
}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 1.0),
      child: Column(
        children: [
          Divider(
            color: Colors.grey.shade300,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'QUANTITY',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 2, child: Text('')),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: model.quantity <= 1
                    ? IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.grey,
                          size: 25,
                        ),
                        onPressed: () {
                          model.decreaseQty((quantity) {
                            quantityController.text =
                                model.quantity!.toInt().toString();
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Color(0xC9000000),
                          size: 25,
                        ),
                        onPressed: () {
                          model.decreaseQty((quantity) {
                            quantityController.text =
                                model.quantity!.toInt().toString();
                          });
                        },
                      ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey.shade300,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    child: TextFormField(
                      controller: quantityController,
                      onChanged: (quantity) {
                        if (quantity.isNotEmpty) {
                          model.customQtyIncrease(double.parse(quantity));
                        }
                      },
                      decoration: InputDecoration(
                        // Set the underline color for both unfocused and focused states
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400), // Change this color
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400), // Change this color
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context)
                            .copyWith(canvasColor: Colors.grey.shade900)
                            .canvasColor,
                      ),
                      key: Key(model.quantity.toInt().toString()),
                      textAlign: TextAlign.center,
                      cursorColor: Theme.of(context)
                          .copyWith(canvasColor: const Color(0x3B000000))
                          .canvasColor,
                    ),
                  )),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey.shade300,
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color(0xC9000000),
                  size: 25,
                ),
                onPressed: () {
                  model.increaseQty(
                      callback: (quantity) {
                        quantityController.text =
                            model.quantity!.toInt().toString();
                      },
                      custom: false);
                },
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
        ],
      ),
    ),
  );
}
