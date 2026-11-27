import 'package:flipper_localize/flipper_localize.dart';
import 'dart:async';
import 'dart:io';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_scanner/scanner_view.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_dashboard/FieldCompositeActivated.dart';
import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/TableVariants.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/features/product/widgets/add_category_modal.dart';
import 'package:flipper_dashboard/dashboard_scanner_actions.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/basic_info_section.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/pricing_section.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/mobile_entry_style.dart';
import 'package:flipper_dashboard/features/product_entry/product_entry_navigation.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_inventory_section.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_scan_section.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_color_picker.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_composite_toggle.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_margin_card.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_page.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_section_nav.dart';
import 'package:flipper_dashboard/responsive_layout.dart' as responsive;
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/utils/image_source_sheet.dart';
import 'package:flipper_dashboard/features/product_entry/combo_save_values.dart';
import 'package:flipper_dashboard/features/product_entry/combo_component_diff.dart';
import 'package:flipper_dashboard/features/product_entry/combo_edit.dart';
import 'package:flipper_dashboard/features/product_entry/product_save_gate.dart';
import 'package:flipper_dashboard/features/product_entry/sku_entry.dart';
import 'package:flipper_models/sku/sku_duplicate_check.dart';
import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:path_provider/path_provider.dart';

class ProductEntryScreen extends StatefulHookConsumerWidget {
  const ProductEntryScreen({super.key, this.productId});

  final String? productId;

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState();
}

class ProductEntryScreenState extends ConsumerState<ProductEntryScreen> {
  Color pickerColor =
      Colors.blue; // Add this to your State class if not already present
  bool isColorPicked = false;

  Map<String, String> _rates = {};
  Map<String, String> _dates = {};

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

  /// Tick counter notified whenever a form-affecting controller changes.
  /// Passed as [formListenable] to [ProductEditorPage] so only the chrome
  /// (top-bar title, nav badges, footer) rebuilds on every keystroke rather
  /// than the entire ViewModelBuilder tree.
  final ValueNotifier<int> _formTick = ValueNotifier(0);
  void _onFormControllerChanged() => _formTick.value++;
  final _formKey = GlobalKey<FormState>();
  final _sectionBasicsKey = GlobalKey();
  final _sectionPricingKey = GlobalKey();
  final _sectionInventoryKey = GlobalKey();
  final _sectionVariantsKey = GlobalKey();
  final _sectionComponentsKey = GlobalKey();
  bool _saveInProgress = false;

  /// Set after a phone save attempt without a category, so the picker says why.
  bool _showCategoryError = false;

  /// The business's currency, shown before every price.
  String get _currency => ProxyService.box.defaultCurrency();

  bool get _isEditMode => widget.productId != null;

  /// The prices the editor opened with. An edit writes a price to the
  /// variants only when the user typed a different one (see [editedPrice]).
  String _loadedRetailText = '';
  String _loadedSupplyText = '';

  /// An edited combo's saved component rows, by component variant id, so its
  /// save updates them instead of adding new ones.
  List<SavedComboComponent> _loadedComboComponents = const [];

  /// What a save needs, on every layout (see [productCanSave]).
  bool _requiredFieldsFilled({required bool isComposite}) {
    return productCanSave(
      isEditMode: _isEditMode,
      isComposite: isComposite,
      name: productNameController.text,
      retailText: retailPriceController.text,
      hasCategory: selectedCategoryId != null,
      hasComponents: ref.read(selectedVariantsLocalProvider).isNotEmpty,
    );
  }

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

