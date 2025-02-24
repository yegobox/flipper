import 'package:flipper_dashboard/ImportWidget.dart';
import 'package:flipper_dashboard/PurchaseSalesWidget.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/realm_model_export.dart' as brick;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class ImportPurchasePage extends StatefulHookConsumerWidget {
  @override
  _ImportPurchasePageState createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage>
    with Refresh {
  DateTime _selectedDate = DateTime.now();
  Future<List<Variant>>? _futureImportResponse;
  Future<List<Variant>>? _futurePurchaseResponse; // Added for purchase data
  Variant? _selectedItem;
  Variant? _selectedPurchaseItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  List<Variant> finalItemList = [];
  List<Variant> salesList = [];
  List<Variant> importList = [];
  GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isImport = true;
  final Map<String, Variant> _variantMap = {}; // Initialize the map here

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      if (isImport) {
        _futureImportResponse = _fetchDataImport(selectedDate: _selectedDate);
        await _futureImportResponse;
      } else {
        _futurePurchaseResponse =
            _fetchDataPurchase(selectedDate: _selectedDate);
        await _futurePurchaseResponse;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      talker.warning(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<List<Variant>> _fetchDataImport(
      {required DateTime selectedDate}) async {
    final convertedDate = selectedDate.toYYYYMMddHH0000();
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    final data = await ProxyService.strategy.selectImportItems(
      tin: business?.tinNumber ?? ProxyService.box.tin(),
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
      lastReqDt: convertedDate,
    );
    return data; // Return data directly
  }

  Future<List<Variant>> _fetchDataPurchase(
      {required DateTime selectedDate}) async {
    try {
      final convertedDate = selectedDate.toYYYYMMddHH0000();
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final url = await ProxyService.box.getServerUrl();
      final rwResponse = await ProxyService.strategy.selectPurchases(
        bhfId: (await ProxyService.box.bhfId()) ?? "00",
        tin: business?.tinNumber ?? ProxyService.box.tin(),
        lastReqDt: convertedDate,
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

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedItem = null;
        _selectedPurchaseItem = null;
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
        _fetchData();
      });
    }
  }

  void _selectItem(Variant? item) {
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

  Map<String, Variant> itemMapper = {};
  void _asignPurchaseItem(
      {required Variant itemToAssign, required Variant itemFromPurchase}) {
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

  Future<void> _acceptAllImport() async {
    try {
      setState(() => isLoading = true);
      for (final item in finalItemList) {
        if (item.supplyPrice == null || item.retailPrice == null) continue;
        item.modrId = item.modrId ?? randomNumber().toString().substring(0, 5);
        item.bhfId = item.bhfId ?? "00";
        item.modrNm = item.modrNm ?? item.itemNm;
        item.tin = item.tin ??
            (await ProxyService.strategy.getBusiness())?.tinNumber ??
            ProxyService.box.tin();
        item.imptItemSttsCd = "3";
      }
      setState(() => isLoading = false);
      toast("Import items saved successfully!");
    } catch (e) {
      toast("Internal error, could not save import items");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => brick.CoreViewModel(),
      builder: (context, model, child) {
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
                              isImport = value;
                              _fetchData();
                            });
                          },
                        ),
                        Text(isImport ? "Import" : "Purchase"),
                        SizedBox(width: 10),
                        FlipperIconButton(
                          icon: Icons.calendar_today,
                          onPressed: _pickDate,
                          textColor: Colors.black,
                          iconColor: Colors.blue,
                          height: 30,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                  isImport
                      ? ImportSalesWidget(
                          futureResponse: _futureImportResponse,
                          formKey: _importFormKey,
                          nameController: _nameController,
                          supplyPriceController: _supplyPriceController,
                          retailPriceController: _retailPriceController,
                          saveChangeMadeOnItem: _saveChangeMadeOnItem,
                          acceptAllImport: _acceptAllImport,
                          selectItem: _selectItem,
                          selectedItem: _selectedItem,
                          finalItemList: finalItemList,
                          variantMap: _variantMap,
                        )
                      : FutureBuilder<List<Variant>>(
                          future: _futurePurchaseResponse,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text('No data available'));
                            } else {
                              salesList = snapshot.data!;
                              return PurchaseSaleWidget(
                                formKey: _importFormKey,
                                nameController: _nameController,
                                supplyPriceController: _supplyPriceController,
                                retailPriceController: _retailPriceController,
                                saveItemName: _saveChangeMadeOnItem,
                                acceptPurchases: (
                                    {required List<Variant> variants,
                                    required String pchsSttsCd}) async {
                                  final pendingTransaction = await ref.read(
                                      pendingTransactionStreamProvider(
                                              isExpense: true)
                                          .future);
                                  model.acceptPurchase(
                                    variants: variants,
                                    itemMapper: itemMapper,
                                    pendingTransaction: pendingTransaction,
                                    pchsSttsCd: pchsSttsCd,
                                  );
                                },
                                selectSale: (Variant? itemToAssign,
                                        Variant? itemFromPurchase) =>
                                    _asignPurchaseItem(
                                        itemToAssign: itemToAssign!,
                                        itemFromPurchase: itemFromPurchase!),
                                finalSalesList: salesList,
                              );
                            }
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
