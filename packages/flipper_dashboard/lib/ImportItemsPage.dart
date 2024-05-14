import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImportItemsPage extends StatefulWidget {
  @override
  _ImportItemsPageState createState() => _ImportItemsPageState();
}

class _ImportItemsPageState extends State<ImportItemsPage> {
  DateTime _selectedDate = DateTime.now();
  late Future<RwApiResponse> _futureResponse;
  Item? _selectedItem;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureResponse = _fetchData();
  }

  Future<RwApiResponse> _fetchData() {
    // String formattedDate = DateFormat('yyyyMMdd').format(_selectedDate);
    return ProxyService.realm.selectImportItems(
      tin: 999909695,
      bhfId: '00',
      lastReqDt: "20210331000000",
    );
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _futureResponse = _fetchData();
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
    if (_selectedItem != null) {
      setState(() {
        _selectedItem!.itemNm = _nameController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Text(
                    'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text('Pick Date'),
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
                  } else if (!snapshot.hasData || snapshot.data!.data == null) {
                    return const Center(child: Text('No Data Found'));
                  } else {
                    final itemList = snapshot.data!.data!.itemList;
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter a name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _saveItemName,
                                child: Text('Save Name'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            children: [
                              DataTable(
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
                                rows: itemList!
                                    .map(
                                      (item) => DataRow(
                                        selected: item == _selectedItem,
                                        onSelectChanged: (bool? selected) {
                                          _selectItem(
                                              selected == true ? item : null);
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
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
