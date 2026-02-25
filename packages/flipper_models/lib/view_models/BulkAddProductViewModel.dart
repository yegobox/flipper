// bulk_add_product_viewmodel.dart

import 'dart:io';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:open_filex/open_filex.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:supabase_models/brick/models/all_models.dart';

class BulkAddProductViewModel extends ChangeNotifier {
  PlatformFile? _selectedFile;
  List<Map<String, dynamic>>? _excelData;
  Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _selectedItemClasses = {};
  final Map<String, String> _selectedTaxTypes = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, String> _selectedProductTypes = {};
  final Map<String, String> _selectedCategories = {};
  bool _isLoading = false;

  PlatformFile? get selectedFile => _selectedFile;
  List<Map<String, dynamic>>? get excelData => _excelData;
  Map<String, TextEditingController> get controllers => _controllers;
  Map<String, String> get selectedItemClasses => _selectedItemClasses;
  Map<String, String> get selectedTaxTypes => _selectedTaxTypes;
  Map<String, String> get selectedProductTypes => _selectedProductTypes;
  Map<String, String> get selectedCategories => _selectedCategories;
  Map<String, TextEditingController> get quantityControllers =>
      _quantityControllers;
  bool get isLoading => _isLoading;

  BulkAddProductViewModel();

  void updateQuantity(String barCode, String value) {
    final product = _excelData!.firstWhere((p) => p['BarCode'] == barCode);
    product['Quantity'] = value;
    notifyListeners();
  }

  void initializeControllers() {
    if (_excelData != null) {
      for (var product in _excelData!) {
        String barCode = product['BarCode'] ?? '';
        _controllers[barCode] = TextEditingController(text: product['Price']);
      }
    }
  }

  void disposeControllers() {
    _controllers.forEach((_, controller) => controller.dispose());
    _quantityControllers.values.forEach((controller) => controller.dispose());
  }

  Future<void> selectFile({String? filePath}) async {
    _isLoading = true;
    notifyListeners();
    try {
      FilePickerResult? result;

      if (filePath != null) {
        // File path is provided via drag and drop
        final file = File(filePath);
        _selectedFile = PlatformFile(
          name: file.path.split('/').last,
          path: file.path,
          size: await file.length(),
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
        );

        if (result != null && result.files.isNotEmpty) {
          _selectedFile = result.files.first;
        }
      }

      if (_selectedFile != null) {
        _excelData = null;
        _isLoading = false;
        notifyListeners();
        parseExcelData();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error selecting file: $e');
      _isLoading = false;
      notifyListeners();
      throw Exception('Error selecting file: $e');
    }
  }

  Future<void> parseExcelData() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_selectedFile != null) {
        late excel_pkg.Excel excel;

        if (_selectedFile!.bytes != null) {
          excel = excel_pkg.Excel.decodeBytes(_selectedFile!.bytes!);
        } else if (_selectedFile!.path != null) {
          final file = File(_selectedFile!.path!);
          final bytes = await file.readAsBytes();
          excel = excel_pkg.Excel.decodeBytes(bytes);
        } else {
          throw Exception('Unable to read file contents');
        }

        final sheet = excel.tables[excel.tables.keys.first];
        if (sheet == null) {
          throw Exception('No sheet found in the Excel file');
        }

        List<Map<String, dynamic>> data = [];
        List<String> headers = [
          'BarCode',
          'Name',
          'Category',
          'Price',
          'Quantity',
          'bcdU',
        ];

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
          bool hasNonEmptyValue = false;
          for (String header in headers) {
            int? columnIndex = headerIndices[header];
            if (columnIndex != null) {
              String? cellValue = sheet.rows[i][columnIndex]?.value?.toString();
              if (cellValue != null && cellValue.isNotEmpty) {
                hasNonEmptyValue = true;
              }
              rowData[header] = cellValue ?? '';
            }
          }
          if (hasNonEmptyValue) {
            data.add(rowData);
          }
        }

