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
import 'package:flipper_dashboard/responsive_layout.dart' as responsive;
import 'package:flutter/services.dart';

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

  /// Keeps [ScannViewModel.kProductName] and in-memory variant titles aligned with
  /// the product name field before persistence (fixes stale `temp` / placeholder).
  String _syncProductNameFromForm(ScannViewModel model, Product productRef) {
    final name = productNameController.text.trim();
    model.setProductName(name: name);
    final productTitle = productRef.name.trim();
    for (final v in model.scannedVariants) {
      final n = v.name.trim();
      if (n.isEmpty || n == TEMP_PRODUCT || n == productTitle) {
        v.name = name;
        v.productName = name;
        v.regrNm = name;
      }
    }
    model.notifyListeners();
    return name;
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

      if (_formKey.currentState!.validate() &&
          !ref.watch(isCompositeProvider)) {
        final syncedProductName = _syncProductNameFromForm(model, productRef);
        if (syncedProductName.length < 3) {
          _showNoProductNameToast();
          ref.read(loadingProvider.notifier).stopLoading();
          return;
        }
        final isPhone =
            responsive.ResponsiveLayout.isPhone(context) ||
            responsive.ResponsiveLayout.isTinyLimit(context);
        if (widget.productId != null) {
          if (!mounted) return;
          await model.bulkUpdateVariants(
            true,
            color: pickerColor.toHex(),
            categoryId: selectedCategoryId,
            productName: syncedProductName,
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
            productName: syncedProductName,
            preserveVariationFields: isPhone,
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
          productName: syncedProductName,
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
          final isPhone =
              responsive.ResponsiveLayout.isPhone(context) ||
              responsive.ResponsiveLayout.isTinyLimit(context);

          // Phone-only: show a confirmation screen for new products.
          if (isPhone && widget.productId == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => _ProductSavedScreen(
                  productName: productNameController.text,
                  retailPrice:
                      double.tryParse(retailPriceController.text) ?? 0.0,
                  supplyPrice:
                      double.tryParse(supplyPriceController.text) ?? 0.0,
                  variantsCount: model.scannedVariants.length,
                  onDone: () => Navigator.of(ctx).maybePop(),
                  onAddAnother: () => Navigator.of(ctx).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(
                        body: SafeArea(child: ProductEntryScreen()),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            Navigator.pop(context);
          }
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
              final isPhone =
                  responsive.ResponsiveLayout.isPhone(context) ||
                  responsive.ResponsiveLayout.isTinyLimit(context);
              for (var variant in model.scannedVariants) {
                if (variant.itemTyCd != selectedProductType) {
                  variant.itemTyCd = selectedProductType;
                  if (selectedProductType == "3") {
                    variant.qty = 0;
                  }
                }
              }
              if (isPhone && !ref.watch(isCompositeProvider)) {
                return Form(
                  key: _formKey,
                  child: _MobileProductEntry(
                    productId: widget.productId,
                    productRef: productRef,
                    model: model,
                    formKey: _formKey,
                    onSave: () async {
                      if (!mounted) return;
                      if (_formKey.currentState!.validate()) {
                        if (productRef == null) {
                          toast("Invalid product reference");
                          return;
                        }
                        await _onSaveButtonPressed(
                          model,
                          context,
                          productRef,
                          selectedProductType: selectedProductType,
                        );
                      }
                    },
                    onClose: () => Navigator.maybePop(context),
                    // Controllers
                    productNameController: productNameController,
                    retailPriceController: retailPriceController,
                    supplyPriceController: supplyPriceController,
                    scannedInputController: scannedInputController,
                    scannedInputFocusNode: _scannedInputFocusNode,
                    // Advanced/inventory plumbing
                    selectedPackageUnitValue: selectedPackageUnitValue,
                    pkgUnits: model.pkgUnits,
                    onPackageUnitChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => selectedPackageUnitValue = newValue);
                      }
                    },
                    selectedCategoryId: selectedCategoryId,
                    selectedCategoryName: selectedCategoryName,
                    onCategoryChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => selectedCategoryId = newValue);
                      }
                    },
                    onAddCategory: () => showAddCategoryModal(context),
                    selectedProductType: selectedProductType,
                    onProductTypeChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => selectedProductType = newValue);
                      }
                    },
                    countryOfOriginController: countryOfOriginController,
                    isSaving: isLoading,
                    onScan: () async {
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
                      final barcode = ProxyService.productService.barCode;
                      if (barcode.trim().isNotEmpty) {
                        await _showVariantSheet(
                          context: context,
                          model: model,
                          productRef: productRef,
                          retailPriceController: retailPriceController,
                          supplyPriceController: supplyPriceController,
                          countryOfOriginController: countryOfOriginController,
                          selectedProductType: selectedProductType,
                          isEditMode: widget.productId != null,
                          initialBarcode: barcode.trim(),
                        );
                      }
                    },
                    onAddVariant: () {
                      _showVariantSheet(
                        context: context,
                        model: model,
                        productRef: productRef,
                        retailPriceController: retailPriceController,
                        supplyPriceController: supplyPriceController,
                        countryOfOriginController: countryOfOriginController,
                        selectedProductType: selectedProductType,
                        isEditMode: widget.productId != null,
                      );
                    },
                    onEditVariant: (variant) {
                      _showVariantSheet(
                        context: context,
                        model: model,
                        productRef: productRef,
                        retailPriceController: retailPriceController,
                        supplyPriceController: supplyPriceController,
                        countryOfOriginController: countryOfOriginController,
                        selectedProductType: selectedProductType,
                        isEditMode: widget.productId != null,
                        existingVariant: variant,
                      );
                    },
                    onDeleteVariant: (variant) => model.removeVariant(id: variant.id),
                  ),
                );
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
                            if (isPhone)
                              ExpansionTile(
                                initiallyExpanded: false,
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: const EdgeInsets.only(top: 8),
                                title: Text(
                                  'Advanced',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                children: [
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
                                ],
                              )
                            else
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

class _ProductSavedScreen extends StatelessWidget {
  const _ProductSavedScreen({
    required this.productName,
    required this.retailPrice,
    required this.supplyPrice,
    required this.variantsCount,
    required this.onDone,
    required this.onAddAnother,
  });

  final String productName;
  final double retailPrice;
  final double supplyPrice;
  final int variantsCount;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product saved')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 42,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$productName saved!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Your product and variants have been added to inventory.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Product', value: productName),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Retail price',
                      value: retailPrice.toStringAsFixed(2),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Supply price',
                      value: supplyPrice.toStringAsFixed(2),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Variants',
                      value: '$variantsCount variants',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onAddAnother,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add another product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

Future<void> _showVariantSheet({
  required BuildContext context,
  required ScannViewModel model,
  required Product? productRef,
  required TextEditingController retailPriceController,
  required TextEditingController supplyPriceController,
  required TextEditingController countryOfOriginController,
  required String selectedProductType,
  required bool isEditMode,
  Variant? existingVariant,
  String? initialBarcode,
}) async {
  final nameController = TextEditingController(text: existingVariant?.name ?? '');
  final barcodeController =
      TextEditingController(text: initialBarcode ?? existingVariant?.bcd ?? existingVariant?.sku ?? '');
  final stockController = TextEditingController(
    text: (existingVariant?.stock?.currentStock ?? existingVariant?.qty ?? 0)
        .toString(),
  );
  final discountController = TextEditingController(
    text: (existingVariant?.dcRt ?? 0).toInt().toString(),
  );
  final priceOverrideController = TextEditingController(
    text: existingVariant?.retailPrice != null &&
            existingVariant!.retailPrice !=
                (double.tryParse(retailPriceController.text) ?? 0)
        ? existingVariant.retailPrice!.toString()
        : '',
  );

  String taxTyCd = existingVariant?.taxTyCd ?? 'B';

  final formKey = GlobalKey<FormState>();
  var savingVariant = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.96,
            minChildSize: 0.70,
            maxChildSize: 0.98,
            expand: false,
            builder: (ctx, scrollController) {
              final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
              return Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  existingVariant == null
                                      ? 'Add variant'
                                      : 'Edit variant',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(ctx).maybePop(),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Variant name',
                                    hintText: 'e.g. Sandals, Size 10',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: priceOverrideController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Retail price override',
                                    helperText:
                                        'Base retail price: ${(double.tryParse(retailPriceController.text) ?? 0).toStringAsFixed(2)}',
                                    hintText:
                                        'Leave blank to use base retail price',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return null;
                                    }
                                    if (double.tryParse(v) == null) {
                                      return 'Invalid price';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: barcodeController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: 'Barcode',
                                    hintText: 'SKU / barcode',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Barcode is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: stockController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Stock quantity',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Tax',
                                    style: Theme.of(ctx)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ChoiceChip(
                                      label: const Text('Standard B'),
                                      selected: taxTyCd == 'B',
                                      onSelected: (_) => setModalState(
                                        () => taxTyCd = 'B',
                                      ),
                                    ),
                                    ChoiceChip(
                                      label: const Text('Standard A'),
                                      selected: taxTyCd == 'A',
                                      onSelected: (_) => setModalState(
                                        () => taxTyCd = 'A',
                                      ),
                                    ),
                                    ChoiceChip(
                                      label: const Text('None'),
                                      selected: taxTyCd == 'D',
                                      onSelected: (_) => setModalState(
                                        () => taxTyCd = 'D',
                                      ),
                                    ),
                                    ChoiceChip(
                                      label: const Text('Exempt'),
                                      selected: taxTyCd == 'C',
                                      onSelected: (_) => setModalState(
                                        () => taxTyCd = 'C',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: discountController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Discount %',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: savingVariant
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (productRef == null) {
                                    toast('Invalid product reference');
                                    return;
                                  }

                                  setModalState(() => savingVariant = true);
                                  try {
                                    final barcode = barcodeController.text.trim();
                                    final baseRetail =
                                        double.tryParse(
                                              retailPriceController.text,
                                            ) ??
                                            0;
                                    final baseSupply =
                                        double.tryParse(
                                              supplyPriceController.text,
                                            ) ??
                                            0;
                                    final override = double.tryParse(
                                      priceOverrideController.text.trim(),
                                    );
                                    final qty =
                                        double.tryParse(
                                          stockController.text.trim(),
                                        ) ??
                                        0;
                                    final discount =
                                        int.tryParse(
                                          discountController.text.trim(),
                                        ) ??
                                        0;

                                    if (existingVariant == null) {
                                      final variantName =
                                          nameController.text.trim();
                                      await model.onScanItem(
                                        countryCode:
                                            countryOfOriginController.text,
                                        editmode: isEditMode,
                                        barCode: barcode,
                                        retailPrice: override ?? baseRetail,
                                        supplyPrice: baseSupply,
                                        isTaxExempted: taxTyCd == 'C',
                                        product: productRef,
                                        variantDisplayName: variantName,
                                      );

                                      final idx =
                                          model.scannedVariants.indexWhere(
                                        (v) => v.bcd == barcode,
                                      );
                                      final v = idx != -1
                                          ? model.scannedVariants[idx]
                                          : (model.scannedVariants.isNotEmpty
                                              ? model.scannedVariants.last
                                              : null);
                                      if (v != null) {
                                        v.name = variantName;
                                        v.taxTyCd = taxTyCd;
                                        v.dcRt = discount.toDouble();
                                        model.getDiscountController(v.id).text =
                                            discount.toString();
                                        await model.updateVariantQuantity(
                                          v.id,
                                          qty,
                                          persistToBackend: false,
                                        );
                                        model.notifyListeners();
                                      }
                                    } else {
                                      existingVariant.name =
                                          nameController.text.trim();
                                      existingVariant.bcd = barcode;
                                      existingVariant.sku = barcode;
                                      existingVariant.taxTyCd = taxTyCd;
                                      existingVariant.retailPrice =
                                          override ?? baseRetail;
                                      existingVariant.supplyPrice = baseSupply;
                                      existingVariant.dcRt =
                                          discount.toDouble();
                                      model
                                          .getDiscountController(
                                            existingVariant.id,
                                          )
                                          .text = discount.toString();
                                      await model.updateVariantQuantity(
                                        existingVariant.id,
                                        qty,
                                        persistToBackend: false,
                                      );
                                      model.notifyListeners();
                                    }

                                    if (ctx.mounted) {
                                      await Navigator.of(ctx).maybePop();
                                    }
                                  } catch (e, st) {
                                    talker.error(
                                      'Save variant failed: $e',
                                      e,
                                      st,
                                    );
                                    if (ctx.mounted) {
                                      toast(
                                        'Could not save variant. Please try again.',
                                      );
                                    }
                                  } finally {
                                    // Do not call setModalState after a successful pop: the sheet
                                    // is deactivating and rebuild triggers InheritedElement asserts.
                                    if (ctx.mounted) {
                                      setModalState(
                                        () => savingVariant = false,
                                      );
                                    }
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0078D4)
                                .withValues(alpha: 0.12),
                            foregroundColor: const Color(0xFF0078D4),
                            disabledBackgroundColor: const Color(0xFF0078D4)
                                .withValues(alpha: 0.12),
                            disabledForegroundColor: const Color(0xFF0078D4),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: savingVariant
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF0078D4),
                                  ),
                                )
                              : Text(
                                  existingVariant == null
                                      ? 'Save variant'
                                      : 'Save',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );

  // The sheet route can still be animating out or finishing unmount when this
  // future completes; disposing controllers synchronously races EditableText and
  // triggers "used after being disposed". Dispose after this frame.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    nameController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    priceOverrideController.dispose();
    discountController.dispose();
  });
}

