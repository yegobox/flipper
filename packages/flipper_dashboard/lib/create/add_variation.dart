import 'package:flipper_dashboard/create/section_select_unit.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class AddVariation extends StatefulWidget {
  const AddVariation({Key? key, required this.productId}) : super(key: key);
  final String productId;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _AddVariationState createState() => _AddVariationState();
}

class _AddVariationState extends State<AddVariation> with TransactionMixinOld {
  TextEditingController retailController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  bool isTaxExempted = false;
  final _routerService = locator<RouterService>();
  String sku = '';

  @override
  void dispose() {
    retailController.dispose();
    costController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannViewModel>.reactive(
        onViewModelReady: (model) async {
          await model.getProduct(productId: widget.productId);
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add Variation'),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (AddVariation._formKey.currentState!.validate()) {
                      /// TODO: change this hard coded on mobile later.
                      await _saveVariation(model,
                          selectedProductType: "1", productName: "");
                      _routerService.pop();
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: SizedBox.shrink(), // Spacer for bottom padding
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Form(
                key: AddVariation._formKey,
                child: ListView(
                  children: <Widget>[
                    SectionSelectUnit(
                      product: model.product!,
                      type: 'variation',
                    ),
                    _buildTextFormField(
                      controller: nameController,
                      labelText: 'Name',
                      hintText: 'Enter product name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name required';
                        }
                        return null;
                      },
                    ),
                    _buildPriceFormField(
                      controller: retailController,
                      labelText: 'Retail Price',
                      hintText: 'Enter retail price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Retail price required';
                        }
                        if (!isNumeric(value)) {
                          return 'Should be a number';
                        }
                        return null;
                      },
                    ),
                    _buildPriceFormField(
                      controller: costController,
                      labelText: 'Cost Price',
                      hintText: 'Enter cost price',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cost price required';
                        }
                        if (!isNumeric(value)) {
                          return 'Should be a number';
                        }
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: skuController,
                      onChanged: (value) {
                        sku = DateTime.now().year.toString() +
                            (value.isEmpty ? '' : value);
                      },
                      labelText: 'SKU',
                      hintText: 'Enter SKU',
                      suffixIcon: Icon(Icons.book),
                    ),
                    SwitchListTile(
                      title: Text(
                        'Tax Exempted',
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
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Fill all required fields',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => ScannViewModel());
  }

  Future<void> _saveVariation(
    ScannViewModel model, {
    required String selectedProductType,
    Map<String, TextEditingController>? rates,
    Map<String, TextEditingController>? dates,
    required String productName,
  }) async {
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    String itemPrefix = "flip-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

    // 321981891968185
    // 321981891968185
    List<Variant> variations = [];
    Variant data = Variant(
      color: model.product!.color,
      name: nameController.text,
      sku: sku,
      lastTouched: DateTime.now().toUtc(),
      itemCd: clip,
      productId: model.product!.id,
      unit: model.productService.currentUnit!,
      productName: nameController.text,
      branchId: ProxyService.box.getBranchId()!,
      supplyPrice: double.parse(costController.text),
      retailPrice: double.parse(retailController.text),
    )
      ..sku = sku
      ..retailPrice = double.parse(retailController.text)
      ..supplyPrice = double.parse(costController.text)
      ..productId = model.product!.id
      ..unit = model.productService.currentUnit!
      ..productName = model.product!.name
      ..branchId = model.productService.branchId!
      ..branchId = ProxyService.box.getBranchId()!
      ..taxPercentage = 0.0
      // RRA fields
      ..bhfId = await ProxyService.box.bhfId() ?? "00"
      ..tin = business!.tinNumber
      ..itemStdNm = "Regular"
      ..prc = 0
      ..addInfo = "A"
      ..modrId = clip
      ..pkg = 1
      ..itemSeq = 1
      ..splyAmt = 0.0
      ..taxName = 'N/A';

    variations.add(data);

    await model.addVariant(
      model: model,
      countryofOrigin: "RW",
      selectedProductType: selectedProductType,
      packagingUnit: "BJ",
      productName: productName,
      rates: rates,
      dates: dates,
      variations: variations,
      onCompleteCallback: (List<Variant> variants) async {
        final pendingTransaction =
            await ProxyService.strategy.manageTransaction(
          transactionType: TransactionType.adjustment,
          isExpense: true,
          branchId: ProxyService.box.getBranchId()!,
        );
        Business? business = await ProxyService.strategy
            .getBusiness(businessId: ProxyService.box.getBusinessId()!);
        for (Variant variant in variants) {
          await ProxyService.strategy.assignTransaction(
            variant: variant,
            doneWithTransaction: true,
            pendingTransaction: pendingTransaction!,
            business: business!,
            randomNumber: randomNumber(),
            // 06 is incoming adjustment.
            sarTyCd: "06",
          );
        }
        if (pendingTransaction != null) {
          await completeTransaction(pendingTransaction: pendingTransaction);
        }
      },
    );
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPriceFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