  @override
  void initState() {
    super.initState();
    productNameController.addListener(_onFormControllerChanged);
    retailPriceController.addListener(_onFormControllerChanged);
    supplyPriceController.addListener(_onFormControllerChanged);
  }

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.removeListener(_onFormControllerChanged);
    retailPriceController.removeListener(_onFormControllerChanged);
    supplyPriceController.removeListener(_onFormControllerChanged);
    productNameController.dispose();
    retailPriceController.dispose();
    scannedInputController.dispose();
    supplyPriceController.dispose();
    countryOfOriginController.dispose();
    barCodeController.dispose();
    skuController.dispose();
    _scannedInputFocusNode.dispose();
    _formTick.dispose();
    super.dispose();
  }

  void _showNoProductNameToast(BuildContext context) {
    showWarningNotification(context, context.flipperL10n.dpaNoProductName);
  }

  void _showNoProductSavedToast(BuildContext context) {
    showWarningNotification(context, context.flipperL10n.dpaNoProductSaved);
  }

  String _productSaveErrorMessage(Object error) {
    final raw = error.toString().replaceFirst('Exception: ', '');
    final lower = raw.toLowerCase();
    if (lower.contains('timeout') || lower.contains('connection')) {
      return context.flipperL10n.dpaRraTimeout;
    }
    if (lower.contains('saveitems') ||
        lower.contains('savestockitems') ||
        lower.contains('savestockmaster') ||
        lower.contains('rra ')) {
      return context.flipperL10n.dpaRraReportingFailed(raw);
    }
    return context.flipperL10n.dpaSaveProductFailed(raw);
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

  String? _categoryNameFor(String categoryId) {
    final categories = ref.read(categoryProvider).value ?? const <Category>[];
    for (final category in categories) {
      if (category.id == categoryId) return category.name;
    }
    return null;
  }

  /// The selected category's own SKU prefix (`BEV`), or null when it has
  /// none and the prefix comes from the category name.
  String? _selectedSkuPrefix() {
    final categoryId = selectedCategoryId;
    if (categoryId == null) return null;
    final categories = ref.read(categoryProvider).value ?? const <Category>[];
    for (final category in categories) {
      if (category.id == categoryId) return category.skuPrefix;
    }
    return null;
  }

  /// Keeps [selectedCategoryId] and [selectedCategoryName] in lockstep, and
  /// honours a null (cleared) selection. Previously only the id was stored and
  /// nulls were dropped, so the editor showed no name for a freshly picked
  /// category — and kept showing the old name after a change in edit mode.
  void _onCategorySelected(String? categoryId) {
    if (!mounted) return;
    final resolvedName = categoryId == null
        ? null
        : _categoryNameFor(categoryId);
    final unchanged = categoryId != null && categoryId == selectedCategoryId;
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategoryName =
          resolvedName ?? (unchanged ? selectedCategoryName : null);
      if (categoryId != null) _showCategoryError = false;
    });
  }

  /// Opens the create-category dialog and selects whatever it returns, so the
  /// user never has to hunt for the category they just created.
  Future<void> _createAndSelectCategory({String? initialName}) async {
    final created = await showAddCategoryModal(
      context,
      initialName: initialName,
    );
    if (!mounted || created == null) return;
    setState(() {
      selectedCategoryId = created.id;
      selectedCategoryName = created.name;
      _showCategoryError = false;
    });
  }

  void _addVariantsToProvider(List<Variant> variants) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null && mounted) {
      ref.read(outerVariantsProvider(branchId).notifier).addVariants(variants);
      for (final catalog in posStockFilteredCatalogs(branchId)) {
        if (ref.exists(catalog)) {
          ref.read(catalog.notifier).addVariants(variants);
        }
      }
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

      if (_formKey.currentState!.validate() && !ref.read(isCompositeProvider)) {
        final syncedProductName = _syncProductNameFromForm(model, productRef);
        if (syncedProductName.length < 3) {
          _showNoProductNameToast(context);
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
            businessId: productRef.businessId,
            productName: syncedProductName,
            selectedProductType: selectedProductType,
            // Only a price the user changed reaches every variant; otherwise
            // each keeps its own (a rename must not flatten their prices).
            newRetailPrice: editedPrice(
              text: retailPriceController.text,
              loadedText: _loadedRetailText,
            ),
            newSupplyPrice: editedPrice(
              text: supplyPriceController.text,
              loadedText: _loadedSupplyText,
            ),
            rates: _rates,
            dates: _dates,
            onCompleteCallback: (List<Variant> variants) async {
              _addVariantsToProvider(variants);
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
          // Phone-only: a new product gets a confirmation screen, which is the
          // confirmation; everywhere else a toast says it saved.
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
                  currency: _currency,
                  onDone: () => Navigator.of(ctx).maybePop(),
                  onAddAnother: () => replaceWithProductEntryScreen(ctx),
                ),
              ),
            );
          } else {
            showSuccessNotification(
              context,
              context.flipperL10n.dpaProductSaved,
            );
            Navigator.pop(context);
          }
        }
      } else {
        // Validation failed. Composite saves never reach this method — they are
        // routed straight to _handleCompositeProductSave() by _onDesktopSave,
        // which owns the _saveInProgress guard for that path. Re-dispatching
        // composite here would hit that guard (already held by
        // _onSaveButtonPressed) and silently no-op, so we only release loading.
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
        showErrorNotification(
          context,
          _productSaveErrorMessage(e),
          duration: const Duration(seconds: 8),
        );
      }
    }
  }

  Future<void> _handleCompositeProductSave(ScannViewModel model) async {
    if (!mounted || _saveInProgress) return;
    _saveInProgress = true;
    // Read the validated form once: it stays editable while the save awaits.
    final v = readComboSaveValues(
      name: productNameController,
      retailPrice: retailPriceController,
      supplyPrice: supplyPriceController,
      sku: skuController,
      barcode: barCodeController,
      countryOfOrigin: countryOfOriginController,
    );
    try {
      ref.read(loadingProvider.notifier).startLoading();

      // Check if unsavedProductProvider has a value
      final product = ref.read(unsavedProductProvider);
      if (product == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          showErrorNotification(
            context,
            context.flipperL10n.dpaProductNotInitialized,
          );
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
          showErrorNotification(
            context,
            context.flipperL10n.dpaBranchIdNotFound,
          );
          talker.error("Error: getBranchId() returned null");
        }
        return;
      }

      if (businessId == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          showErrorNotification(
            context,
            context.flipperL10n.dpaBusinessIdNotFound,
          );
          talker.error("Error: getBusinessId() returned null");
        }
        return;
      }

      // A typed SKU must be free in the business (local check, offline-safe).
      // Blank is fine: one is assigned on save.
      final typedSku = v.sku;
      // Editing: the combo's own variant, so its own SKU is no clash.
      final editedComboVariant = _isEditMode
          ? model.scannedVariants.firstOrNull
          : null;
      final skuError = await skuSaveError(
        context,
        typed: typedSku,
        businessId: businessId,
        storedSku: editedComboVariant?.sku,
        candidate: SkuHolder(
          id: editedComboVariant?.id ?? '',
          branchId: branchId,
          productId: product.id,
          bcd: v.barcode.trim(),
        ),
      );
      if (skuError != null) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) showErrorNotification(context, skuError);
        return;
      }

      List<VariantState> partOfComposite = ref.read(
        selectedVariantsLocalProvider,
      );

      // Validate that there are components to save
      if (partOfComposite.isEmpty) {
        ref.read(loadingProvider.notifier).stopLoading();
        if (mounted) {
          showWarningNotification(context, context.flipperL10n.dpaAddComponent);
          talker.warning("No composite components selected");
        }
        return;
      }

      if (editedComboVariant != null) {
        await _updateComboProduct(
          model,
          product: product,
          comboVariant: editedComboVariant,
          values: v,
          lines: partOfComposite,
          branchId: branchId,
          businessId: businessId,
        );
        if (!mounted) return;
        _finishComboSave(product);
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
            actualPrice: v.retailPrice,
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
        name: v.name,
        isComposite: true,
      );

      talker.info("Product updated as composite: ${v.name}");

      if (!mounted) return;

      // Create variant using the standard addVariant method for consistency
      // This ensures all EBM fields and required configurations are properly set
      try {
        // Get the current EBM VAT status directly to ensure consistency
        final ebm = await ProxyService.strategy.ebm(branchId: branchId);
        final isVatEnabled = ebm?.vatEnabled ?? false;
        // Sold as made (a service, no stock: its components' stock moves at
        // payment) or made ahead in Production Output (a finished product,
        // itemTyCd 2, sold from its own stock, which starts at 0).
        final madeInProduction = ref.read(madeInProductionProvider);
        final itemType = madeInProduction ? "2" : "3";

        await model.addVariant(
          model: model,
          productName: v.name,
          countryofOrigin: v.countryOfOrigin,
          rates: _rates,
          color: product.color,
          dates: _dates,
          retailPrice: v.retailPrice,
          supplyPrice: v.supplyPrice,
          variations: [
            Variant(
              name: v.name,
              sku: typedSku.isEmpty ? null : typedSku,
              bcd: v.barcode,
              qty: madeInProduction ? 0.0 : 1.0,
              retailPrice: v.retailPrice,
              supplyPrice: v.supplyPrice,
              prc: v.retailPrice,
              color: product.color,
              branchId: branchId,
              productId: product.id,
              productName: v.name,
              unit: 'Per Item',
              pkgUnitCd: "NT",
              dcRt: 0,
              regrNm: v.name,
              lastTouched: DateTime.now().toUtc(),
              itemTyCd: itemType,
              taxTyCd: isVatEnabled ? "B" : "D", // VAT or non-VAT
              taxName: isVatEnabled ? "B" : "D", // Should match taxTyCd
            ),
          ],
          product: product,
          selectedProductType: itemType,
          packagingUnit: selectedPackageUnitValue.split(":")[0],
          categoryId: selectedCategoryId,
          onCompleteCallback: (List<Variant> variants) async {
            if (!mounted) return;

            // A combo starts with no stock (a service never has any; a
            // made-in-production combo gets it from Production Output).
            // Just add variants to provider for immediate UI update
            _addVariantsToProvider(variants);

            talker.info(
              "Composite variant created (service type - no stock): ${v.name}",
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

      _finishComboSave(product);
    } catch (e, stackTrace) {
      ref.read(loadingProvider.notifier).stopLoading();
      if (mounted) {
        showErrorNotification(
          context,
          context.flipperL10n.dpaCompositeSaveFailed(e.toString()),
        );
        talker.error(
          "Error saving composite product: $e\nStack trace: $stackTrace",
        );
      }
      // Don't close the dialog automatically on error
    } finally {
      _saveInProgress = false;
    }
  }

  /// After a combo is saved (made or edited): refresh the lists, say so, and
  /// close the editor.
  void _finishComboSave(Product product) {
    ref.read(refreshProvider).performActions(productName: "", scanMode: true);
    ref.read(loadingProvider.notifier).stopLoading();
    if (!mounted) return;
    showSuccessNotification(context, context.flipperL10n.dpaCompositeSaved);
    Navigator.pop(context);
    // Cleared after closing, so the closing page does not flash empty.
    ref.read(selectedVariantsLocalProvider.notifier).clearState();
  }

  /// Saves an edited combo in place (see [updateComboInPlace]). Prices reach
  /// its variant only when changed, as for any product edit.
  Future<void> _updateComboProduct(
    ScannViewModel model, {
    required Product product,
    required Variant comboVariant,
    required ComboSaveValues values,
    required List<VariantState> lines,
    required String branchId,
    required String businessId,
  }) async {
    final retailPrice = editedPrice(
      text: values.retailText,
      loadedText: _loadedRetailText,
    );
    await updateComboInPlace(
      strategy: ProxyService.strategy,
      productId: product.id,
      branchId: branchId,
      businessId: businessId,
      comboVariant: comboVariant,
      values: values,
      madeInProduction: ref.read(madeInProductionProvider),
      saved: _loadedComboComponents,
      lines: lines,
      retailPrice: retailPrice,
      updateVariant: (itemType) => model.bulkUpdateVariants(
        true,
        color: pickerColor.toHex(),
        categoryId: selectedCategoryId,
        businessId: businessId,
        productName: values.name,
        selectedProductType: itemType,
        newRetailPrice: retailPrice,
        newSupplyPrice: editedPrice(
          text: values.supplyText,
          loadedText: _loadedSupplyText,
        ),
        rates: _rates,
        dates: _dates,
        onCompleteCallback: _addVariantsToProvider,
      ),
      // A failed save leaves the rows it already wrote as the baseline, so a
      // retry updates them instead of writing a new line a second time.
      onComponentsWritten: (rows) => _loadedComboComponents = rows,
    );
  }

  Future<void> _onSaveButtonPressed(
    ScannViewModel model,
    BuildContext context,
    Product product, {
    required String selectedProductType,
  }) async {
    if (!mounted || _saveInProgress) return;
    _saveInProgress = true;
    try {
      if (model.scannedVariants.isEmpty && widget.productId == null) {
        _showNoProductSavedToast(context);
        return;
      }
      await _saveProductAndVariants(
        model,
        context,
        product,
        selectedProductType: selectedProductType,
      );
    } catch (e) {
      if (mounted) {
        showErrorNotification(
          context,
          _productSaveErrorMessage(e),
          duration: const Duration(seconds: 8),
        );
        talker.error("Error in _onSaveButtonPressed: $e");
      }
    } finally {
      _saveInProgress = false;
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
        showErrorNotification(
          context,
          context.flipperL10n.dpaInvalidProductRefSelect,
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
          itemTyCd: selectedProductType,
        );
        talker.warning("onAddVariant called successfully");
        scannedInputController.clear();
        _scannedInputFocusNode.requestFocus();
      } catch (e, s) {
        talker.error("Error in onAddVariant: $e", s);
        showErrorNotification(context, context.flipperL10n.dpaUnexpectedReopen);
      }
    }
  }

  Future<void> _onDesktopSave(ScannViewModel model, Product? productRef) async {
    if (!mounted) return;
    try {
      // One form holds every field, a combo's bar code included, so an
      // invalid field blocks either save.
      final formValid = _formKey.currentState!.validate();
      if (formValid && !ref.read(isCompositeProvider)) {
        if (productRef == null) {
          showErrorNotification(
            context,
            context.flipperL10n.dpaInvalidProductRef,
          );
          return;
        }
        if (!mounted) return;
        await _onSaveButtonPressed(
          model,
          context,
          productRef,
          selectedProductType: selectedProductType,
        );
      } else if (formValid) {
        await _handleCompositeProductSave(model);
      }
    } catch (e) {
      showErrorNotification(context, context.flipperL10n.dpaUnexpectedError);
      talker.error("Error in save button: $e");
    }
  }

  void _onUnitOfMeasureChanged(
    String? unitCode,
    String variantId,
    ScannViewModel model,
  ) {
    if (unitCode == null) return;
    final units = ref.read(unitsProvider).value?.value ?? [];
    if (units.isEmpty) return;

    IUnit? unit;
    try {
      unit = units.firstWhere((u) => u.code == unitCode);
    } catch (e) {
      try {
        unit = units.firstWhere((u) => u.name == unitCode);
      } catch (e) {
        try {
          if (model.scannedVariants.isNotEmpty) {
            unit = units.firstWhere(
              (u) => u.name == model.scannedVariants.first.unit,
            );
          } else {
            unit = units.isNotEmpty ? units.first : null;
          }
        } catch (e) {
          unit = units.isNotEmpty ? units.first : null;
        }
      }
    }
    if (unit == null) return;

    final variantIndex = model.scannedVariants.indexWhere(
      (v) => v.id == variantId,
    );
    if (variantIndex != -1) {
      final variant = model.scannedVariants[variantIndex];
      variant.qtyUnitCd = unitCode;
      variant.unit = unit.name ?? unitCode;
    }
  }

  Widget _buildDesktopProductEditor({
    required BuildContext context,
    required ScannViewModel model,
    required Product? productRef,
    required bool isLoading,
  }) {
    final isComposite = ref.watch(isCompositeProvider);
    final components = ref.watch(selectedVariantsLocalProvider);
    final nameFilled = productNameController.text.trim().isNotEmpty;
    final retailFilled =
        retailPriceController.text.trim().isNotEmpty &&
        double.tryParse(retailPriceController.text) != null;
    final inventoryFilled = selectedCategoryId != null;
    final variantsFilled = model.scannedVariants.isNotEmpty;
    final componentsFilled = components.isNotEmpty;

    final sections = isComposite
        ? [
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'basics',
                title: context.flipperL10n.dpaBasics,
                subtitle: context.flipperL10n.dpaNameColor,
                icon: Icons.sell_outlined,
                isFilled: nameFilled,
              ),
              sectionKey: _sectionBasicsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PeField(
                    label: context.flipperL10n.dpaProductColor,
                    child: ProductEditorColorPicker(
                      color: pickerColor,
                      onColorChanged: (color) {
                        setState(() {
                          pickerColor = color;
                          isColorPicked = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  PeField(
                    label: context.flipperL10n.fuelProductName,
                    required: true,
                    child: PeTextInput(
                      controller: productNameController,
                      placeholder: context.flipperL10n.dpaProductNameHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.flipperL10n.fuelProductNameRequired;
                        } else if (value.length < 3) {
                          return context.flipperL10n.dpaProductNameMinLength;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const ProductEditorCompositeToggle(),
                  const SizedBox(height: 12),
                  const ProductEditorMadeInProductionToggle(),
                ],
              ),
            ),
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'pricing',
                title: context.flipperL10n.dpaPricingCodes,
                subtitle: context.flipperL10n.dpaPriceSkuBarcode,
                icon: Icons.payments_outlined,
                isFilled: retailFilled,
              ),
              sectionKey: _sectionPricingKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PeField(
                          label: context.flipperL10n.dpaRetailPrice,
                          required: true,
                          hint: context.flipperL10n.dpaRetailPriceHint,
                          child: PeTextInput(
                            controller: retailPriceController,
                            prefix: _currency,
                            mono: true,
                            placeholder: '0',
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.setRetailPrice(price: value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                // An edit keeps each variant's own price.
                                if (_isEditMode) return null;
                                return context.flipperL10n.dpaPriceRequired;
                              }
                              if (double.tryParse(value) == null) {
                                return context.flipperL10n.invalidPrice;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PeField(
                          label: context.flipperL10n.dpaSupplyPrice,
                          hint: context.flipperL10n.dpaSupplyFromComponents,
                          child: PeTextInput(
                            controller: supplyPriceController,
                            prefix: _currency,
                            mono: true,
                            locked: true,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Fieldcompositeactivated(
                    skuController: skuController,
                    barCodeController: barCodeController,
                  ),
                  ProductEditorMarginCard(
                    retailController: retailPriceController,
                    supplyController: supplyPriceController,
                    isComposite: true,
                  ),
                ],
              ),
            ),
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'components',
                title: context.flipperL10n.dpaComponents,
                subtitle: context.flipperL10n.dpaBillOfMaterials,
                icon: Icons.layers_outlined,
                isFilled: componentsFilled,
              ),
              sectionKey: _sectionComponentsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchProduct(),
                  const SizedBox(height: 16),
                  CompositeVariation(
                    currency: _currency,
                    supplyPriceController: supplyPriceController,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ]
        : [
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'basics',
                title: context.flipperL10n.dpaBasics,
                subtitle: context.flipperL10n.dpaNameColor,
                icon: Icons.sell_outlined,
                isFilled: nameFilled,
              ),
              sectionKey: _sectionBasicsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PeField(
                    label: context.flipperL10n.dpaProductColor,
                    child: ProductEditorColorPicker(
                      color: pickerColor,
                      onColorChanged: (color) {
                        setState(() {
                          pickerColor = color;
                          isColorPicked = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  PeField(
                    label: context.flipperL10n.fuelProductName,
                    required: true,
                    child: PeTextInput(
                      controller: productNameController,
                      placeholder: context.flipperL10n.dpaProductNameHint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.flipperL10n.fuelProductNameRequired;
                        } else if (value.length < 3) {
                          return context.flipperL10n.dpaProductNameMinLength;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const ProductEditorCompositeToggle(),
                ],
              ),
            ),
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'pricing',
                title: context.flipperL10n.pricing,
                subtitle: context.flipperL10n.dpaRetailSupply,
                icon: Icons.payments_outlined,
                isFilled: retailFilled,
              ),
              sectionKey: _sectionPricingKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PeField(
                          label: context.flipperL10n.dpaRetailPrice,
                          required: true,
                          hint: context.flipperL10n.dpaRetailPriceHint,
                          child: PeTextInput(
                            controller: retailPriceController,
                            prefix: _currency,
                            mono: true,
                            placeholder: '0',
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.setRetailPrice(price: value),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                // An edit keeps each variant's own price.
                                if (_isEditMode) return null;
                                return context.flipperL10n.dpaPriceRequired;
                              }
                              if (double.tryParse(value) == null) {
                                return context.flipperL10n.invalidPrice;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PeField(
                          label: context.flipperL10n.dpaSupplyPrice,
                          hint: context.flipperL10n.dpaCostPerUnit,
                          child: PeTextInput(
                            controller: supplyPriceController,
                            prefix: _currency,
                            mono: true,
                            placeholder: '0',
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                model.setSupplyPrice(price: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ProductEditorMarginCard(
                    retailController: retailPriceController,
                    supplyController: supplyPriceController,
                  ),
                ],
              ),
            ),
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'inventory',
                title: context.flipperL10n.dpaInventoryCategorization,
                subtitle: context.flipperL10n.dpaCategoryItemType,
                icon: Icons.layers_outlined,
                isFilled: inventoryFilled,
              ),
              sectionKey: _sectionInventoryKey,
              child: ProductEditorInventorySection(
                selectedPackageUnitValue: selectedPackageUnitValue,
                pkgUnits: model.pkgUnits,
                onPackageUnitChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => selectedPackageUnitValue = newValue);
                  }
                },
                selectedCategoryId: selectedCategoryId,
                selectedCategoryName: selectedCategoryName,
                onCategoryChanged: _onCategorySelected,
                onAddCategory: _createAndSelectCategory,
                onCreateCategory: (initialName) =>
                    _createAndSelectCategory(initialName: initialName),
                selectedProductType: selectedProductType,
                onProductTypeChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => selectedProductType = newValue);
                    // Sync in-memory variants to the new type outside build();
                    // a service drops any stock typed in so far.
                    model.setProductType(newValue);
                  }
                },
                countryOfOriginController: countryOfOriginController,
                isEditMode: widget.productId != null,
              ),
            ),
            ProductEditorSectionContent(
              def: ProductEditorSectionDef(
                id: 'variants',
                title: context.flipperL10n.dpaVariantsStock,
                subtitle: context.flipperL10n.dpaStockScan,
                icon: Icons.qr_code_scanner,
                isFilled: variantsFilled,
              ),
              sectionKey: _sectionVariantsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductEditorScanSection(
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
                      final barcode = ProxyService.productService.barCode;
                      if (barcode.trim().isNotEmpty) {
                        scannedInputController.text = barcode.trim();
                        _handleBarcodeScan(barcode.trim(), model, productRef);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TableVariants(
                    productId: productRef?.id,
                    isEbmEnabled:
                        ref.watch(ebmVatEnabledProvider).value ?? false,
                    isEditMode: widget.productId != null,
                    useCardLayout: true,
                    onDateChanged: (String variantId, DateTime date) {
                      _dates[variantId] = date.toIso8601String();
                    },
                    unversalProducts: ref.watch(universalProductsNames).value,
                    units: ref.watch(unitsProvider).value?.value ?? [],
                    scannedInputFocusNode: _scannedInputFocusNode,
                    unitOfMeasures: [],
                    model: model,
                    onUnitOfMeasureChanged: (unitCode, variantId) =>
                        _onUnitOfMeasureChanged(unitCode, variantId, model),
                  ),
                ],
              ),
            ),
          ];

    return Form(
      key: _formKey,
      child: ProductEditorPage(
        isEditMode: widget.productId != null,
        isComposite: isComposite,
        productNameController: productNameController,
        sections: sections,
        onBack: () => Navigator.maybePop(context),
        onClose: () => Navigator.maybePop(context),
        backIcon:
            responsive.ResponsiveLayout.isPhone(context) ||
                responsive.ResponsiveLayout.isTinyLimit(context)
            ? Icons.close
            : Icons.arrow_back,
        onSave: () => _onDesktopSave(model, productRef),
        formListenable: _formTick,
        canSaveBuilder: () => _requiredFieldsFilled(isComposite: isComposite),
        sectionDefsBuilder: () => sections.map((s) => s.def).toList(),
        isSaving: isLoading,
      ),
    );
  }

  /// Loads the product being edited, or creates the placeholder product a
  /// new one is written into.
  Future<void> _loadEditor(ScannViewModel model) async {
    try {
      if (widget.productId != null) {
        Product product = await model.getProduct(productId: widget.productId!);
        if (!mounted) return;
        ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
        // Opening reset the combo switch; a combo is edited as a combo.
        showProductInItsOwnMode(ref, product);

        productNameController.text = product.name;
        model.setProductName(name: product.name);

        // Fetch variants WITHOUT tax filtering to ensure we find all variants
        // for the product when in edit mode.
        final paged = await ProxyService.getStrategy(Strategy.capella).variants(
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

          // A product saved without a price shows a blank field, never the
          // text "null" (which no save would accept).
          _loadedSupplyText = priceFieldText(variants.first.supplyPrice);
          _loadedRetailText = priceFieldText(variants.first.retailPrice);
          supplyPriceController.text = _loadedSupplyText;
          retailPriceController.text = _loadedRetailText;

          // Explicitly update model prices to ensure UI sync
          model.setRetailPrice(price: retailPriceController.text);
          model.setSupplyPrice(price: supplyPriceController.text);

          if (variants.first.categoryId != null) {
            String? catName = variants.first.categoryName;
            if (catName == null) {
              Category? fetchedCategory = await ProxyService.getStrategy(
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
          // A service shows no stock, even one with stock still on
          // record; that stays untouched until a Stock Recount.
          if (isServiceItemType(selectedProductType)) {
            model.setProductType(selectedProductType);
          }

          if (variants.first.color != null) {
            pickerColor = getColorOrDefault(variants.first.color!);
          }

          if (product.isComposite == true) {
            await _loadComboForEdit(product, variants.first);
            if (!mounted) return;
          }
        }
      } else {
        Product? product = await model.createProduct(
          name: TEMP_PRODUCT,
          createItemCode: false,
        );
        if (!mounted) return;
        if (product != null) {
          ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
        }
      }

      model.initialize();
      // Ensure we are not in loading state AFTER data is loaded
      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e, s) {
      talker.error('ProductEntryScreen load failed', e, s);
      if (!mounted) return;
      // Never leave the editor stuck on the loading spinner.
      ref.read(loadingProvider.notifier).stopLoading();
      showErrorNotification(
        context,
        e is ProductNotFoundException
            ? context.flipperL10n.dpaProductDeleted
            : context.flipperL10n.dpaProductLoadFailed,
      );
    }
  }

  /// Puts an edited combo's own fields and its component lines (with their
  /// quantities) into the editor, so it opens as it was saved and its save
  /// updates it rather than adding a second combo.
  Future<void> _loadComboForEdit(Product product, Variant comboVariant) async {
    skuController.text = comboVariant.sku ?? '';
    barCodeController.text = comboVariant.bcd ?? '';
    ref.read(madeInProductionProvider.notifier).state =
        comboVariant.itemTyCd == '2';
    final combo = await loadComboComponents(
      strategy: ProxyService.strategy,
      productId: product.id,
    );
    if (!mounted) return;
    _loadedComboComponents = combo.saved;
    ref
        .read(selectedVariantsLocalProvider.notifier)
        .loadComponents(combo.lines);
  }

  @override
  Widget build(BuildContext context) {
    final productRef = ref.watch(unsavedProductProvider);
    final isLoading = ref.watch(loadingProvider).isLoading;

    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      // Tracked so a till's stall report names this screen: a customer's till
      // froze for a while opening "Single product", with no log to say why.
      onViewModelReady: (model) => PerfOpTrail.instance.track(
        'product_entry_open',
        () => _loadEditor(model),
        critical: true,
      ),
      builder: (context, model, child) {
        final isPhone =
            responsive.ResponsiveLayout.isPhone(context) ||
            responsive.ResponsiveLayout.isTinyLimit(context);
        // itemTyCd sync is done in _onProductTypeChanged; avoid
        // mutating variants inside build() to prevent unnecessary jank.
        if (isPhone && !ref.watch(isCompositeProvider)) {
          final l10n = context.flipperL10n;
          return Scaffold(
            backgroundColor: MposTokens.bg,
            appBar: CustomAppBar(
              title: widget.productId == null
                  ? l10n.productEntryAddNewProduct
                  : l10n.productEntryEditProduct,
              icon: Icons.close,
              onPop: isLoading ? null : () => Navigator.maybePop(context),
              barBackgroundColor: MposTokens.head,
            ),
            body: Form(
              key: _formKey,
              child: _MobileProductEntry(
                productId: widget.productId,
                productRef: productRef,
                model: model,
                formKey: _formKey,
                currency: _currency,
                showCategoryError: _showCategoryError,
                onSave: () async {
                  if (!mounted) return;
                  // validate() marks the bad fields; the gate is the same
                  // one desktop's Save uses.
                  final formOk = _formKey.currentState!.validate();
                  // An edit keeps each variant's own category.
                  if (selectedCategoryId == null && !_isEditMode) {
                    setState(() => _showCategoryError = true);
                  }
                  if (formOk && _requiredFieldsFilled(isComposite: false)) {
                    if (productRef == null) {
                      showErrorNotification(
                        context,
                        context.flipperL10n.dpaInvalidProductRef,
                      );
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
                onCategoryChanged: _onCategorySelected,
                onAddCategory: _createAndSelectCategory,
                onCreateCategory: (initialName) =>
                    _createAndSelectCategory(initialName: initialName),
                selectedProductType: selectedProductType,
                onProductTypeChanged: (newValue) {
                  if (newValue != null) {
                    setState(() => selectedProductType = newValue);
                    model.setProductType(newValue);
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
                        scannerActions: DashboardScannerActions(context, ref),
                      ),
                    ),
                  );
                  final barcode = ProxyService.productService.barCode;
                  if (barcode.trim().isNotEmpty) {
                    await _showVariantSheet(
                      context: context,
                      ref: ref,
                      model: model,
                      productRef: productRef,
                      retailPriceController: retailPriceController,
                      supplyPriceController: supplyPriceController,
                      countryOfOriginController: countryOfOriginController,
                      selectedProductType: selectedProductType,
                      isEditMode: widget.productId != null,
                      categoryName: selectedCategoryName,
                      skuPrefix: _selectedSkuPrefix(),
                      initialBarcode: barcode.trim(),
                    );
                  }
                },
                onAddVariant: () {
                  _showVariantSheet(
                    context: context,
                    ref: ref,
                    model: model,
                    productRef: productRef,
                    retailPriceController: retailPriceController,
                    supplyPriceController: supplyPriceController,
                    countryOfOriginController: countryOfOriginController,
                    selectedProductType: selectedProductType,
                    isEditMode: widget.productId != null,
                    categoryName: selectedCategoryName,
                    skuPrefix: _selectedSkuPrefix(),
                  );
                },
                onEditVariant: (variant) {
                  _showVariantSheet(
                    context: context,
                    ref: ref,
                    model: model,
                    productRef: productRef,
                    retailPriceController: retailPriceController,
                    supplyPriceController: supplyPriceController,
                    countryOfOriginController: countryOfOriginController,
                    selectedProductType: selectedProductType,
                    isEditMode: widget.productId != null,
                    categoryName: selectedCategoryName,
                    skuPrefix: _selectedSkuPrefix(),
                    existingVariant: variant,
                  );
                },
                onDeleteVariant: (variant) =>
                    model.removeVariant(id: variant.id),
                pickerColor: pickerColor,
                onColorSelected: (color) {
                  setState(() {
                    pickerColor = color;
                  });
                },
              ),
            ),
          );
        }

        return _buildDesktopProductEditor(
          context: context,
          model: model,
          productRef: productRef,
          isLoading: isLoading,
        );
      },
    );
  }
}

class _ProductSavedScreen extends StatelessWidget {
  const _ProductSavedScreen({
    required this.productName,
    required this.retailPrice,
    required this.supplyPrice,
    required this.variantsCount,
    required this.currency,
    required this.onDone,
    required this.onAddAnother,
  });

  final String productName;
  final double retailPrice;
  final double supplyPrice;
  final int variantsCount;
  final String currency;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Scaffold(
      backgroundColor: MposTokens.bg,
      appBar: CustomAppBar(
        title: l10n.dpaProductSavedTitle,
        icon: Icons.close,
        onPop: onDone,
        barBackgroundColor: MposTokens.head,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: MposTokens.gainTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 44,
                  color: MposTokens.gain,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.dpaNamedProductSaved(productName),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.dpaAddedToInventory,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: PosTokens.ink3),
              ),
              const SizedBox(height: 22),
              MobileEntryCard(
                child: Column(
                  children: [
                    _SummaryRow(label: l10n.productLabel, value: productName),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: l10n.dpaRetailPrice,
                      value: '$currency ${retailPrice.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: l10n.dpaSupplyPrice,
                      value: '$currency ${supplyPrice.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: l10n.dpaVariants,
                      value: l10n.fuelVariantsCount(variantsCount),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              MobileEntryPrimaryButton(label: l10n.done, onPressed: onDone),
              const SizedBox(height: 12),
              MobileEntrySecondaryButton(
                label: l10n.dpaAddAnother,
                icon: Icons.add,
                onPressed: onAddAnother,
                expand: true,
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
            style: const TextStyle(fontSize: 13.5, color: PosTokens.ink3),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: PosTokens.ink1,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _showVariantSheet({
  required BuildContext context,
  required WidgetRef ref,
  required ScannViewModel model,
  required Product? productRef,
  required TextEditingController retailPriceController,
  required TextEditingController supplyPriceController,
  required TextEditingController countryOfOriginController,
  required String selectedProductType,
  required bool isEditMode,
  Variant? existingVariant,
  String? initialBarcode,
  String? categoryName,
  String? skuPrefix,
}) async {
  // Services carry no stock: the sheet hides the stock fields and saves 0.
  final isService = isServiceItemType(selectedProductType);
  final nameController = TextEditingController(
    text: existingVariant?.name ?? '',
  );
  // The barcode is the manufacturer's code and the SKU the shop's own: two
  // fields, never copied into each other.
  final barcodeController = TextEditingController(
    text: initialBarcode ?? existingVariant?.bcd ?? '',
  );
  final skuController = TextEditingController(text: existingVariant?.sku ?? '');
  final skuPreview = skuPreviewFor(
    businessId: productRef?.businessId ?? '',
    categoryName: categoryName,
    skuPrefix: skuPrefix,
    siblingSkus: [
      for (final v in model.scannedVariants)
        if (v.id != existingVariant?.id) v.sku,
    ],
  );
  final _initialStockNum =
      (existingVariant?.stock?.currentStock ?? existingVariant?.qty ?? 0)
          .toDouble();
  final stockController = TextEditingController(
    text: _initialStockNum == 0
        ? '0'
        : (_initialStockNum == _initialStockNum.roundToDouble()
              ? _initialStockNum.toInt().toString()
              : _initialStockNum.toString()),
  );
  final stockFocusNode = FocusNode();
  stockFocusNode.addListener(() {
    if (!stockFocusNode.hasFocus) return;
    final t = stockController.text.trim();
    final n = double.tryParse(t);
    if (n != null && n == 0) {
      stockController.clear();
    }
  });
  final lowStockText = (() {
    final low = existingVariant?.stock?.lowStock;
    if (low == null) return '0';
    return (low == low.roundToDouble())
        ? low.toInt().toString()
        : low.toString();
  })();
  final lowStockController = TextEditingController(text: lowStockText);
  final discountController = TextEditingController(
    text: (existingVariant?.dcRt ?? 0).toInt().toString(),
  );
  final priceOverrideController = TextEditingController(
    text:
        existingVariant?.retailPrice != null &&
            existingVariant!.retailPrice !=
                (double.tryParse(retailPriceController.text) ?? 0)
        ? existingVariant.retailPrice!.toString()
        : '',
  );

  final branchId = ProxyService.box.getBranchId()!;
  final ebm = await ProxyService.strategy.ebm(branchId: branchId);
  final isVatEnabled = ebm?.vatEnabled ?? false;
  // Match ScannViewModel / desktop: B when VAT, D when non-VAT. Hardcoding 'B'
  // for new rows caused mobile saves to overwrite correct onScanItem tax with B.
  // When VAT is enabled, "None" (D) is not offered — map legacy D to B.
  String taxTyCd = isVatEnabled
      ? (() {
          final t = existingVariant?.taxTyCd ?? 'B';
          if (t == 'D') return 'B';
          if (t == 'A' || t == 'B' || t == 'C') return t;
          return 'B';
        })()
      : 'D';

  final formKey = GlobalKey<FormState>();
  var savingVariant = false;
  var uploadingImage = false;
  String? variantAssetName = () {
    final direct = existingVariant?.imageUrl;
    if (direct != null && direct.isNotEmpty) return direct;
    final raw = existingVariant?.addInfo;
    if (raw == null) return null;
    return raw.startsWith('asset:') ? raw.substring('asset:'.length) : null;
  }();
  String? variantPreviewPath;

  Future<String?> tryGetLocalAssetPath(String assetName) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final p = '${dir.path}/$assetName';
      final f = File(p);
      return await f.exists() ? p : null;
    } catch (_) {
      return null;
    }
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: MposTokens.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(MposTokens.sheetRadius),
      ),
    ),
    builder: (ctx) {
      return Theme(
        data: Theme.of(
          ctx,
        ).copyWith(inputDecorationTheme: mobileEntryInputTheme()),
        child: StatefulBuilder(
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
                                        ? context.flipperL10n.dpaAddVariant
                                        : context.flipperL10n.dpaEditVariant,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: PosTokens.ink1,
                                    ),
                                  ),
                                ),
                                AppBarRoundIconButton(
                                  icon: Icons.close,
                                  onPressed: () => Navigator.of(ctx).maybePop(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context.flipperL10n.variantsImage,
                                      style: Theme.of(ctx).textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: uploadingImage
                                        ? null
                                        : () async {
                                            if (productRef == null) {
                                              showErrorNotification(
                                                ctx,
                                                context
                                                    .flipperL10n
                                                    .dpaInvalidProductRef,
                                              );
                                              return;
                                            }
                                            final sourceResult =
                                                await showImageSourceSheet(ctx);
                                            if (sourceResult == null) return;

                                            setModalState(
                                              () => uploadingImage = true,
                                            );
                                            try {
                                              // Pick first so we can preview immediately.
                                              final pickedPath =
                                                  await pickLocalImagePathForSheetResult(
                                                    sourceResult,
                                                  );
                                              if (pickedPath == null) return;

                                              setModalState(() {
                                                variantPreviewPath = pickedPath;
                                              });

                                              final uploader = UploadViewModel()
                                                ..setRef(ref);
                                              final fileName = await uploader
                                                  .uploadPickedImagePath(
                                                    pickedPath: pickedPath,
                                                    id: productRef.id,
                                                    urlType: URLTYPE.PRODUCT,
                                                    updateProductImage: false,
                                                    // Persist a variant-scoped Assets row (not the product-level image).
                                                    persistAssetRecord:
                                                        existingVariant?.id !=
                                                        null,
                                                    variantId:
                                                        existingVariant?.id,
                                                  );
                                              setModalState(() {
                                                variantAssetName = fileName;
                                                // Keep preview; it will get replaced by local asset on next open.
                                              });
                                            } catch (e, st) {
                                              talker.error(
                                                'Variant image upload failed: $e',
                                                e,
                                                st,
                                              );
                                              showErrorNotification(
                                                ctx,
                                                context
                                                    .flipperL10n
                                                    .dpaImageUploadFailed,
                                              );
                                            } finally {
                                              if (ctx.mounted) {
                                                setModalState(
                                                  () => uploadingImage = false,
                                                );
                                              }
                                            }
                                          },
                                    child: Container(
                                      width: double.infinity,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: PosTokens.surface2,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: PosTokens.line,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          if (variantPreviewPath != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(
                                                File(variantPreviewPath!),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else if (variantAssetName != null)
                                            FutureBuilder<String?>(
                                              future: tryGetLocalAssetPath(
                                                variantAssetName!,
                                              ),
                                              builder: (c, snap) {
                                                final local = snap.data;
                                                if (local != null) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Image.file(
                                                      File(local),
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                }
                                                return Center(
                                                  child: Text(
                                                    context
                                                        .flipperL10n
                                                        .dpaImageSelected,
                                                    style: TextStyle(
                                                      color: PosTokens.ink2,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          else
                                            Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_a_photo_outlined,
                                                    color: PosTokens.ink2,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    context
                                                        .flipperL10n
                                                        .dpaAddImage,
                                                    style: TextStyle(
                                                      color: PosTokens.ink2,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (uploadingImage)
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.35),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: nameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText:
                                          context.flipperL10n.dpaVariantName,
                                      hintText: context
                                          .flipperL10n
                                          .dpaVariantNameHint,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return context
                                            .flipperL10n
                                            .dpaNameRequired;
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
                                      labelText:
                                          context.flipperL10n.dpaRetailOverride,
                                      helperText: context.flipperL10n
                                          .dpaBaseRetailPrice(
                                            (double.tryParse(
                                                      retailPriceController
                                                          .text,
                                                    ) ??
                                                    0)
                                                .toStringAsFixed(2),
                                          ),
                                      hintText: context
                                          .flipperL10n
                                          .dpaLeaveBlankBasePrice,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return null;
                                      }
                                      if (double.tryParse(v) == null) {
                                        return context.flipperL10n.invalidPrice;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: barcodeController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: context.flipperL10n.dpaBarcode,
                                      hintText:
                                          context.flipperL10n.dpaBarcodeHint,
                                      helperText: context
                                          .flipperL10n
                                          .dpaLeaveBlankVariantName,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SkuTextField(
                                    controller: skuController,
                                    preview: skuPreview,
                                    decorate: (base) => base.copyWith(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (isService)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        context
                                            .flipperL10n
                                            .editQtyServiceNotice,
                                        style: Theme.of(ctx).textTheme.bodySmall
                                            ?.copyWith(color: PosTokens.ink2),
                                      ),
                                    ),
                                  if (!isService) ...[
                                    TextFormField(
                                      controller: stockController,
                                      focusNode: stockFocusNode,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: context
                                            .flipperL10n
                                            .dpaStockQuantity,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: lowStockController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.]'),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: context
                                            .flipperL10n
                                            .dpaLowStockReorder,
                                        helperText: context
                                            .flipperL10n
                                            .dpaLowStockHelper,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context.flipperL10n.variantsTax,
                                      style: Theme.of(ctx).textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  if (!isVatEnabled) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      context.flipperL10n.dpaNotVatRegistered,
                                      style: Theme.of(ctx).textTheme.bodySmall
                                          ?.copyWith(color: PosTokens.ink2),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  if (isVatEnabled)
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ChoiceChip(
                                          label: Text(
                                            context.flipperL10n.dpaTaxStandardB,
                                          ),
                                          selected: taxTyCd == 'B',
                                          onSelected: (_) => setModalState(
                                            () => taxTyCd = 'B',
                                          ),
                                        ),
                                        ChoiceChip(
                                          label: Text(
                                            context.flipperL10n.dpaTaxStandardA,
                                          ),
                                          selected: taxTyCd == 'A',
                                          onSelected: (_) => setModalState(
                                            () => taxTyCd = 'A',
                                          ),
                                        ),
                                        ChoiceChip(
                                          label: Text(
                                            context
                                                .flipperL10n
                                                .roomTaxExemptShort,
                                          ),
                                          selected: taxTyCd == 'C',
                                          onSelected: (_) => setModalState(
                                            () => taxTyCd = 'C',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Chip(
                                        avatar: const Icon(
                                          Icons.check_circle_outline,
                                          size: 20,
                                        ),
                                        label: Text(
                                          context.flipperL10n.dpaTaxNoneD,
                                        ),
                                        backgroundColor: Theme.of(
                                          ctx,
                                        ).colorScheme.surfaceContainerHighest,
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context
                                          .flipperL10n
                                          .variantsDiscountPercent,
                                      style: Theme.of(ctx).textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: discountController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: '0',
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
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16 + MediaQuery.of(ctx).padding.bottom,
                        ),
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
                                      showErrorNotification(
                                        ctx,
                                        context
                                            .flipperL10n
                                            .dpaInvalidProductRef,
                                      );
                                      return;
                                    }

                                    setModalState(() => savingVariant = true);
                                    try {
                                      final barcode = barcodeController.text
                                          .trim();
                                      final variantName = nameController.text
                                          .trim();
                                      final effectiveBarcode =
                                          barcode.isNotEmpty
                                          ? barcode
                                          : variantName;
                                      // Local check only (works offline); a
                                      // blank SKU is assigned on save.
                                      final typedSku = skuController.text
                                          .trim();
                                      final skuError = await skuSaveError(
                                        ctx,
                                        typed: typedSku,
                                        storedSku: existingVariant?.sku,
                                        businessId: productRef.businessId,
                                        candidate: SkuHolder(
                                          id: existingVariant?.id ?? '',
                                          branchId:
                                              existingVariant?.branchId ??
                                              productRef.branchId,
                                          productId: productRef.id,
                                          itemCd: existingVariant?.itemCd,
                                          bcd: effectiveBarcode,
                                        ),
                                        unsaved: [
                                          for (final v in model.scannedVariants)
                                            (
                                              id: v.id,
                                              name: v.name,
                                              sku: v.sku,
                                            ),
                                        ],
                                      );
                                      if (skuError != null) {
                                        if (ctx.mounted) {
                                          showErrorNotification(ctx, skuError);
                                        }
                                        return;
                                      }
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
                                      final qty = isService
                                          ? 0.0
                                          : double.tryParse(
                                                  stockController.text.trim(),
                                                ) ??
                                                0;
                                      final lowStockVal =
                                          double.tryParse(
                                            lowStockController.text.trim(),
                                          ) ??
                                          0.0;
                                      final discount =
                                          int.tryParse(
                                            discountController.text.trim(),
                                          ) ??
                                          0;
                                      final effectiveTaxTyCd = isVatEnabled
                                          ? (taxTyCd == 'D' ? 'B' : taxTyCd)
                                          : 'D';

                                      if (existingVariant == null) {
                                        await model.onScanItem(
                                          countryCode:
                                              countryOfOriginController.text,
                                          editmode: isEditMode,
                                          barCode: effectiveBarcode,
                                          retailPrice: override ?? baseRetail,
                                          supplyPrice: baseSupply,
                                          isTaxExempted:
                                              effectiveTaxTyCd == 'C',
                                          product: productRef,
                                          variantDisplayName: variantName,
                                          itemTyCd: selectedProductType,
                                        );

                                        final idx = model.scannedVariants
                                            .indexWhere(
                                              (v) => v.bcd == effectiveBarcode,
                                            );
                                        final v = idx != -1
                                            ? model.scannedVariants[idx]
                                            : (model.scannedVariants.isNotEmpty
                                                  ? model.scannedVariants.last
                                                  : null);
                                        if (v != null) {
                                          if (typedSku.isNotEmpty) {
                                            v.sku = typedSku;
                                          }
                                          v.name = variantName;
                                          v.itemNm = variantName;
                                          v.modrNm = variantName;
                                          v.taxTyCd = effectiveTaxTyCd;
                                          v.taxName = effectiveTaxTyCd;
                                          v.dcRt = discount.toDouble();
                                          if (variantAssetName != null) {
                                            v.imageUrl = variantAssetName;
                                            // Backward-compatible fallback for older clients.
                                            v.addInfo =
                                                'asset:$variantAssetName';
                                          }
                                          model
                                              .getDiscountController(v.id)
                                              .text = discount
                                              .toString();
                                          await model.updateVariantQuantity(
                                            v.id,
                                            qty,
                                            persistToBackend: false,
                                            lowStock: lowStockVal,
                                          );
                                          model.notifyListeners();
                                        }
                                      } else {
                                        existingVariant.name = variantName;
                                        existingVariant.itemNm = variantName;
                                        existingVariant.modrNm = variantName;
                                        existingVariant.bcd = effectiveBarcode;
                                        if (skuNeedsDuplicateCheck(
                                          typed: typedSku,
                                          stored: existingVariant.sku,
                                        )) {
                                          // A new SKU clears the server's
                                          // conflict flag; it re-flags if the
                                          // clash is still there.
                                          existingVariant
                                            ..sku = typedSku
                                            ..skuPending = false
                                            ..skuConflict = false;
                                        }
                                        existingVariant.taxTyCd =
                                            effectiveTaxTyCd;
                                        existingVariant.taxName =
                                            effectiveTaxTyCd;
                                        existingVariant.retailPrice =
                                            override ?? baseRetail;
                                        existingVariant.supplyPrice =
                                            baseSupply;
                                        existingVariant.dcRt = discount
                                            .toDouble();
                                        if (variantAssetName != null) {
                                          existingVariant.imageUrl =
                                              variantAssetName;
                                          // Backward-compatible fallback for older clients.
                                          existingVariant.addInfo =
                                              'asset:$variantAssetName';
                                        }
                                        model
                                            .getDiscountController(
                                              existingVariant.id,
                                            )
                                            .text = discount
                                            .toString();
                                        await model.updateVariantQuantity(
                                          existingVariant.id,
                                          qty,
                                          persistToBackend: false,
                                          lowStock: lowStockVal,
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
                                        showErrorNotification(
                                          ctx,
                                          context
                                              .flipperL10n
                                              .dpaSaveVariantFailed,
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
                              backgroundColor: PosTokens.blue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: PosTokens.blue,
                              disabledForegroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(
                                MposTokens.checkoutPrimaryHeight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  MposTokens.radiusMd,
                                ),
                              ),
                            ),
                            child: savingVariant
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    existingVariant == null
                                        ? context.flipperL10n.dpaSaveVariant
                                        : context.flipperL10n.save,
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
        ),
      );
    },
  );

  // The sheet route can still be animating out; disposing too early can race
  // EditableText listeners and trigger "used after being disposed".
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      nameController.dispose();
      barcodeController.dispose();
      skuController.dispose();
      stockFocusNode.dispose();
      stockController.dispose();
      lowStockController.dispose();
      priceOverrideController.dispose();
      discountController.dispose();
    });
  });
}

class _MobileProductEntry extends StatelessWidget {
  const _MobileProductEntry({
    required this.productId,
    required this.productRef,
    required this.model,
    required this.formKey,
    required this.currency,
    required this.showCategoryError,
    required this.onSave,
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
    required this.onCreateCategory,
    required this.selectedProductType,
    required this.onProductTypeChanged,
    required this.countryOfOriginController,
    required this.isSaving,
    required this.onScan,
    required this.onAddVariant,
    required this.onEditVariant,
    required this.onDeleteVariant,
    required this.pickerColor,
    required this.onColorSelected,
  });

  final String? productId;
  final Product? productRef;
  final ScannViewModel model;
  final GlobalKey<FormState> formKey;
  final String currency;
  final bool showCategoryError;
  final VoidCallback onSave;

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
  final Future<void> Function(String? initialName) onCreateCategory;
  final String selectedProductType;
  final void Function(String?) onProductTypeChanged;
  final TextEditingController countryOfOriginController;

  final bool isSaving;
  final VoidCallback onScan;
  final VoidCallback onAddVariant;
  final void Function(Variant) onEditVariant;
  final void Function(Variant) onDeleteVariant;
  final Color pickerColor;
  final ValueChanged<Color> onColorSelected;

  static String? _variantAssetName(Variant v) {
    final direct = v.imageUrl;
    if (direct != null && direct.isNotEmpty) return direct;
    final raw = v.addInfo;
    if (raw == null) return null;
    return raw.startsWith('asset:') ? raw.substring('asset:'.length) : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;

    // Cache download operations across rebuilds (keyed by assetName).
    // This avoids re-triggering downloads while scrolling.
    final Map<String, Future<void>> downloadCache =
        _MobileVariantThumbnail.globalDownloadCache;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
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
                currencySymbol: currency,
                allowBlankRetail: productId != null,
              ),
              const SizedBox(height: 12),
              // Category and item type change stock, tax and the SKU prefix,
              // so they sit in the open; packaging and origin stay folded.
              MobileEntryCard(
                title: l10n.dpaInventoryCategorization,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductEditorInventorySection(
                      selectedPackageUnitValue: selectedPackageUnitValue,
                      pkgUnits: pkgUnits,
                      onPackageUnitChanged: onPackageUnitChanged,
                      selectedCategoryId: selectedCategoryId,
                      selectedCategoryName: selectedCategoryName,
                      onCategoryChanged: onCategoryChanged,
                      onAddCategory: onAddCategory,
                      onCreateCategory: onCreateCategory,
                      selectedProductType: selectedProductType,
                      onProductTypeChanged: onProductTypeChanged,
                      countryOfOriginController: countryOfOriginController,
                      isEditMode: productId != null,
                    ),
                    if (showCategoryError && selectedCategoryId == null) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.dashFieldRequired(l10n.category),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: PosTokens.lossInk,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.dpaVariants} (${model.scannedVariants.length})',
                      style: mobileEntrySectionTitleStyle,
                    ),
                  ),
                  MobileEntrySecondaryButton(
                    label: l10n.checkoutScan,
                    icon: Icons.qr_code_scanner,
                    onPressed: isSaving ? null : onScan,
                  ),
                  const SizedBox(width: 8),
                  MobileEntrySecondaryButton(
                    label: l10n.dpaPlusAdd,
                    onPressed: isSaving ? null : onAddVariant,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(l10n.dpaVariantsHint, style: mobileEntryHintStyle),
              const SizedBox(height: 10),
              ...model.scannedVariants.reversed.map(
                (v) => _MobileVariantCard(
                  variant: v,
                  currency: currency,
                  assetName: _variantAssetName(v),
                  downloadCache: downloadCache,
                  onEdit: () => onEditVariant(v),
                  onDelete: () => onDeleteVariant(v),
                ),
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: const BoxDecoration(
            color: PosTokens.surface,
            border: Border(top: BorderSide(color: PosTokens.line)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.paddingOf(context).bottom,
            ),
            child: MobileEntryPrimaryButton(
              label: l10n.dpaSaveProduct,
              isBusy: isSaving,
              onPressed: onSave,
            ),
          ),
        ),
      ],
    );
  }
}

/// One variant on the phone form: swipe left or expand to edit or delete.
class _MobileVariantCard extends StatelessWidget {
  const _MobileVariantCard({
    required this.variant,
    required this.currency,
    required this.assetName,
    required this.downloadCache,
    required this.onEdit,
    required this.onDelete,
  });

  final Variant variant;
  final String currency;
  final String? assetName;
  final Map<String, Future<void>> downloadCache;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final v = variant;
    final displayName = v.name.isNotEmpty
        ? v.name
        : (v.bcd ?? l10n.variantsVariant);
    const radius = BorderRadius.all(Radius.circular(MposTokens.radiusMd));
    const shape = RoundedRectangleBorder(borderRadius: radius);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Dismissible(
        key: ValueKey('variant-${v.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: const BoxDecoration(
            color: PosTokens.loss,
            borderRadius: radius,
          ),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        onDismissed: (_) => onDelete(),
        // ExpansionTile builds a ListTile, which paints its ripple on the
        // nearest Material: the card itself, so the tap shows.
        child: Material(
          color: PosTokens.surface,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: PosTokens.line),
            borderRadius: radius,
          ),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            key: PageStorageKey<String>('vexp-${v.id}'),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            shape: shape,
            collapsedShape: shape,
            iconColor: PosTokens.ink3,
            collapsedIconColor: PosTokens.ink3,
            leading: _MobileVariantThumbnail(
              assetName: assetName,
              downloadCache: downloadCache,
            ),
            title: Text(
              displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.5,
                color: PosTokens.ink1,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$currency ${(v.retailPrice ?? 0).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: PosTokens.blue,
                  fontSize: 14.5,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: Text(
                      l10n.dpaEditVariant,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: PosTokens.blue,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                      l10n.delete,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: PosTokens.lossInk,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileVariantThumbnail extends StatefulWidget {
  const _MobileVariantThumbnail({
    required this.assetName,
    required this.downloadCache,
  });

  final String? assetName;
  final Map<String, Future<void>> downloadCache;

  static final Map<String, Future<void>> globalDownloadCache =
      <String, Future<void>>{};

  @override
  State<_MobileVariantThumbnail> createState() =>
      _MobileVariantThumbnailState();
}

class _MobileVariantThumbnailState extends State<_MobileVariantThumbnail> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _kickoff();
  }

  @override
  void didUpdateWidget(covariant _MobileVariantThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetName != widget.assetName) {
      _localPath = null;
      _kickoff();
    }
  }

  Future<void> _kickoff() async {
    final assetName = widget.assetName;
    if (assetName == null || assetName.isEmpty) return;

    final dir = await getApplicationSupportDirectory();
    final candidate = '${dir.path}/$assetName';
    if (File(candidate).existsSync()) {
      if (mounted) setState(() => _localPath = candidate);
      return;
    }

    // Lazy download from S3 if missing locally.
    widget.downloadCache[assetName] ??= () async {
      try {
        final stream = await ProxyService.strategy.downloadAssetSave(
          assetName: assetName,
          subPath: 'branch',
        );
        await for (final p in stream) {
          if (p >= 100) break;
        }
      } catch (_) {
        // Best-effort; UI will fall back to icon if download fails.
      }
    }();

    await widget.downloadCache[assetName];

    if (!mounted) return;
    if (File(candidate).existsSync()) {
      setState(() => _localPath = candidate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetName = widget.assetName;
    if (assetName == null || assetName.isEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: PosTokens.surface2,
        child: const Icon(
          Icons.inventory_2_outlined,
          size: 20,
          color: PosTokens.ink3,
        ),
      );
    }

    final local = _localPath;
    if (local == null) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: PosTokens.surface2,
        child: const Icon(
          Icons.image_outlined,
          size: 20,
          color: PosTokens.ink3,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(File(local), width: 40, height: 40, fit: BoxFit.cover),
    );
  }
}
