import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class ReceiveStock extends StatefulWidget {
  const ReceiveStock({Key? key, required this.variantId, this.existingStock})
      : super(key: key);
  final String variantId;
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
    controller = TextEditingController(text: widget.existingStock);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
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
            onActionButtonClicked: () {
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
                    onChanged: (String? count) {
                      if (count != null) {
                        double? parsedValue = double.tryParse(count);
                        if (parsedValue != null) {
                          if (count.startsWith('0')) {
                            controller.value = TextEditingValue(
                              text: count.substring(1),
                              selection: TextSelection.collapsed(
                                  offset: count.length - 1),
                            );
                          } else {
                            model.setStockValue(value: parsedValue);
                          }
                        }
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