class _MobileProductEntry extends StatelessWidget {
  const _MobileProductEntry({
    required this.productId,
    required this.productRef,
    required this.model,
    required this.formKey,
    required this.onSave,
    required this.onClose,
    required this.productNameController,
    required this.retailPriceController,
    required this.supplyPriceController,
    required this.scannedInputController,
    required this.scannedInputFocusNode,
    required this.selectedPackageUnitValue,
    required this.pkgUnits,
    required this.onPackageUnitChanged,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.selectedProductType,
    required this.onProductTypeChanged,
    required this.countryOfOriginController,
    required this.isSaving,
    required this.onScan,
    required this.onAddVariant,
    required this.onEditVariant,
    required this.onDeleteVariant,
  });

  final String? productId;
  final Product? productRef;
  final ScannViewModel model;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;
  final VoidCallback onClose;

  final TextEditingController productNameController;
  final TextEditingController retailPriceController;
  final TextEditingController supplyPriceController;
  final TextEditingController scannedInputController;
  final FocusNode scannedInputFocusNode;

  final String selectedPackageUnitValue;
  final List<String> pkgUnits;
  final void Function(String?) onPackageUnitChanged;
  final String? selectedCategoryId;
  final String? selectedCategoryName;
  final void Function(String?) onCategoryChanged;
  final VoidCallback onAddCategory;
  final String selectedProductType;
  final void Function(String?) onProductTypeChanged;
  final TextEditingController countryOfOriginController;

