import 'package:customappbar/customappbar.dart';
import 'package:flipper/views/variation/variation_viewmodel.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'build_cost_widget.dart';
import 'build_retail_widget.dart';

class EditVariationScreen extends StatefulWidget {
  const EditVariationScreen(
      {Key key,
      @required this.variationId,
      @required this.productId,
      this.unitId})
      : super(key: key);
  final String variationId;
  final String unitId;
  final String productId;

  @override
  _EditVariationScreenState createState() => _EditVariationScreenState();
}

class _EditVariationScreenState extends State<EditVariationScreen> {
  static final GlobalKey<FormState> _textKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.nonReactive(
        builder:
            (BuildContext context, VariationViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Edit Variation',
              showActionButton: true,
              disableButton: model.isLocked,
              actionButtonName: 'Save',
              onPressedCallback: () async {
                model.updateVariation(variation: model.variation);
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
                      Container(
                        width: 400,
                        child: const Divider(
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 300,
                        child: GestureDetector(
                          onTap: () {
                            ProxyService.nav.navigateTo(
                              Routing.addUnitType,
                            );
                          },
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.3),
                            leading: const Text('Unit Type'),
                            trailing: Wrap(
                              children: <Widget>[
                                Text(model.variation.name),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          key: _textKey,
                          initialValue: model.variation.name,
                          style: const TextStyle(color: Colors.black),
                          validator: Validators.isEmpty,
                          controller: model.nameController,
                          decoration: const InputDecoration(
                              hintText: 'Name', focusColor: Colors.blue),
                        ),
                      ),
                      BuildRetailWidget(productId: widget.productId),
                      BuildCostWidget(productId: widget.productId),
                      Container(
                        width: 300,
                        child: TextFormField(
                          key: _textKey,
                          initialValue: model.variation.sku,
                          style: TextStyle(color: HexColor('#2d3436')),
                          validator: Validators.isValid,
                          controller: model.skuController,
                          decoration: InputDecoration(
                              hintText: 'SKU', focusColor: HexColor('#0984e3')),
                        ),
                      ),
                      const Text(
                          'Leave the price blank to enter at the time of sale.'),
                      Container(
                        height: 50,
                        color: model.nameController.text.length == 1
                            ? Colors.redAccent[700]
                            : Colors.white,
                        width: 340,
                        child: OutlineButton(
                          onPressed: () {
                            _closeAndDelete(context);
                          },
                          child: Text('Delete Item',
                              style: TextStyle(
                                  color: model.nameController.text.length == 1
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        onModelReady: (VariationViewModel model) =>
            model.getVariationsByProductId(productId: widget.productId),
        viewModelBuilder: () => VariationViewModel());
  }

  void _closeAndDelete(BuildContext context) async {
    ProxyService.nav.pop();
  }
}
