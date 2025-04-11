// ImportPurchasePage.dart
import 'package:flipper_dashboard/Imports.dart';
import 'package:flipper_dashboard/Purchases.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart' as brick;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

class ImportPurchasePage extends StatefulHookConsumerWidget {
  @override
  _ImportPurchasePageState createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage>
    with Refresh {
  DateTime _selectedDate = DateTime.now();
  Future<List<model.Variant>> _futureImportResponse = Future.value([]);
  Future<List<model.Variant>> _futurePurchaseResponse = Future.value([]);
  Future<List<model.Purchase>> _futurePurchases = Future.value([]);
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
  bool isImport = true;
  final Map<String, model.Variant> _variantMap = {}; // Initialize the map here

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    try {
      if (isImport) {
        final importResponse = _fetchDataImport(selectedDate: _selectedDate);
        _futureImportResponse = importResponse;
        await importResponse;
      } else {
        final purchaseResponseFuture =
            _fetchDataPurchase(selectedDate: _selectedDate);
        final purchasesFuture = ProxyService.strategy.purchases();

        _futurePurchaseResponse = purchaseResponseFuture;
        _futurePurchases = purchasesFuture;

        // Wait for both futures to complete
        await Future.wait([purchaseResponseFuture, purchasesFuture]);
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

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      if (isImport) {
        final importResponse = _fetchDataImport(selectedDate: _selectedDate);
        _futureImportResponse = importResponse;
        await importResponse;
      } else {
        final purchaseResponseFuture =
            _fetchDataPurchase(selectedDate: _selectedDate);
        final purchasesFuture = ProxyService.strategy.purchases();

        _futurePurchaseResponse = purchaseResponseFuture;
        _futurePurchases = purchasesFuture;

        // Wait for both futures to complete
        await Future.wait([purchaseResponseFuture, purchasesFuture]);
      }
    } catch (e) {
      talker.warning(e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<List<model.Variant>> _fetchDataImport(
      {required DateTime selectedDate}) async {
    final convertedDate = selectedDate.toYYYYMMddHHmmss();
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    final data = await ProxyService.strategy.selectImportItems(
      tin: business?.tinNumber ?? ProxyService.box.tin(),
      lastRequestdate: convertedDate,
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
    );
    return data; // Return data directly
  }

  Future<List<model.Variant>> _fetchDataPurchase(
      {required DateTime selectedDate}) async {
    try {
      final convertedDate = DateTime.now().toYYYYMMddHHmmss();
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final url = await ProxyService.box.getServerUrl();
      final rwResponse = await ProxyService.strategy.selectPurchases(
        lastRequestdate: convertedDate,
        bhfId: (await ProxyService.box.bhfId()) ?? "00",
        tin: business?.tinNumber ?? ProxyService.box.tin(),
        url: url!,
      );
      talker.warning(rwResponse);
      return rwResponse; // Return data directly
    } catch (e, s) {
      talker.warning(e);
      talker.warning(s);
      rethrow;
    }
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

  Map<String, model.Variant> itemMapper = {};
  void _asignPurchaseItem(
      {required model.Variant itemToAssign,
      required model.Variant itemFromPurchase}) {
    setState(() {
      itemMapper.putIfAbsent(itemToAssign.id, () => itemFromPurchase);
    });
  }

  void _saveChangeMadeOnItem() {
    if (_importFormKey.currentState?.validate() ?? false) {
      if (isImport && _selectedItem != null) {
        setState(() {
          _selectedItem!.itemNm = _nameController.text;
          _selectedItem!.supplyPrice =
              double.tryParse(_supplyPriceController.text);
          _selectedItem!.retailPrice =
              double.tryParse(_retailPriceController.text);
          finalItemList = finalItemList
              .map((item) =>
                  item.hsCd == _selectedItem!.hsCd ? _selectedItem! : item)
              .toList();
        });
      } else if (!isImport && _selectedPurchaseItem != null) {
        setState(() {
          _selectedPurchaseItem?.retailPrice =
              double.tryParse(_retailPriceController.text) ?? 0;
          salesList = (salesList
              .map((item) =>
                  item == _selectedPurchaseItem ? _selectedPurchaseItem! : item)
              .toList());
        });
      }
      _nameController.clear();
      _supplyPriceController.clear();
      _retailPriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<brick.CoreViewModel>.reactive(
      viewModelBuilder: () => brick.CoreViewModel(),
      builder: (context, coreViewModel, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isImport
                                ? 'Import From Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'
                                : 'Purchase From Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Switch(
                          value: isImport,
                          onChanged: (value) {
                            setState(() {
                              _selectItem(null);
                              _selectedPurchaseItem = null;
                              finalItemList = [];
                              salesList = [];
                              _variantMap.clear();
                              isImport = value;
                            });
                            _fetchData();
                          },
                        ),
                        Text(isImport ? "Import" : "Purchase"),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  isImport
                      ? Imports(
                          futureResponse: _futureImportResponse,
                          formKey: _importFormKey,
                          nameController: _nameController,
                          supplyPriceController: _supplyPriceController,
                          retailPriceController: _retailPriceController,
                          saveChangeMadeOnItem: _saveChangeMadeOnItem,
                          acceptAllImport:
                              (List<model.Variant> variants) async {
                            for (model.Variant variant in variants) {
                              if (!_variantMap.containsKey(variant.id) &&
                                      variant.retailPrice == null ||
                                  variant.supplyPrice == null ||
                                  variant.retailPrice! <= 0 ||
                                  variant.supplyPrice! <= 0) {
                                toast(
                                    "One of item to be approved does not have retail price or supply price");
                                return;
                              }
                            }
                            await coreViewModel.approveAllImportItems(variants,
                                variantMap: _variantMap);
                            final combinedNotifier = ref.read(refreshProvider);
                            combinedNotifier.performActions(
                                productName: "", scanMode: true);
                          },
                          selectItem: _selectItem,
                          selectedItem: _selectedItem,
                          finalItemList: finalItemList,
                          variantMap: _variantMap,
                          onApprove: (model.Variant item,
                              Map<String, model.Variant> variantMap) async {
                            final condition = variantMap.containsKey(item.id);
                            if (!condition &&
                                (item.retailPrice == null ||
                                    item.supplyPrice == null ||
                                    item.retailPrice! <= 0 ||
                                    item.supplyPrice! <= 0)) {
                              toast("You need to set retail price");
                              return;
                            }
                            await coreViewModel.approveImportItem(item,
                                variantMap: variantMap);
                            final combinedNotifier = ref.read(refreshProvider);
                            combinedNotifier.performActions(
                                productName: "", scanMode: true);
                          },
                          onReject: (model.Variant item,
                              Map<String, model.Variant> variantMap) async {
                            await coreViewModel.rejectImportItem(item);
                          },
                        )
                      : FutureBuilder<List<model.Purchase>>(
                          future: _futurePurchases,
                          builder: (context, purchaseSnapshot) {
                            if (purchaseSnapshot.hasError) {
                              return Center(
                                  child:
                                      Text('Error: ${purchaseSnapshot.error}'));
                            }
                            return FutureBuilder<List<model.Variant>>(
                              future: _futurePurchaseResponse,
                              builder: (context, variantSnapshot) {
                                if (variantSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${variantSnapshot.error}'));
                                } else if (!variantSnapshot.hasData ||
                                    variantSnapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No data available'));
                                } else {
                                  salesList = variantSnapshot.data!;
                                  return Purchases(
                                    purchases: purchaseSnapshot.data ?? [],
                                    formKey: _importFormKey,
                                    nameController: _nameController,
                                    supplyPriceController:
                                        _supplyPriceController,
                                    retailPriceController:
                                        _retailPriceController,
                                    saveItemName: _saveChangeMadeOnItem,
                                    acceptPurchases: (
                                        {required List<model.Variant> variants,
                                        required String pchsSttsCd,
                                        required model.Purchase
                                            purchase}) async {
                                      final pendingTransaction =
                                          await ProxyService.strategy
                                              .manageTransaction(
                                        transactionType:
                                            TransactionType.adjustment,
                                        isExpense: true,
                                        branchId:
                                            ProxyService.box.getBranchId()!,
                                      );
                                      await coreViewModel.acceptPurchase(
                                        variants: variants,
                                        itemMapper: itemMapper,
                                        pendingTransaction: pendingTransaction!,
                                        pchsSttsCd: pchsSttsCd,
                                        purchase: purchase,
                                      );
                                    },
                                    selectSale: (model.Variant? itemToAssign,
                                            model.Variant? itemFromPurchase) =>
                                        _asignPurchaseItem(
                                            itemToAssign: itemToAssign!,
                                            itemFromPurchase:
                                                itemFromPurchase!),
                                    variants: salesList,
                                  );
                                }
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
            if (isLoading) Center(child: CircularProgressIndicator()),
          ],
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
