import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter/material.dart';

class ScannViewModel extends ProductViewModel with RRADEFAULTS {
  final Map<String, bool> _selectedVariants = {};
  final Map<String, TextEditingController> _discountControllers = {};
  final Map<String, TextEditingController> _dateControllers = {};

  // Toggles selection for a specific variant.
  void toggleSelect(String variantId) {
    _selectedVariants[variantId] = !_selectedVariants[variantId]!;
    notifyListeners();
  }

  // Checks if a specific variant is selected.
  bool isSelected(String variantId) {
    return _selectedVariants[variantId] ?? false;
  }

  // Toggles selection for all variants.
  void toggleSelectAll(List<Variant> scannedVariants, bool selectAll) {
    for (var variant in scannedVariants) {
      _selectedVariants[variant.id] = selectAll;
    }
    notifyListeners();
  }

  // Returns the selection state for all variants.
  bool selectAll(List<Variant> variants) {
    return variants.every((variant) => _selectedVariants[variant.id] ?? false);
  }

  // Updates the tax type for a variant.
  Future<void> updateTax(Variant variant, String newTaxType) async {
    try {
      await ProxyService.strategy.updateVariant(
        updatables: [variant],
        variantId: variant.id,
        taxTyCd: newTaxType,
      );
      notifyListeners();
    } catch (e) {
      talker.error(e);
    }
  }

  // Returns a TextEditingController for managing the discount of a variant.
  TextEditingController getDiscountController(String variantId,
      {int? defaultDiscount}) {
    if (!_discountControllers.containsKey(variantId)) {
      _discountControllers[variantId] = TextEditingController(
        text: defaultDiscount?.toString() ?? '0',
      );
    }
    return _discountControllers[variantId]!;
  }

