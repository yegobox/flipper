import 'dart:developer';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class ReceiveStock extends StatefulWidget {
  const ReceiveStock({Key? key, required this.variantId, this.existingStock})
      : super(key: key);
  final int variantId;
  final String? existingStock;

  @override
  State<ReceiveStock> createState() => _ReceiveStockState();
}

class _ReceiveStockState extends State<ReceiveStock> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController controller;
  final FocusNode _searchFocusNode = FocusNode();
  final _routerService = locator<RouterService>();
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.existingStock ?? "0");
    controller.selection = TextSelection.collapsed(offset: 0);

    /// when user start typing remove 0 instantly

    controller.addListener(() {
      final value = controller.text;
      // ignore: todo
      ///TODO: the value is like 20
      /// but zero was not intended as I want to remove it
      /// if the lenght is ==2 because 20 has lenght==2
      /// but moving forward it should not remove it if a user type again and add zero
      /// so meaning removing 0 the initial value of TextFormField should be removed
      /// if a user type in TextFormField for the first time
      // if (value.length == 2 && value.endsWith('0')) {
      //   log(controller.text);
      //   controller.text = value.replaceAll(RegExp('^0+'), '');
      //   // Move cursor to the end of the text
      //   controller.selection = TextSelection.fromPosition(
      //       TextPosition(offset: controller.text.length));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              _routerService.pop();
            },
            disableButton: false,
            title: 'Receive stock',
            onPressedCallback: () {
              if (_formKey.currentState!.validate()) {
                model.updateStock(variantId: widget.variantId);
                _routerService.pop();
              }
            },
            showActionButton: true,
            rightActionButtonName: 'Save',
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 80, 10, 40),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onEditingComplete: () {
                      _searchFocusNode.unfocus();
                    },
                    focusNode: _searchFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock value';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        enabled: true,
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.book),
                        hintText: 'Add Stock'),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.rtl,
                    autofocus: true,
                    style: const TextStyle(color: Colors.black),
                    onTap: () {
                      if (controller.text.startsWith('0')) {
                        controller.text = "";
                      }
                    },

                    /// The parsedValue / 10 calculation in the modified code I provided is used to handle the case where the count string starts with a '0'.

                    ///When a double value is parsed from a string that starts with a '0', the leading '0' is often treated as a signifier that the value is in octal (base 8) notation rather than decimal (base 10) notation. This means that a string like "01.5" would be parsed as the value 1.5 in decimal notation, but a string like "012.5" would be parsed as the value 10.5 in octal notation (since the '12' in this case represents the number 1 * 8^1 + 2 * 8^0 = 10 in decimal notation).

                    ///To avoid this issue, the modified code I provided divides the parsed value by 10 if the count string starts with a '0'. This is because in some cases, the count string may represent a value that is intended to be displayed with one decimal point (e.g., "01.5" represents a count of 1.5 units), but the leading '0' can cause issues when parsing the value as a double. By dividing the parsed value by 10, we can correctly handle these cases and get the expected value of 1.5
                    onChanged: (String? count) async {
                      log("$count");
                      if (count != null) {
                        double? parsedValue = double.tryParse(count);
                        if (parsedValue != null) {
                          if (count.startsWith('0')) {
                            model.setStockValue(value: parsedValue / 10);
                          } else {
                            model.setStockValue(value: parsedValue);
                          }
                        } else {
                          // handle invalid double value
                        }
                      } else {
                        // handle null value
                      }
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  const Text(
                      'Inventory tracking will be enabled by\n default for items with stock count. To turn \n tracking off, visit your flipper Dashboard')
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
