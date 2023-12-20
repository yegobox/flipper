import 'dart:async';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

import 'mixins/_product.dart';

class ScannViewModel extends BaseViewModel with ProductMixin {
  List<Variant> scannedVariants = [];
  double retailPrice = 0.0;
  double supplyPrice = 0.0;

  void initialize() {
    scannedVariants = [];
    setProductName(name: null);
    notifyListeners();
  }

  void onAddVariant({
    required String variantName,
    required bool isTaxExempted,
    required Product product,
  }) {
    int branchId = ProxyService.box.getBranchId()!;

    // Check if the variant with the same name already exists
    for (var variant in scannedVariants) {
      if (variant.name == variantName) {
        // If found, update it
        variant.retailPrice = retailPrice;
        variant.supplyPrice = supplyPrice;
        variant.qty = (variant.qty ?? 0) + 1; // Increment the quantity safely
        notifyListeners();
        return;
      }
    }

    // If no matching variant was found, add a new one
    scannedVariants.add(
      Variant(
        name: variantName,
        retailPrice: retailPrice,
        id: randomString(),
        sku: variantName,
        productId: product.id,
        color: currentColor,
        unit: 'item',
        productName: productName ?? product.name,
        branchId: branchId,
        supplyPrice: supplyPrice,
        isTaxExempted: isTaxExempted,
        action: AppActions.created,
        lastTouched: DateTime.now(),
        qty: 1,
      ),
    );

    notifyListeners();
  }

  Future<Product> createProduct({required String name}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.isar.createProduct(
      product: Product(
        name: name,
        color: COLOR,
        businessId: businessId,
        branchId: branchId,
        action: AppActions.created,
        id: randomString(),
        lastTouched: DateTime.now(),
      ),
      skipRegularVariant: true,
    );
  }

  void setProductName({String? name}) {
    productName = name;
    notifyListeners();
  }

  void removeVariant({required String id}) {
    // Find the index of the variant with the specified id
    int index = scannedVariants.indexWhere((variant) => variant.id == id);

    if (index != -1) {
      // If the variant is found, remove it from the list
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

  void updateVariantQuantity(String id, double newQuantity) {
    try {
      // Find the variant with the specified id
      Variant variant =
          scannedVariants.firstWhere((variant) => variant.id == id);

      // If the variant is found, update its quantity
      variant.qty = newQuantity;
      notifyListeners();
    } catch (e) {
      // Handle the exception if the variant is not found
      print('Variant with ID $id not found.');
    }
  }
}
