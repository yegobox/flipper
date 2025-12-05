// ImportPurchasePage.dart
import 'package:flipper_dashboard/Imports.dart';
import 'package:flipper_dashboard/Purchases.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart' as brick;
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_models/providers/import_purchase_dates_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';

class ImportPurchasePage extends StatefulHookConsumerWidget {
  @override
  _ImportPurchasePageState createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage>
    with Refresh {
  DateTime _selectedDate = DateTime.now();
  Future<List<model.Variant>>? _futureImportResponse;
  Future<List<model.Purchase>>? _futurePurchases;
  model.Variant? _selectedItem;
  model.Variant? _selectedPurchaseItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  List<model.Variant> finalItemList = [];
  List<model.Variant> salesList = [];
  List<model.Variant> importList = [];
  GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool isImport = true; // Removed, will use ViewModel
  final Map<String, List<model.Variant>> _variantMap =
      {}; // Initialize the map here

  @override
  void initState() {
    super.initState();
    _loadData(); // Call the unified data loading method
  }

  Future<void> _loadData() async {
    int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);
    final isImportState =
        ref.read(importPurchaseViewModelProvider).value?.isImport ?? true;
    setState(() => isLoading = true);

    final business = await ProxyService.strategy.getBusiness(
      businessId: ProxyService.box.getBusinessId()!,
    );
    try {
      if (isImportState) {
        _futureImportResponse = _fetchDataImport(
          selectedDate: _selectedDate,
          business: business,
        );
        await _futureImportResponse;
      } else {
        _futurePurchases = ProxyService.strategy.selectPurchases(
          bhfId: (await ProxyService.box.bhfId()) ?? "00",
          tin: tin!,
          url: await ProxyService.box.getServerUrl() ?? "",
        );

        await _futurePurchases;
      }

      if (mounted) {
        setState(() {
          // State is updated after both futures complete
        });
      }
    } catch (e) {
      talker.warning(e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<List<model.Variant>> _fetchDataImport({
    required DateTime selectedDate,
    required brick.Business? business,
  }) async {
    int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);
    final data = await ProxyService.strategy.selectImportItems(
      tin: tin!,
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
    );
    return data; // Return data directly
  }

  void _selectItem(model.Variant? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _nameController.text = item.itemNm ?? item.name;
        _supplyPriceController.text = item.supplyPrice?.toString() ?? "";
        _retailPriceController.text = item.retailPrice?.toString() ?? "";
      } else {
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
      }
    });
  }

  Map<String, List<model.Variant>> itemMapper = {};
  void _asignPurchaseItem({
    required model.Variant itemToAssign,
    required model.Variant itemFromPurchase,
  }) {
    setState(() {
      itemMapper.putIfAbsent(itemToAssign.id, () => []).add(itemFromPurchase);
    });
  }

  void _saveChangeMadeOnItem() {
    if (_importFormKey.currentState?.validate() ?? false) {
      final isImportState =
          ref.read(importPurchaseViewModelProvider).value?.isImport ?? true;
      if (isImportState && _selectedItem != null) {
        setState(() {
          _selectedItem!.itemNm = _nameController.text;
          _selectedItem!.supplyPrice = double.tryParse(
            _supplyPriceController.text,
          );
          _selectedItem!.retailPrice = double.tryParse(
            _retailPriceController.text,
          );
          finalItemList = finalItemList
              .map(
                (item) =>
                    item.hsCd == _selectedItem!.hsCd ? _selectedItem! : item,
              )
              .toList();
        });
      } else if (!isImportState && _selectedPurchaseItem != null) {
        setState(() {
          _selectedPurchaseItem?.retailPrice =
              double.tryParse(_retailPriceController.text) ?? 0;
          salesList = (salesList
              .map(
                (item) => item == _selectedPurchaseItem
                    ? _selectedPurchaseItem!
                    : item,
              )
              .toList());
        });
      }
      _nameController.clear();
      _supplyPriceController.clear();
      _retailPriceController.clear();
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Loading data...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            (ref.watch(importPurchaseViewModelProvider).value?.isImport ?? true)
                ? 'No import items available for the selected date.'
                : 'No purchase items available for the selected date.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isImport =
        ref.watch(importPurchaseViewModelProvider).value?.isImport ?? true;
    final requestType = isImport ? "IMPORT" : "PURCHASE";

    // Watch the active branch provider to get branch ID
    final activeBranchAsync = ref.watch(activeBranchProvider);

    return activeBranchAsync.when(
      data: (activeBranch) {
        final branchId = activeBranch.id;

        // Watch the provider to get the last request date
        final lastDateAsync = ref.watch(
          importPurchaseDatesProvider(
            branchId: branchId,
            requestType: requestType,
          ),
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: lastDateAsync.when(
                  data: (lastDate) {
                    final displayDate = lastDate ?? _selectedDate;
                    return Text(
                      isImport
                          ? 'Import From Date: ${DateFormat('yyyy-MM-dd').format(displayDate)}'
                          : 'Purchase From Date: ${DateFormat('yyyy-MM-dd').format(displayDate)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                  loading: () => Text(
                    isImport
                        ? 'Import From Date: Loading...'
                        : 'Purchase From Date: Loading...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  error: (error, stack) => Text(
                    isImport
                        ? 'Import From Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'
                        : 'Purchase From Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isImport ? 'Import' : 'Purchase',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isImport,
                    onChanged: (value) {
                      ref
                          .read(importPurchaseViewModelProvider.notifier)
                          .toggleImportPurchase(value);
                      // Clear local state that depends on import/purchase mode
                      setState(() {
                        _selectItem(null);
                        _selectedPurchaseItem = null;
                        finalItemList = [];
                        salesList = [];
                        _variantMap.clear();
                      });
                      _loadData();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Text(
          'Loading branch...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Text(
          'Error loading branch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<brick.CoreViewModel>.reactive(
      viewModelBuilder: () => brick.CoreViewModel(),
      builder: (context, coreViewModel, child) {
        return Form(
          key: _importFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Expanded(
                child: isLoading
                    ? _buildLoadingIndicator()
                    : (ref
                              .watch(importPurchaseViewModelProvider)
                              .value
                              ?.isImport ??
                          true)
                    ? _buildImportView(coreViewModel)
                    : _buildPurchaseView(coreViewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImportView(brick.CoreViewModel coreViewModel) {
    return FutureBuilder<List<model.Variant>>(
      future: _futureImportResponse ?? Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(
            snapshot.error?.toString() ?? 'An unknown error occurred',
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final items = snapshot.data!;
        return Imports(
          key: ValueKey(
            'import_view_${isLoading}_${ref.watch(importPurchaseViewModelProvider).value?.isImport}',
          ),
          futureResponse: Future.value(items),
          formKey: _importFormKey,
          nameController: _nameController,
          supplyPriceController: _supplyPriceController,
          retailPriceController: _retailPriceController,
          saveChangeMadeOnItem: _saveChangeMadeOnItem,
          acceptAllImport: (List<model.Variant> variants) async {
            for (model.Variant variant in variants) {
              bool isAssigned = false;
              for (final list in _variantMap.values) {
                if (list.contains(variant)) {
                  isAssigned = true;
                  break;
                }
              }
              if (!isAssigned &&
                  (variant.retailPrice == null ||
                      variant.supplyPrice == null ||
                      variant.retailPrice! <= 0 ||
                      variant.supplyPrice! <= 0)) {
                toast(
                  "One of the items to be approved is missing required pricing",
                );
                return;
              }
            }
            await coreViewModel.approveAllImportItems(
              variants,
              variantMap: _variantMap,
            );
            final combinedNotifier = ref.read(refreshProvider);
            combinedNotifier.performActions(productName: "", scanMode: true);
          },
          selectItem: _selectItem,
          finalItemList: finalItemList,
          variantMap: _variantMap,
          onApprove:
              (
                model.Variant item,
                Map<String, List<model.Variant>> variantMap,
              ) async {
                bool isAssigned = false;
                for (final list in variantMap.values) {
                  if (list.contains(item)) {
                    isAssigned = true;
                    break;
                  }
                }
                if (!isAssigned &&
                    (item.retailPrice == null ||
                        item.supplyPrice == null ||
                        item.retailPrice! <= 0 ||
                        item.supplyPrice! <= 0)) {
                  toast("Please set both retail and supply prices");
                  return;
                }
                await coreViewModel.processImportItem(item, variantMap);
                final combinedNotifier = ref.read(refreshProvider);
                combinedNotifier.performActions(
                  productName: "",
                  scanMode: true,
                );
              },
          onReject:
              (
                model.Variant item,
                Map<String, List<model.Variant>> variantMap,
              ) async {
                await coreViewModel.rejectImportItem(item);
              },
          variants:
              ref
                  .watch(
                    outerVariantsProvider(ProxyService.box.getBranchId() ?? 0),
                  )
                  .value ??
              [],
        );
      },
    );
  }

  Widget _buildPurchaseView(brick.CoreViewModel coreViewModel) {
    return FutureBuilder<List<model.Purchase>>(
      future: _futurePurchases,
      builder: (context, purchaseSnapshot) {
        if (purchaseSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (purchaseSnapshot.hasError) {
          return _buildErrorWidget(
            purchaseSnapshot.error?.toString() ?? 'Error loading purchases',
          );
        } else if (!purchaseSnapshot.hasData ||
            purchaseSnapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final allPurchases = purchaseSnapshot.data!;
        // Get variants from outerVariantsProvider (watch so it updates on search)
        final allVariants = ref.watch(
          outerVariantsProvider(ProxyService.box.getBranchId() ?? 0),
        );

        return Purchases(
          key: ValueKey(
            'purchase_view_${isLoading}_${ref.watch(importPurchaseViewModelProvider).value?.isImport}',
          ),
          purchases: allPurchases,
          formKey: _importFormKey,
          nameController: _nameController,
          supplyPriceController: _supplyPriceController,
          retailPriceController: _retailPriceController,
          saveItemName: _saveChangeMadeOnItem,
          acceptPurchases:
              ({
                required List<model.Purchase> purchases,
                required String pchsSttsCd,
                required model.Purchase purchase,
                model.Variant? clickedVariant,
              }) async {
                try {
                  await coreViewModel.acceptPurchase(
                    purchases: purchases,
                    itemMapper: itemMapper,
                    pchsSttsCd: pchsSttsCd,
                    purchase: purchase,
                    clickedVariant: clickedVariant,
                  );
                  itemMapper.clear();
                } catch (e) {
                  talker.error('Error accepting purchase: $e');
                  rethrow;
                }
              },
          selectSale:
              (model.Variant? itemToAssign, model.Variant? itemFromPurchase) {
                if (itemToAssign != null && itemFromPurchase != null) {
                  _asignPurchaseItem(
                    itemToAssign: itemToAssign,
                    itemFromPurchase: itemFromPurchase,
                  );
                }
              },
          variants: allVariants.value ?? [],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplyPriceController.dispose();
    _retailPriceController.dispose();
    super.dispose();
  }
}
