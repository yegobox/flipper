// bulk_add_product_viewmodel.dart

import 'dart:io';
import 'package:flipper_models/bulk_rra_client.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:open_filex/open_filex.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:supabase_models/brick/models/all_models.dart';

class BulkAddProductViewModel extends ChangeNotifier {
  PlatformFile? _selectedFile;
  List<Map<String, dynamic>>? _excelData;
  Map<String, TextEditingController> _controllers = {};
  Map<String, TextEditingController> _supplyPriceControllers = {};
  final Map<String, String> _selectedItemClasses = {};
  final Map<String, String> _selectedTaxTypes = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, String> _selectedProductTypes = {};
  final Map<String, String> _selectedCategories = {};
  bool _isLoading = false;
  bool _isSaving = false;
  bool _useServerBulkRra = false;
  final ValueNotifier<ProgressData> _progressNotifier =
      ValueNotifier<ProgressData>(
        ProgressData(progress: '', currentItem: 0, totalItems: 0),
      );

  PlatformFile? get selectedFile => _selectedFile;
  List<Map<String, dynamic>>? get excelData => _excelData;
  Map<String, TextEditingController> get controllers => _controllers;
  Map<String, TextEditingController> get supplyPriceControllers =>
      _supplyPriceControllers;
  Map<String, String> get selectedItemClasses => _selectedItemClasses;
  Map<String, String> get selectedTaxTypes => _selectedTaxTypes;
  Map<String, String> get selectedProductTypes => _selectedProductTypes;
  Map<String, String> get selectedCategories => _selectedCategories;
  Map<String, TextEditingController> get quantityControllers =>
      _quantityControllers;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get useServerBulkRra => _useServerBulkRra;
  ValueNotifier<ProgressData> get progressNotifier => _progressNotifier;

  void setUseServerBulkRra(bool value) {
    if (_useServerBulkRra == value) return;
    _useServerBulkRra = value;
    notifyListeners();
  }

  BulkAddProductViewModel();

  void updateQuantity(String barCode, String value) {
    final product = _excelData!.firstWhere((p) => p['BarCode'] == barCode);
    product['Quantity'] = value;
    notifyListeners();
  }

  void initializeControllers() {
    if (_excelData != null) {
      if (_controllers.isEmpty) {
        for (var product in _excelData!) {
          String barCode = product['BarCode'] ?? '';
          _controllers[barCode] = TextEditingController(text: product['Price']);
        }
      }
      if (_supplyPriceControllers.isEmpty) {
        for (var product in _excelData!) {
          String barCode = product['BarCode'] ?? '';
          _supplyPriceControllers[barCode] = TextEditingController(
            text: product['SupplyPrice'] ?? product['Price'] ?? '0',
          );
        }
      }
      for (var product in _excelData!) {
        final barCode = product['BarCode'] ?? '';
        if (barCode.isEmpty) continue;
        _quantityControllers[barCode] ??= TextEditingController(
          text: _resolveQuantityText(barCode, product),
        );
        _selectedProductTypes[barCode] ??= '2';
        _selectedTaxTypes[barCode] ??= 'B';
        _selectedItemClasses[barCode] ??= '5020230602';
      }
    }
  }

  /// Resolves stock quantity from the grid controller, then Excel row, then 1.
  String _resolveQuantityText(String barCode, Map<String, dynamic> product) {
    final fromController = _quantityControllers[barCode]?.text.trim();
    if (fromController != null &&
        fromController.isNotEmpty &&
        fromController != '0') {
      return fromController;
    }
    final fromExcel = product['Quantity']?.toString().trim();
    if (fromExcel != null && fromExcel.isNotEmpty && fromExcel != '0') {
      return fromExcel;
    }
    return '1';
  }

  void _clearRowState() {
    disposeControllers();
    _controllers.clear();
    _supplyPriceControllers.clear();
    _quantityControllers.clear();
    _selectedProductTypes.clear();
    _selectedTaxTypes.clear();
    _selectedItemClasses.clear();
    _selectedCategories.clear();
  }

  Map<String, String> _buildQuantitiesMap() {
    final map = <String, String>{};
    if (_excelData == null) return map;
    for (final product in _excelData!) {
      final barCode = product['BarCode'] ?? '';
      if (barCode.isEmpty) continue;
      map[barCode] = _resolveQuantityText(barCode, product);
    }
    return map;
  }

