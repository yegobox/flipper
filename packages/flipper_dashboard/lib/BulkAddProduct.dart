import 'dart:io';
import 'dart:math';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/helperModels/extensions.dart';

class Item {
  final String barCode;
  final String name;
  final String category;
  String price;

  Item({
    required this.barCode,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  String toString() {
    return 'Item(barCode: $barCode, name: $name, category: $category, price: $price)';
  }
}

class BulkAddProduct extends StatefulHookConsumerWidget {
  const BulkAddProduct({super.key});

  @override
  BulkAddProductState createState() => BulkAddProductState();
}

class BulkAddProductState extends ConsumerState<BulkAddProduct> {
  PlatformFile? _selectedFile;
  List<Map<String, dynamic>>? _excelData;
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_excelData != null) {
      for (var product in _excelData!) {
        String barCode = product['BarCode'] ?? '';
        _controllers[barCode] = TextEditingController(text: product['Price']);
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          _excelData = null;
        });
        _parseExcelData();
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

  Future<void> _parseExcelData() async {
    try {
      if (_selectedFile != null) {
        late Excel excel;

        if (_selectedFile!.bytes != null) {
          excel = Excel.decodeBytes(_selectedFile!.bytes!);
        } else if (_selectedFile!.path != null) {
          final file = File(_selectedFile!.path!);
          final bytes = await file.readAsBytes();
          excel = Excel.decodeBytes(bytes);
        } else {
          throw Exception('Unable to read file contents');
        }

        final sheet = excel.tables[excel.tables.keys.first];
        if (sheet == null) {
          throw Exception('No sheet found in the Excel file');
        }

        List<Map<String, dynamic>> data = [];
        List<String> headers = ['BarCode', 'Name', 'Category', 'Price'];

        // Find header row
        int headerRowIndex = sheet.rows.indexWhere(
          (row) => row.any((cell) => headers.contains(cell?.value?.toString())),
        );

        if (headerRowIndex == -1) {
          throw Exception('Required headers not found in the Excel file');
        }

        // Map column indices to headers
        Map<String, int> headerIndices = {};
        for (int i = 0; i < sheet.rows[headerRowIndex].length; i++) {
          String? cellValue = sheet.rows[headerRowIndex][i]?.value?.toString();
          if (cellValue != null && headers.contains(cellValue)) {
            headerIndices[cellValue] = i;
          }
        }

        // Parse data rows
        for (int i = headerRowIndex + 1; i < sheet.rows.length; i++) {
          Map<String, dynamic> rowData = {};
          for (String header in headers) {
            int? columnIndex = headerIndices[header];
            if (columnIndex != null) {
              rowData[header] =
                  sheet.rows[i][columnIndex]?.value?.toString() ?? '';
            }
          }
          if (rowData.isNotEmpty) {
            data.add(rowData);
          }
        }

        setState(() {
          _excelData = data;
        });
      }
    } catch (e, s) {
      print('Error parsing Excel data: $e');
      print('Error parsing Excel data: $s');
    }
  }

  void _updatePrice(String barCode, String newPrice) {
    setState(() {
      final index =
          _excelData!.indexWhere((product) => product['BarCode'] == barCode);
      if (index != -1) {
        _excelData![index]['Price'] = newPrice;
      }
    });
  }

  String randomizeColor() {
    return '#${(Random().nextInt(0x1000000) | 0x800000).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  void _saveAll() {
    // Convert each row from the table to an Item model
    List<Item> items = _excelData!.map((product) {
      return Item(
        barCode: product['BarCode'] ?? '',
        name: product['Name'] ?? '',
        category: product['Category'] ?? '',
        price: product['Price'] ?? '',
      );
    }).toList();

    // Print all items to console
    for (var item in items) {
      try {
        /// create a new product
        Product product = Product(
          ObjectId(),
          id: randomNumber(),
          name: item.name,
          barCode: item.barCode,
        );

        /// add the product to the Realm
        ProxyService.local.realm!.writeN(
            tableName: productsTable,
            writeCallback: () =>
                ProxyService.local.realm!.add<Product>(product));

        /// create variant for the product
        Variant variant = Variant(
          ObjectId(),
          id: randomNumber(),
          productId: product.id!,
          sku: product.barCode,
          name: product.barCode,
          productName: product.name,
          qty: 1,
          retailPrice: double.parse(item.price),
          supplyPrice: double.parse(item.price),
          color: randomizeColor(),
          itemSeq: 1,
          pkg: "1",

          /// TODO allow user to specify tax type
          taxTyCd: "B",

          /// TODO: get itemClsCd from RRA
          itemClsCd: "5020230602",
          spplrItemCd: "",
          spplrItemClsCd: "",
          bcd: randomNumber().toString(),
          qtyUnitCd: "U",
          regrNm: item.name,
          tin: ProxyService.box.tin(),
          bhfId: ProxyService.box.bhfId() ?? "00",
          isTaxExempted: false,
          itemNm: product.name,
          ebmSynced: false,
          itemStdNm: product.name,
          orgnNatCd: "RW",
          prc: double.parse(item.price),
          splyAmt: double.parse(item.price),
          itemCd: DateTime.now().generateFlipperClip(),
          modrNm: product.name,
          modrId: product.barCode,
          pkgUnitCd: "BJ",
          regrId: product.barCode,
          rsdQty: 1,
          useYn: "N",
          itemTyCd: "2",
          lastTouched: DateTime.now(),
          branchId: ProxyService.box.getBranchId()!,
          taxPercentage: 18,
        );

        /// add the variant to the Realm
        ProxyService.local.realm!.writeN(
            tableName: variantTable,
            writeCallback: () =>
                ProxyService.local.realm!.add<Variant>(variant));

        /// create stock for the variant
        Stock stock = Stock(
          ObjectId(),
          id: randomNumber(),
          variantId: variant.id!,
          currentStock: variant.qty,
          lowStock: 0,
          canTrackingStock: false,
          showLowStockAlert: true,
          productId: variant.productId,
          active: true,
          value: variant.qty,
          rsdQty: variant.qty,
          supplyPrice: variant.supplyPrice,
          retailPrice: variant.retailPrice,
          lastTouched: DateTime.now(),
          variant: variant,
          branchId: ProxyService.box.getBranchId()!,
          ebmSynced: false,
        );
        // update variant with stock
        ProxyService.local.realm!.writeN(
            tableName: variantTable,
            writeCallback: () {
              variant.stock = stock;
              return variant;
            });

        /// add the stock to the Realm
        ProxyService.local.realm!.writeN(
            tableName: stocksTable,
            writeCallback: () => ProxyService.local.realm!.add<Stock>(stock));
      } catch (e) {
        talker.error(e);
      }
      //pop
    }
    final combinedNotifier = ref.read(refreshProvider);
    combinedNotifier.performActions(productName: "", scanMode: true);
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FlipperButton(
              textColor: Colors.black,
              onPressed: _selectFile,
              text: 'Choose Excel File',
            ),
            const SizedBox(height: 24.0),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected File: ${_selectedFile!.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FlipperButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                if (_excelData != null) {
                  _saveAll();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No data to save'),
                    ),
                  );
                }
              },
              text: 'Save All',
            ),
            const SizedBox(height: 24.0),
            if (_excelData == null && _selectedFile != null)
              const Center(child: CircularProgressIndicator()),
            if (_excelData != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('BarCode',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Category',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: _excelData!.map((product) {
                      String barCode = product['BarCode'] ?? '';
                      if (!_controllers.containsKey(barCode)) {
                        _controllers[barCode] =
                            TextEditingController(text: product['Price']);
                      }
                      return DataRow(
                        cells: [
                          DataCell(Text(product['BarCode'] ?? '')),
                          DataCell(Text(product['Name'] ?? '')),
                          DataCell(Text(product['Category'] ?? '')),
                          DataCell(
                            TextField(
                              controller: _controllers[barCode],
                              onChanged: (value) {
                                _updatePrice(product['BarCode'], value);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
