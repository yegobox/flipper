import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/product/section_select_unit.dart';
import 'package:flipper/home/variation/variation_viewmodel.dart';

import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class AddVariationScreen extends StatefulWidget {
  const AddVariationScreen(
      {Key key, this.productId,})
      : super(key: key);
  final String productId;

  @override
  _AddVariationScreenState createState() => _AddVariationScreenState();
}

class _AddVariationScreenState extends State<AddVariationScreen> {
  String name;

  static final GlobalKey<FormState> _textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, VariationViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Add Variation',
              showActionButton: true,
              disableButton: model.isLocked,
              actionButtonName: 'Save',
              onPressedCallback: () async {
                await model.createVariant(context: context, productId:widget.productId);
                ProxyService.nav.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Container(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 400,
                          child: const Divider(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SectionSelectUnit(),
                      Center(
                        child: Container(
                          width: 300,
                          child: TextFormField(
                            key: _textKey,
                            controller: model.nameController,
                            style: const TextStyle(color: Colors.black),
                            validator: Validators.isValid,
                            onChanged: (String _name) {
                              model.lock(); //lock the fields
                            },
                            decoration: const InputDecoration(
                              hintText: 'Name',
                              focusColor: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      buildRetailPriceWidget(context: context, model: model),
                      buildCostPriceWidget(context: context, model: model),
                      Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: HexColor('#2d3436')),
                          validator: Validators.isValid,
                          onChanged: (String sku) {
                            if (sku == '' || sku == null) {
                              sku = DateTime.now().year.toString() +
                                  Uuid().v1().substring(0, 4);
                            } else {
                              sku = DateTime.now().year.toString() +
                                  sku.substring(0, 4);
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'SKU', focusColor: HexColor('#0984e3')),
                        ),
                      ),
                      const Text(
                          'Leave the price blank to enter at the time of sale.')
                    ],
                  )
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => VariationViewModel());
  }

  Container buildCostPriceWidget(
      {BuildContext context, VariationViewModel model}) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black),
        validator: Validators.isValid,
        onChanged: (String supplyPrice) {
          if (supplyPrice != '') {
            setState(() {
              model.supplierPrice = double.parse(supplyPrice);
            });
          }
        },
        decoration: const InputDecoration(
            hintText: 'Cost Price', focusColor: Colors.blue),
      ),
    );
  }

  Container buildRetailPriceWidget(
      {BuildContext context, VariationViewModel model}) {
    return Container(
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black),
        validator: Validators.isValid,
        onChanged: (String price) {
          if (price != '') {
            model.retailPrice = double.parse(price);
          }
        },
        decoration: const InputDecoration(
            hintText: 'Retail Price', focusColor: Colors.blue),
      ),
    );
  }
}
