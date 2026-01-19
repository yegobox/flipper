import 'dart:async';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_scanner/scanner_view.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_dashboard/FieldCompositeActivated.dart';
import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/TableVariants.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_dashboard/create/browsePhotos.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/features/product/widgets/invoice_number_modal.dart';
import 'package:flipper_dashboard/features/product/widgets/add_category_modal.dart';
import 'package:flipper_dashboard/dashboard_scanner_actions.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/basic_info_section.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/pricing_section.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/action_buttons.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/inventory_section.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/scan_section.dart';

class ProductEntryScreen extends StatefulHookConsumerWidget {
  const ProductEntryScreen({super.key, this.productId});

  final String? productId;

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState();
}

class ProductEntryScreenState extends ConsumerState<ProductEntryScreen>
    with TransactionMixinOld {
  Color pickerColor =
      Colors.blue; // Add this to your State class if not already present
  bool isColorPicked = false;

  Map<String, TextEditingController> _rates = {};
  Map<String, TextEditingController> _dates = {};

  // Default to the first packaging unit option (Ampoule)
  String selectedPackageUnitValue = RRADEFAULTS.packagingUnit.first;
  String? selectedCategoryId;
  String? selectedCategoryName;

  TextEditingController productNameController = TextEditingController();
  TextEditingController retailPriceController = TextEditingController();
  TextEditingController supplyPriceController = TextEditingController();
  TextEditingController countryOfOriginController = TextEditingController();
  TextEditingController scannedInputController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  FocusNode _scannedInputFocusNode = FocusNode();
  Timer? _inputTimer;
  final _formKey = GlobalKey<FormState>();
  final _fieldComposite = GlobalKey<FormState>();

  // Helper function to get a valid color or a default color
  Color getColorOrDefault(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.amber;
    }
    try {
      return HexColor(hexColor);
    } catch (e) {
      return Colors.amber;
    }
  }

  // Helper function to check if a string is a valid hexadecimal color code

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.dispose();
    retailPriceController.dispose();
    scannedInputController.dispose();
    supplyPriceController.dispose();
    _scannedInputFocusNode.dispose();
    super.dispose();
  }

  void _showNoProductNameToast() {
    toast('No product name!');
  }

  void _showNoProductSavedToast() {
    toast('No Product saved!');
  }

  void _addVariantsToProvider(List<Variant> variants) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null && mounted) {
      ref.read(outerVariantsProvider(branchId).notifier).addVariants(variants);
    }
  }

  Future<void> _saveProductAndVariants(
    ScannViewModel model,
    BuildContext context,
    Product productRef, {
    required String selectedProductType,
  }) async {
    if (!mounted) return; // Moved to the top
    try {
      ref.read(loadingProvider.notifier).startLoading();

      if (model.kProductName == null) {
        _showNoProductNameToast();
        ref.read(loadingProvider.notifier).stopLoading();
        return;
      }

      if (_formKey.currentState!.validate() &&
          !ref.watch(isCompositeProvider)) {
        if (widget.productId != null) {
          if (!mounted) return;
          await model.bulkUpdateVariants(
            true,
            color: pickerColor.toHex(),
            categoryId: selectedCategoryId,
            productName: productNameController.text,
            selectedProductType: selectedProductType,
            newRetailPrice: double.tryParse(retailPriceController.text) ?? 0,
            rates: _rates,
            dates: _dates,
            onCompleteCallback: (List<Variant> variants) async {
              _addVariantsToProvider(variants);
              if (!mounted) return;
              final invoiceNumber = await showInvoiceNumberModal(context);
              if (invoiceNumber == null) return;

              if (!mounted) return;
              final pendingTransaction = await ProxyService.strategy
                  .manageTransaction(
                    transactionType: TransactionType.adjustment,
                    isExpense: true,
                    branchId: ProxyService.box.getBranchId()!,
                  );
              Business? business = await ProxyService.strategy.getBusiness(
                businessId: ProxyService.box.getBusinessId()!,
              );
              if (!mounted) return;

              for (Variant variant in variants) {
                // Handle the transaction for stock adjustment
                await ProxyService.strategy.assignTransaction(
                  variant: variant,
                  doneWithTransaction: true,
                  invoiceNumber: invoiceNumber,
                  pendingTransaction: pendingTransaction!,
                  business: business!,
                  randomNumber: randomNumber(),
                  // 06 is incoming adjustment.
                  sarTyCd: "06",
                );
              }

              if (pendingTransaction != null) {
                if (!mounted) return;

                await completeTransaction(
                  pendingTransaction: pendingTransaction,
                );
              }
            },
          );
        } else {
          if (!mounted) return;
          await model.addVariant(
            model: model,
            productName: model.kProductName!,
            countryofOrigin: countryOfOriginController.text.isEmpty
                ? "RW"
                : countryOfOriginController.text,
            rates: _rates,
            color: pickerColor.toHex(),
            dates: _dates,
            retailPrice: double.tryParse(retailPriceController.text) ?? 0,
            supplyPrice: double.tryParse(supplyPriceController.text) ?? 0,
            variations: model.scannedVariants,
            product: productRef,
            selectedProductType: selectedProductType,
            packagingUnit: selectedPackageUnitValue.split(":")[0],
            categoryId: selectedCategoryId,
            onCompleteCallback: (List<Variant> variants) async {
              _addVariantsToProvider(variants);
              if (!mounted) return;
              final invoiceNumber = await showInvoiceNumberModal(context);
              if (invoiceNumber == null) return;

              if (!mounted) return;
              final pendingTransaction = await ProxyService.strategy
                  .manageTransaction(
                    transactionType: TransactionType.adjustment,
                    isExpense: true,
                    branchId: ProxyService.box.getBranchId()!,
                  );
              Business? business = await ProxyService.strategy.getBusiness(
                businessId: ProxyService.box.getBusinessId()!,
              );
              if (!mounted) return;

              for (Variant variant in variants) {
                // Handle the transaction for stock adjustment
                await ProxyService.strategy.assignTransaction(
                  variant: variant,
                  doneWithTransaction: true,
                  invoiceNumber: invoiceNumber,
                  pendingTransaction: pendingTransaction!,
                  business: business!,
                  randomNumber: randomNumber(),
                  // 06 is incoming adjustment.
                  sarTyCd: "06",
                );
              }

              if (pendingTransaction != null) {
                if (!mounted) return;

                await completeTransaction(
                  pendingTransaction: pendingTransaction,
                );
              }
            },
          );
        }

        model.currentColor = pickerColor.toHex();

        await model.saveProduct(
          mproduct: productRef,
          color: model.currentColor,
          inUpdateProcess: widget.productId != null,
          productName: model.kProductName!,
        );

        if (!mounted) return;

        // Refresh the product list and asset data
        final combinedNotifier = ref.read(refreshProvider);
        combinedNotifier.performActions(productName: "", scanMode: true);

        // Refresh asset provider to show the newly uploaded image immediately
        if (productRef.id.isNotEmpty) {
          // Invalidate the asset provider cache to force a refresh
          // ref.invalidate(assetProvider(productRef.id));

          // Also refresh the product provider to ensure all data is up-to-date
          // ref.invalidate(productProvider(productRef.id));
        }

        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          toast("Product saved successfully!");
          Navigator.pop(context);
        }
      } else if (_fieldComposite.currentState?.validate() ?? false) {
        await _handleCompositeProductSave(model);
      } else {
        // Validation failed or no action taken
        ref.read(loadingProvider.notifier).stopLoading();
      }
    } catch (e, s) {
      GlobalErrorHandler.logError(
        s,
        type: "PRODUCT-CREATION",
        context: {
          'resultCode': e,
          'businessId': ProxyService.box.getBusinessId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
        extra: {
          'resultCode': s,
          'businessId': ProxyService.box.getBusinessId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      ref.read(loadingProvider.notifier).stopLoading();
      if (mounted) {
        toast(
          "We did not close normally, check if your product is saved",
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pop(context); // Always close the modal, even on error
      }
      rethrow;
    }
  }

  Future<void> _handleCompositeProductSave(ScannViewModel model) async {
    if (!mounted) return;
    try {
      ref.read(loadingProvider.notifier).startLoading();

      // Check if unsavedProductProvider has a value
      final product = ref.read(unsavedProductProvider);
      if (product == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          toast("Product not initialized. Please try again.");
          talker.error("Error: unsavedProductProvider is null");
        }
        return;
      }

      // Validate required ProxyService values
      final branchId = ProxyService.box.getBranchId();
      final businessId = ProxyService.box.getBusinessId();

      if (branchId == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          toast(
            "Branch ID not found. Please ensure you're logged in properly.",
          );
          talker.error("Error: getBranchId() returned null");
        }
        return;
      }

      if (businessId == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          toast(
            "Business ID not found. Please ensure you're logged in properly.",
          );
          talker.error("Error: getBusinessId() returned null");
        }
        return;
      }

      List<VariantState> partOfComposite = ref.read(
        selectedVariantsLocalProvider,
      );

      // Validate that there are components to save
      if (partOfComposite.isEmpty) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          toast("Please add at least one component to the composite product.");
          talker.warning("No composite components selected");
        }
        return;
      }

      talker.info(
        "Saving composite product with ${partOfComposite.length} components",
      );

      // Save each composite component
      for (var component in partOfComposite) {
        await ProxyService.strategy.saveComposite(
          composite: Composite(
            businessId: businessId,
            productId: product.id,
            qty: component.quantity,
            actualPrice: double.tryParse(retailPriceController.text) ?? 0.0,
            branchId: branchId,
            variantId: component.variant.id,
          ),
        );
        talker.debug("Saved composite component: ${component.variant.name}");
      }

      if (!mounted) return;

      // Update the product
      await ProxyService.strategy.updateProduct(
        productId: product.id,
        branchId: branchId,
        businessId: businessId,
        name: productNameController.text,
        isComposite: true,
      );

      talker.info(
        "Product updated as composite: ${productNameController.text}",
      );

      if (!mounted) return;

      // Create variant using the standard addVariant method for consistency
      // This ensures all EBM fields and required configurations are properly set
      try {
        // Get the current EBM VAT status directly to ensure consistency
        final ebm = await ProxyService.strategy.ebm(branchId: branchId);
        final isVatEnabled = ebm?.vatEnabled ?? false;

        await model.addVariant(
          model: model,
          productName: productNameController.text,
          countryofOrigin: countryOfOriginController.text.isEmpty
              ? "RW"
              : countryOfOriginController.text,
          rates: _rates,
          color: product.color,
          dates: _dates,
          retailPrice: double.tryParse(retailPriceController.text) ?? 0,
          supplyPrice: double.tryParse(supplyPriceController.text) ?? 0,
          variations: [
            Variant(
              name: productNameController.text,
              sku: skuController.text,
              bcd: barCodeController.text,
              qty: 1.0,
              retailPrice: double.tryParse(retailPriceController.text) ?? 0,
              supplyPrice: double.tryParse(supplyPriceController.text) ?? 0,
              prc: double.tryParse(retailPriceController.text) ?? 0,
              color: product.color,
              branchId: branchId,
              productId: product.id,
              productName: productNameController.text,
              unit: 'Per Item',
              pkgUnitCd: "NT",
              dcRt: 0,
              regrNm: productNameController.text,
              lastTouched: DateTime.now().toUtc(),
              itemTyCd: "3", // Mark as service (no stock reporting to RRA)
              taxTyCd: isVatEnabled ? "B" : "D", // VAT or non-VAT
              taxName: isVatEnabled ? "B" : "D", // Should match taxTyCd
            ),
          ],
          product: product,
          selectedProductType:
              "3", // Service type for composite (no stock reporting)
          packagingUnit: selectedPackageUnitValue.split(":")[0],
          categoryId: selectedCategoryId,
          onCompleteCallback: (List<Variant> variants) async {
            if (!mounted) return;

            // Composite variants are services (itemTyCd=3) and don't need stock transactions
            // Just add variants to provider for immediate UI update
            _addVariantsToProvider(variants);

            talker.info(
              "Composite variant created (service type - no stock): ${productNameController.text}",
            );
          },
        );
      } catch (e) {
        // Silently handle "No items to save" error for composite products
        if (e.toString().contains("No items to save")) {
          talker.info(
            "Composite product created successfully (no stock reporting needed)",
          );
        } else {
          rethrow;
        }
      }

      if (!mounted) return;

      // Refresh the list
      final combinedNotifier = ref.read(refreshProvider);
      combinedNotifier.performActions(productName: "", scanMode: true);

      // Refresh asset provider to show the newly uploaded image immediately
      if (product.id.isNotEmpty) {
        // Invalidate the asset provider cache to force a refresh
        // ref.invalidate(assetProvider(product.id));

        // Also refresh the product provider to ensure all data is up-to-date
        // ref.invalidate(productProvider(product.id));
      }

      ref.read(loadingProvider.notifier).stopLoading();

      if (!mounted) return;

      // Show success message and close dialog
      toast("Composite product saved successfully!");
      Navigator.pop(context);

      // Clear the state after closing the dialog to prevent visual glitch
      ref.read(selectedVariantsLocalProvider.notifier).clearState();
    } catch (e, stackTrace) {
      ref.read(loadingProvider.notifier).stopLoading();
      if (mounted) {
        toast("Failed to save composite product: ${e.toString()}");
        talker.error(
          "Error saving composite product: $e\nStack trace: $stackTrace",
        );
      }
      // Don't close the dialog automatically on error
    }
  }

  Future<void> _onSaveButtonPressed(
    ScannViewModel model,
    BuildContext context,
    Product product, {
    required String selectedProductType,
  }) async {
    if (!mounted) return;
    try {
      if (model.scannedVariants.isEmpty && widget.productId == null) {
        _showNoProductSavedToast();
        return;
      }
      //
      await _saveProductAndVariants(
        model,
        context,
        product,
        selectedProductType: selectedProductType,
      );
    } catch (e) {
      if (mounted) {
        toast("Error saving product: ${e.toString()}");
        talker.error("Error in _onSaveButtonPressed: $e");
      }
    }
  }

  // Add this new method to create the product type dropdown

  // Add a state variable to hold the selected product type
  String selectedProductType = "2";

  void _handleBarcodeScan(
    String barCodeInput,
    ScannViewModel model,
    Product? productRef,
  ) {
    if (barCodeInput.trim().isNotEmpty) {
      if (productRef == null) {
        toast(
          "Invalid product reference. Please select or create a product first.",
        );
        talker.error(
          "Attempted to scan barcode with null productRef. Skipping scan.",
        );
        return;
      }
      try {
        model.onScanItem(
          countryCode: countryOfOriginController.text,
          editmode: widget.productId != null,
          barCode: barCodeInput,
          retailPrice: double.tryParse(retailPriceController.text) ?? 0,
          supplyPrice: double.tryParse(supplyPriceController.text) ?? 0,
          isTaxExempted: false,
          product: productRef,
        );
        talker.warning("onAddVariant called successfully");
        scannedInputController.clear();
        _scannedInputFocusNode.requestFocus();
      } catch (e, s) {
        talker.error("Error in onAddVariant: $e", s);
        toast("We faced unexpected error, close this window and open again");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productRef = ref.watch(unsavedProductProvider);
    final isLoading = ref.watch(loadingProvider).isLoading;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: ViewModelBuilder<ScannViewModel>.reactive(
            viewModelBuilder: () => ScannViewModel(),
            onViewModelReady: (model) async {
              if (widget.productId != null) {
                Product product = await model.getProduct(
                  productId: widget.productId!,
                );
                if (!mounted) return;
                ref
                    .read(unsavedProductProvider.notifier)
                    .emitProduct(value: product);

                productNameController.text = product.name;
                model.setProductName(name: product.name);

                // Fetch variants WITHOUT tax filtering to ensure we find all variants
                // for the product when in edit mode.
                final paged = await ProxyService.getStrategy(Strategy.capella)
                    .variants(
                      taxTyCds: [],
                      productId: widget.productId!,
                      branchId: ProxyService.box.getBranchId()!,
                      fetchRemote: true,
                    );

                List<Variant> variants = List<Variant>.from(paged.variants);
                if (!mounted) return;

                if (variants.isNotEmpty) {
                  if (variants.first.itemTyCd != null) {
                    selectedProductType = variants.first.itemTyCd!;
                  }

                  supplyPriceController.text = variants.first.supplyPrice
                      .toString();
                  retailPriceController.text = variants.first.retailPrice
                      .toString();

                  // Explicitly update model prices to ensure UI sync
                  model.setRetailPrice(price: retailPriceController.text);
                  model.setSupplyPrice(price: supplyPriceController.text);

                  if (variants.first.categoryId != null) {
                    String? catName = variants.first.categoryName;
                    if (catName == null) {
                      Category? fetchedCategory =
                          await ProxyService.getStrategy(
                            Strategy.capella,
                          ).category(id: variants.first.categoryId!);
                      catName = fetchedCategory?.name;
                    }
                    setState(() {
                      selectedCategoryId = variants.first.categoryId;
                      selectedCategoryName = catName;
                    });
                  }

                  model.setScannedVariants(variants);

                  if (variants.first.color != null) {
                    pickerColor = getColorOrDefault(variants.first.color!);
                  }
                }
              } else {
                Product? product = await model.createProduct(
                  name: TEMP_PRODUCT,
                  createItemCode: false,
                );
                if (!mounted) return;
                if (product != null) {
                  ref
                      .read(unsavedProductProvider.notifier)
                      .emitProduct(value: product);
                }
              }

              model.initialize();
              // Ensure we are not in loading state AFTER data is loaded
              ref.read(loadingProvider.notifier).stopLoading();
            },
            builder: (context, model, child) {
              for (var variant in model.scannedVariants) {
                if (variant.itemTyCd != selectedProductType) {
                  variant.itemTyCd = selectedProductType;
                  if (selectedProductType == "3") {
                    variant.qty = 0;
                  }
                }
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Browsephotos(
                              imageUrl: productRef?.imageUrl,
                              currentColor: pickerColor,
                              onColorSelected: (color) {
                                setState(() {
                                  pickerColor = color;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Toggle for Composite/Simple
                          ToggleButtonWidget(),
                          const SizedBox(height: 16),

                          BasicInfoSection(
                            productNameController: productNameController,
                            model: model,
                            isEditMode: widget.productId != null,
                          ),
                          const SizedBox(height: 16),
                          PricingSection(
                            retailPriceController: retailPriceController,
                            supplyPriceController: supplyPriceController,
                            model: model,
                            isComposite: ref.watch(isCompositeProvider),
                          ),

                          if (!ref.watch(isCompositeProvider)) ...[
                            const SizedBox(height: 16),
                            InventorySection(
                              selectedPackageUnitValue:
                                  selectedPackageUnitValue,
                              pkgUnits: model.pkgUnits,
                              onPackageUnitChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedPackageUnitValue = newValue;
                                  });
                                }
                              },
                              selectedCategoryId: selectedCategoryId,
                              selectedCategoryName: selectedCategoryName,
                              onCategoryChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedCategoryId = newValue;
                                  });
                                }
                              },
                              onAddCategory: () {
                                showAddCategoryModal(context);
                              },
                              selectedProductType: selectedProductType,
                              onProductTypeChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedProductType = newValue;
                                  });
                                }
                              },
                              countryOfOriginController:
                                  countryOfOriginController,
                              isEditMode: widget.productId != null,
                            ),
                            const SizedBox(height: 16),
                            ScanSection(
                              controller: scannedInputController,
                              focusNode: _scannedInputFocusNode,
                              onBarcodeScanned: (value) =>
                                  _handleBarcodeScan(value, model, productRef),
                              onRequestCamera: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScannView(
                                      intent: BARCODE,
                                      scannerActions: DashboardScannerActions(
                                        context,
                                        ref,
                                      ),
                                    ),
                                  ),
                                );
                                String barcode =
                                    ProxyService.productService.barCode;
                                if (barcode.trim().isNotEmpty) {
                                  scannedInputController.text = barcode.trim();
                                  _handleBarcodeScan(
                                    barcode.trim(),
                                    model,
                                    productRef,
                                  );
                                }
                              },
                            ),
                          ],

                          const SizedBox(height: 16),
                          if (!ref.watch(isCompositeProvider))
                            TableVariants(
                              isEbmEnabled:
                                  ref.watch(ebmVatEnabledProvider).value ??
                                  false,
                              isEditMode: widget.productId != null,
                              onDateChanged: (String variantId, DateTime date) {
                                _dates[variantId] = TextEditingController(
                                  text: date.toIso8601String(),
                                );
                              },
                              unversalProducts: ref
                                  .watch(universalProductsNames)
                                  .value,
                              units:
                                  ref.watch(unitsProvider).value?.value ?? [],
                              scannedInputFocusNode: _scannedInputFocusNode,
                              unitOfMeasures: [],
                              model: model,
                              onUnitOfMeasureChanged: (unitCode, variantId) {
                                final units =
                                    ref.read(unitsProvider).value?.value ?? [];

                                // Guard against empty units list to prevent StateError
                                if (units.isEmpty) {
                                  // Skip updating the variant if no units are available
                                  return;
                                }

                                // Safely find the unit with fallback options
                                IUnit? unit;

                                try {
                                  // Find by code first
                                  unit = units.firstWhere(
                                    (u) => u.code == unitCode,
                                  );
                                } catch (e) {
                                  try {
                                    // If not found by code, try by name
                                    unit = units.firstWhere(
                                      (u) => u.name == unitCode,
                                    );
                                  } catch (e) {
                                    try {
                                      // If not found by name, try to match with first variant's unit
                                      if (model.scannedVariants.isNotEmpty) {
                                        unit = units.firstWhere(
                                          (u) =>
                                              u.name ==
                                              model.scannedVariants.first.unit,
                                        );
                                      } else {
                                        // If no scanned variants, just return the first unit if available
                                        unit = units.isNotEmpty
                                            ? units.first
                                            : null;
                                      }
                                    } catch (e) {
                                      // Ultimate fallback to first unit if available
                                      unit = units.isNotEmpty
                                          ? units.first
                                          : null;
                                    }
                                  }
                                }

                                // If no unit was found, return early
                                if (unit == null) {
                                  return;
                                }

                                final variantIndex = model.scannedVariants
                                    .indexWhere((v) => v.id == variantId);
                                if (variantIndex != -1) {
                                  final variant =
                                      model.scannedVariants[variantIndex];
                                  variant.qtyUnitCd = unitCode;
                                  variant.unit = unit.name ?? unitCode;
                                }
                              },
                            ),

                          if (ref.watch(isCompositeProvider)) ...[
                            Fieldcompositeactivated(
                              formKey: _fieldComposite,
                              skuController: skuController,
                              barCodeController: barCodeController,
                            ),
                            SearchProduct(),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("Components"),
                            ),
                            CompositeVariation(
                              supplyPriceController: supplyPriceController,
                            ),
                          ],

                          ActionButtons(
                            isSaving: isLoading,
                            onSave: () async {
                              if (!mounted) return;
                              try {
                                if (_formKey.currentState!.validate() &&
                                    !ref.read(isCompositeProvider)) {
                                  if (productRef == null) {
                                    toast("Invalid product reference");
                                    return;
                                  }
                                  if (!mounted) return;
                                  await _onSaveButtonPressed(
                                    model,
                                    context,
                                    productRef,
                                    selectedProductType: selectedProductType,
                                  );
                                } else if (_fieldComposite.currentState
                                        ?.validate() ??
                                    false) {
                                  await _handleCompositeProductSave(model);
                                }
                              } catch (e) {
                                toast("An unexpected error occurred");
                                talker.error("Error in save button: $e");
                              }
                            },
                            onClose: () {
                              Navigator.maybePop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const SafeArea(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveLayout({Key? key, required this.mobile, required this.tablet})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768; // or 600, depending on your preference

    return isMobile ? mobile : tablet;
  }
}
