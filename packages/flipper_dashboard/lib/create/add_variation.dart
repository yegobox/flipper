import 'package:flipper/localization.dart';
import 'package:flipper_dashboard/create/section_select_unit.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/constants.dart';
import 'divider.dart';

class AddVariation extends StatefulWidget {
  AddVariation({Key? key, required this.productId}) : super(key: key);
  final int productId;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _AddVariationState createState() => _AddVariationState();
}

class _AddVariationState extends State<AddVariation> {
  TextEditingController retailController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  String sku = '';
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
                  final variantId = DateTime.now().millisecondsSinceEpoch;
                  List<Variant> variations = [];
                  Variant data = new Variant(
                    name: nameController.text,
                    sku: sku,
                    retailPrice: double.parse(retailController.text),
                    supplyPrice: double.parse(costController.text),
                    fproductId: model.product.id,
                    unit: model.productService.currentUnit!,
                    channels: [model.productService.userId!],
                    productName: model.product.name,
                    fbranchId: model.productService.branchId!,
                    id: variantId,
                    table: AppTables.variation,
                    taxName: 'N/A', //TODO: replace with branch/business config
                    taxPercentage: 0.0,
                  );
                  variations.add(data);
                  await model.addVariant(
                      variations: variations,
                      retailPrice: double.parse(retailController.text),
                      supplyPrice: double.parse(costController.text));
                  model.productService
                      .variantsProduct(productId: model.product.id);
                  ProxyService.nav.back();
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
                                hintText: Localization.of(context)!.productName,
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
                                onChanged: (String value) {
                                  if (value == '') {
                                    sku = DateTime.now().year.toString() +
                                        Uuid().v1().substring(0, 4);
                                  } else {
                                    sku = DateTime.now().year.toString() + sku;
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
            hintText: Localization.of(context)!.supplyPrice,
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
            hintText: Localization.of(context)!.retailPrice,
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
