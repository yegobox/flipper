import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class ImportItemsPage extends StatefulWidget {
  @override
  _ImportItemsPageState createState() => _ImportItemsPageState();
}

class _ImportItemsPageState extends State<ImportItemsPage> {
  DateTime _selectedDate = DateTime.now();
  Future<RwApiResponse>? _futureResponse;
  Item? _selectedItem;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _supplyPrice = TextEditingController();
  final TextEditingController _retailPrice = TextEditingController();
  List<Item> _finalItemList = []; // List to store the final items
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool isImport = true;

  @override
  void initState() {
    super.initState();
  }

  Future<RwApiResponse> _fetchData({required DateTime selectedDate}) {
    String convertedDate = convertDateToString(selectedDate);
    return ProxyService.realm.selectImportItems(
      tin: ProxyService.box.tin(),
      bhfId: ProxyService.box.bhfId(),
      lastReqDt: convertedDate,
    );
  }

  String convertDateToString(DateTime date) {
    // Define the desired output format
    final outputFormat = DateFormat('yyyyMMddHHmmss');

    // Format the date as desired
    return outputFormat.format(date);
  }

  void _pickDate() async {
    // working 03/31/2021 to get data from import API
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _futureResponse = _fetchData(selectedDate: _selectedDate);
        _selectedItem = null;
        _nameController.clear();
      });
    }
  }

  void _selectItem(Item? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _nameController.text = item.itemNm;
      } else {
        _nameController.clear();
      }
    });
  }

  void _saveItemName() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedItem != null) {
        setState(() {
          _selectedItem!.itemNm = _nameController.text;
          _selectedItem!.supplyPrice = double.tryParse(_supplyPrice.text);
          _selectedItem!.retailPrice = double.tryParse(_retailPrice.text);
        });
        int index = _finalItemList
            .indexWhere((item) => item.hsCd == _selectedItem!.hsCd);
        if (index != -1) {
          _finalItemList[index].itemNm = _nameController.text;
        }
      }

      /// clear the field for next manipulation if there will be any!
      _nameController.clear();
      _supplyPrice.clear();
      _retailPrice.clear();
    }
  }

  Future<void> _acceptAllImport() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// take finalItemList and submit for approval
      for (Item item in _finalItemList) {
        // call the api
        await ProxyService.tax.updateImportItems(item: item);
      }

      /// This is for testing purpose to see if I can update, for now we limit it to just update one item.
      // for (var i = 0; i < 1; i++) {
      //   await ProxyService.tax.updateImportItems(item: _finalItemList[i]);
      // }
    } catch (e) {
      toast("Internal error, could not save");
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
                Container(
                  height: 400,
                  child: FutureBuilder<RwApiResponse>(
                    future: _futureResponse,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.data == null) {
                        return const Center(child: Text('No Data Found'));
                      } else {
                        final itemList = snapshot.data!.data!.itemList;
                        _finalItemList =
                            itemList!; // Update the final item list

                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter a name',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _supplyPrice,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Supply price is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter supply price',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _retailPrice,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Retail price is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Enter retail Price',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton(
                                      onPressed: _saveItemName,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Text(
                                          'Save Name',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    ElevatedButton(
                                      onPressed: _acceptAllImport,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Text(
                                          'Accept All import',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView(
                                  children: [
                                    DataTable(
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      columnSpacing: 24.0,
                                      headingRowHeight: 48.0,
                                      dataRowMinHeight: 48.0,
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Item Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'HS Code',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Quantity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: itemList
                                          .map(
                                            (item) => DataRow(
                                              selected: item == _selectedItem,
                                              onSelectChanged:
                                                  (bool? selected) {
                                                _selectItem(selected == true
                                                    ? item
                                                    : null);
                                              },
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    item.itemNm,
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    item.hsCd,
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    '${item.qty} ${item.qtyUnitCd}',
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(), // Or any other spinner
              )
            : Container(),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
