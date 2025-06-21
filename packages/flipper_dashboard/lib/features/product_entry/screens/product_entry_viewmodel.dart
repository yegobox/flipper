// import 'dart:async';
// import 'dart:io';

// import 'package:flipper_models/db_model_export.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class ProductEntryViewModel extends ChangeNotifier {
//   // Controllers
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController retailPriceController = TextEditingController();
//   final TextEditingController supplyPriceController = TextEditingController();
//   final TextEditingController countryOfOriginController = TextEditingController();
//   final TextEditingController scannedInputController = TextEditingController();
//   final FocusNode scannedInputFocusNode = FocusNode();

//   // State
//   Color pickerColor = Colors.amber;
//   bool isColorPicked = false;
//   Timer? _inputTimer;
//   Product? productRef;
//   List<String> pkgUnits = ["BJ: Bucket Bucket"]; // Example, should be from data

//   Future<void> initialize(String? productId, WidgetRef ref) async {
//     if (productId != null) {
//       // Load existing product
//       productRef = await getProduct(productId: productId);
//       ref.read(unsavedProductProvider.notifier).emitProduct(value: productRef!);
//       productNameController.text = productRef!.name;
//       setProductName(name: productRef!.name);

//       List<Variant> variants = await ProxyService.strategy.variants(
//           productId: productId,
//           branchId: ProxyService.box.getBranchId()!);

//       if (variants.isNotEmpty) {
//         pickerColor = getColorOrDefault(variants.first.color!);
//         supplyPriceController.text = variants.first.supplyPrice.toString();
//         retailPriceController.text = variants.first.retailPrice.toString();
//       }
//     } else {
//       // Create new product
//       productRef = await createProduct(name: TEMP_PRODUCT, createItemCode: false);
//       ref.read(unsavedProductProvider.notifier).emitProduct(value: productRef!);
//     }
//   }

//   // Helper methods
//   Color getColorOrDefault(String? hexColor) {
//     if (hexColor == null || hexColor.isEmpty) return Colors.amber;
//     try {
//       return HexColor(hexColor);
//     } catch (e) {
//       return Colors.amber;
//     }
//   }

//   void setProductName({required String name}) {
//     // Implementation
//   }

//   void setRetailPrice({required String price}) {
//     // Implementation
//   }

//   void setSupplyPrice({required String price}) {
//     // Implementation
//   }

//   // ... other methods from original class

//   @override
//   void dispose() {
//     _inputTimer?.cancel();
//     productNameController.dispose();
//     retailPriceController.dispose();
//     scannedInputController.dispose();
//     supplyPriceController.dispose();
//     scannedInputFocusNode.dispose();
//     super.dispose();
//   }
// }