  void disposeControllers() {
    _controllers.forEach((_, controller) => controller.dispose());
    _supplyPriceControllers.forEach((_, controller) => controller.dispose());
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
        _clearRowState();
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
          'SupplyPrice',
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

        _clearRowState();
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

  void updateSupplyPrice(String barCode, String newPrice) {
    final index = _excelData!.indexWhere(
      (product) => product['BarCode'] == barCode,
    );
    if (index != -1) {
      _excelData![index]['SupplyPrice'] = newPrice;
      notifyListeners();
    }
  }

  Future<List<brick.Variant>> _buildVariantsForLegacySave() async {
    final branchId = ProxyService.box.getBranchId()!;
    final items = <brick.Variant>[];
    for (final product in _excelData!) {
      String barCode = product['BarCode'] ?? '';
      String finalCategoryId = _selectedCategories[barCode] ?? '';
      if (finalCategoryId.isEmpty) {
        final category = await ProxyService.strategy.ensureUncategorizedCategory(
          branchId: branchId,
        );
        finalCategoryId = category.id;
      }
      final qtyText = _resolveQuantityText(barCode, product);
      items.add(
        brick.Variant(
          branchId: branchId,
          bcdU: product['bcdU'] ?? '',
          barCode: barCode,
          name: product['Name'] ?? '',
          category: finalCategoryId.isNotEmpty
              ? finalCategoryId
              : (product['Category'] ?? ''),
          retailPrice: double.tryParse(product['Price'] ?? '0') ?? 0,
          supplyPrice:
              double.tryParse(product['SupplyPrice'] ?? '0') ??
              double.tryParse(product['Price'] ?? '0') ??
              0,
          quantity: double.tryParse(qtyText) ?? 1,
          categoryId: finalCategoryId,
        ),
      );
    }
    return items;
  }

  Future<void> saveAll() async {
    final items = await _buildVariantsForLegacySave();

    // Process each item
    for (var item in items) {
      try {
        await ProxyService.strategy.processItem(
          item: item,
          quantitis: _buildQuantitiesMap(),
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

  Future<void> saveAllWithProgress() async {
    _isSaving = true;
    notifyListeners();
    try {
      if (_useServerBulkRra) {
        await _saveViaDataConnector();
      } else {
        await _saveLegacy();
      }
    } catch (e) {
      talker.error('Fatal error during bulk save: $e');
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _saveLegacy() async {
    final items = await _buildVariantsForLegacySave();

    final totalItems = items.length;
    final ebm = await ProxyService.strategy.ebm(
      branchId: ProxyService.box.getBranchId()!,
    );
    final isVatEnabled = ebm?.vatEnabled ?? false;

    for (var i = 0; i < items.length; i++) {
      try {
        _progressNotifier.value = ProgressData(
          progress: 'Processing ${items[i].name}',
          currentItem: i + 1,
          totalItems: totalItems,
        );

        String barCode = items[i].barCode ?? '';
        if (barCode.isEmpty) {
          barCode = 'TEMP_${DateTime.now().millisecondsSinceEpoch}';
          items[i].barCode = barCode;
        }

        if (items[i].name.isEmpty) {
          items[i].name = 'Unnamed Product';
        }
        items[i].itemNm = items[i].name;

        if (!_quantityControllers.containsKey(barCode)) {
          _quantityControllers[barCode] = TextEditingController(text: '0');
        }
        if (!_selectedTaxTypes.containsKey(barCode)) {
          _selectedTaxTypes[barCode] = isVatEnabled ? 'B' : 'D';
        }
        if (!_selectedItemClasses.containsKey(barCode)) {
          _selectedItemClasses[barCode] = '5020230602';
        }
        if (!_selectedProductTypes.containsKey(barCode)) {
          _selectedProductTypes[barCode] = '2';
        }

        await ProxyService.strategy.processItem(
          item: items[i],
          quantitis: _buildQuantitiesMap(),
          taxTypes: _selectedTaxTypes,
          itemClasses: _selectedItemClasses,
          itemTypes: _selectedProductTypes,
        );
      } catch (e) {
        talker.error('General error: $e');
      }
    }
  }

  Future<void> _saveViaDataConnector() async {
    if (_excelData == null || _excelData!.isEmpty) {
      throw Exception('No data to save');
    }

    final branchId = ProxyService.box.getBranchId()!;
    final businessId = ProxyService.box.getBusinessId()!;
    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    final tin = await effectiveTin(branchId: branchId);
    if (tin == null) {
      throw Exception('TIN is required for bulk RRA');
    }

    final isVatEnabled = ebm?.vatEnabled ?? false;
    final isTaxEnabled = await ProxyService.strategy.isTaxEnabled(
      businessId: businessId,
      branchId: branchId,
    );

    final connectorBase = await resolveDataConnectorBaseUrl(
      taxServerUrl: ebm?.taxServerUrl,
      serverUrl: await ProxyService.box.getServerUrl(),
    );
    final client = BulkRraClient(baseUrl: connectorBase);

    final bhfId = ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? '00';
    final rows = await _buildBulkSubmitRows(
      branchId: branchId,
      businessId: businessId,
      tin: tin,
      bhfId: bhfId,
      isVatEnabled: isVatEnabled,
    );

    _progressNotifier.value = ProgressData(
      progress: 'Submitting ${rows.length} products to server…',
      currentItem: 0,
      totalItems: rows.length,
    );

    final accepted = await client.submitBulkAdd(
      tinNumber: tin.toString(),
      bhfId: bhfId,
      branchId: branchId,
      businessId: businessId,
      rows: rows,
      taxServerUrl: ebm?.taxServerUrl,
      isTaxEnabled: isTaxEnabled,
    );

    const pollInterval = Duration(seconds: 2);
    const maxPolls = 600;
    BulkRraJobStatus? status;
    for (var i = 0; i < maxPolls; i++) {
      await Future.delayed(pollInterval);
      status = await client.pollJob(accepted.jobId);
      final done = status.completed;
      _progressNotifier.value = ProgressData(
        progress:
            'RRA: ${status.success} succeeded, ${status.failed} failed (${status.status})',
        currentItem: done,
        totalItems: status.accepted,
      );
      if (status.isTerminal) {
        break;
      }
    }

    status ??= await client.pollJob(accepted.jobId);
    if (status.failed > 0) {
      final failed = await client.listFailedItems(accepted.jobId);
      failed.sort(
        (a, b) => (a['index'] as int? ?? 0).compareTo(b['index'] as int? ?? 0),
      );
      for (final item in failed.take(3)) {
        talker.error(
          'Bulk RRA failed row ${item['index']}: ${item['resultMsg'] ?? item['status']}',
        );
      }
      final first = failed.first;
      final idx = first['index'];
      final variant = first['variant'] as Map<String, dynamic>?;
      final name = variant?['name'] ?? variant?['itemNm'] ?? 'unknown';
      throw Exception(
        'Bulk RRA failed ($status.failed rows). '
        'First failure at index $idx ($name): ${first['resultMsg'] ?? first['status']}',
      );
    }

    _progressNotifier.value = ProgressData(
      progress: 'Refreshing catalog…',
      currentItem: status.accepted,
      totalItems: status.accepted,
    );
  }

  Future<List<Map<String, dynamic>>> _buildBulkSubmitRows({
    required String branchId,
    required String businessId,
    required int tin,
    required String bhfId,
    required bool isVatEnabled,
  }) async {
    final rows = <Map<String, dynamic>>[];
    for (final product in _excelData!) {
      String barCode = product['BarCode'] ?? '';
      if (barCode.isEmpty) {
        barCode = 'TEMP_${DateTime.now().millisecondsSinceEpoch}';
      }
      String name = product['Name'] ?? '';
      if (name.isEmpty) {
        name = 'Unnamed Product';
      }

      String finalCategoryId = _selectedCategories[barCode] ?? '';
      if (finalCategoryId.isEmpty) {
        final category = await ProxyService.strategy.ensureUncategorizedCategory(
          branchId: branchId,
        );
        finalCategoryId = category.id;
      }

      final qty = _resolveQuantityText(barCode, product);
      final taxTyCd =
          _selectedTaxTypes[barCode] ?? (isVatEnabled ? 'B' : 'D');
      final itemClsCd = _selectedItemClasses[barCode] ?? '5020230602';
      final itemTyCd = _selectedProductTypes[barCode] ?? '2';
      final retailPrice =
          double.tryParse(product['Price'] ?? '0') ?? 0;
      final supplyPrice =
          double.tryParse(product['SupplyPrice'] ?? '0') ??
          retailPrice;

      final variant = <String, dynamic>{
        'branchId': branchId,
        'businessId': businessId,
        'barCode': barCode,
        'name': name,
        'itemNm': name,
        'bcdU': product['bcdU'] ?? '',
        'retailPrice': retailPrice,
        'prc': retailPrice,
        'supplyPrice': supplyPrice,
        'categoryId': finalCategoryId,
        'category': finalCategoryId,
        'tin': tin,
        'bhfId': bhfId,
        'taxTyCd': taxTyCd,
        'itemClsCd': itemClsCd,
        'itemTyCd': itemTyCd,
        'orgnNatCd': 'RW',
        'pkgUnitCd': 'CT',
        'qtyUnitCd': 'BJ',
      };

      rows.add({
        'variant': variant,
        'quantity': qty,
        'taxTyCd': taxTyCd,
        'itemClsCd': itemClsCd,
        'itemTyCd': itemTyCd,
        'bcdU': product['bcdU'] ?? '',
        'categoryId': finalCategoryId,
      });
    }
    return rows;
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
    sheet.getRangeByIndex(1, 5).setText('SupplyPrice');
    sheet.getRangeByIndex(1, 6).setText('Quantity');
    sheet.getRangeByIndex(1, 7).setText('bcdU');

    // Style headers
    final Range headerRange = sheet.getRangeByIndex(1, 1, 1, 7);
    headerRange.cellStyle.bold = true;
    headerRange.cellStyle.backColor = '#EEEEEE';

    // Add sample data
    sheet.getRangeByIndex(2, 1).setText('123456789');
    sheet.getRangeByIndex(2, 2).setText('Sample Product');
    sheet.getRangeByIndex(2, 3).setText('General');
    sheet.getRangeByIndex(2, 4).setNumber(100.0);
    sheet.getRangeByIndex(2, 5).setNumber(80.0);
    sheet.getRangeByIndex(2, 6).setNumber(10.0);
    sheet.getRangeByIndex(2, 7).setText('PCS');

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
