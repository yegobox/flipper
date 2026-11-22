import 'package:flipper_dashboard/create/section_select_unit.dart';
import 'package:flipper_dashboard/features/product_entry/sku_entry.dart';
import 'package:flipper_models/sku/sku_duplicate_check.dart';
import 'package:flipper_models/sku/sku_service.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
  String? _skuPreview;

  @override
  void dispose() {
    retailController.dispose();
    costController.dispose();
    nameController.dispose();
    skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannViewModel>.reactive(
      onViewModelReady: (model) async {
        await model.getProduct(productId: widget.productId);
        final product = model.product;
        if (product == null) return;
        // Local read: the product's other variants decide whether this one
        // gets a suffix (BEV-00042-02) or a new number.
        final siblings = await productVariantSkus(
          productId: product.id,
          branchId: product.branchId,
        );
        if (!mounted) return;
        setState(() {
          _skuPreview = skuPreviewFor(
            businessId: product.businessId,
            siblingSkus: siblings,
          );
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.flipperL10n.createAddVariation),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (AddVariation._formKey.currentState!.validate()) {
                    // A typed SKU must be free in the business. Local check
                    // only, so it works offline; blank is assigned on save.
                    final product = model.product;
                    // Read once: the field stays editable during the awaits
                    // below, and the SKU saved must be the one checked.
                    final checkedSku = skuController.text.trim();
                    if (product != null) {
                      final skuError = await skuSaveError(
                        context,
                        typed: checkedSku,
                        businessId: product.businessId,
                        candidate: SkuHolder(
                          id: '',
                          branchId: product.branchId,
                          productId: product.id,
                        ),
                      );
                      if (skuError != null) {
                        if (context.mounted) {
                          showErrorNotification(context, skuError);
                        }
                        return;
                      }
                    }

                    /// TODO: change this hard coded on mobile later.
                    await _saveVariation(
                      model,
                      selectedProductType: "1",
                      productName: "",
                      typedSku: checkedSku,
                    );
                    _routerService.pop();
                  }
                },
                child: Text(
                  context.flipperL10n.save,
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
                  SectionSelectUnit(product: model.product!, type: 'variation'),
                  _buildTextFormField(
                    controller: nameController,
                    labelText: context.flipperL10n.name,
                    hintText: context.flipperL10n.createEnterProductName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.flipperL10n.createNameRequired;
                      }
                      return null;
                    },
                  ),
                  _buildPriceFormField(
                    controller: retailController,
                    labelText: context.flipperL10n.createRetailPrice,
                    hintText: context.flipperL10n.createEnterRetailPrice,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.flipperL10n.createRetailPriceRequired;
                      }
                      if (!isNumeric(value)) {
                        return context.flipperL10n.createShouldBeNumber;
                      }
                      return null;
                    },
                  ),
                  _buildPriceFormField(
                    controller: costController,
                    labelText: context.flipperL10n.createCostPrice,
                    hintText: context.flipperL10n.createEnterCostPrice,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.flipperL10n.createCostPriceRequired;
                      }
                      if (!isNumeric(value)) {
                        return context.flipperL10n.createShouldBeNumber;
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SkuTextField(
                      controller: skuController,
                      preview: _skuPreview,
                      decorate: (base) => base.copyWith(
                        suffixIcon: const Icon(Icons.book),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      context.flipperL10n.createTaxExempted,
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
                  const Divider(color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      context.flipperL10n.createFillRequiredFields,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ScannViewModel(),
    );
  }

  Future<void> _saveVariation(
    ScannViewModel model, {
    required String selectedProductType,
    Map<String, String>? rates,
    Map<String, String>? dates,
    required String productName,
    required String typedSku,
  }) async {
    Business? business = await ProxyService.strategy.getBusiness(
      businessId: ProxyService.box.getBusinessId()!,
    );
    String itemPrefix = "flip-";
    String clip =
        itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

    // 321981891968185
    // 321981891968185
    List<Variant> variations = [];
    // Blank: addVariant assigns the SKU (a sibling suffix or a new number).
    final String? sku = typedSku.isEmpty ? null : typedSku;
    Variant data =
        Variant(
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
        final pendingTransaction = await ProxyService.strategy
            .manageTransaction(
              transactionType: TransactionType.adjustment,
              isExpense: true,
              branchId: ProxyService.box.getBranchId()!,
            );
        Business? business = await ProxyService.strategy.getBusiness(
          businessId: ProxyService.box.getBusinessId()!,
        );
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
