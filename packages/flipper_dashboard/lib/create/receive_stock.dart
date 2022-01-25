import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/models/models.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';

class ReceiveStock extends StatefulWidget {
  ReceiveStock({Key? key, required this.variantId}) : super(key: key);
  final int variantId;

  @override
  State<ReceiveStock> createState() => _ReceiveStockState();
}

class _ReceiveStockState extends State<ReceiveStock> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "0");
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              ProxyService.nav.back();
            },
            disableButton: false,
            title: 'Receive stock',
            onPressedCallback: () {
              if (_formKey.currentState!.validate()) {
                model.updateStock(variantId: widget.variantId);
                ProxyService.nav.back();
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
            child: Container(
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
                      onChanged: (String? count) async {
                        if (count != null &&
                            count.startsWith('0') &&
                            count != '') {
                          controller.text = count.substring(1);
                          model.setStockValue(
                            value: double.parse(controller.text),
                          );
                        } else if (count != null && count != '') {
                          model.setStockValue(
                            value: double.parse(controller.text),
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
          ),
        );
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
