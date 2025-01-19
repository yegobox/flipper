// bulk_add_product_viewmodel.dart

import 'dart:io';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class BulkAddProductViewModel extends ChangeNotifier {
  PlatformFile? _selectedFile;
  List<Map<String, dynamic>>? _excelData;
  Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _selectedItemClasses = {};
  final Map<String, String> _selectedTaxTypes = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, String> _selectedProductTypes = {};
  bool _isLoading = false;

  PlatformFile? get selectedFile => _selectedFile;
  List<Map<String, dynamic>>? get excelData => _excelData;
  Map<String, TextEditingController> get controllers => _controllers;
  Map<String, String> get selectedItemClasses => _selectedItemClasses;
  Map<String, String> get selectedTaxTypes => _selectedTaxTypes;
  Map<String, String> get selectedProductTypes => _selectedProductTypes;
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

  Future<void> selectFile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result != null && result.files.isNotEmpty) {
        _selectedFile = result.files.first;
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
        List<String> headers = [
          'BarCode',
          'Name',
          'Category',
          'Price',
          'Quantity',
          'bcdU'
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
    final index =
        _excelData!.indexWhere((product) => product['BarCode'] == barCode);
    if (index != -1) {
      _excelData![index]['Price'] = newPrice;
      notifyListeners();
    }
  }

  Future<void> saveAll() async {
    // Convert each row from the table to an Item model
    List<brick.Variant> items = _excelData!.map((product) {
      return brick.Variant(
        bcdU: product['bcdU'] ?? '',
        barCode: product['BarCode'] ?? '',
        name: product['Name'] ?? '',
        category: product['Category'] ?? '',
        retailPrice: double.tryParse(product['Price']) ?? 0,
        supplyPrice: double.tryParse(product['Price']) ?? 0,
        quantity: double.tryParse(product['Quantity']) ?? 0,
      );
    }).toList();

    // Process each item
    for (var item in items) {
      try {
        await ProxyService.strategy.processItem(
          item: item,
          quantitis: _quantityControllers
              .map((barCode, controller) => MapEntry(barCode, controller.text)),
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
      ValueNotifier<ProgressData> progressNotifier) async {
    List<brick.Variant> items = _excelData!.map((product) {
      return brick.Variant(
        bcdU: product['bcdU'] ?? '',
        barCode: product['BarCode'] ?? '',
        name: product['Name'] ?? '',
        category: product['Category'] ?? '',
        retailPrice: double.tryParse(product['Price']) ?? 0,
        supplyPrice: double.tryParse(product['Price']) ?? 0,
        quantity: double.tryParse(product['Quantity']) ?? 0,
      );
    }).toList();

    final totalItems = items.length;

    for (var i = 0; i < items.length; i++) {
      try {
        progressNotifier.value = ProgressData(
          progress: 'Processing ${items[i].name}',
          currentItem: i + 1,
          totalItems: totalItems,
        );

        await ProxyService.strategy.processItem(
          item: items[i],
          quantitis: _quantityControllers
              .map((barCode, controller) => MapEntry(barCode, controller.text)),
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
      final rowIndex =
          _excelData!.indexWhere((row) => row['BarCode'] == barCode);
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
    if (newValue == null) return;

    _selectedItemClasses[barCode] = newValue;
    // Update the Excel data
    final rowIndex = _excelData!.indexWhere((row) => row['BarCode'] == barCode);
    if (rowIndex != -1) {
      // Extract the item class code from the selected value
      final itemClassCode = newValue.split(' ').last;
      _excelData![rowIndex]['ItemClass'] = itemClassCode;
      notifyListeners();
    }
  }
}

final bulkAddProductViewModelProvider =
    ChangeNotifierProvider.autoDispose<BulkAddProductViewModel>(
        (ref) => BulkAddProductViewModel());
