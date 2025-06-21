// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:stacked/stacked.dart';

// import 'product_entry_viewmodel.dart';
// import 'widgets/top_buttons.dart';
// import 'widgets/product_name_field.dart';
// import 'widgets/price_fields.dart';
// import 'widgets/scan_field.dart';

// class ProductEntryScreen extends StatefulHookConsumerWidget {
//   const ProductEntryScreen({super.key, this.productId});
//   final String? productId;

//   @override
//   ProductEntryScreenState createState() => ProductEntryScreenState();
// }

// class ProductEntryScreenState extends ConsumerState<ProductEntryScreen>
//     with TransactionMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _fieldComposite = GlobalKey<FormState>();
//   String selectedProductType = "2";
//   String selectedPackageUnitValue = "BJ: Bucket Bucket";

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<ProductEntryViewModel>.reactive(
//       viewModelBuilder: () => ProductEntryViewModel(),
//       onViewModelReady: (model) => model.initialize(widget.productId, ref),
//       builder: (context, model, child) {
//         return Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 18, right: 18),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TopButtons(
//                         formKey: _formKey,
//                         fieldComposite: _fieldComposite,
//                         productId: widget.productId,
//                         selectedProductType: selectedProductType,
//                         ref: ref,
//                       ),
//                       const ToggleButtonWidget(),
//                       ProductNameField(controller: model.productNameController),
//                       RetailPriceField(controller: model.retailPriceController),
//                       SupplyPriceField(
//                         controller: model.supplyPriceController,
//                         isComposite: ref.watch(isCompositeProvider),
//                       ),
//                       if (!ref.watch(isCompositeProvider))
//                         ScanField(
//                           controller: model.scannedInputController,
//                           focusNode: model.scannedInputFocusNode,
//                           productRef: model.productRef,
//                           retailPriceController: model.retailPriceController,
//                           supplyPriceController: model.supplyPriceController,
//                           countryController: model.countryOfOriginController,
//                           productId: widget.productId,
//                           model: model,
//                         ),
//                       DropdownButtonWithLabel(
//                         label: "Packaging Unit",
//                         selectedValue: selectedPackageUnitValue,
//                         options: model.pkgUnits,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedPackageUnitValue = newValue!;
//                           });
//                         },
//                       ),
//                       ProductTypeDropdown(
//                         selectedValue: selectedProductType,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             selectedProductType = newValue!;
//                           });
//                         },
//                       ),
//                       CountryOfOriginSelector(
//                         onCountrySelected: (Country country) {
//                           model.countryOfOriginController.text = country.code;
//                         },
//                       ),
//                       // ... other widgets
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Consumer(
//               builder: (context, ref, child) {
//                 final loadingState = ref.watch(loadingProvider);
//                 return loadingState.isLoading
//                     ? const LoadingOverlay()
//                     : const SizedBox.shrink();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class LoadingOverlay extends StatelessWidget {
//   const LoadingOverlay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black.withValues(alpha: .5),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Center(
//           child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             strokeWidth: 3,
//           ),
//         ),
//       ),
//     );
//   }
// }
