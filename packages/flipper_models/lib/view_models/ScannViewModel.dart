// ScannViewModel.dart (Revised)
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
    print('ScannViewModel.updateTax called with: ${variant.id}, $newTaxType');
    try {
      int branchId = ProxyService.box.getBranchId()!;
      // 3. Update the local scannedVariants list by creating a copy of the variant with new taxtype.
      final index = scannedVariants.indexWhere((v) => v.id == variant.id);
      if (index != -1) {
        final existingVariant = scannedVariants[index]; //Get existing variant
        scannedVariants[index] = Variant(
            id: existingVariant.id,
            purchaseId: existingVariant.purchaseId,
            stockId: existingVariant.stockId,
            stock: existingVariant.stock != null
                ? Stock(
                    branchId: branchId,
                    id: existingVariant.stock!.id,
                    currentStock: existingVariant.stock!.currentStock,
                    rsdQty: existingVariant.stock!.rsdQty,
                    value: existingVariant.stock!.value,
                    lastTouched: DateTime.now(),
                  )
                : null,
            taxPercentage: existingVariant.taxPercentage,
            name: existingVariant.name,
            color: existingVariant.color,
            sku: existingVariant.sku,
            productId: existingVariant.productId,
            unit: existingVariant.unit,
            productName: existingVariant.productName,
            branchId: existingVariant.branchId,
            taxName: existingVariant.taxName,
            itemSeq: existingVariant.itemSeq,
            isrccCd: existingVariant.isrccCd,
            isrccNm: existingVariant.isrccNm,
            isrcRt: existingVariant.isrcRt,
            isrcAmt: existingVariant.isrcAmt,
            taxTyCd: newTaxType, // Set the new tax type here
            bcd: existingVariant.bcd,
            itemClsCd: existingVariant.itemClsCd,
            itemTyCd: existingVariant.itemTyCd,
            itemStdNm: existingVariant.itemStdNm,
            orgnNatCd: existingVariant.orgnNatCd,
            pkg: existingVariant.pkg,
            itemCd: existingVariant.itemCd,
            pkgUnitCd: existingVariant.pkgUnitCd,
            qtyUnitCd: existingVariant.qtyUnitCd,
            itemNm: existingVariant.itemNm,
            prc: existingVariant.prc,
            splyAmt: existingVariant.splyAmt,
            tin: existingVariant.tin,
            bhfId: existingVariant.bhfId,
            dftPrc: existingVariant.dftPrc,
            addInfo: existingVariant.addInfo,
            isrcAplcbYn: existingVariant.isrcAplcbYn,
            useYn: existingVariant.useYn,
            regrId: existingVariant.regrId,
            regrNm: existingVariant.regrNm,
            modrId: existingVariant.modrId,
            modrNm: existingVariant.modrNm,
            lastTouched: existingVariant.lastTouched,
            supplyPrice: existingVariant.supplyPrice,
            retailPrice: existingVariant.retailPrice,
            spplrItemClsCd: existingVariant.spplrItemClsCd,
            spplrItemCd: existingVariant.spplrItemCd,
            spplrItemNm: existingVariant.spplrItemNm,
            ebmSynced: existingVariant.ebmSynced,
            dcRt: existingVariant.dcRt,
            expirationDate: existingVariant.expirationDate,
            qty: existingVariant.qty,
            totWt: existingVariant.totWt,
            netWt: existingVariant.netWt,
            spplrNm: existingVariant.spplrNm,
            agntNm: existingVariant.agntNm,
            invcFcurAmt: existingVariant.invcFcurAmt,
            invcFcurCd: existingVariant.invcFcurCd,
            invcFcurExcrt: existingVariant.invcFcurExcrt,
            exptNatCd: existingVariant.exptNatCd,
            dclNo: existingVariant.dclNo,
            taskCd: existingVariant.taskCd,
            dclDe: existingVariant.dclDe,
            hsCd: existingVariant.hsCd,
            imptItemSttsCd: existingVariant.imptItemSttsCd,
            barCode: existingVariant.barCode,
            bcdU: existingVariant.bcdU,
            quantity: existingVariant.quantity,
            category: existingVariant.category,
            dcAmt: existingVariant.dcAmt,
            taxblAmt: existingVariant.taxblAmt,
            taxAmt: existingVariant.taxAmt,
            totAmt: existingVariant.totAmt,
            pchsSttsCd: existingVariant.pchsSttsCd,
            isShared: existingVariant.isShared);
      }

      // 4. Notify listeners to rebuild the UI
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
      regrNm: product.name,
      qty: 1,
      dcRt: 0,
      pkgUnitCd: "NT",
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
      int index = scannedVariants.indexWhere((variant) => variant.id == id);
      int branchId = ProxyService.box.getBranchId()!;

      if (index != -1) {
        // Create a *new* Variant object with the updated quantity
        final scannedVariant =
            scannedVariants[index]; // Store the original variant

        final updatedVariant = Variant(
          id: scannedVariant.id,
          purchaseId: scannedVariant.purchaseId,
          stockId: scannedVariant.stockId,
          stock: scannedVariant.stock != null
              ? Stock(
                  branchId: branchId,
                  id: scannedVariant.stock!.id,
                  currentStock: newQuantity,
                  rsdQty: newQuantity,
                  value: newQuantity * (scannedVariant.retailPrice ?? 0.0),
                  lastTouched: DateTime.now(),
                )
              : null,
          taxPercentage: scannedVariant.taxPercentage,
          name: scannedVariant.name,
          color: scannedVariant.color,
          sku: scannedVariant.sku,
          productId: scannedVariant.productId,
          unit: scannedVariant.unit,
          productName: scannedVariant.productName,
          branchId: scannedVariant.branchId,
          taxName: scannedVariant.taxName,
          itemSeq: scannedVariant.itemSeq,
          isrccCd: scannedVariant.isrccCd,
          isrccNm: scannedVariant.isrccNm,
          isrcRt: scannedVariant.isrcRt,
          isrcAmt: scannedVariant.isrcAmt,
          taxTyCd: scannedVariant.taxTyCd,
          bcd: scannedVariant.bcd,
          itemClsCd: scannedVariant.itemClsCd,
          itemTyCd: scannedVariant.itemTyCd,
          itemStdNm: scannedVariant.itemStdNm,
          orgnNatCd: scannedVariant.orgnNatCd,
          pkg: scannedVariant.pkg,
          itemCd: scannedVariant.itemCd,
          pkgUnitCd: scannedVariant.pkgUnitCd,
          qtyUnitCd: scannedVariant.qtyUnitCd,
          itemNm: scannedVariant.itemNm,
          prc: scannedVariant.prc,
          splyAmt: scannedVariant.splyAmt,
          tin: scannedVariant.tin,
          bhfId: scannedVariant.bhfId,
          dftPrc: scannedVariant.dftPrc,
          addInfo: scannedVariant.addInfo,
          isrcAplcbYn: scannedVariant.isrcAplcbYn,
          useYn: scannedVariant.useYn,
          regrId: scannedVariant.regrId,
          regrNm: scannedVariant.regrNm,
          modrId: scannedVariant.modrId,
          modrNm: scannedVariant.modrNm,
          lastTouched: DateTime.now(),
          supplyPrice: scannedVariant.supplyPrice,
          retailPrice: scannedVariant.retailPrice,
          spplrItemClsCd: scannedVariant.spplrItemClsCd,
          spplrItemCd: scannedVariant.spplrItemCd,
          spplrItemNm: scannedVariant.spplrItemNm,
          ebmSynced: scannedVariant.ebmSynced,
          dcRt: scannedVariant.dcRt,
          expirationDate: scannedVariant.expirationDate,
          qty: scannedVariant.qty,
          totWt: scannedVariant.totWt,
          netWt: scannedVariant.netWt,
          spplrNm: scannedVariant.spplrNm,
          agntNm: scannedVariant.agntNm,
          invcFcurAmt: scannedVariant.invcFcurAmt,
          invcFcurCd: scannedVariant.invcFcurCd,
          invcFcurExcrt: scannedVariant.invcFcurExcrt,
          exptNatCd: scannedVariant.exptNatCd,
          dclNo: scannedVariant.dclNo,
          taskCd: scannedVariant.taskCd,
          dclDe: scannedVariant.dclDe,
          hsCd: scannedVariant.hsCd,
          imptItemSttsCd: scannedVariant.imptItemSttsCd,
          barCode: scannedVariant.barCode,
          bcdU: scannedVariant.bcdU,
          quantity: scannedVariant.quantity,
          category: scannedVariant.category,
          dcAmt: scannedVariant.dcAmt,
          taxblAmt: scannedVariant.taxblAmt,
          taxAmt: scannedVariant.taxAmt,
          totAmt: scannedVariant.totAmt,
          pchsSttsCd: scannedVariant.pchsSttsCd,
          isShared: scannedVariant.isShared,
        );

        // Replace the old variant with the new variant
        scannedVariants[index] = updatedVariant;

        //Persit to db
        ProxyService.strategy.updateVariant(
          updatables: [updatedVariant],
          variantId: updatedVariant.id,
        );

        // Notify listeners to rebuild the UI
        notifyListeners();
      } else {
        // Handle the exception if the variant is not found
        print('Variant with ID $id not found');
        talker.error('Variant with ID $id not found');
      }
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
      Map<String, TextEditingController>? dates,
      required String productName,
      Function(List<Variant>)? onCompleteCallback}) async {
    if (editmode) {
      try {
        for (var variant in scannedVariants) {
          if (dates != null && dates.containsKey(variant.id)) {
            variant.expirationDate =
                DateFormat('yyyy-MM-dd').parse(dates[variant.id]!.text);
          }
          await ProxyService.strategy.updateVariant(
            updatables: scannedVariants,
            color: color,
            productName: productName.isEmpty ? null : productName,
            expirationDate: variant.expirationDate,
            newRetailPrice: newRetailPrice,
            rates: rates?.map((key, value) => MapEntry(key, value.text)),
            dates: dates?.map((key, value) => MapEntry(key, value.text)),
            supplyPrice: supplyPrice != 0 ? supplyPrice : null,
            retailPrice: retailPrice != 0 ? retailPrice : null,
          );
        }

        // Call the onCompleteCallback if provided
        if (onCompleteCallback != null) {
          onCompleteCallback(scannedVariants);
        }
      } catch (e) {
        talker.error(e);
        rethrow;
      }
    }
  }

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
