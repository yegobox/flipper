import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
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
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
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
            title: context.flipperL10n.receiveStockTitle,
            onActionButtonClicked: () {
              if (_formKey.currentState!.validate()) {
                model.updateStock(variantId: widget.variantId);
                _routerService.pop();
              }
            },
            showActionButton: true,
            rightActionButtonName: context.flipperL10n.save,
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 70,
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
                        return context.flipperL10n.receiveStockEnterValue;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabled: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.book),
                      hintText: context.flipperL10n.receiveStockAddStock,
                    ),
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
                                offset: count.length - 1,
                              ),
                            );
                          } else {
                            model.setStockValue(value: parsedValue);
                          }
                        }
                      }
                    },
                  ),
                  Container(height: 20),
                  Text(context.flipperL10n.receiveStockTrackingHint),
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