  final bool isSaving;
  final VoidCallback onScan;
  final VoidCallback onAddVariant;
  final void Function(Variant) onEditVariant;
  final void Function(Variant) onDeleteVariant;

  @override
  Widget build(BuildContext context) {
    const accentBlue = Color(0xFF0078D4);
    final sym = ProxyService.box.defaultCurrency();

    return ColoredBox(
      color: const Color(0xFFF2F2F7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                children: [
                  Text(
                    'Product info',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  BasicInfoSection(
                    productNameController: productNameController,
                    model: model,
                    isEditMode: productId != null,
                  ),
                  const SizedBox(height: 12),
                  PricingSection(
                    retailPriceController: retailPriceController,
                    supplyPriceController: supplyPriceController,
                    model: model,
                    isComposite: false,
                    forceHorizontalPrices: true,
                  ),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    initiallyExpanded: false,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(top: 8),
                    title: Text(
                      'Advanced',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      InventorySection(
                        selectedPackageUnitValue: selectedPackageUnitValue,
                        pkgUnits: pkgUnits,
                        onPackageUnitChanged: onPackageUnitChanged,
                        selectedCategoryId: selectedCategoryId,
                        selectedCategoryName: selectedCategoryName,
                        onCategoryChanged: onCategoryChanged,
                        onAddCategory: onAddCategory,
                        selectedProductType: selectedProductType,
                        onProductTypeChanged: onProductTypeChanged,
                        countryOfOriginController: countryOfOriginController,
                        isEditMode: productId != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Variants (${model.scannedVariants.length})',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: onScan,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentBlue,
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Scan'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: onAddVariant,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentBlue,
                          side: const BorderSide(color: Color(0xFFD1D1D6)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('+ Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap a variant to expand · Edit or delete inside · swipe to delete',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  ...model.scannedVariants.reversed.map((v) {
                    final displayName =
                        v.name.isNotEmpty ? v.name : (v.bcd ?? 'Variant');
                    final priceStr =
                        '${(v.retailPrice ?? 0).toStringAsFixed(2)}';
                    return Dismissible(
                      key: ValueKey('variant-${v.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: Colors.red.shade600,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async => true,
                      onDismissed: (_) => onDeleteVariant(v),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ExpansionTile(
                          key: PageStorageKey<String>('vexp-${v.id}'),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            12,
                            0,
                            12,
                            12,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade100,
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          title: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '$sym $priceStr',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: accentBlue,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          children: [
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => onEditVariant(v),
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  label: const Text('Edit variant'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: accentBlue,
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () => onDeleteVariant(v),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red.shade700,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isSaving ? null : onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: accentBlue.withValues(alpha: 0.12),
                  foregroundColor: accentBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save product',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isSaving ? null : onClose,
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentBlue,
                  side: const BorderSide(color: Color(0xFFD1D1D6)),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
