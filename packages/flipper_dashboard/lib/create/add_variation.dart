import 'package:flipper_dashboard/create/section_select_unit.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'divider.dart';

class AddVariation extends StatefulWidget {
  AddVariation({Key? key, required this.productId}) : super(key: key);
  final String productId;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _AddVariationState createState() => _AddVariationState();
}

class _AddVariationState extends State<AddVariation> {
  TextEditingController retailController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder<ProductViewModel>.reactive(
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.back();
              },
              title: 'Add Variation',
              showActionButton: true,
              disableButton: model.lock,
              rightActionButtonName: 'Save',
              onPressedCallback: () async {
                if (AddVariation._formKey.currentState!.validate()) {
                  await model.addVariant(
                    name: nameController.text,
                    retailPrice: double.parse(retailController.text),
                    supplyPrice: double.parse(costController.text),
                    productId: widget.productId,
                  );
                }
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Container(
              color: Theme.of(context).canvasColor,
              child: Form(
                key: AddVariation._formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                        ),
                        SectionSelectUnit(
                            product: model.product, type: 'variation'),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name required';
                                }
                                return null;
                              },
                              onChanged: (String _name) {
                                model.lock;
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
                        buildRetailPriceWidget(context: context),
                        const CenterDivider(
                          width: double.infinity,
                        ),
                        buildCostPriceWidget(context: context),
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
                                  if (sku == '') {
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
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
        viewModelBuilder: () => ProductViewModel());
  }

  Widget buildCostPriceWidget({required BuildContext context}) {
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
          controller: costController,
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

  Widget buildRetailPriceWidget({required BuildContext context}) {
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
          controller: retailController,
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
