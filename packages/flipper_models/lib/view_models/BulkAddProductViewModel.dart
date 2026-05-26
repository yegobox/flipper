// bulk_add_product_viewmodel.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/bulk_add_constants.dart';
import 'package:flipper_models/bulk_rra_client.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' show compute, kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/utils/bulk_excel_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:open_filex/open_filex.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
import 'package:supabase_models/brick/models/all_models.dart';

/// Lightweight validation after Excel parse (and after row deletes).
class BulkImportValidation {
  BulkImportValidation({
    this.missingNameCount = 0,
    this.duplicateBarCodeCount = 0,
    this.duplicateBarCodes = const [],
  });

  final int missingNameCount;
  final int duplicateBarCodeCount;
  final List<String> duplicateBarCodes;

  bool get hasIssues => missingNameCount > 0 || duplicateBarCodeCount > 0;
}

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
  String? _parseError;
  bool _useServerBulkRra = false;
  BulkImportValidation? _importValidation;
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
  String? get parseError => _parseError;
  bool get useServerBulkRra => _useServerBulkRra;
  BulkImportValidation? get importValidation => _importValidation;
  int get rowCount => _excelData?.length ?? 0;
  bool get exceedsEditableLimit => rowCount > kBulkEditableRowLimit;
  bool get canSave =>
      rowCount > 0 && !_isLoading && !_isSaving && _excelData != null;
  ValueNotifier<ProgressData> get progressNotifier => _progressNotifier;

  void setUseServerBulkRra(bool value) {
    if (_useServerBulkRra == value) return;
    _useServerBulkRra = value;
    notifyListeners();
  }

  BulkAddProductViewModel();

  @visibleForTesting
  void setExcelDataForTesting(List<Map<String, dynamic>> data) {
    _clearRowState();
    _excelData = List<Map<String, dynamic>>.from(data);
    _runValidationScan();
    notifyListeners();
  }

  void updateQuantity(String barCode, String value) {
    final product = _excelData!.firstWhere((p) => p['BarCode'] == barCode);
    product['Quantity'] = value;
    notifyListeners();
  }

  /// Removes a row before save. [index] is the index in [excelData].
  void removeRowAt(int index) {
    if (_excelData == null || index < 0 || index >= _excelData!.length) {
      return;
    }
    final barCode = (_excelData![index]['BarCode'] ?? '').toString();
    _excelData!.removeAt(index);
    _disposeRowMaps(barCode);
    _runValidationScan();
    notifyListeners();
  }

  void _disposeRowMaps(String barCode) {
    if (barCode.isEmpty) return;
    _controllers.remove(barCode)?.dispose();
    _supplyPriceControllers.remove(barCode)?.dispose();
    _quantityControllers.remove(barCode)?.dispose();
    _selectedProductTypes.remove(barCode);
    _selectedTaxTypes.remove(barCode);
    _selectedItemClasses.remove(barCode);
    _selectedCategories.remove(barCode);
  }

  void clearSelectedFile() {
    _selectedFile = null;
    _excelData = null;
    _parseError = null;
    _importValidation = null;
    _clearRowState();
    notifyListeners();
  }

  void _runValidationScan() {
    if (_excelData == null || _excelData!.isEmpty) {
      _importValidation = null;
      return;
    }
    var missingNames = 0;
    final seenBarcodes = <String, int>{};
    final duplicates = <String>[];
    for (final row in _excelData!) {
      final name = (row['Name'] ?? '').toString().trim();
      if (name.isEmpty) missingNames++;
      final bc = (row['BarCode'] ?? '').toString().trim();
      if (bc.isNotEmpty) {
        seenBarcodes[bc] = (seenBarcodes[bc] ?? 0) + 1;
      }
    }
    for (final e in seenBarcodes.entries) {
      if (e.value > 1) duplicates.add(e.key);
    }
    _importValidation = BulkImportValidation(
      missingNameCount: missingNames,
      duplicateBarCodeCount: duplicates.length,
      duplicateBarCodes: duplicates.take(5).toList(),
    );
  }

  void initializeControllers() {
    if (_excelData == null || exceedsEditableLimit) {
      return;
    }
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
    try {
      _parseError = null;
      FilePickerResult? result;

      if (filePath != null) {
        if (!BulkExcelParser.isSupportedExtension(filePath)) {
          throw Exception(BulkExcelParser.unsupportedFormatHelp(filePath));
        }
        final file = File(filePath);
        _selectedFile = PlatformFile(
          name: file.path.split(Platform.pathSeparator).last,
          path: file.path,
          size: await file.length(),
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
          // Desktop: read from path only (faster than loading bytes in picker).
          withData: kIsWeb,
        );

        if (result != null && result.files.isNotEmpty) {
          final picked = result.files.first;
          final name = picked.name.isNotEmpty
              ? picked.name
              : (picked.path ?? '');
          if (name.isNotEmpty && !BulkExcelParser.isSupportedExtension(name)) {
            throw Exception(BulkExcelParser.unsupportedFormatHelp(name));
          }
          _selectedFile = picked;
        }
      }

      if (_selectedFile != null) {
        _clearRowState();
        _excelData = null;
        await parseExcelData();
      }
    } catch (e) {
      talker.warning('Error selecting file: $e');
      _isLoading = false;
      notifyListeners();
      if (e is Exception) rethrow;
      throw Exception('Error selecting file: $e');
    }
  }

  Future<Uint8List> _readSelectedFileBytes() async {
    final file = _selectedFile!;
    if (file.path != null) {
      final disk = File(file.path!);
      if (await disk.exists()) {
        final bytes = await disk.readAsBytes();
        if (bytes.isNotEmpty) return bytes;
      }
    }
    if (file.bytes != null && file.bytes!.isNotEmpty) {
      return file.bytes!;
    }
    throw BulkExcelParseException(
      'Could not read the file. Try selecting it again, or save a copy as .xlsx.',
    );
  }

  Future<BulkExcelParseResult> _parseExcelBytes(Uint8List bytes) async {
    if (bytes.length >= kBulkExcelIsolateParseMinBytes) {
      return compute(parseBulkExcelInIsolate, bytes);
    }
    return parseBulkExcelInIsolate(bytes);
  }

  Future<void> parseExcelData() async {
    _isLoading = true;
    _parseError = null;
    notifyListeners();
    try {
      if (_selectedFile == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final name = _selectedFile!.name.isNotEmpty
          ? _selectedFile!.name
          : (_selectedFile!.path ?? '');
      if (name.isNotEmpty && !BulkExcelParser.isSupportedExtension(name)) {
        throw BulkExcelParseException(
          BulkExcelParser.unsupportedFormatHelp(name),
        );
      }

      final bytes = await _readSelectedFileBytes();
      final parsed = await _parseExcelBytes(bytes);
      _clearRowState();
      _excelData = parsed.rows;
      _runValidationScan();
      initializeControllers();
      _isLoading = false;
      notifyListeners();
    } on BulkExcelParseException catch (e) {
      talker.warning('Bulk Excel parse: ${e.message}');
      _parseError = e.message;
      _excelData = null;
      _isLoading = false;
      notifyListeners();
    } catch (e, s) {
      talker.error('Error parsing Excel data: $e', s);
      _parseError = 'Could not parse spreadsheet: $e';
      _excelData = null;
      _isLoading = false;
      notifyListeners();
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
        final category = await ProxyService.strategy
            .ensureUncategorizedCategory(branchId: branchId);
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

  Future<BulkSaveResult> saveAllWithProgress() async {
    _isSaving = true;
    notifyListeners();
    try {
      if (_useServerBulkRra) {
        return await _saveViaDataConnector();
      } else {
        await _saveLegacy();
        final n = _excelData?.length ?? 0;
        return BulkSaveResult(
          success: true,
          message: 'Saved $n products locally and synced to RRA on device.',
          total: n,
          succeeded: n,
          failed: 0,
        );
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

  Future<BulkSaveResult> _saveViaDataConnector() async {
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
    final isTaxEnabled = isVatEnabled;
    final dataConnectorUrl = _resolveDataConnectorUrl(ebm);
    if (dataConnectorUrl == null) {
      talker.warning(
        'Bulk RRA: no data-connector URL on EBM; using default http://127.0.0.1:8084/',
      );
    } else {
      talker.info('Bulk RRA using data-connector at $dataConnectorUrl');
    }

    final connectorBase = await resolveDataConnectorBaseUrl(
      dataConnectorUrl: dataConnectorUrl,
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
      isTaxEnabled: isTaxEnabled,
    );

    const pollInterval = Duration(seconds: 2);
    const maxPolls = 600;
    BulkRraJobStatus? status;
    for (var i = 0; i < maxPolls; i++) {
      if (i > 0) {
        await Future.delayed(pollInterval);
      }
      status = await client.pollJob(accepted.jobId);
      final done = status.completed;
      _progressNotifier.value = ProgressData(
        progress:
            'Server: ${status.success} ok, ${status.failed} failed (${status.status})',
        currentItem: done,
        totalItems: status.accepted,
      );
      if (status.isTerminal) {
        break;
      }
    }

    status ??= await client.pollJob(accepted.jobId);
    final total = status.accepted;
    final succeeded = status.success;
    final failed = status.failed;

    if (succeeded + failed < total) {
      throw Exception(
        'Bulk job ended incomplete: $succeeded succeeded, $failed failed, '
        '$total expected. Check data-connector is running on port 8084.',
      );
    }

    if (status.status == 'completed_with_errors' || status.status == 'failed') {
      if (succeeded == 0) {
        final failedItems = await client.listFailedItems(accepted.jobId);
        final first = failedItems.isNotEmpty ? failedItems.first : null;
        return BulkSaveResult(
          success: false,
          message:
              'All $total products failed. '
              '${first?['resultMsg'] ?? status.status}',
          total: total,
          succeeded: 0,
          failed: failed,
          jobId: accepted.jobId,
        );
      }
    }

    if (failed > 0) {
      final failedItems = await client.listFailedItems(accepted.jobId);
      failedItems.sort(
        (a, b) => (a['index'] as int? ?? 0).compareTo(b['index'] as int? ?? 0),
      );
      for (final item in failedItems.take(3)) {
        talker.error(
          'Bulk RRA failed row ${item['index']}: ${item['resultMsg'] ?? item['status']}',
        );
      }
      final first = failedItems.first;
      final idx = first['index'];
      final variant = first['variant'] as Map<String, dynamic>?;
      final name = variant?['name'] ?? variant?['itemNm'] ?? 'unknown';
      return BulkSaveResult(
        success: false,
        message:
            '$failed of $total failed at RRA. '
            'First error (row $idx, $name): '
            '${first['resultMsg'] ?? first['status']}',
        total: total,
        succeeded: succeeded,
        failed: failed,
        jobId: accepted.jobId,
      );
    }

    if (!isTaxEnabled) {
      return BulkSaveResult(
        success: true,
        rraSkipped: true,
        message:
            'Saved $succeeded products to Ditto on data-connector (job '
            '${accepted.jobId}), but RRA was not called because tax is disabled '
            'for this branch. Wait for Ditto sync or restart Flipper to see them '
            'in the app.',
        total: total,
        succeeded: succeeded,
        failed: 0,
        jobId: accepted.jobId,
      );
    }

    await _refreshVariantsFromDittoCloud(branchId);

    _progressNotifier.value = ProgressData(
      progress: 'Done — $succeeded products added',
      currentItem: total,
      totalItems: total,
    );

    return BulkSaveResult(
      success: true,
      message:
          'Added $succeeded products. Catalog is in Ditto cloud (see Ditto Portal). '
          'Open your product list to load them on this device.',
      total: total,
      succeeded: succeeded,
      failed: 0,
      jobId: accepted.jobId,
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
        final category = await ProxyService.strategy
            .ensureUncategorizedCategory(branchId: branchId);
        finalCategoryId = category.id;
      }

      final qty = _resolveQuantityText(barCode, product);
      final taxTyCd = _selectedTaxTypes[barCode] ?? (isVatEnabled ? 'B' : 'D');
      final itemClsCd = _selectedItemClasses[barCode] ?? '5020230602';
      final itemTyCd = _selectedProductTypes[barCode] ?? '2';
      final retailPrice = double.tryParse(product['Price'] ?? '0') ?? 0;
      final supplyPrice =
          double.tryParse(product['SupplyPrice'] ?? '0') ?? retailPrice;

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
        'pkg': 1,
        'pkgUnitCd': 'CT',
        'qtyUnitCd': 'U',
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
    final workbook = excel_pkg.Excel.createExcel();
    final defaultSheet = workbook.getDefaultSheet()!;
    final sheet = workbook.tables[defaultSheet]!;

    for (var c = 0; c < kBulkProductTemplateHeaders.length; c++) {
      sheet
          .cell(
            excel_pkg.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
          )
          .value = excel_pkg.TextCellValue(kBulkProductTemplateHeaders[c]);
    }

    const sampleRow = [
      '123456789',
      'Sample Product',
      'General',
      '100',
      '80',
      '10',
      'PCS',
    ];
    for (var c = 0; c < sampleRow.length; c++) {
      sheet
          .cell(
            excel_pkg.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 1),
          )
          .value = excel_pkg.TextCellValue(sampleRow[c]);
    }

    final encoded = workbook.encode();
    if (encoded == null) {
      throw Exception('Could not create template file');
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/bulk_add_products_template.xlsx';
    await File(path).writeAsBytes(encoded, flush: true);
    await OpenFilex.open(path);
  }

  String? _resolveDataConnectorUrl(brick.Ebm? ebm) {
    final trimmed = ebm?.dataConnectorUrl?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : null;
  }

  /// Register Ditto cloud subscriptions and re-query (Capella [variants] path).
  Future<void> _refreshVariantsFromDittoCloud(String branchId) async {
    try {
      _progressNotifier.value = ProgressData(
        progress: 'Syncing from Ditto cloud…',
        currentItem: 0,
        totalItems: _excelData?.length ?? 0,
      );

      final ditto = DittoService.instance.dittoInstance;
      if (ditto != null) {
        await ensureBranchCatalogCloudSubscriptions(
          ditto: ditto,
          branchId: branchId,
          businessId: ProxyService.box.getBusinessId(),
        );
        final names =
            _excelData
                ?.map((r) => (r['Name'] ?? '').toString().trim())
                .where((n) => n.isNotEmpty)
                .toList() ??
            [];
        if (names.isNotEmpty) {
          final landed = await waitForVariantNamesInDitto(
            ditto: ditto,
            branchId: branchId,
            names: names,
          );
          talker.info('Post bulk Ditto name poll: landed=$landed names=$names');
        }
      }

      final capella = ProxyService.getStrategy(Strategy.capella);
      final paged = await capella.variants(
        branchId: branchId,
        fetchRemote: true,
        page: 0,
        itemsPerPage: 200,
      );
      final visibleNames = paged.variants.map((v) => v.name).toSet();
      talker.info(
        'Post bulk Ditto cloud refresh: ${paged.variants.length} variants '
        'visible on device (totalCount=${paged.totalCount})',
      );
      if (_excelData != null) {
        for (final row in _excelData!) {
          final name = (row['Name'] ?? '').toString().trim();
          if (name.isEmpty) continue;
          talker.info(
            'Post bulk visibility "$name": ${visibleNames.contains(name)}',
          );
        }
      }
    } catch (e, st) {
      talker.warning('Post bulk Ditto cloud refresh failed: $e', e, st);
    }
  }
}

final bulkAddProductViewModelProvider =
    ChangeNotifierProvider.autoDispose<BulkAddProductViewModel>(
      (ref) => BulkAddProductViewModel(),
    );
