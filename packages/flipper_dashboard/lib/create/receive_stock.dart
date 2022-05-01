import 'dart:developer';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:stacked/stacked.dart';
import 'package:go_router/go_router.dart';

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
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.existingStock ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              GoRouter.of(context).pop();
            },
            disableButton: false,
            title: 'Receive stock',
            onPressedCallback: () {
              if (_formKey.currentState!.validate()) {
                model.updateStock(variantId: widget.variantId);
                GoRouter.of(context).pop();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock value';
                      }
                      return null;
                    },
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
                    onChanged: (String? count) async {
                      log("$count");
                      if (count?.startsWith('0') == true) {
                        model.setStockValue(
                          value: double.parse(count!.substring(1)),
                        );
                      } else {
                        model.setStockValue(
                          value: double.parse(count!),
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Add Stock',
                      focusColor: Colors.blue,
                    ),
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
