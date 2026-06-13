// ImportPurchasePage.dart
import 'package:flipper_dashboard/features/import_purchase/import_purchase_import_view.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_purchase_view.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
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

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage> {
  model.Variant? _selectedItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();
  final Map<String, List<model.Variant>> _variantMap = {};
  final Map<String, List<model.Variant>> _itemMapper = {};

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
      setState(() {
        _selectedItem!.itemNm = _nameController.text;
        _selectedItem!.supplyPrice = double.tryParse(_supplyPriceController.text);
        _selectedItem!.retailPrice = double.tryParse(_retailPriceController.text);
      });
    }
    _nameController.clear();
    _supplyPriceController.clear();
    _retailPriceController.clear();
  }

  void _assignPurchaseItem({
    required model.Variant itemToAssign,
    required model.Variant itemFromPurchase,
  }) {
    setState(() {
      _itemMapper.putIfAbsent(itemToAssign.id, () => []).add(itemFromPurchase);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importPurchaseViewModelProvider);
    final notifier = ref.read(importPurchaseViewModelProvider.notifier);
    final branchId = ProxyService.box.getBranchId() ?? '';
    final catalogVariants =
        ref.watch(outerVariantsProvider(branchId)).value ?? [];

    if (state.isLoading && state.importItems.isEmpty && state.purchases.isEmpty) {
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
            title: 'Error loading data',
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
      return const IpmEmptyState(
        icon: Icons.inbox_outlined,
        title: 'No imported items',
        subtitle: 'Sync from RRA to fetch new import items.',
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
            _notify(
              'One of the items to approve is missing required pricing',
              success: false,
            );
            return;
          }
        }
        try {
          await notifier.approveAllImports(
            variants: variants,
            variantMap: _variantMap,
          );
          _notify('Approved ${variants.length} item(s)');
        } catch (e) {
          _notify('Could not approve items: $e', success: false);
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
          _notify('Please set both retail and supply prices', success: false);
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
          await notifier.approveImport(
            variant: item,
            targetVariantId: targetId,
          );
          _notify('Approved "${item.itemNm ?? item.name}"');
        } catch (e) {
          _notify('Could not approve item: $e', success: false);
        }
      },
      onReject: (item, _) async {
        try {
          await notifier.rejectImport(variant: item);
          _notify('Rejected "${item.itemNm ?? item.name}"');
        } catch (e) {
          _notify('Could not reject item: $e', success: false);
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
      return const IpmEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'No purchase invoices',
        subtitle: 'Sync from RRA or record a purchase manually.',
      );
    }

    return ImportPurchasePurchaseView(
      purchases: state.purchases,
      nameController: _nameController,
      supplyPriceController: _supplyPriceController,
      retailPriceController: _retailPriceController,
      saveItemName: _saveChangeMadeOnItem,
      itemMapper: _itemMapper,
      variants: catalogVariants,
      statusFilter: state.purchaseStatusFilter,
      onStatusFilterChanged: notifier.setPurchaseStatusFilter,
      isProcessing: notifier.isProcessing,
      acceptPurchases: ({
        required List<model.Purchase> purchases,
        required String pchsSttsCd,
        required model.Purchase purchase,
        model.Variant? clickedVariant,
      }) async {
        final isDecline = pchsSttsCd == '04';
        try {
          if (isDecline) {
            await notifier.rejectPurchase(purchase: purchase);
          } else {
            await notifier.approvePurchase(
              purchase: purchase,
              itemMapper: _itemMapper,
            );
          }
          _itemMapper.clear();
          _notify(isDecline ? 'Purchase declined' : 'Purchase accepted');
        } catch (e) {
          _notify(
            'Could not ${isDecline ? 'decline' : 'accept'} purchase: $e',
            success: false,
          );
        }
      },
      selectSale: (itemToAssign, itemFromPurchase) {
        if (itemToAssign != null && itemFromPurchase != null) {
          _assignPurchaseItem(
            itemToAssign: itemToAssign,
            itemFromPurchase: itemFromPurchase,
          );
        }
      },
    );
  }
}