        _excelData = data;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e, s) {
      print('Error parsing Excel data: $e');
      print('Error parsing Excel data: $s');
      _isLoading = false;
      notifyListeners();
      throw Exception('Error parsing Excel data: $e');
    }
  }

  void updatePrice(String barCode, String newPrice) {
    final index = _excelData!.indexWhere(
      (product) => product['BarCode'] == barCode,
    );
    if (index != -1) {
      _excelData![index]['Price'] = newPrice;
      notifyListeners();
    }
  }

  Future<void> saveAll() async {
    // Convert each row from the table to an Item model
    String orgnNatCd = "RW"; // Define the variable
    List<Future<brick.Variant>> itemFutures = _excelData!.map((product) async {
      String barCode = product['BarCode'] ?? '';
      String finalCategoryId = _selectedCategories[barCode] ?? '';
      if (finalCategoryId.isEmpty) {
        final category = await ProxyService.strategy
            .ensureUncategorizedCategory(
              branchId: ProxyService.box.getBranchId()!,
            );
        finalCategoryId = category.id;
      }

      return brick.Variant(
        branchId: ProxyService.box.getBranchId()!,
        itemCd: (await ProxyService.strategy.itemCode(
          countryCode: orgnNatCd,
          productType: "2",
          packagingUnit: "CT",
          quantityUnit: "BJ",
          branchId: ProxyService.box.getBranchId()!,
        )),
        bcdU: product['bcdU'] ?? '',
        barCode: barCode,
        name: product['Name'] ?? '',
        category: finalCategoryId.isNotEmpty
            ? finalCategoryId
            : (product['Category'] ?? ''),
        retailPrice: double.tryParse(product['Price'] ?? '0') ?? 0,
        supplyPrice: double.tryParse(product['Price'] ?? '0') ?? 0,
        quantity: double.tryParse(product['Quantity'] ?? '0') ?? 0,
        categoryId: finalCategoryId,
      );
    }).toList();

    List<brick.Variant> items = await Future.wait(itemFutures);

    // Process each item
    for (var item in items) {
      try {
        await ProxyService.strategy.processItem(
          item: item,
          quantitis: _quantityControllers.map(
            (barCode, controller) => MapEntry(barCode, controller.text),
          ),
          taxTypes: _selectedTaxTypes,
          itemClasses: _selectedItemClasses,
          itemTypes: _selectedProductTypes,
        );
      } catch (e) {
        talker.error(e);
        rethrow;
      }
    }
  }

  Future<void> saveAllWithProgress(
    ValueNotifier<ProgressData> progressNotifier,
  ) async {
    String orgnNatCd = "RW"; // Define the variable
    List<Future<brick.Variant>> itemFutures = _excelData!.map((product) async {
      String barCode = product['BarCode'] ?? '';
      String finalCategoryId = _selectedCategories[barCode] ?? '';
      if (finalCategoryId.isEmpty) {
        final category = await ProxyService.strategy
            .ensureUncategorizedCategory(
              branchId: ProxyService.box.getBranchId()!,
            );
        finalCategoryId = category.id;
      }

      return brick.Variant(
        branchId: ProxyService.box.getBranchId()!,
        itemCd: (await ProxyService.strategy.itemCode(
          countryCode: orgnNatCd,
          productType: "2",
          packagingUnit: "CT",
          quantityUnit: "BJ",
          branchId: ProxyService.box.getBranchId()!,
        )),
        bcdU: product['bcdU'] ?? '',
        barCode: barCode,
        name: product['Name'] ?? '',
        category: finalCategoryId.isNotEmpty
            ? finalCategoryId
            : (product['Category'] ?? ''),
        retailPrice: double.tryParse(product['Price'] ?? '0') ?? 0,
        supplyPrice: double.tryParse(product['Price'] ?? '0') ?? 0,
        quantity: double.tryParse(product['Quantity'] ?? '0') ?? 0,
        categoryId: finalCategoryId,
      );
    }).toList();
    List<brick.Variant> items = await Future.wait(itemFutures);

    final totalItems = items.length;

    for (var i = 0; i < items.length; i++) {
      try {
        progressNotifier.value = ProgressData(
          progress: 'Processing ${items[i].name}',
          currentItem: i + 1,
          totalItems: totalItems,
        );

        // Ensure we have valid values for required fields
        String barCode = items[i].barCode ?? '';
        if (barCode.isEmpty) {
          barCode = 'TEMP_${DateTime.now().millisecondsSinceEpoch}';
          items[i].barCode = barCode;
        }

        // Make sure we have a valid name
        if (items[i].name.isEmpty) {
          items[i].name = 'Unnamed Product';
        }

        // Set itemNm to the same as name if it's null
        items[i].itemNm = items[i].name;

        // Ensure we have valid maps with the barcode as key
        if (!_quantityControllers.containsKey(barCode)) {
          _quantityControllers[barCode] = TextEditingController(text: '0');
        }
        if (!_selectedTaxTypes.containsKey(barCode)) {
          final ebm = await ProxyService.strategy.ebm(
            branchId: ProxyService.box.getBranchId()!,
          );
          final isVatEnabled = ebm?.vatEnabled ?? false;
          _selectedTaxTypes[barCode] = isVatEnabled ? 'B' : 'D';
        }
        if (!_selectedItemClasses.containsKey(barCode)) {
          _selectedItemClasses[barCode] =
              '5020230602'; // Default item class code (finished product)
        }
        if (!_selectedProductTypes.containsKey(barCode)) {
          _selectedProductTypes[barCode] =
              '2'; // Default: 2 = Finished Product, 1 = Raw Material, 3 = Service
        }

        try {
          await ProxyService.strategy.processItem(
            item: items[i],
            quantitis: _quantityControllers.map(
              (barCode, controller) => MapEntry(barCode, controller.text),
            ),
            taxTypes: _selectedTaxTypes,
            itemClasses: _selectedItemClasses,
            itemTypes: _selectedProductTypes,
          );
        } catch (processError) {
          // Log the error but continue processing other items
          talker.error('Error processing item ${items[i].name}: $processError');
          // Update progress to show the error
          progressNotifier.value = ProgressData(
            progress:
                'Error: ${processError.toString().substring(0, processError.toString().length > 50 ? 50 : processError.toString().length)}...',
            currentItem: i + 1,
            totalItems: totalItems,
          );
          // Wait a moment so the user can see the error
          await Future.delayed(Duration(milliseconds: 500));
        }
      } catch (e) {
        talker.error('General error: $e');
        // Don't rethrow, just log and continue with the next item
      }
    }
  }

  void updateProductType(String barCode, String? newValue) {
    if (newValue == null) return;
    if (_excelData == null) {
      throw Exception('Excel data is not loaded');
    }

    final rowIndex = _excelData!.indexWhere((row) => row['BarCode'] == barCode);
    if (rowIndex == -1) {
      throw Exception('Row not found for barCode: $barCode');
    }
    _selectedProductTypes[barCode] = newValue;
    _excelData![rowIndex]['ProductType'] = newValue;
    notifyListeners();
  }

  void updateTaxType(String barCode, String? newValue) {
    if (newValue == null) return;

    if (_excelData != null) {
      final rowIndex = _excelData!.indexWhere(
        (row) => row['BarCode'] == barCode,
      );
      if (rowIndex != -1) {
        _selectedTaxTypes[barCode] = newValue;
        _excelData![rowIndex]['TaxType'] = newValue;
        notifyListeners();
      } else {
        talker.error('Row not found for barCode: $barCode');
      }
    } else {
      talker.error('Excel data is null');
    }
  }

  void updateItemClass(String barCode, String? newValue) {
    if (newValue != null) {
      // Extract just the code from the format "Name Code"
      // Example: "Finished Product 5020230602" -> "5020230602"
      String itemClassCode = newValue.trim();

      // If the value contains a space, take the last part (the code)
      if (itemClassCode.contains(' ')) {
        itemClassCode = itemClassCode.split(' ').last;
      }

      // Ensure we have a valid code (not empty after extraction)
      if (itemClassCode.isEmpty) {
        itemClassCode = '5020230602'; // Default to finished product
      }

      _selectedItemClasses[barCode] = itemClassCode;
      notifyListeners();
    }
  }

  void updateCategory(String barCode, String? newValue) {
    if (newValue != null) {
      _selectedCategories[barCode] = newValue;
      notifyListeners();
    }
  }

  Future<void> downloadTemplate() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Set headers
    sheet.getRangeByIndex(1, 1).setText('BarCode');
    sheet.getRangeByIndex(1, 2).setText('Name');
    sheet.getRangeByIndex(1, 3).setText('Category');
    sheet.getRangeByIndex(1, 4).setText('Price');
    sheet.getRangeByIndex(1, 5).setText('Quantity');
    sheet.getRangeByIndex(1, 6).setText('bcdU');

    // Style headers
    final Range headerRange = sheet.getRangeByIndex(1, 1, 1, 6);
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.backColor = '#EEEEEE';

    // Add sample data
    sheet.getRangeByIndex(2, 1).setText('123456789');
    sheet.getRangeByIndex(2, 2).setText('Sample Product');
    sheet.getRangeByIndex(2, 3).setText('General');
    sheet.getRangeByIndex(2, 4).setNumber(100.0);
    sheet.getRangeByIndex(2, 5).setNumber(10.0);
    sheet.getRangeByIndex(2, 6).setText('PCS');

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/bulk_add_products_template.xlsx';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    await OpenFilex.open(path);
  }
}

final bulkAddProductViewModelProvider =
    ChangeNotifierProvider.autoDispose<BulkAddProductViewModel>(
      (ref) => BulkAddProductViewModel(),
    );
