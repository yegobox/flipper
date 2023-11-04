import 'dart:async';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ScannViewModel extends BaseViewModel {
  List<Variant> scannedVariants = [];
  late Product product;
  TextEditingController productNameController = TextEditingController();
  TextEditingController defaultPriceController = TextEditingController();
  TextEditingController scannedInputController = TextEditingController();
  FocusNode scannedInputFocusNode = FocusNode();
  Timer? _inputTimer;

  void addVariant({
    required String variantName,
    required double defaultPrice,
    required bool isTaxExempted,
  }) {
    int branchId = ProxyService.box.getBranchId()!;
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
      ),
    );
    notifyListeners();
  }

  void handleScannedInput(String scannedInput) {
    _inputTimer?.cancel();
    _inputTimer = Timer(const Duration(microseconds: 30), () {
      double defaultPrice = double.parse(defaultPriceController.text);
      if (scannedInput.isNotEmpty) {
        addVariant(
          variantName: scannedInput,
          defaultPrice: defaultPrice,
          isTaxExempted: false,
        );
        scannedInputController.clear();
        scannedInputFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.dispose();
    defaultPriceController.dispose();
    scannedInputController.dispose();
    scannedInputFocusNode.dispose();
    super.dispose();
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
    ));
  }

  String productName = TEMP_PRODUCT;
  void setProductName({required String name}) {
    productName = name;
    notifyListeners();
  }
}
