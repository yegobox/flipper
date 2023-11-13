import 'dart:async';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

import 'mixins/_product.dart';

class ScannViewModel extends BaseViewModel with ProductMixin {
  List<Variant> scannedVariants = [];
  late Product product;
  double defaultPrice = 0.0;

  void initialize() {
    scannedVariants = [];
    setProductName(name: null);
    notifyListeners();
  }

  void onAddVariant({
    required String variantName,
    required bool isTaxExempted,
  }) {
    int branchId = ProxyService.box.getBranchId()!;

    // Check if the variant with the same name already exists
    for (var variant in scannedVariants) {
      if (variant.name == variantName) {
        // If found, update it
        variant.retailPrice = defaultPrice;
        variant.qty = (variant.qty ?? 0) + 1; // Increment the quantity safely
        notifyListeners();
        return;
      }
    }

    // If no matching variant was found, add a new one
    scannedVariants.add(
      Variant(
        name: variantName,
        retailPrice: defaultPrice,
        id: randomString(),
        sku: variantName,
        productId: product.id,
        unit: 'item',
        productName: product.name,
        branchId: branchId,
        supplyPrice: defaultPrice,
        isTaxExempted: isTaxExempted,
        action: AppActions.create,
        lastTouched: DateTime.now(),
        qty: 1,
      ),
    );

    notifyListeners();
  }

  Future<void> createProduct({required String name}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    product = await ProxyService.isar.createProduct(
      product: Product(
        name: name,
        color: COLOR,
        businessId: businessId,
        branchId: branchId,
        action: AppActions.create,
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

  setDefaultPrice({required String price}) {
    defaultPrice = double.parse(price);
    notifyListeners();
  }
}
