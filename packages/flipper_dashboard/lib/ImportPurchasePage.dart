import 'package:flipper_dashboard/ImportWidget.dart';
import 'package:flipper_dashboard/PurchaseSalesWidget.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class ImportPurchasePage extends StatefulWidget {
  @override
  _ImportPurchasePageState createState() => _ImportPurchasePageState();
}

class _ImportPurchasePageState extends State<ImportPurchasePage> {
  DateTime _selectedDate = DateTime.now();
  Future<RwApiResponse>? _futureImportResponse;
  Future<RwApiResponse>? _futurePurchaseResponse;
  Item? _selectedItem;
  ItemList? _selectedPurchaseItem; // Track selected purchase item
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPriceController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  List<Item> finalItemList = [];
  List<ItemList> finalItemListPurchase = [];
  List<SaleList>? finalSaleList = [];
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
      final data = await ProxyService.realm.selectImportItems(
        tin: ProxyService.box.tin(),
        bhfId: ProxyService.box.bhfId(),
        lastReqDt: convertedDate,
      );
      setState(() {
        isLoading = false;
      });
      return data;
    } else {
      setState(() {
        isLoading = true;
      });
      final data = await ProxyService.tax.selectTrnsPurchaseSales(
        tin: ProxyService.box.tin(),
        bhfId: ProxyService.box.bhfId(),
        lastReqDt: convertedDate,
      );
      setState(() {
        isLoading = false;
      });
      return data;
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

        // Find the index of the SaleList in finalSaleList
        int saleListIndex = finalSaleList!.indexWhere((s) =>
            s.spplrTin == saleList.spplrTin &&
            s.spplrInvcNo == saleList.spplrInvcNo);

        if (saleListIndex != -1) {
          // Find the index of the ItemList within the found SaleList
          int itemListIndex = finalSaleList![saleListIndex]
              .itemList!
              .indexWhere((i) => i.itemCd == item.itemCd);

          if (itemListIndex != -1) {
            // Update the ItemList in finalSaleList
            finalSaleList![saleListIndex].itemList![itemListIndex] = item;
          }
        }
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
        setState(() {
          _selectedPurchaseItem!.itemNm = _nameController.text;
          // Update supply and retail prices in  _selectedPurchaseItem if needed
        });
        // Update finalItemListPurchase or finalSaleList as necessary
      }
      _nameController.clear();
      _supplyPriceController.clear();
      _retailPriceController.clear();
    }
  }

  Future<void> _acceptPurchase() async {
    try {
      setState(() {
        isLoading = true;
      });
      for (SaleList item in finalSaleList ?? []) {
        await ProxyService.tax.savePurchases(item: item);
      }
      setState(() {
        isLoading = false;
      });
      toast("Purchases saved successfully!");
    } catch (e) {
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
        await ProxyService.tax.updateImportItems(item: item);
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
                        acceptPurchases: _acceptPurchase,
                        selectSale:
                            (ItemList? selectedItem, SaleList saleList) {
                          _selectItemPurchase(selectedItem, saleList: saleList);
                        },
                        finalSalesList: finalItemListPurchase,
                        finalSaleList: finalSaleList ?? [],
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplyPriceController.dispose();
    _retailPriceController.dispose();
    super.dispose();
  }
}
