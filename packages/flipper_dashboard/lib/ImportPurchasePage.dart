// ImportPurchasePage.dart
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_import_view.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_purchase_view.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_dashboard/features/import_purchase/purchase_approval_mixin.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;

class ImportPurchasePage extends ConsumerStatefulWidget {
  const ImportPurchasePage({super.key});

  @override
  ConsumerState<ImportPurchasePage> createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage>
    with PurchaseApprovalMixin {
  model.Variant? _selectedItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();
  final Map<String, List<model.Variant>> _variantMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(importPurchaseViewModelProvider.notifier).loadList();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplyPriceController.dispose();
    _retailPriceController.dispose();
    super.dispose();
  }

  void _notify(String message, {bool success = true}) {
    if (!mounted) return;
    showImportPurchaseToast(context, message, isError: !success);
  }

  @override
  void notifyPurchase(String message, {bool success = true}) =>
      _notify(message, success: success);

  void _selectItem(model.Variant? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _nameController.text = item.itemNm ?? item.name;
        _supplyPriceController.text = item.supplyPrice?.toString() ?? '';
        _retailPriceController.text = item.retailPrice?.toString() ?? '';
      } else {
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
      }
    });
  }

  void _saveChangeMadeOnItem() {
    if (_importFormKey.currentState?.validate() != true) return;
    final state = ref.read(importPurchaseViewModelProvider);
    if (state.isImport && _selectedItem != null) {
      _applyControllerPricingTo(_selectedItem!);
    }
    _nameController.clear();
    _supplyPriceController.clear();
    _retailPriceController.clear();
  }

  /// Mirror legacy ImportPurchasePage: prices live on the [Variant] before approve.
  void _applyControllerPricingTo(model.Variant item) {
    if (_selectedItem?.id != item.id) return;
    final supply = double.tryParse(_supplyPriceController.text);
    final retail = double.tryParse(_retailPriceController.text);
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      item.itemNm = name;
    }
    if (supply != null && supply > 0) {
      item.supplyPrice = supply;
    }
    if (retail != null && retail > 0) {
      item.retailPrice = retail;
      item.prc = retail;
      item.dftPrc = retail;
    }
  }

  model.Variant _variantForApprove(model.Variant item) {
    _applyControllerPricingTo(item);
    return item;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    final branchId = ProxyService.box.getBranchId() ?? '';
    final catalogVariants =
        ref.watch(outerVariantsProvider(branchId)).value ?? [];

    if (state.isLoading &&
        state.importItems.isEmpty &&
        state.purchases.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null &&
        state.importItems.isEmpty &&
        state.purchases.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: IpmEmptyState(
            icon: Icons.error_outline,
            title: context.flipperL10n.ipmPageErrorLoading,
            subtitle: state.error!,
          ),
        ),
      );
    }

    return Form(
      key: _importFormKey,
      child: SizedBox.expand(
        child: state.isImport
            ? _buildImportView(state, notifier, catalogVariants)
            : _buildPurchaseView(state, notifier, catalogVariants),
      ),
    );
  }

  Widget _buildImportView(
    ImportPurchaseState state,
    ImportPurchaseViewModel notifier,
    List<model.Variant> catalogVariants,
  ) {
    if (state.importItems.isEmpty && !state.isLoading) {
      return IpmEmptyState(
        icon: Icons.inbox_outlined,
        title: context.flipperL10n.ipmPageNoImports,
        subtitle: context.flipperL10n.ipmPageNoImportsHint,
      );
    }

    return ImportPurchaseImportView(
      items: state.importItems,
      formKey: _importFormKey,
      nameController: _nameController,
      supplyPriceController: _supplyPriceController,
      retailPriceController: _retailPriceController,
      saveChangeMadeOnItem: _saveChangeMadeOnItem,
      selectItem: _selectItem,
      variantMap: _variantMap,
      catalogVariants: catalogVariants,
      statusFilter: state.importStatusFilter,
      onStatusFilterChanged: notifier.setImportStatusFilter,
      isProcessing: notifier.isProcessing,
      canRetry: notifier.canRetryRow,
      onRetry: (rowId) async {
        try {
          await notifier.replayRowJob(rowId);
          _notify(FlipperL10n.current.ipmPageRetrySucceeded);
        } catch (e) {
          _notify(FlipperL10n.current.ipmPageRetryFailed('$e'), success: false);
        }
      },
      acceptAllImport: (variants) async {
        for (final variant in variants) {
          final isAssigned = _variantMap.values.any(
            (list) => list.any((v) => v.id == variant.id),
          );
          if (!isAssigned &&
              (variant.retailPrice == null ||
                  variant.supplyPrice == null ||
                  variant.retailPrice! <= 0 ||
                  variant.supplyPrice! <= 0)) {
            _notify(context.flipperL10n.ipmPageMissingPricing, success: false);
            return;
          }
        }
        try {
          await notifier.approveAllImports(
            variants: variants.map(_variantForApprove).toList(),
            variantMap: _variantMap,
          );
          _notify(FlipperL10n.current.ipmPageApprovedCount(variants.length));
        } catch (e) {
          _notify(
            FlipperL10n.current.ipmPageApproveItemsFailed('$e'),
            success: false,
          );
        }
      },
      onApprove: (item, variantMap) async {
        final isAssigned = variantMap.values.any(
          (list) => list.any((v) => v.id == item.id),
        );
        if (!isAssigned &&
            (item.retailPrice == null ||
                item.supplyPrice == null ||
                item.retailPrice! <= 0 ||
                item.supplyPrice! <= 0)) {
          _notify(context.flipperL10n.ipmPageSetBothPrices, success: false);
          return;
        }
        String? targetId;
        for (final entry in variantMap.entries) {
          if (entry.value.any((v) => v.id == item.id)) {
            targetId = entry.key;
            break;
          }
        }
        try {
          final prepared = _variantForApprove(item);
          await notifier.approveImport(
            variant: prepared,
            targetVariantId: targetId,
          );
          _notify(
            FlipperL10n.current.ipmPageApprovedItem(item.itemNm ?? item.name),
          );
        } catch (e) {
          _notify(
            FlipperL10n.current.ipmPageApproveItemFailed('$e'),
            success: false,
          );
        }
      },
      onReject: (item, _) async {
        try {
          await notifier.rejectImport(variant: item);
          _notify(
            FlipperL10n.current.ipmPageRejectedItem(item.itemNm ?? item.name),
          );
        } catch (e) {
          _notify(
            FlipperL10n.current.ipmPageRejectItemFailed('$e'),
            success: false,
          );
        }
      },
    );
  }

  Widget _buildPurchaseView(
    ImportPurchaseState state,
    ImportPurchaseViewModel notifier,
    List<model.Variant> catalogVariants,
  ) {
    if (state.purchases.isEmpty && !state.isLoading) {
      return IpmEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: context.flipperL10n.ipmPageNoPurchases,
        subtitle: context.flipperL10n.ipmPageNoPurchasesHint,
      );
    }

    return ImportPurchasePurchaseView(
      purchases: state.purchases,
      itemMapper: itemMapper,
      variants: catalogVariants,
      statusFilter: state.purchaseStatusFilter,
      onStatusFilterChanged: notifier.setPurchaseStatusFilter,
      isProcessing: notifier.isProcessing,
      canRetry: notifier.canRetryRow,
      onRetry: (rowId) async {
        try {
          await notifier.replayRowJob(rowId);
          _notify(FlipperL10n.current.ipmPageRetrySucceeded);
        } catch (e) {
          _notify(FlipperL10n.current.ipmPageRetryFailed('$e'), success: false);
        }
      },
      onSavePurchaseMapping: savePurchaseMapping,
      acceptPurchases:
          ({
            required List<model.Purchase> purchases,
            required String pchsSttsCd,
            required model.Purchase purchase,
            model.Variant? clickedVariant,
          }) async {
            await decidePurchase(purchase, accept: pchsSttsCd != '04');
          },
    );
  }
}
