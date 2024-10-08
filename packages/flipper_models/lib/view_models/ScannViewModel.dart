import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'mixins/_product.dart';

class ScannViewModel extends ProductViewModel with ProductMixin, RRADEFAULTS {
  List<Variant> scannedVariants = [];
  double retailPrice = 0.0;
  double supplyPrice = 0.0;
  bool EBMenabled = false;
  List<String> pkgUnits = [];

  void initialize() {
    setProductName(name: null);
    pkgUnits = RRADEFAULTS.packagingUnits;
    log(ProxyService.box.tin().toString(), name: "ScannViewModel");
    log(ProxyService.box.bhfId().toString(), name: "ScannViewModel");

    /// when ebm enabled,additional feature will start to appear on UI e.g when adding new product on desktop
    EBMenabled =
        ProxyService.box.tin() != -1 && ProxyService.box.bhfId()!.isNotEmpty;
    log(EBMenabled.toString(), name: "ScannViewModel");
    notifyListeners();
  }

  setScannedVariants(List<Variant> variants) {
    scannedVariants = variants;
    notifyListeners();
  }

  final talker = TalkerFlutter.init();
  void onAddVariant(
      {required String variantName,
      required bool isTaxExempted,
      required Product product,
      required bool editmode}) {
    int branchId = ProxyService.box.getBranchId()!;

    /// scan item if the same item is scanned more than once
    /// then its quantity will be incremented otherwise if the item is not found
    /// a new item will be created and added to the scannedVariants list
    for (var variant in scannedVariants) {
      if (variant.name == variantName) {
        // If found, update it
        variant.retailPrice = retailPrice;
        variant.supplyPrice = supplyPrice;
        variant.qty = (variant.qty) + 1; // Increment the quantity safely
        notifyListeners();
        return;
      }
    }
    talker.info(
        "Scanned or about to create variant with productId ${product.id}");
    // If no matching variant was found, add a new one
    scannedVariants.add(
      Variant(
        ObjectId(),
        name: variantName,
        retailPrice: retailPrice,
        supplyPrice: supplyPrice,
        prc: retailPrice,
        id: randomNumber(),
        sku: variantName,
        productId: product.id,
        color: currentColor,
        unit: 'Per Item',
        productName: kProductName ?? product.name,
        branchId: branchId,
        isTaxExempted: isTaxExempted,
        action: AppActions.created,
        lastTouched: DateTime.now(),
        qty: 1,
      ),
    );

    notifyListeners();
  }

  Future<Product?> createProduct({required String name}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.realm.createProduct(
      tinNumber: ProxyService.box.tin(),
      bhFId: ProxyService.box.bhfId() ?? "00",
      businessId: ProxyService.box.getBusinessId()!,
      branchId: ProxyService.box.getBranchId()!,
      product: Product(
        ObjectId(),
        name: name,
        color: COLOR,
        businessId: businessId,
        branchId: branchId,
        action: AppActions.created,
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
        ProxyService.realm.delete(
            id: matchedVariant.id!,
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

      // If the variant is found, update its quantity
      ProxyService.realm.realm!.write(() {
        variant.qty = newQuantity;
        variant.ebmSynced = false;
      });

      Stock? stock = ProxyService.realm.stockByVariantId(
          variantId: variant.id!, branchId: ProxyService.box.getBranchId()!);
      ProxyService.realm.realm!.write(() {
        stock!.rsdQty = newQuantity;
        stock.ebmSynced = false;
        stock.currentStock = newQuantity;
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
      await ProxyService.realm.delete(
          id: variant.id!,
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
      ProxyService.realm.realm!.write(() {
        variant.unit = selectedUnit ?? 'Per Item';
      });
      notifyListeners();
    } catch (e) {
      // Handle the exception if the variant is not found
      print('Variant with ID $id has error while updating it');
      talker.error(e);
    }
  }

  Future<void> bulkUpdateVariants(bool editmode,
      {required String color}) async {
    if (editmode) {
      final variantsLength = scannedVariants.length;

      // loop through all variants and update all with retailPrice and supplyPrice
      ProxyService.realm.realm!.write(() {
        for (var i = 0; i < variantsLength; i++) {
          scannedVariants[i].color = color;
          scannedVariants[i].itemNm = scannedVariants[i].name;
          scannedVariants[i].ebmSynced = false;
          // If found, update it
          if (retailPrice != 0) {
            scannedVariants[i].retailPrice = retailPrice;
          }

          if (supplyPrice != 0) {
            scannedVariants[i].supplyPrice = supplyPrice;
          }

          scannedVariants[i].qty = (scannedVariants[i].qty);
          scannedVariants[i].lastTouched = DateTime.now().toLocal();
          notifyListeners();
        }
      });
    }
  }
}
