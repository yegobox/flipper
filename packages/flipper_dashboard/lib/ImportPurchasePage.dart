import 'package:flipper_dashboard/ImportWidget.dart';
import 'package:flipper_dashboard/PurchaseSalesWidget.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';

class ImportPurchasePage extends StatefulHookConsumerWidget {
  @override
  _ImportPurchasePageState createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends ConsumerState<ImportPurchasePage>
    with Refresh {
  DateTime _selectedDate = DateTime.now();
  Future<RwApiResponse>? _futureImportResponse;
  Future<RwApiResponse>? _futurePurchaseResponse;
  Item? _selectedItem;
  ItemList? _selectedPurchaseItem; // Track selected purchase item
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  List<Item> finalItemList = [];
  RwApiResponse? rwResponse;
  List<SaleList> salesList = []; // New list to store all sales

  GlobalKey<FormState> _importFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isImport = true;

  @override
  void initState() {
    super.initState();
    _futureImportResponse = _fetchData(selectedDate: _selectedDate);
  }

  Future<RwApiResponse> _fetchData({required DateTime selectedDate}) async {
    String convertedDate = convertDateToString(selectedDate);
    if (isImport) {
      setState(() {
        isLoading = true;
      });
      final data = await ProxyService.local.selectImportItems(
        tin: ProxyService.box.tin(),
        bhfId: ProxyService.box.bhfId() ?? "00",
        lastReqDt: convertedDate,
      );
      setState(() {
        isLoading = false;
        this.rwResponse = rwResponse;
        salesList = rwResponse?.data?.saleList ?? [];
      });
      return data;
    } else {
      setState(() {
        isLoading = true;
      });
      final rwResponse = await ProxyService.tax.selectTrnsPurchaseSales(
        URI: ProxyService.box.getServerUrl()!,
        tin: ProxyService.box.tin(),
        bhfId: ProxyService.box.bhfId() ?? "00",
        lastReqDt: convertedDate,
      );
      setState(() {
        isLoading = false;
        salesList = rwResponse.data?.saleList ?? [];
      });
      return rwResponse;
    }
  }

  String convertDateToString(DateTime date) {
    final outputFormat = DateFormat('yyyyMMddHHmmss');
    return outputFormat.format(date);
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        if (isImport) {
          _futureImportResponse = _fetchData(selectedDate: _selectedDate);
          _selectedItem = null;
        } else {
          _futurePurchaseResponse = _fetchData(selectedDate: _selectedDate);
          // Clear selection and reset text fields when switching modes
          _selectedPurchaseItem = null;
        }
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
      });
    }
  }

  void _selectItem(Item? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _nameController.text = item.itemNm;
        _supplyPriceController.text = item.supplyPrice?.toString() ?? "";
        _retailPriceController.text = item.retailPrice?.toString() ?? "";
      } else {
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
      }
    });
  }

  void _selectItemPurchase(ItemList? item, {required SaleList saleList}) {
    setState(() {
      _selectedPurchaseItem = item;
      if (item != null) {
        _nameController.text = item.itemNm;
        _supplyPriceController.text = item.prc.toString();
      } else {
        _nameController.clear();
        _supplyPriceController.clear();
        _retailPriceController.clear();
      }
    });
  }

  void _saveItemName() {
    if (_importFormKey.currentState?.validate() ?? false) {
      if (isImport && _selectedItem != null) {
        setState(() {
          _selectedItem!.itemNm = _nameController.text;
          _selectedItem!.supplyPrice =
              double.tryParse(_supplyPriceController.text);
          _selectedItem!.retailPrice =
              double.tryParse(_retailPriceController.text);
        });
        int index = finalItemList
            .indexWhere((item) => item.hsCd == _selectedItem!.hsCd);
        if (index != -1) {
          finalItemList[index] = _selectedItem!; // Update the item in the list
        }
      } else if (!isImport && _selectedPurchaseItem != null) {
        for (var saleList in salesList) {
          int itemIndex = saleList.itemList
                  ?.indexWhere((item) => item == _selectedPurchaseItem) ??
              -1;
          if (itemIndex != -1) {
            /// update retailPrice of the item
            _selectedPurchaseItem?.retailPrice =
                double.tryParse(_retailPriceController.text) ?? 0;
            saleList.itemList![itemIndex] = _selectedPurchaseItem!;
            break;
          }
        }
      }
      _nameController.clear();
      _supplyPriceController.clear();
      _retailPriceController.clear();
    }
  }

  Future<void> _acceptPurchase({required CoreViewModel model}) async {
    ITransaction? pendingTransaction = null;
    try {
      setState(() {
        isLoading = true;
      });
      talker.warning("salesListLrnghts" + salesList.length.toString());
      for (SaleList supplier in salesList) {
        for (ItemList item in supplier.itemList!) {
          item.retailPrice ??= item.prc;
          talker.warning(
              "Retail Prices while saving item in our DB:: ${item.retailPrice}");
          Product? product = await ProxyService.local.createProduct(
            businessId: ProxyService.box.getBusinessId()!,
            branchId: ProxyService.box.getBranchId()!,
            tinNumber: ProxyService.box.tin(),
            bhFId: ProxyService.box.bhfId() ?? "00",
            product: Product(
              id: randomNumber(),
              ObjectId(),
              name: item.itemNm,
              lastTouched: DateTime.now(),
              branchId: ProxyService.box.getBranchId(),
              businessId: ProxyService.box.getBusinessId(),
              createdAt: DateTime.now().toIso8601String(),
              spplrNm: supplier.spplrNm,
            ),
            supplyPrice: item.prc,
            retailPrice: item.prc,
            itemSeq: item.itemSeq,
            ebmSynced: false,
          );

          /// add the variant to the current transaction, this transaction will imediately be completed
          /// for the API to call the saveItem endpoint
          /// find variant
          talker.warning("Created Product ${product!.id}");
          Variant? variant = await ProxyService.local
              .getVariantByProductId(productId: product.id!);
          talker.warning("Variant ${variant?.id}");
          pendingTransaction = ProxyService.local.manageTransaction(
            transactionType: TransactionType.sale,
            isExpense: false,
            branchId: ProxyService.box.getBranchId()!,
          );
          if (variant != null) {
            talker.warning(variant.toEJson().toFlipperJson());
            model.saveTransaction(
              variation: variant,
              amountTotal: variant.retailPrice,
              customItem: false,
              currentStock: variant.stock!.currentStock,
              pendingTransaction: pendingTransaction,
              partOfComposite: true,
              compositePrice: 0,
            );
            // mark the transaction as parked until completed
            ProxyService.local.realm!.write(() {
              /// when sarTyCd == 6 it is incoming adjustment
              pendingTransaction!.sarTyCd = "6";
              pendingTransaction.customerName =
                  ProxyService.local.getBusiness().name;
              pendingTransaction.customerTin =
                  ProxyService.box.tin().toString();
              pendingTransaction.customerBhfId =
                  ProxyService.box.bhfId() ?? "00";
              pendingTransaction.status = PARKED;
            });
          }

          /// save purchased item
          ProxyService.tax.savePurchases(
              item: supplier,
              realm: ProxyService.local.realm!,
              URI: ProxyService.box.getServerUrl()!);
        }

        /// mark transaction as completed from parked
        ProxyService.local.realm!.write(() {
          pendingTransaction!.status = COMPLETE;
        });
        refreshTransactionItems(transactionId: pendingTransaction!.id!);
      }
      setState(() {
        isLoading = false;
      });
      toast("Purchases saved successfully!");
      Navigator.maybePop(context);

      /// Pop the screen
    } catch (e, s) {
      talker.error(s);
      toast("Internal error, could not save purchases");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _acceptAllImport() async {
    try {
      setState(() {
        isLoading = true;
      });
      for (Item item in finalItemList) {
        await ProxyService.tax.updateImportItems(
            item: item, URI: ProxyService.box.getServerUrl()!);
      }
      setState(() {
        isLoading = false;
      });
      toast("Import items saved successfully!");
    } catch (e) {
      toast("Internal error, could not save import items");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Import From Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Switch(
                              value: isImport,
                              onChanged: (value) {
                                setState(() {
                                  isImport = value;
                                  // Fetch data for the selected mode
                                  if (isImport) {
                                    _futureImportResponse =
                                        _fetchData(selectedDate: _selectedDate);
                                  } else {
                                    _futurePurchaseResponse =
                                        _fetchData(selectedDate: _selectedDate);
                                  }
                                });
                              },
                            ),
                            Text(isImport ? "Import" : "Purchase"),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: _pickDate,
                              child: Text('Pick Date'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
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
                              saveItemName: _saveItemName,
                              acceptAllImport: _acceptAllImport,
                              selectItem: (Item? selectedItem) {
                                _selectItem(selectedItem);
                              },
                              selectedItem: _selectedItem,
                              finalItemList: finalItemList,
                            )
                          : PurchaseSaleWidget(
                              futureResponse: _futurePurchaseResponse,
                              formKey: _importFormKey,
                              nameController: _nameController,
                              supplyPriceController: _supplyPriceController,
                              retailPriceController: _retailPriceController,
                              saveItemName: _saveItemName,
                              acceptPurchases: () {
                                _acceptPurchase(model: model);
                              },
                              selectSale:
                                  (ItemList? selectedItem, SaleList saleList) {
                                _selectItemPurchase(selectedItem,
                                    saleList: saleList);
                              },
                              finalSalesList:
                                  rwResponse?.data!.saleList!.first.itemList ??
                                      [],
                            )
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ],
          );
        });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplyPriceController.dispose();
    _retailPriceController.dispose();
    super.dispose();
  }
}