  // Opens a date picker and returns the picked date.
  Future<DateTime?> pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
  }

  // Returns a TextEditingController for managing the expiration date of a variant.
  TextEditingController getDateController(String variantId,
      {DateTime? defaultDate}) {
    if (!_dateControllers.containsKey(variantId)) {
      _dateControllers[variantId] = TextEditingController(
        text: defaultDate != null
            ? DateFormat('yyyy-MM-dd').format(defaultDate)
            : '',
      );
    }
    return _dateControllers[variantId]!;
  }

  // Determines whether to show the delete button for a variant.
  bool showDeleteButton(String variantId) {
    return isSelected(variantId);
  }

  // Disposes controllers when they are no longer needed.
  @override
  void dispose() {
    for (var controller in _discountControllers.values) {
      controller.dispose();
    }
    for (var controller in _dateControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Variant> scannedVariants = [];
  double retailPrice = 0.0;
  double supplyPrice = 0.0;
  bool EBMenabled = false;
  List<String> pkgUnits = [];

  Future<void> initialize() async {
    setProductName(name: null);
    pkgUnits = RRADEFAULTS.packagingUnits;
    log(ProxyService.box.tin().toString(), name: "ScannViewModel");
    log((await ProxyService.box.bhfId()).toString(), name: "ScannViewModel");

    /// when ebm enabled,additional feature will start to appear on UI e.g when adding new product on desktop
    EBMenabled = ProxyService.box.tin() != -1 &&
        (await ProxyService.box.bhfId())!.isNotEmpty;
    log(EBMenabled.toString(), name: "ScannViewModel");
    notifyListeners();
  }

  setScannedVariants(List<Variant> variants) {
    scannedVariants = variants;
    notifyListeners();
  }

  final talker = TalkerFlutter.init();

  Future<void> onScanItem(
      {required String barCode,
      required bool isTaxExempted,
      required Product product,
      required double retailPrice,
      required double supplyPrice,
      required bool editmode,
      required String countryCode}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    /// scan item if the same item is scanned more than once
    /// then its quantity will be incremented otherwise if the item is not found
    /// a new item will be created and added to the scannedVariants list
    for (var variant in scannedVariants) {
      if (variant.bcd == barCode) {
        // If found, update it
        variant.retailPrice = retailPrice;
        variant.supplyPrice = supplyPrice;
        variant.rsdQty = (variant.qty!) + 1;
        variant.qty = (variant.qty!) + 1; // Increment the quantity safely
        notifyListeners();
        return;
      }
    }
    talker.info(
        "Scanned or about to create variant with productId ${product.id}");
    // If no matching variant was found, add a new one
    final variant = Variant(
      name: product.name,
      retailPrice: retailPrice,
      supplyPrice: supplyPrice,
      prc: retailPrice,
      qty: 1,
      dcRt: 0,

      // bcd is bar code
      bcd: barCode,
      sku: barCode,
      productId: product.id,
      color: currentColor,
      unit: 'Per Item',
      productName: product.name,
      branchId: branchId,

      lastTouched: DateTime.now(),
    );
    final stock = Stock(
      currentStock: 1,
      branchId: branchId,
      initialStock: 1,
      rsdQty: 1,
      tin: business?.tinNumber ?? ProxyService.box.tin(),
      value: 1 * retailPrice,
      ebmSynced: false,
      active: false,
      showLowStockAlert: true,
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
    );
    variant.stock = stock;
    variant.stockId = stock.id;

    scannedVariants.add(
      variant,
    );

    notifyListeners();
  }

  Future<Product?> createProduct(
      {required String name, required bool createItemCode}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    String bhfid = (await ProxyService.box.bhfId()) ?? "00";
    return await ProxyService.strategy.createProduct(
      createItemCode: false,
      tinNumber: ProxyService.box.tin(),
      bhFId: bhfid,
      businessId: ProxyService.box.getBusinessId()!,
      branchId: ProxyService.box.getBranchId()!,
      product: Product(
        name: name,
        color: COLOR,
        businessId: businessId,
        branchId: branchId,
        lastTouched: DateTime.now(),
      ),
      skipRegularVariant: true,
    );
  }

  void removeVariant({required String id}) {
    // Find the index of the variant with the specified id
    int index = scannedVariants.indexWhere((variant) => variant.id == id);

    if (index != -1) {
      // If the variant is found, remove it from the list
      Variant matchedVariant = scannedVariants[index];
      try {
        ProxyService.strategy.delete(
            id: matchedVariant.id,
            endPoint: 'variant',
            flipperHttpClient: ProxyService.http);
      } catch (e) {}
      scannedVariants.removeAt(index);
      notifyListeners();
    }
  }

  setRetailPrice({required String price}) {
    try {
      retailPrice = double.parse(price);
    } catch (e) {}
    notifyListeners();
  }

  setSupplyPrice({required String price}) {
    try {
      supplyPrice = double.parse(price);
    } catch (e) {}
    notifyListeners();
  }

  Future<void> updateVariantQuantity(String id, double newQuantity) async {
    try {
      // Find the variant with the specified id

      // from scannedVariants look where id match set the qty
      scannedVariants.forEach((variant) {
        if (variant.id == id) {
          variant.stock!.rsdQty = newQuantity;
          variant.stock!.currentStock = newQuantity;
          variant.stock!.initialStock = newQuantity;
          variant.stock!.value = newQuantity * variant.retailPrice!;
        }
      });

      notifyListeners();
    } catch (e) {
      // Handle the exception if the variant is not found
      print('Variant with ID $id has error while updating it');
      talker.error(e);
    }
  }

  Future<void> deleteAllVariants() async {
    // Assuming that each variant has a unique ID
    for (var variant in scannedVariants) {
      await ProxyService.strategy.delete(
          id: variant.id,
          endPoint: 'variant',
          flipperHttpClient: ProxyService.http);
    }

    scannedVariants.clear();
    notifyListeners();
  }

  void updateVariantUnit(String id, String? selectedUnit) {
    try {
      // Find the variant with the specified id
      Variant variant =
          scannedVariants.firstWhere((variant) => variant.id == id);

      // If the variant is found, update its unit

      ProxyService.strategy.updateVariant(
          updatables: [variant],
          unit: selectedUnit ?? 'Per Item',
          variantId: id);
      notifyListeners();
    } catch (e) {
      // Handle the exception if the variant is not found
      print('Variant with ID $id has error while updating it');
      talker.error(e);
    }
  }

  Future<void> bulkUpdateVariants(bool editmode,
      {required String color,
      required String selectedProductType,
      Map<String, TextEditingController>? rates,
      required double newRetailPrice,
      Map<String, TextEditingController>? dates}) async {
    if (editmode) {
      try {
        ProxyService.strategy.updateVariant(
          updatables: scannedVariants,
          newRetailPrice: newRetailPrice,
          rates: rates?.map((key, value) => MapEntry(key, value.text)),
          dates: dates?.map((key, value) => MapEntry(key, value.text)),
          supplyPrice: supplyPrice != 0 ? supplyPrice : null,
          retailPrice: retailPrice != 0 ? retailPrice : null,
        );
      } catch (e) {
        talker.error(e);
        rethrow;
      }
    }
  }
  // OLJ

  void updateDateController(String id, DateTime date) {
    if (_dateControllers.containsKey(id)) {
      _dateControllers[id]!.text = DateFormat('yyyy-MM-dd').format(date);
      // Update the variant's expiration date
      scannedVariants.forEach((variant) {
        if (variant.id == id) {
          variant.expirationDate = date;
        }
      });
      notifyListeners();
    }
  }
}
