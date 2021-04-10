import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/views/product/section_select_unit.dart';
import 'package:flipper/views/shared/divider.dart';
import 'package:flipper_models/view_models/variation_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class AddVariationScreen extends StatelessWidget {
  const AddVariationScreen({Key key, this.productId}) : super(key: key);
  final String productId;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder<VariationViewModel>.reactive(
        builder:
            (BuildContext context, VariationViewModel model, Widget child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Add Variation',
              showActionButton: true,
              disableButton: model.isLocked,
              rightActionButtonName: 'Save',
              onPressedCallback: () async {
                if (_formKey.currentState.validate()) {
                  await model.createVariant(
                      context: context, productId: productId);
                }
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Container(
              color: Theme.of(context).canvasColor,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                        ),
                        const SectionSelectUnit(),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: model.nameController,
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name required';
                                }
                                return null;
                              },
                              onChanged: (String _name) {
                                model.lock();
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                fillColor: Theme.of(context)
                                    .copyWith(canvasColor: Colors.white)
                                    .canvasColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#D0D7E3')),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const CenterDivider(
                          width: double.infinity,
                        ),
                        buildRetailPriceWidget(context: context, model: model),
                        const CenterDivider(
                          width: double.infinity,
                        ),
                        buildCostPriceWidget(context: context, model: model),
                        const CenterDivider(
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                                style: TextStyle(color: HexColor('#2d3436')),
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
                                  hintText: 'SKU',
                                  fillColor: Theme.of(context)
                                      .copyWith(canvasColor: Colors.white)
                                      .canvasColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: HexColor('#D0D7E3')),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )),
                          ),
                        ),
                        const CenterDivider(
                          width: double.infinity,
                        ),
                        Text(
                          'Leave the price blank to enter at the time of sale.',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.black,
                                height: 1.37,
                              ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (VariationViewModel model) {
          model.initFields(TextEditingController(), TextEditingController(),
              TextEditingController());
        },
        viewModelBuilder: () => VariationViewModel());
  }

  Widget buildCostPriceWidget(
      {BuildContext context, VariationViewModel model}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cost price required';
            }
            return null;
          },
          controller: model.costController,
          decoration: InputDecoration(
            hintText: 'Cost Price',
            fillColor: Theme.of(context)
                .copyWith(canvasColor: Colors.white)
                .canvasColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#D0D7E3')),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRetailPriceWidget(
      {BuildContext context, VariationViewModel model}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: double.infinity,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Retail price required';
            }
            return null;
          },
          controller: model.retailController,
          decoration: InputDecoration(
            hintText: 'Retail Price',
            fillColor: Theme.of(context)
                .copyWith(canvasColor: Colors.white)
                .canvasColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#D0D7E3')),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
