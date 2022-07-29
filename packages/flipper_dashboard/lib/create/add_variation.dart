import 'package:flipper_services/constants.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_dashboard/create/section_select_unit.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:go_router/go_router.dart';
import 'divider.dart';

class AddVariation extends StatefulWidget {
  const AddVariation({Key? key, required this.productId}) : super(key: key);
  final int productId;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _AddVariationState createState() => _AddVariationState();
}

class _AddVariationState extends State<AddVariation> {
  TextEditingController retailController = TextEditingController();

  TextEditingController costController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  bool isTaxExempted = false;
  final log = getLogger('AddVariation');
  String sku = '';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder<ProductViewModel>.reactive(
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                GoRouter.of(context).pop();
              },
              title: 'Add Variation',
              showActionButton: true,
              disableButton: model.lock,
              rightActionButtonName: 'Save',
              onPressedCallback: () async {
                Business? business = await ProxyService.isarApi.getBusiness();
                String itemPrefix = "flip-";
                String clip = itemPrefix +
                    DateTime.now()
                        .microsecondsSinceEpoch
                        .toString()
                        .substring(0, 5);
                if (AddVariation._formKey.currentState!.validate()) {
                  final variantId = DateTime.now().millisecondsSinceEpoch;
                  List<Variant> variations = [];
                  Variant data = Variant()
                    ..name = nameController.text
                    ..sku = sku
                    ..retailPrice = double.parse(retailController.text)
                    ..supplyPrice = double.parse(costController.text)
                    ..productId = model.product.id!
                    ..unit = model.productService.currentUnit!
                    ..isTaxExempted = isTaxExempted
                    ..productName = model.product.name
                    ..branchId = model.productService.branchId!
                    ..id = variantId
                    ..branchId = ProxyService.box.getBranchId()!
                    ..taxPercentage = 0.0
                    ..table = AppTables.variation
                    // RRA fields
                    ..bhfId = business?.bhfId
                    ..tin = business?.tinNumber
                    ..itemCd = clip
                    // TODOask about item clasification code, it seems to be static
                    ..itemClsCd = "5020230602"
                    ..itemTyCd = "1"
                    ..itemNm = "Regular"
                    ..itemStdNm = "Regular"
                    ..orgnNatCd = "RW"
                    ..pkgUnitCd = "NT"
                    ..qtyUnitCd = "CA"
                    ..taxTyCd = "B"
                    ..dftPrc = 0.0
                    ..prc = 0
                    ..addInfo = "A"
                    ..isrcAplcbYn = "N"
                    ..useYn = "N"
                    ..regrId = clip
                    ..regrNm = "Regular"
                    ..modrId = clip
                    ..modrNm = "Regular"
                    ..pkg = "1"
                    ..itemSeq = "1"
                    ..splyAmt = 0.0
                    // RRA fields ends
                    //TODOreplace with branch/business config
                    ..taxName = 'N/A';

                  variations.add(data);
                  await model.addVariant(
                    variations: variations,
                    retailPrice: double.parse(retailController.text),
                    supplyPrice: double.parse(
                      costController.text,
                    ),
                  );
                  model.productService
                      .variantsProduct(productId: model.product.id!);
                  GoRouter.of(context).pop();
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
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name required';
                                  }
                                  return null;
                                },
                                onChanged: (String _name) {
                                  if (_name.isEmpty) {
                                    return;
                                  }
                                  model.lock;
                                },
                                decoration: InputDecoration(
                                    enabled: true,
                                    border: const OutlineInputBorder(),
                                    hintText:
                                        FLocalization.of(context).productName)),
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
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                                onChanged: (String value) {
                                  if (value == '') {
                                    sku = DateTime.now().year.toString() +
                                        const Uuid().v1().substring(0, 4);
                                  } else {
                                    sku = DateTime.now().year.toString() + sku;
                                  }
                                },
                                decoration: const InputDecoration(
                                    enabled: true,
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.book),
                                    hintText: "SKU")),
                          ),
                        ),
                        SwitchListTile(
                            title: const Text(
                              'Tax exempted',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            value: isTaxExempted,
                            onChanged: (value) {
                              setState(() {
                                isTaxExempted = value;
                              });
                            }),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Leave the price blank to enter at the time of sale.',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black,
                                      height: 1.37,
                                    ),
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
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cost price required';
            }
            if (!isNumeric(value)) {
              return 'Should be a number';
            }
            return null;
          },
          controller: costController,
          decoration: InputDecoration(
              enabled: true,
              border: const OutlineInputBorder(),
              hintText: FLocalization.of(context).supplyPrice),
        ),
      ),
    );
  }

  Widget buildRetailPriceWidget({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Retail price required';
              }
              if (!isNumeric(value)) {
                return 'Should be a number';
              }
              return null;
            },
            controller: retailController,
            decoration: InputDecoration(
                enabled: true,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.book),
                hintText: FLocalization.of(context).retailPrice)),
      ),
    );
  }
}
