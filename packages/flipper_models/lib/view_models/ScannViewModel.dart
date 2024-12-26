import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter/material.dart';

class ScannViewModel extends ProductViewModel with RRADEFAULTS {
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

  Future<void> onAddVariant(
      {required String barCode,
      required bool isTaxExempted,
      required Product product,
      required double retailPrice,
      required double supplyPrice,
      required bool editmode}) async {
    int branchId = ProxyService.box.getBranchId()!;

    /// scan item if the same item is scanned more than once
    /// then its quantity will be incremented otherwise if the item is not found
    /// a new item will be created and added to the scannedVariants list
    for (var variant in scannedVariants) {
      if (variant.bcd == barCode) {
        // If found, update it
        variant.retailPrice = retailPrice;
        variant.supplyPrice = supplyPrice;

        variant.qty = (variant.qty!) + 1; // Increment the quantity safely
        notifyListeners();
        return;
      }
    }
    talker.info(
        "Scanned or about to create variant with productId ${product.id}");
    // If no matching variant was found, add a new one
    final variant = Variant(
      id: randomNumber(),
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
      productName: kProductName ?? product.name,
      branchId: branchId,
      lastTouched: DateTime.now(),
    );
    variant.stock = Stock(
      id: randomNumber(),
      currentStock: 1,
      variantId: variant.id,
      variant: variant,
      branchId: branchId,
      initialStock: 1,
      showLowStockAlert: true,
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
    );

    scannedVariants.add(
      variant,
    );

    notifyListeners();
  }

  Future<Product?> createProduct({required String name}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    String bhfid = (await ProxyService.box.bhfId()) ?? "00";
    return await ProxyService.strategy.createProduct(
      tinNumber: ProxyService.box.tin(),
      bhFId: bhfid,
      businessId: ProxyService.box.getBusinessId()!,
      branchId: ProxyService.box.getBranchId()!,
      product: Product(
        name: name,
        color: COLOR,
        businessId: businessId,
        branchId: branchId,
        id: randomNumber(),
        lastTouched: DateTime.now(),
      ),
      skipRegularVariant: true,
    );
  }

  void removeVariant({required int id}) {
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

  void updateVariantQuantity(int id, double newQuantity) {
    try {
      // Find the variant with the specified id
      Variant variant =
          scannedVariants.firstWhere((variant) => variant.id == id);

      Stock? stock = ProxyService.strategy.stockByVariantId(
          variantId: variant.id, branchId: ProxyService.box.getBranchId()!);
      ProxyService.strategy.updateStock(
          stockId: stock!.id,
          currentStock: newQuantity,
          rsdQty: newQuantity,
          initialStock: newQuantity,
          ebmSynced: false);

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

  void updateVariantUnit(int id, String? selectedUnit) {
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
      Map<int, TextEditingController>? rates,
      required double newRetailPrice,
      Map<int, TextEditingController>? dates}) async {
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
}
