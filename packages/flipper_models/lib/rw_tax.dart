import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:supabase_models/brick/models/all_models.dart' as odm;
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:flipper_models/NetworkHelper.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
// ignore: unused_import
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/notice.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'dart:math' as math;

/// Align branch counters in Ditto when RRA rejects a duplicate [invcNo].
Future<void> persistCapellaCountersInvcNo(int invcNo) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return;

  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    talker.warning('Ditto not initialized; cannot persist counter invcNo.');
    return;
  }

  final counters = await ProxyService.getStrategy(
    Strategy.capella,
  ).getCounters(branchId: branchId, fetchRemote: false);
  final now = DateTime.now().toUtc();
  for (final counter in counters) {
    if (counter.branchId == null) continue;
    counter.invcNo = invcNo;
    counter.lastTouched = now;
    counter.createdAt = now;
    final doc = counter.toDittoDocument();
    await ditto.store.execute(
      'INSERT INTO counters DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }
}

// Expose a top-level calculateTaxTotals function so tests can call it
// without needing to instantiate RWTax (which pulls in app-wide services).
Map<String, double> calculateTaxTotals(List<Map<String, dynamic>> items) {
  // Initialize tax totals with zero values
  Map<String, double> taxTotals = {
    'A': 0.0,
    'B': 0.0,
    'C': 0.0,
    'D': 0.0,
    'F': 0.0,
    'ttTaxAmt': 0.0,
    'ttTaxblAmt': 0.0,
  };

  for (var item in items) {
    try {
      String taxType = (item['taxTyCd'] as String?) ?? 'B';
      taxType = taxType.toUpperCase();

      if (!taxTotals.containsKey(taxType)) {
        print('Warning: Invalid tax type $taxType found. Using default type B');
        taxType = 'B';
      }

      final unitPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['qty'] as num?)?.toDouble() ?? 0.0;
      final discountRate = (item['dcRt'] as num?)?.toDouble() ?? 0.0;
      final prftDcAmt = (item['prftDcAmt'] as num?)?.toDouble() ?? 0.0;

      double unitDiscount = (unitPrice * discountRate) / 100;
      double lineGross = (unitPrice - unitDiscount) * quantity;
      if (taxType == 'F') {
        lineGross -= prftDcAmt;
      }
      if (lineGross < 0) lineGross = 0;

      taxTotals[taxType] = taxTotals[taxType]! + lineGross;

      // Sum up TT tax amounts and taxable amounts from items
      if (item.containsKey('ttTaxAmt')) {
        double ttTaxAmt = (item['ttTaxAmt'] as num?)?.toDouble() ?? 0.0;
        taxTotals['ttTaxAmt'] = taxTotals['ttTaxAmt']! + ttTaxAmt;
      }

      if (item.containsKey('ttTaxblAmt')) {
        double ttTaxblAmt = (item['ttTaxblAmt'] as num?)?.toDouble() ?? 0.0;
        taxTotals['ttTaxblAmt'] = taxTotals['ttTaxblAmt']! + ttTaxblAmt;
      }

      // Optional: Add debug print to verify calculations
      print(
        'Processing item - Tax Type: $taxType, Amount: $lineGross, New Total: ${taxTotals[taxType]}',
      );
    } catch (e) {
      print('Error processing item: $item');
      print('Error details: $e');
    }
  }

  return taxTotals;
}

/// RRA [saveSales] may return a code-value error when [qtyUnitCd] is not in the allowed set.
bool _rwTaxIsQtyUnitCdCodeValueError(String? msg) {
  if (msg == null || msg.isEmpty) return false;
  final lower = msg.toLowerCase();
  return lower.contains('code value error') && lower.contains('qtyunitcd');
}

/// Package count on RRA `itemList` lines (not unit quantity — see [TransactionItem.qty]).
int _rraItemListPkgCount(TransactionItem item) {
  final p = item.pkg;
  if (p != null && p > 0 && p < item.qty) return p;
  return 1;
}

bool _variantTinMissing(Variant variant) =>
    variant.tin == null || variant.tin == 0;

/// Fills [Variant.tin] / [Variant.bhfId] from branch EBM when missing (product add path).
Future<bool> _hydrateVariantEbmFields(Variant variant) async {
  final needsTin = _variantTinMissing(variant);
  final needsBhf = variant.bhfId == null || variant.bhfId!.trim().isEmpty;
  if (!needsTin && !needsBhf) return true;

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return false;
  final ebm = await ProxyService.strategy.ebm(branchId: branchId);
  if (ebm == null) return false;

  if (needsTin) variant.tin = ebm.tinNumber;
  if (needsBhf) variant.bhfId = ebm.bhfId;
  return !_variantTinMissing(variant);
}

class RWTax with NetworkHelper, TransactionMixinOld implements TaxApi {
  static final Map<String, Configurations> _taxConfigByBranchAndType = {};
  String itemPrefix = "flip-";
  Dio? _dio;
  Talker? _talker;

  @override
  Dio? get dioInstance => _dio;

  @override
  get talkerInstance => _talker;
  RWTax() {
    _talker = Talker();
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 120),
      ),
    );

    _dio!.interceptors.add(
      TalkerDioLogger(
        talker: _talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
        ),
      ),
    );
  }

  @override
  Future<BusinessInfo> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
    required String URI, // You're not currently using this URI parameter
  }) async {
    String? token = ProxyService.box.readString(key: 'bearerToken');
    final branchId = ProxyService.box.getBranchId()!;
    models.Ebm? ebm = await ProxyService.strategy.ebm(
      branchId: branchId,
      fetchRemote: true,
    );
    if (ebm == null) {
      throw Exception("Ebm not found for branch $branchId");
    }
    final taxUrl = ebm.taxServerUrl;
    if (taxUrl == null || taxUrl.isEmpty) {
      throw Exception("Ebm tax server URL not configured for branch $branchId");
    }
    var headers = {'Authorization': token!, 'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse(taxUrl + 'initializer/selectInitInfo'),
    );
    request.body = json.encode({
      "tin": tinNumber,
      "bhfId": bhfId,
      "dvcSrlNo": dvcSrlNo,
    });
    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();
    String responseBody = await streamedResponse.stream.bytesToString();

    // Parse the response body to check for error messages
    try {
      final jsonResponse = jsonDecode(responseBody);

      // Check if this is an error response
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('resultCd') &&
          jsonResponse['resultCd'] != '0000') {
        // This is an error response from the API
        final errorMessage = jsonResponse['resultMsg'] ?? 'Unknown error';
        throw Exception(errorMessage);
      }

      // If we get here, it's a successful response
      if (streamedResponse.statusCode == 200) {
        // Create a BusinessInfoResponse object from the response
        BusinessInfoResponse response = BusinessInfoResponse.fromJson(
          jsonResponse,
        );
        return response.data.info;
      } else {
        throw Exception(
          'Failed to load BusinessInfo: HTTP ${streamedResponse.statusCode}',
        );
      }
    } catch (e) {
      // If JSON parsing fails or any other error occurs, rethrow with the original response
      if (e is FormatException) {
        throw Exception('Invalid response from server: $responseBody');
      }
      rethrow; // Rethrow the original exception if it's not a FormatException
    }
  }

  /// Saves stock item transactions to the RRA (Rwanda Revenue Authority) system.
  ///
  /// IMPORTANT: Before calling this method, you must first save the item/variant details
  /// using [saveItem()] to ensure the item exists in the RRA system.
  ///
  /// This method is used for recording stock movements (in/out) and requires:
  /// - The item must already exist in the RRA system (via saveItem)
  /// - Transaction details including customer information
  /// - Tax and amount calculations
  /// - Business location details (bhfId)
  ///
  /// The [sarTyCd] parameter indicates the type of stock movement:
  /// - '11' for sales (stock out)
  /// - Other codes for different stock movement types
  /// This update stock IO given on the input data.
  @override
  Future<RwApiResponse> saveStockItems({
    required List<TransactionItem> items,
    required String tinNumber,
    required String bhFId,
    String? customerName,
    String? custTin,
    String? regTyCd = "A",
    //sarTyCd 11 is for sale
    required String sarTyCd,
    bool isStockIn = false,
    String? custBhfId,
    required double totalSupplyPrice,
    required double totalvat,
    required double totalAmount,
    required String remark,
    required DateTime ocrnDt,
    num? invoiceNumber,
    String? sarNo,
    num? approvedQty,
    bool updateMaster = true,
    required String URI,
    bool includeCustomerFields = false,
  }) async {
    if ((isAndroid || isIos) && URI.contains('localhost')) {
      return RwApiResponse(
        resultCd: "000",
        resultMsg: "Skipped localhost call on mobile",
      );
    }
    try {
      final url = Uri.parse(
        URI,
      ).replace(path: Uri.parse(URI).path + 'stock/saveStockItems').toString();

      /// Filter out service items as they cannot be saved in IO
      items = items.where((item) => item.itemTyCd != "3").toList();
      final itemsList = items
          .asMap()
          .entries
          .map(
            (entry) => mapRraStockIoItemToJson(
              entry.value,
              bhfId: bhFId,
              approvedQty: entry.value.qty == 0 ? approvedQty : entry.value.qty,
              itemSeq: entry.key + 1,
            ),
          )
          .toList();
      if (itemsList.isEmpty) {
        return RwApiResponse(
          resultCd: "000",
          resultMsg: "No stock items to save",
        );
      }

      final storedCustomerName = ProxyService.box.customerName();
      final effectiveCustomerName =
          (customerName != null && customerName.trim().isNotEmpty)
          ? customerName.trim()
          : (storedCustomerName != null && storedCustomerName.trim().isNotEmpty)
          ? storedCustomerName.trim()
          : "N/A";

      final json = buildRraSaveStockItemsRequest(
        items: items,
        itemList: itemsList,
        tinNumber: tinNumber,
        bhfId: bhFId,
        sarTyCd: sarTyCd,
        regTyCd: regTyCd ?? 'A',
        ocrnDt: ocrnDt.toYYYMMdd(),
        totalSupplyPrice: totalSupplyPrice,
        totalvat: totalvat,
        totalAmount: totalAmount,
        remark: remark,
        sarNo: sarNo,
        orgSarNo: (invoiceNumber ?? int.tryParse(sarNo ?? '') ?? 0).toInt(),
        saleCustomerName: effectiveCustomerName,
        saleCustTin: custTin != null && custTin.isValidTin() ? custTin : null,
        saleCustBhfId: custBhfId,
        includeCustomerFields: includeCustomerFields,
      );
      talker.info(json);
      Response response = await sendPostRequest(url, json);

      final data = RwApiResponse.fromJson(response.data);

      /// save stock master for  the involved variants
      /// to keep stock master in sync
      if (updateMaster && data.resultCd == "000") {
        for (var item in items) {
          final vid = item.variantId;
          if (vid == null) continue;
          Variant? variant = await ProxyService.getStrategy(
            Strategy.capella,
          ).getVariant(id: vid);
          if (variant != null) {
            await saveStockMaster(variant: variant, URI: URI);
          }
        }
      }

      if (data.resultCd == "000" && sarTyCd != "06") {}

      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// save or update stock of item saved before.
  /// so it is an item i.e variant we pass back
  /// The API will not fail even if the item Code @[itemCd] is not found
  /// in a ist of saved Item.
  /// @[rsdQty] is the remaining stock of the item.
  /// it is very important to note that given on how RRA data is structured
  /// we ended up mixing data for stock and variant but data stay in related model
  /// we just borrow properties to simplify the accesibility
  @override
  Future<RwApiResponse> saveStockMaster({
    required Variant variant,
    required String URI,
    num? approvedQty,
    double? stockMasterQty,
  }) async {
    if ((isAndroid || isIos) && URI.contains('localhost')) {
      return RwApiResponse(
        resultCd: "000",
        resultMsg: "Skipped localhost call on mobile",
      );
    }
    try {
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'stockMaster/saveStockMaster')
          .toString();

      /// update the remaining stock of this item in rra
      // Prefer approvedQty when provided (assignment path). Otherwise use stock.currentStock
      if (approvedQty != null) {
        variant.rsdQty = double.parse(
          approvedQty.toDouble().toStringAsFixed(2),
        );
      } else if (variant.stock?.currentStock != null) {
        // Truncate/round to 2 decimal places for RRA compatibility
        variant.rsdQty = double.parse(
          variant.stock!.currentStock!.toStringAsFixed(2),
        );
      } else {
        variant.rsdQty = null;
      }
      await _hydrateVariantEbmFields(variant);
      if (_variantTinMissing(variant)) {
        return RwApiResponse(resultCd: "001", resultMsg: "Missing TIN number");
      }

      if (variant.rsdQty == null) {
        return RwApiResponse(
          resultCd: "000",
          resultMsg: "Missing remaining stock quantity",
        );
      }

      if (variant.itemCd == 'null' || variant.itemCd == null) {
        return RwApiResponse(resultCd: "000", resultMsg: "Missing item code");
      }
      if (variant.itemCd!.isEmpty) {
        return RwApiResponse(
          resultCd: "000",
          resultMsg: "Invalid data while saving stock",
        );
      }
      if (variant.productName == TEMP_PRODUCT) {
        return RwApiResponse(resultCd: "000", resultMsg: "Invalid product");
      }

      // Do not overwrite rsdQty here — it was set above, preferring approvedQty when provided.
      // Ensure qty prefers approvedQty, then falls back to the variant's current stock,
      // and finally to any existing variant.qty to avoid breaking prior behavior.
      variant.qty =
          approvedQty?.toDouble() ??
          variant.stock?.currentStock?.toDouble() ??
          variant.qty;
      final rsdSource = approvedQty != null
          ? 'approvedQty'
          : 'stock.currentStock';
      talker.warning("RSD QTY (from $rsdSource): ${variant.toFlipperJson()}");

      /// the stockMasterQty is set when during refund to provide acturate stock qty
      if (stockMasterQty != null) {
        variant.qty = stockMasterQty;
        variant.rsdQty = stockMasterQty;
      }
      // if variant?.itemTyCd  == '3' it means it is a servcice, keep qty to 0, as service does not have stock.
      if (variant.itemTyCd == '3') {
        variant.rsdQty = 0;
        return RwApiResponse(
          resultCd: "000",
          resultMsg: "Invalid data while saving stock",
        );
      }
      Response response = await sendPostRequest(url, variant.toFlipperJson());

      final data = RwApiResponse.fromJson(response.data);
      return data;
    } catch (e, s) {
      talker.warning("Invalid Stock ${s}");
      rethrow;
    }
  }

  // Create the Dio instance and add the TalkerDioLogger interceptor

  Future<Response> sendGetRequest(
    String baseUrl,
    Map<String, dynamic>? queryParameters,
  ) async {
    final headers = {'Content-Type': 'application/json'};

    _dio!.interceptors.add(
      TalkerDioLogger(
        talker: _talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );

    try {
      final response = await _dio!.get(
        baseUrl,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle the error
      final errorMessage = e.response?.data;
      throw Exception(
        'Error sending GET request: ${errorMessage ?? 'Bad Request'}',
      );
    }
  }

  void sendEmailLogging({
    required dynamic requestBody,
    required String subject,
    required String body,
  }) async {
    sendEmailNotification(
      requestBody: json.encode(requestBody).toString(),
      response: body,
    );
  }

  void logError(dynamic error, StackTrace stackTrace) {
    log('Error: $error\nStack Trace: $stackTrace');
  }

  /// Saves an item/variant to the RRA (Rwanda Revenue Authority) system.
  ///
  /// This method MUST be called before using [saveStockItems()] for any item.
  /// It registers the item's details with the tax authority, including:
  /// - Item code (itemCd)
  /// - Item classification (itemClsCd)
  /// - Standard name (itemStdNm)
  /// - Tax information
  ///
  /// In Flipper, we work with product variations rather than base products,
  /// as these variations are what get reported to the EBM server.
  ///
  /// After successfully saving an item, you can use the items/selectItems
  /// endpoint to retrieve the saved item information.
  ///
  /// For more details, refer to RRA API documentation section '3.2.4.1 ItemSaveReq/Res'.
  @override
  Future<RwApiResponse> saveItem({
    required Variant variation,
    required String URI,
  }) async {
    if ((isAndroid || isIos) && URI.contains('localhost')) {
      return RwApiResponse(
        resultCd: "000",
        resultMsg: "Skipped localhost call on mobile",
      );
    }
    final url = Uri.parse(
      URI,
    ).replace(path: Uri.parse(URI).path + 'items/saveItems').toString();

    try {
      await _hydrateVariantEbmFields(variation);
      if (_variantTinMissing(variation)) {
        return RwApiResponse(
          resultCd: "001",
          resultMsg: "Invalid Tin Number ${variation.name}",
        );
      }
      if (variation.itemTyCd == null) {
        return RwApiResponse(
          resultCd: "001",
          resultMsg: "itemTyCd is null ${variation.name}",
        );
      }
      if (variation.itemTyCd?.isEmpty == true) {
        return RwApiResponse(
          resultCd: "001",
          resultMsg: "Empty itemTyCd ${variation.name}",
        );
      }

      /// first remove fields for imports
      final itemJson = variation.toFlipperJson();
      itemJson.removeWhere(
        (key, value) =>
            [
              "totWt",
              "netWt",
              "spplrNm",
              "agntNm",
              "invcFcurAmt",
              "invcFcurCd",
              "invcFcurExcrt",
              "exptNatCd",
              "dclNo",
              "taskCd",
              "dclDe",
              "hsCd",
              "imptItemSttsCd",
              "purchaseId",
              "totAmt",
              "taxblAmt",
              "taxAmt",
              "dcAmt",
            ].contains(key) ||
            value == null ||
            value == "",
      );
      final response = await sendPostRequest(url, itemJson);
      if (response.statusCode == 200) {
        final data = RwApiResponse.fromJson(response.data);

        return data;
      } else {
        throw Exception("failed to save item");
      }
    } catch (e) {
      // Handle the exception
      rethrow;
    }
  }

  /// lastReqDt we do year +  0523000000 where 0523000000 seem to be constant
  /// this get a list of items that are saved in the server from saveItem endPoint

  @override
  Future<bool> selectItems({
    required String tinNumber,
    required String bhfId,
    required String URI,
    String? lastReqDt,
  }) async {
    // Use current date if lastReqDt is not provided
    lastReqDt ??= DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    models.Ebm? ebm = await ProxyService.strategy.ebm(
      branchId: ProxyService.box.getBranchId()!,
    );
    if (ebm == null) {
      return false;
    }
    final url = Uri.parse(
      URI,
    ).replace(path: Uri.parse(URI).path + 'items/selectItems').toString();

    final data = {"tin": tinNumber, "bhfId": bhfId, "lastReqDt": lastReqDt};

    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// After [trnsSales/saveSales] succeeds, RRA still expects stock movement and
  /// master updates. Those calls are not needed to build the signed receipt.
  /// Line totals for `stock/saveStockItems` envelope (stock lines only, matches flipper-turbo).
  ({double taxable, double tax, double total}) _stockIoEnvelopeTotals(
    List<TransactionItem> items,
  ) {
    var taxable = 0.0;
    var tax = 0.0;
    var total = 0.0;
    for (final item in items) {
      if (item.itemTyCd == '3') continue;
      final qty = item.qty.toDouble();
      final retailUnit = (item.prc ?? item.price).toDouble();
      final lineTotal = double.parse((retailUnit * qty).toStringAsFixed(2));
      taxable += lineTotal;
      total += lineTotal;
      tax += (item.taxAmt ?? 0).toDouble();
    }
    return (
      taxable: double.parse(taxable.toStringAsFixed(2)),
      tax: double.parse(tax.toStringAsFixed(2)),
      total: double.parse(total.toStringAsFixed(2)),
    );
  }

  /// Invoke via [syncStockAfterSuccessfulSaveSales] after local stock deduction
  /// (see [runPostSaleStockDeductionAndRraSync]) so saveStockItems → saveStockMaster
  /// use post-sale quantities and the allow-below-stock snapshot is available.
  @override
  Future<void> syncStockAfterSuccessfulSaveSales({
    required String receiptType,
    required List<TransactionItem> items,
    required ITransaction transaction,
    required int highestInvcNo,
    String? sarTyCd,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    if (ebm == null) return;
    await _syncStockAfterSuccessfulSaveSales(
      receiptType: receiptType,
      items: items,
      ebm: ebm,
      highestInvcNo: highestInvcNo,
      sarTyCd: sarTyCd,
      transaction: transaction,
      repository: Repository(),
    );
  }

  Future<void> _syncStockAfterSuccessfulSaveSales({
    required String receiptType,
    required List<TransactionItem> items,
    required models.Ebm ebm,
    required int highestInvcNo,
    String? sarTyCd,
    required ITransaction transaction,
    required Repository repository,
  }) async {
    final snapshotKey = rraSaleStockSnapshotBoxKey(transaction.id);
    Map<String, num> allocations = {};
    var movementItemsForStockIo = items;
    var capRra = false;

    try {
      final taxUrl = ebm.taxServerUrl;
      if (taxUrl == null || taxUrl.isEmpty) {
        talker.warning(
          'Skipping RRA stock IO: EBM tax server URL not configured',
        );
        return;
      }

      if (receiptType != 'NR' && receiptType != 'CR' && receiptType != 'TR') {
        final bizId = ProxyService.box.getBusinessId();
        Setting? bizSetting;
        if (bizId != null && bizId.isNotEmpty) {
          bizSetting = await ProxyService.getStrategy(
            Strategy.capella,
          ).getSetting(businessId: bizId);
        }
        final snapshot = decodeRraSaleStockSnapshot(
          ProxyService.box.readString(key: snapshotKey),
        );
        capRra =
            bizSetting?.allowSellingBelowStock == true &&
            snapshot != null &&
            snapshot.isNotEmpty;

        movementItemsForStockIo = items;
        if (capRra) {
          final capellaStrat = ProxyService.getStrategy(Strategy.capella);
          final variantIds = items
              .where((i) {
                final vid = i.variantId;
                return vid != null &&
                    vid.trim().isNotEmpty &&
                    i.itemTyCd != '3';
              })
              .map((i) => i.variantId!)
              .toSet()
              .toList();
          final variantsLookup = variantIds.isEmpty
              ? <String, Variant>{}
              : await capellaStrat.batchGetVariantsByIds(variantIds);
          allocations = rraAllocatedQtyByTransactionItemId(
            items: items,
            variantsByVariantId: variantsLookup,
            snapshotByStockId: snapshot,
            allowSellingBelowStock: true,
          );
          movementItemsForStockIo = movementItemsWithRraCapAllocation(
            items,
            allocations,
          );
        }

        final stockIoSarTyCd = resolveRraStockIoSarTyCd(
          sarTyCd: sarTyCd,
          receiptType: receiptType,
          transactionSarTyCd: transaction.sarTyCd,
        );

        final stockIoTotals = _stockIoEnvelopeTotals(movementItemsForStockIo);
        final stockIoRemark = stockIoSarTyCd == StockInOutType.sale
            ? 'Stock out for sale'
            : (transaction.remark ?? '');

        final stockIoResp = await saveStockItems(
          items: movementItemsForStockIo,
          tinNumber: ebm.tinNumber.toString(),
          bhFId: ebm.bhfId,
          updateMaster: false,
          customerName: transaction.customerName,
          custTin: transaction.customerTin,
          invoiceNumber: highestInvcNo,
          regTyCd: "A",
          sarNo: highestInvcNo.toString(),
          sarTyCd: stockIoSarTyCd,
          custBhfId: transaction.customerBhfId,
          totalSupplyPrice: stockIoTotals.taxable,
          totalvat: stockIoTotals.tax,
          totalAmount: stockIoTotals.total,
          remark: stockIoRemark,
          ocrnDt: transaction.updatedAt ?? DateTime.now().toUtc(),
          URI: taxUrl,
        );
        if (stockIoResp.resultCd != '000') {
          talker.warning(
            'RRA saveStockItems after sale failed: ${stockIoResp.resultCd} '
            '${stockIoResp.resultMsg} (sarTyCd=$stockIoSarTyCd)',
          );
        }

        final tinForMaster = ebm.tinNumber;
        final bhfForMaster = ebm.bhfId;

        for (var item in items) {
          if (item.itemTyCd == '3') continue;
          if (capRra && ((allocations[item.id] ?? 0) <= 0)) continue;
          final vid = item.variantId;
          if (vid == null || vid.isEmpty) continue;

          final Variant? variant = await ProxyService.getStrategy(
            Strategy.capella,
          ).getVariant(id: vid);
          if (variant == null) continue;

          final stockId = variant.stockId;
          if (stockId == null || stockId.isEmpty) continue;

          final Stock stock = await ProxyService.getStrategy(
            Strategy.capella,
          ).getStockById(id: stockId);
          final remainingQty = math.max(
            0.0,
            stock.currentStock?.toDouble() ?? 0.0,
          );

          variant.stock = stock;
          if (variant.tin == null) {
            variant.tin = tinForMaster;
          }
          if (variant.bhfId == null || variant.bhfId!.isEmpty) {
            variant.bhfId = bhfForMaster;
          }

          final masterResp = await ProxyService.tax.saveStockMaster(
            variant: variant,
            URI: taxUrl,
            stockMasterQty: remainingQty,
          );
          if (masterResp.resultCd != '000') {
            talker.warning(
              'RRA saveStockMaster failed for ${variant.itemNm ?? variant.name}: '
              '${masterResp.resultCd} ${masterResp.resultMsg} (rsdQty=$remainingQty)',
            );
          }
        }
      } else if (receiptType == 'NR' || receiptType == 'TR') {
        final sar = await ProxyService.strategy.getSar(
          branchId: ProxyService.box.getBranchId()!,
        );

        sar!.sarNo = sar.sarNo + 1;
        await repository.upsert<Sar>(sar);

        await saveStockItems(
          updateMaster: true,
          items: items,
          tinNumber: ebm.tinNumber.toString(),
          bhFId: ebm.bhfId,
          customerName: transaction.customerName,
          custTin: transaction.customerTin,
          invoiceNumber: transaction.invoiceNumber!,
          regTyCd: "A",
          sarNo: sar.sarNo.toString(),
          sarTyCd: "06",
          custBhfId: transaction.customerBhfId,
          totalSupplyPrice: transaction.subTotal!,
          totalvat: transaction.taxAmount!.toDouble(),
          totalAmount: transaction.subTotal!,
          remark: transaction.remark ?? "",
          ocrnDt: transaction.updatedAt ?? DateTime.now().toUtc(),
          URI: taxUrl,
        );
      }
    } catch (e, s) {
      _talker?.error(e);
      _talker?.error(s);
      await GlobalErrorHandler.logError(
        e,
        stackTrace: s,
        type: "tax_stock_sync_error",
        context: {
          'businessId': ProxyService.box.getBusinessId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } finally {
      ProxyService.box.remove(key: snapshotKey);
    }
  }

  @override
  Future<RwApiResponse> generateReceiptSignature({
    required ITransaction transaction,
    required String receiptType,
    String? purchaseCode,
    required DateTime timeToUser,
    required String URI,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? sarTyCd,
    String? custMblNo,
    required String customerName,
    Customer? customer,
    List<TransactionItem>? preloadedItems,
    bool deferStockSync = false,
  }) async {
    if ((isAndroid || isIos) && URI.contains('localhost')) {
      return RwApiResponse(
        resultCd: "000",
        resultMsg: "Skipped localhost call on mobile",
      );
    }
    final repository = Repository();
    // Get business details
    final capella = ProxyService.getStrategy(Strategy.capella);
    Business? business = await capella.getBusiness(
      businessId: ProxyService.box.getBusinessId()!,
    );
    String branchId = (await capella.activeBranch(
      branchId: ProxyService.box.getBranchId()!,
    )).id;
    Ebm? ebm = await capella.ebm(branchId: ProxyService.box.getBranchId()!);
    final List<TransactionItem> items;
    if (preloadedItems != null && preloadedItems.isNotEmpty) {
      items = preloadedItems;
    } else {
      items = await ProxyService.getStrategy(Strategy.capella).transactionItems(
        transactionId: transaction.id,
        branchId: branchId,
        doneWithTransaction: false,
        active: true,
      );
    }

    if (items.isEmpty) {
      throw Exception(
        'Cannot save sale to RRA: itemList is empty for transaction ${transaction.id}',
      );
    }

    // Get the current date and time in the required format yyyyMMddHHmmss
    String date = timeToUser
        .toIso8601String()
        .replaceAll(RegExp(r'[:-\sT]'), '')
        .substring(0, 14);
    final bhfId = ebm!.bhfId;
    // Build item list with proper sequence
    List<Future<Map<String, dynamic>>> itemsFutures = items
        .asMap()
        .entries
        .map(
          (entry) =>
              mapItemToJson(entry.value, bhfId: bhfId, itemSeq: entry.key + 1),
        )
        .toList();
    var itemsList = await Future.wait(itemsFutures);

    // Calculate total for non-tax-exempt items
    //NOTE: before I was excluding tax of type D but in recent test it is no longer wokring
    // I removed where((item) => item.taxTyCd != "D") from bellow line
    double totalTaxable = items.fold(0.0, (sum, item) {
      final dcRt = item.dcRt?.toDouble() ?? 0;
      final discountedPrice = dcRt != 0
          ? item.price.toDouble() *
                item.qty.toDouble() *
                (1 - (dcRt / 100))
          : item.price.toDouble() * item.qty.toDouble();
      return sum + discountedPrice;
    });

    // Get sales and receipt type codes
    Map<String, String> receiptCodes = getReceiptCodes(receiptType);
    var taxTotals = calculateTaxTotals(itemsList);
    List<odm.Counter> _counters =
        await ProxyService.getStrategy(Strategy.capella).getCounters(
          branchId: ProxyService.box.getBranchId()!,
          fetchRemote: false,
        );
    var currentHighestInvcNo = _counters.fold<int>(
      0,
      (prev, c) => math.max(prev, c.invcNo ?? 0),
    );
    if (currentHighestInvcNo <= 0) {
      currentHighestInvcNo = 1;
    }

    // Retrieve customer information

    // Build request data
    var requestData = await buildRequestData(
      business: business,
      custMblNo: custMblNo,
      customerName: customerName,
      customer: customer,
      highestInvcNo: currentHighestInvcNo,
      ebm: ebm,
      bhFId: bhfId,
      salesSttsCd: salesSttsCd,
      transaction: transaction,
      date: date,
      originalInvoiceNumber: originalInvoiceNumber,
      totalTaxable: totalTaxable,
      taxTotals: taxTotals,
      receiptCodes: receiptCodes,
      itemsList: itemsList,
      purchaseCode: purchaseCode,
      timeToUse: timeToUser,
      receiptType: receiptType,
    );

    if (URI.trim().isEmpty) {
      throw Exception(
        'Tax server URL is empty. Configure EBM tax server URL for branch $branchId.',
      );
    }

    try {
      // Send request
      final url = Uri.parse(
        URI,
      ).replace(path: Uri.parse(URI).path + 'trnsSales/saveSales').toString();

      RwApiResponse? successData;
      for (var saveAttempt = 0; saveAttempt < 3; saveAttempt++) {
        final response = await sendPostRequest(url, requestData);

        if (response.statusCode != 200) {
          throw Exception(
            "Failed to send request. Status Code: ${response.statusCode}",
          );
        }

        ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
        final data = RwApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          final msg = data.resultMsg;
          if (saveAttempt < 2 && _rwTaxIsQtyUnitCdCodeValueError(msg)) {
            talker.warning(
              'RRA rejected qtyUnitCd; defaulting transaction lines and variants to U and retrying saveSales.',
            );
            await _healQtyUnitCdToDefaultUnits(items);
            final retryFutures = items
                .asMap()
                .entries
                .map(
                  (entry) => mapItemToJson(
                    entry.value,
                    bhfId: bhfId,
                    itemSeq: entry.key + 1,
                  ),
                )
                .toList();
            itemsList = await Future.wait(retryFutures);
            taxTotals = calculateTaxTotals(itemsList);
            requestData = await buildRequestData(
              business: business,
              custMblNo: custMblNo,
              customerName: customerName,
              customer: customer,
              highestInvcNo: currentHighestInvcNo,
              ebm: ebm,
              bhFId: bhfId,
              salesSttsCd: salesSttsCd,
              transaction: transaction,
              date: date,
              originalInvoiceNumber: originalInvoiceNumber,
              totalTaxable: totalTaxable,
              taxTotals: taxTotals,
              receiptCodes: receiptCodes,
              itemsList: itemsList,
              purchaseCode: purchaseCode,
              timeToUse: timeToUser,
              receiptType: receiptType,
            );
            continue;
          }

          if (saveAttempt < 2 && msg == "Invoice number already exists.") {
            talker.warning(
              'Invoice number $currentHighestInvcNo already exists; incrementing and retrying saveSales.',
            );
            currentHighestInvcNo += 1;
            await persistCapellaCountersInvcNo(currentHighestInvcNo);
            requestData = await buildRequestData(
              business: business,
              custMblNo: custMblNo,
              customerName: customerName,
              customer: customer,
              highestInvcNo: currentHighestInvcNo,
              ebm: ebm,
              bhFId: bhfId,
              salesSttsCd: salesSttsCd,
              transaction: transaction,
              date: date,
              originalInvoiceNumber: originalInvoiceNumber,
              totalTaxable: totalTaxable,
              taxTotals: taxTotals,
              receiptCodes: receiptCodes,
              itemsList: itemsList,
              purchaseCode: purchaseCode,
              timeToUse: timeToUser,
              receiptType: receiptType,
            );
            continue;
          }

          Exception exception = Exception(msg);

          if (msg == "Invoice number already exists.") {
            exception = Exception(
              "Error occurred, please try again. If the problem persists, contact support.",
            );
          }

          GlobalErrorHandler.logError(
            exception,
            type: "tax_error",
            context: {
              'resultCode': data.resultCd,
              'businessId': ProxyService.box.getBusinessId(),
              'timestamp': DateTime.now().toIso8601String(),
            },
          );

          throw exception;
        }

        data.usedInvcNo = currentHighestInvcNo;
        await persistCapellaCountersInvcNo(currentHighestInvcNo + 1);
        successData = data;
        break;
      }

      if (successData == null) {
        throw Exception('Unexpected: saveSales completed without a response.');
      }

      final data = successData;
      // remove any tin saved in local storage on success
      ProxyService.box.remove(key: 'customerTin');
      if (deferStockSync) {
        // Quick-selling: deduction + saveStockItems → saveStockMaster in
        // runPostSaleStockDeductionAndRraSync after saveSales.
      } else {
        unawaited(
          _syncStockAfterSuccessfulSaveSales(
            receiptType: receiptType,
            items: items,
            ebm: ebm,
            highestInvcNo: currentHighestInvcNo,
            sarTyCd: sarTyCd,
            transaction: transaction,
            repository: repository,
          ),
        );
      }
      return data;
    } catch (e, s) {
      _talker?.error(e);
      _talker?.error(s);
      rethrow;
    }
  }

  /// Default [qtyUnitCd] to RRA-safe "U" on line items and linked variants (see doc 4.6 / CoreSync).
  Future<void> _healQtyUnitCdToDefaultUnits(List<TransactionItem> items) async {
    final repository = Repository();
    for (final line in items) {
      line.qtyUnitCd = 'U';
      line.lastTouched = DateTime.now().toUtc();
      await repository.upsert<TransactionItem>(
        line,
        policy: OfflineFirstUpsertPolicy.optimisticLocal,
      );
      final vid = line.variantId;
      if (vid == null) continue;
      final variant = await ProxyService.getStrategy(
        Strategy.capella,
      ).getVariant(id: vid);
      if (variant == null) continue;
      variant.qtyUnitCd = 'U';
      variant.lastTouched = DateTime.now().toUtc();
      await repository.upsert<Variant>(variant);
    }
  }

  // Helper function to map TransactionItem to JSON
  Future<Configurations> _taxConfigForType(String taxType) async {
    final branchId = ProxyService.box.getBranchId()!;
    final cacheKey = '$branchId|$taxType';
    final cached = _taxConfigByBranchAndType[cacheKey];
    if (cached != null) return cached;

    final repository = Repository();
    final taxConfigs = await repository.get<Configurations>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: Query(
        where: [
          Where('taxType').isExactly(taxType),
          Where('branchId').isExactly(branchId),
        ],
      ),
    );
    if (taxConfigs.isEmpty) {
      throw Exception('Failed to get tax config for $taxType');
    }
    final config = taxConfigs.first;
    _taxConfigByBranchAndType[cacheKey] = config;
    return config;
  }

  Future<Configurations> _taxConfigForItem(TransactionItem item) =>
      _taxConfigForType(item.taxTyCd ?? 'B');

  /// Stock I/O lines (`saveStockItems`) — see [mapRraStockIoItemToJson].
  Map<String, dynamic> mapStockIoItemToJson(
    TransactionItem item, {
    required String bhfId,
    num? approvedQty,
    int? itemSeq,
  }) => mapRraStockIoItemToJson(
    item,
    bhfId: bhfId,
    approvedQty: approvedQty,
    itemSeq: itemSeq,
  );

  Future<Map<String, dynamic>> mapItemToJson(
    TransactionItem item, {
    required String bhfId,
    num? approvedQty,
    int? itemSeq,
  }) async {
    final taxConfig = await _taxConfigForItem(item);

    // Base calculations
    final unitPrice = item.price;
    final quantity = approvedQty ?? item.qty;
    final baseTotal = unitPrice * quantity;

    // Calculate discount amount correctly for the total
    final discountRate = item.dcRt ?? 0.0;
    final totalDiscountAmount = (baseTotal * discountRate) / 100;

    // Calculate total after discount
    final totalAfterDiscount = baseTotal - totalDiscountAmount;

    talker.warning("DISCOUNT${totalAfterDiscount}");

    // Get tax percentage and calculate tax based on the item's taxTyCd
    final taxPercentage = taxConfig.taxPercentage ?? 0.0;
    // Formula: taxAmount = (totalAfterDiscount * taxPercentage) / (100 + taxPercentage)
    // Example for 18%: taxAmount = (totalAfterDiscount * 18) / 118
    // This extracts the tax from a tax-inclusive price
    double taxAmount =
        (totalAfterDiscount * taxPercentage) / (100 + taxPercentage);
    taxAmount = (taxAmount * 100).round() / 100;

    // Calculate ttTaxAmt for TT items (Tourism Tax is ADDITIONAL to regular tax)
    double ttTaxAmount = 0.0;
    double ttTaxblBase = 0.0;
    if (item.ttCatCd == 'TT') {
      final ttTaxConfig = await _taxConfigForType('TT');
      final ttTaxPercentage = ttTaxConfig.taxPercentage ?? 0.0;

      // Determine taxable base for TT tax depending on the item's tax type
      // For items with VAT (taxTyCd: B or C), prices are VAT-inclusive and we need to extract the base
      // For items without VAT (taxTyCd: A or D), prices don't include VAT, so use full amount
      String itemTaxType = item.taxTyCd ?? "B";

      if (itemTaxType == "B" || itemTaxType == "C") {
        // VAT-inclusive items: remove VAT to get the base for TT calculation
        // Formula: base = totalAfterDiscount / (1 + taxPercentage/100)
        // Example for 18%: base = totalAfterDiscount / 1.18
        // Example for 10%: base = totalAfterDiscount / 1.10
        // This correctly handles different VAT rates for B and C
        ttTaxblBase = totalAfterDiscount / (1 + (taxPercentage / 100));
      } else {
        // Non-VAT items (A: Exempt, D: Non-VAT): use full amount as base
        // These items don't have VAT included in their price
        ttTaxblBase = totalAfterDiscount;
      }

      // Calculate ttTaxAmt using TT tax percentage on the base
      // Formula: ttTaxAmt = (base * ttTaxPercentage) / (100 + ttTaxPercentage)
      ttTaxAmount = ttTaxblBase * ttTaxPercentage / (100 + ttTaxPercentage);
      ttTaxAmount = (ttTaxAmount * 100).round() / 100;
    }

    final itemJson = TransactionItem(
      ttCatCd: item.ttCatCd == 'TT' ? 'TT' : null,
      lastTouched: DateTime.now().toUtc(),
      qty: quantity,
      discount: item.discount,
      remainingStock: item.remainingStock?.toDouble().roundToTwoDecimalPlaces(),
      itemCd: item.itemCd,
      variantId: item.variantId,
      qtyUnitCd: item.qtyUnitCd,
      regrNm: item.regrNm ?? "Registrar",

      // Fixed calculations
      dcRt: discountRate.toDouble().roundToTwoDecimalPlaces(),
      dcAmt: totalDiscountAmount.roundToTwoDecimalPlaces(),
      totAmt: totalAfterDiscount.roundToTwoDecimalPlaces(),
      // RRA itemList: pkg = package count (1), qty = unit quantity — not the same.
      pkg: _rraItemListPkgCount(item),
      taxblAmt: totalAfterDiscount.roundToTwoDecimalPlaces(),
      taxAmt: taxAmount.roundToTwoDecimalPlaces(),
      itemClsCd: item.itemClsCd,
      itemNm: item.name,
      itemSeq: itemSeq ?? item.itemSeq ?? 1,
      isrccCd: "",
      isrccNm: "",
      isrcRt: 0,
      isrcAmt: 0,
      taxTyCd: item.taxTyCd,
      bcd: item.bcd,
      itemTyCd: item.itemTyCd,
      itemStdNm: item.name,
      orgnNatCd: item.orgnNatCd ?? "RW",
      pkgUnitCd: item.pkgUnitCd,
      splyAmt: ((item.supplyPrice ?? item.price) * quantity)
          .toDouble()
          .roundToTwoDecimalPlaces(),
      price: item.price,
      bhfId: item.bhfId ?? bhfId,
      // removed this as in richard example it was not there.
      // dftPrc: baseTotal,
      addInfo: "",
      isrcAplcbYn: "N",
      prc: item.price,
      useYn: "Y",
      regrId:
          item.regrId?.toString() ?? randomNumber().toString().substring(0, 15),
      modrId: item.modrId ?? randomString().substring(0, 8),
      modrNm: item.modrNm ?? randomString().substring(0, 8),
      name: item.name,
    ).toFlipperJson();

    itemJson.removeWhere(
      (key, value) =>
          [
            "active",
            "doneWithTransaction",
            "isRefunded",
            "isTaxExempted",
            "updatedAt",
            "createdAt",
            "remainingStock",
            "discount",
            "transactionId",
            "bhfId",
            "lastTouched",
            "deletedAt",
            "action",
            "branchId",
          ].contains(key) ||
          value == null ||
          value == "",
    );

    if (itemJson["isrccCd"] == "" || itemJson["isrccNm"] == "") {
      itemJson.removeWhere(
        (key, value) => key == "isrccCd" || key == "isrccNm",
      );
    }

    // Add ttTaxAmt and ttTaxblAmt to the JSON if it's a TT item (after cleanup)
    if (item.ttCatCd == 'TT') {
      // Add TT taxable amount (calculated above based on item's tax type)
      itemJson['ttTaxblAmt'] = ttTaxblBase.roundToTwoDecimalPlaces();
      itemJson['ttTaxAmt'] = ttTaxAmount.roundToTwoDecimalPlaces();
      itemJson['ttCatCd'] = "TT";
    }

    if ((item.taxTyCd ?? '').toUpperCase() == 'F') {
      final rrp = (item as dynamic).rrp as num?;
      final prftDcAmt = (item as dynamic).prftDcAmt as num? ?? 0;
      final unitPrice = item.price.toDouble();
      final quantity = (approvedQty ?? item.qty).toDouble();
      final splyAmt = unitPrice * quantity;
      final taxableBase = splyAmt - prftDcAmt.toDouble();
      final fuelTaxPct = taxPercentage;
      final fuelTaxAmt = taxableBase > 0
          ? double.parse(
              (taxableBase * fuelTaxPct / (100 + fuelTaxPct)).toStringAsFixed(
                2,
              ),
            )
          : 0.0;
      final fuelTaxbl = taxableBase - fuelTaxAmt;
      itemJson['taxTyCd'] = 'F';
      itemJson['rrp'] = (rrp ?? unitPrice).toDouble().roundToTwoDecimalPlaces();
      itemJson['prc'] = unitPrice.roundToTwoDecimalPlaces();
      itemJson['prftDcAmt'] = prftDcAmt.toDouble().roundToTwoDecimalPlaces();
      itemJson['splyAmt'] = splyAmt.roundToTwoDecimalPlaces();
      itemJson['taxblAmt'] = fuelTaxbl.roundToTwoDecimalPlaces();
      itemJson['taxAmt'] = fuelTaxAmt.roundToTwoDecimalPlaces();
      itemJson['totAmt'] = splyAmt.roundToTwoDecimalPlaces();
      itemJson['dcRt'] = 0;
      itemJson['dcAmt'] = 0;
    }

    // always make itemSeq be first in object
    Map<String, dynamic> sortedItemJson = Map.from(itemJson);
    final itemSeqValue = sortedItemJson.remove('itemSeq');
    sortedItemJson.addAll({'itemSeq': itemSeqValue});

    final qUnit =
        sortedItemJson['qtyUnitCd'] ?? item.qtyUnitCd ?? item.pkgUnitCd ?? 'U';
    sortedItemJson['qtyUnitCd'] = qUnit is String && qUnit.isNotEmpty
        ? qUnit
        : 'U';

    return sortedItemJson;
  }

  // Helper function to determine receipt type codes
  Map<String, String> getReceiptCodes(String receiptType) {
    switch (receiptType) {
      case 'NR':
        return {'salesTyCd': 'N', 'rcptTyCd': 'R'};
      case 'CR':
        return {'salesTyCd': 'C', 'rcptTyCd': 'R'};
      case 'NS':
        return {'salesTyCd': 'N', 'rcptTyCd': 'S'};
      case 'CS':
        return {'salesTyCd': 'C', 'rcptTyCd': 'S'};
      case 'TS':
        return {'salesTyCd': 'T', 'rcptTyCd': 'S'};
      case 'PS':
        return {'salesTyCd': 'P', 'rcptTyCd': 'S'};
      case 'TR':
        return {'salesTyCd': 'T', 'rcptTyCd': 'R'};
      default:
        return {'salesTyCd': 'N', 'rcptTyCd': 'R'};
    }
  }

  // Helper function to build request data
  Future<Map<String, dynamic>> buildRequestData({
    required Business? business,
    required Ebm? ebm,
    required int highestInvcNo,
    required ITransaction transaction,
    required String date,
    required double totalTaxable,
    required Map<String, double> taxTotals,
    required Map<String, String> receiptCodes,
    Customer? customer,
    required List<Map<String, dynamic>> itemsList,
    String? purchaseCode,
    required String receiptType,
    required DateTime timeToUse,
    required String bhFId,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? custMblNo,
    required String customerName,
  }) async {
    final capella = ProxyService.getStrategy(Strategy.capella);
    odm.Configurations? taxConfigTaxB = await capella.getByTaxType(
      taxtype: "B",
    );
    odm.Configurations? taxConfigTaxA = await capella.getByTaxType(
      taxtype: "A",
    );
    odm.Configurations? taxConfigTaxC = await capella.getByTaxType(
      taxtype: "C",
    );
    odm.Configurations? taxConfigTaxD = await capella.getByTaxType(
      taxtype: "D",
    );
    odm.Configurations? taxConfigTaxTT = await capella.getByTaxType(
      taxtype: "TT",
    );
    odm.Configurations? taxConfigTaxF = await capella.getByTaxType(
      taxtype: "F",
    );

    final fuelTaxRate = taxConfigTaxF?.taxPercentage ?? 18.0;
    final taxAmtF = double.parse(
      ((taxTotals['F'] ?? 0.0) * fuelTaxRate / (100 + fuelTaxRate))
          .toStringAsFixed(2),
    );
    final taxAmtB = double.parse(
      ((taxTotals['B'] ?? 0.0) * 18 / 118).toStringAsFixed(2),
    );
    final totalTax = taxAmtB + taxAmtF;
    talker.warning("HARD COPY TOTALTAX: ${totalTax.toStringAsFixed(2)}");

    final hasFuelLine = itemsList.any(
      (line) => (line['taxTyCd'] as String?)?.toUpperCase() == 'F',
    );

    final topMessage = [
      business?.name ?? 'Our Business',
      business?.adrs?.isNotEmpty == true ? business!.adrs : '',
      'TEL: ${business?.phoneNumber?.replaceAll("+", "") ?? '0780000000'}',
      'Email: ${business?.email ?? 'info@yegobox.com'}',
      'TIN: ${ebm?.tinNumber ?? '999909695'}',
      'WELCOME TO OUR SHOP',
    ].join('\n');

    talker.error("TopMessage: $topMessage");
    talker.error("TINN: ${ebm?.tinNumber}");
    final pmtTyCd = ProxyService.box.pmtTyCd();
    // Resolve customer object if transaction has a customerId but no
    // customer object was provided by the caller.

    // Use the highest available invoice number across branch counters for the
    // top-level `invcNo` (covers all receipt types like NS, TS, etc.). We
    // intentionally fetch local counters (fetchRemote: false) to avoid blocking
    // remote calls during request build; this mirrors the behavior used when
    // resolving counters elsewhere.

    Map<String, dynamic> json = {
      "tin": ebm?.tinNumber.toString() ?? "999909695",
      "bhfId": bhFId,
      // Use highest counter value for invoice number (as requested)
      "invcNo": highestInvcNo,
      "salesTyCd": receiptCodes['salesTyCd'],
      "rcptTyCd": receiptCodes['rcptTyCd'],
      "pmtTyCd": pmtTyCd,
      "salesSttsCd": salesSttsCd,
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      // "stockRlsDt": timeToUse.toYYYYMMddHHmmss(),
      "stockRlsDt": date,
      "totItemCnt": itemsList.length,

      // Ensure tax amounts and taxable amounts are set to 0 if null
      "taxblAmtA": (taxTotals['A'] ?? 0.0).roundToTwoDecimalPlaces(),
      "taxblAmtB": (taxTotals['B'] ?? 0.0).roundToTwoDecimalPlaces(),
      "taxblAmtC": (taxTotals['C'] ?? 0.0).roundToTwoDecimalPlaces(),
      "taxblAmtD": (taxTotals['D'] ?? 0.0).roundToTwoDecimalPlaces(),
      "taxblAmtTt": (taxTotals['ttTaxblAmt'] ?? 0.0).roundToTwoDecimalPlaces(),
      "taxblAmtF": (taxTotals['F'] ?? 0.0).roundToTwoDecimalPlaces(),

      "taxAmtA":
          ((taxTotals['A'] ?? 0.0) *
                  (taxConfigTaxA!.taxPercentage ?? 0) /
                  (100 + (taxConfigTaxA.taxPercentage ?? 0)))
              .toStringAsFixed(2),
      "taxAmtB": taxAmtB,
      "taxAmtC": double.parse(
        ((taxTotals['C'] ?? 0.0) *
                (taxConfigTaxC!.taxPercentage ?? 0) /
                (100 + (taxConfigTaxC.taxPercentage ?? 0)))
            .toStringAsFixed(2),
      ),
      "taxAmtD": double.parse(
        ((taxTotals['D'] ?? 0.0) *
                (taxConfigTaxD!.taxPercentage ?? 0) /
                (100 + (taxConfigTaxD.taxPercentage ?? 0)))
            .toStringAsFixed(2),
      ),
      "ttTaxAmt": (taxTotals['ttTaxAmt'] ?? 0.0),
      "taxAmtF": taxAmtF,

      "taxRtA": taxConfigTaxA.taxPercentage,
      "taxRtB": taxConfigTaxB!.taxPercentage,
      "taxRtC": taxConfigTaxC.taxPercentage,
      "taxRtD": taxConfigTaxD.taxPercentage,
      "taxRtF": fuelTaxRate,
      "ttTaxRt": taxConfigTaxTT!.taxPercentage,

      "totTaxblAmt": totalTaxable.roundToTwoDecimalPlaces(),

      "totTaxAmt": (totalTax).roundToTwoDecimalPlaces(),
      "totAmt": totalTaxable.roundToTwoDecimalPlaces(),

      "regrId": transaction.id.substring(0, 5),
      "regrNm": transaction.id.substring(0, 5),
      "modrId": transaction.id.substring(0, 5),
      "modrNm": transaction.id.substring(0, 5),
      // Always use the customer name from ProxyService.box.customerName()
      // This ensures consistency with what's entered in QuickSellingView
      "custNm": customerName,
      "remark": "",
      "prchrAcptcYn": "Y",
      "receipt": {
        "prchrAcptcYn": "Y",
        // Use highest invoice number in the receipt sub-object as well
        "rptNo": highestInvcNo,
        "adrs": business?.adrs ?? "",
        "topMsg": topMessage,
        "btmMsg": "THANK YOU COME BACK AGAIN",
        "custMblNo": custMblNo,
      },
      "itemList": itemsList,
    };
    if (hasFuelLine) {
      final salePurpose = (transaction as dynamic).salePurposeCd as String?;
      if (salePurpose != null && salePurpose.isNotEmpty) {
        json['salePurposeCd'] = salePurpose;
      }
    }
    if (receiptType == "NR" || receiptType == "CR" || receiptType == "TR") {
      json['rfdRsnCd'] = ProxyService.box.getRefundReason() ?? "05";

      /// this is normal refund add rfdDt refunded date
      /// ATTENTION: rfdDt was added later and it might cause trouble we need to watch out.
      /// 'rfdDt': Must be a valid date in yyyyMMddHHmmss format. rejected value: '20241107'
      json['rfdDt'] = timeToUse.toYYYMMddHHmmss();

      // get a transaction being refunded
      // final trans = ProxyService.strategy.getTransactionById(
      //     id: transaction.id!);
      json['orgInvcNo'] =
          originalInvoiceNumber ?? transaction.invoiceNumber ?? 0;
    } else {
      /// rra api does not accept real invoice number when we are dealing with CS receipt.
      json['orgInvcNo'] = 0;
    }
    if (transaction.customerId != null) {
      json = addFieldIfCondition(
        customer: customer,
        json: json,
        transaction: transaction,
        purchaseCode: purchaseCode ?? ProxyService.box.purchaseCode(),
      );
    }
    // print(json);
    return json;
  }

  // Define these constants at the top level of your file
  String customerTypeBusiness = "Business";
  String custTinKey = "custTin";
  String custNmKey = "custNm";
  String prcOrdCd = "prcOrdCd";

  Map<String, dynamic> addFieldIfCondition({
    required Map<String, dynamic> json,
    required ITransaction transaction,
    Customer? customer,
    String? purchaseCode,
  }) {
    if (transaction.customerId != null &&
        purchaseCode != null &&
        transaction.customerTin != null &&
        transaction.customerTin!.isNotEmpty) {
      json[custTinKey] = transaction.customerTin;
      ProxyService.box.customerTin();
      json[custNmKey] =
          transaction.customerName ??
          customer?.custNm ??
          ProxyService.box.customerName() ??
          "";
      json[prcOrdCd] = purchaseCode;
      json['receipt'][custTinKey] =
          transaction.customerTin ?? customer?.custTin;
    }
    return json;
  }

  @override
  Future<RwApiResponse> saveCustomer({
    required ICustomer customer,
    required String URI,
  }) async {
    talker.info("URI::1:${URI}");
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'branches/saveBrancheCustomers')
        .toString();
    int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);

    try {
      final requiredObjc = {
        "tin": tin!,
        "bhfId": customer.bhfId,
        "custNo": customer.custNo,
        "custTin": customer.custTin,
        "custNm": customer.custNm,
        "adrs": customer.adrs,
        "telNo": customer.telNo,
        "email": customer.email,
        // "faxNo": customer.faxNo,
        "useYn": "Y",
        // "remark": customer.remark,
        "modrId": customer.modrId,
        "modrNm": customer.custNm,
        "regrId": customer.regrId,
        "regrNm": customer.custNm,
      };
      final response = await sendPostRequest(url, requiredObjc);

      if (response.statusCode == 200) {
        sendEmailLogging(
          requestBody: customer.toJson().toString(),
          subject: "Worked",
          body: response.data.toString(),
        );

        final data = RwApiResponse.fromJson(response.data);
        return data;
      } else {
        throw Exception(
          "Failed to send request. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      // Handle the exception
      print(e);
      rethrow;
    }
  }

  String convertDateToString(DateTime date) {
    // Define the desired output format
    final outputFormat = DateFormat('yyyyMMddHHmmss');

    // Format the date as desired
    return outputFormat.format(date);
  }

  @override
  Future<RwApiResponse> savePurchases({
    required Purchase item,
    required String URI,
    String rcptTyCd = "S",
    String regTyCd = "A",
    required String bhfId,
    required List<Variant> variants,
    required Business business,
    required String pchsSttsCd,
  }) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'trnsPurchase/savePurchases')
        .toString();
    Ebm? ebm = await ProxyService.strategy.ebm(
      branchId: ProxyService.box.getBranchId()!,
    );
    Map<String, dynamic> data = item.toFlipperJson();
    data['tin'] = ebm?.tinNumber ?? 999909695;
    data['bhfId'] = bhfId;
    data['pchsDt'] = convertDateToString(DateTime.now()).substring(0, 8);
    data['invcNo'] = item.spplrInvcNo;
    data['regrId'] = randomNumber().toString();
    data['pchsSttsCd'] = pchsSttsCd; // purchase status 02= approved.
    data['modrNm'] = randomNumber().toString();
    data['orgInvcNo'] = item.spplrInvcNo;
    data['regrNm'] = randomNumber();
    data['totItemCnt'] = variants.length;
    data['pchsTyCd'] = 'N'; // transaction type N=normal
    data['cfmDt'] = convertDateToString(DateTime.now());
    data['regTyCd'] = regTyCd;
    data['modrId'] = randomNumber();
    // P is refund after sale
    data['rcptTyCd'] = rcptTyCd;
    data['itemList'] = variants.map((variant) {
      variant.qty = variant.stock?.currentStock ?? 0;
      return variant.toFlipperJson();
    }).toList();
    final talker = Talker();
    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894" || respond.resultCd != "000") {
          throw Exception(respond.resultMsg);
        }
        // update variant with the new rcptTyCd
        Variant variant = variants.first;
        variant.pchsSttsCd = pchsSttsCd;
        ProxyService.strategy.updateVariant(updatables: [variant]);
        return respond;
      } else {
        throw Exception(
          'Failed to fetch import items. Status code: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastReqDt,
    required String URI,
  }) async {
    if (ProxyService.box.enableDebug() ?? false) {
      final String jsonString = await rootBundle.loadString(
        'packages/flipper_models/jsons/import.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return RwApiResponse.fromJson(jsonMap);
    }
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'imports/selectImportItems')
        .toString();

    final talker = Talker();
    final data = {'tin': tin, 'bhfId': bhfId, 'lastReqDt': lastReqDt};

    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894") {
          throw Exception(respond.resultMsg);
        }
        return respond;
      } else {
        throw Exception(
          'Failed to fetch import items. Status code: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> selectTrnsPurchaseSales({
    required int tin,
    required String bhfId,
    required String URI,
    required String lastReqDt,
  }) async {
    print("selectTrnsPurchaseSales ${ProxyService.box.enableDebug()}");
    if (ProxyService.box.enableDebug() ?? false) {
      final String jsonString = await rootBundle.loadString(
        'packages/flipper_models/jsons/purchase.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return RwApiResponse.fromJson(jsonMap);
    }
    final url = Uri.parse(URI)
        .replace(
          path: Uri.parse(URI).path + 'trnsPurchase/selectTrnsPurchaseSales',
        )
        .toString();

    final data = {'tin': tin, 'bhfId': bhfId, 'lastReqDt': lastReqDt};
    final talker = Talker();
    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894") {
          throw Exception(respond.resultMsg);
        }
        return respond;
      } else {
        throw Exception(
          'Failed to fetch import items. Status code: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> updateImportItems({
    required Variant item,
    required String URI,
  }) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'imports/updateImportItems')
        .toString();

    final data = item.toFlipperJson();
    final talker = Talker();

    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894" ||
            respond.resultCd != "000" ||
            respond.resultCd == "910") {
          throw Exception(respond.resultMsg);
        }

        /// I need to also receive both retail and supply price from user
        return respond;
      } else {
        throw Exception(
          'Failed to fetch import items. Status code: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<bool> stockIn({
    required Map<String, Object?> json,
    required String URI,
    required String sarTyCd,
  }) async {
    talker.warning("Processing stockIn");
    final url = Uri.parse(
      URI,
    ).replace(path: Uri.parse(URI).path + 'stock/saveStockItems').toString();
    await sendPostRequest(url, json);
    return true;
  }

  @override
  Future<bool> stockOut({
    required Map<String, Object?> json,
    required String URI,
    required String sarTyCd,
  }) async {
    talker.warning("Processing stockOut");
    final url = Uri.parse(
      URI,
    ).replace(path: Uri.parse(URI).path + 'stock/saveStockItems').toString();
    await sendPostRequest(url, json);
    return true;
  }

  @override
  Future<List<odm.Configurations>> taxConfigs({
    required String branchId,
  }) async {
    final repository = Repository();
    List<Configurations> taxConfigs = await repository.get<Configurations>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
    return taxConfigs;
  }

  @override
  Future<List<Notice>> fetchNotices({required String URI}) async {
    talker.warning("Processing stockOut");
    final url = Uri.parse(
      URI,
    ).replace(path: Uri.parse(URI).path + 'notices/selectNotices').toString();
    final data = {
      "tin": (await ProxyService.strategy.ebm(
        branchId: ProxyService.box.getBranchId()!,
      ))?.tinNumber,
      "bhfId": await ProxyService.box.bhfId(),
      "lastReqDt": "20200218191141",
    };
    final response = await sendPostRequest(url, data);
    if (response.statusCode == 200) {
      try {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894" ||
            respond.resultCd != "000" ||
            respond.resultCd == "910") {
          throw Exception(respond.resultMsg);
        }
        // The response contains a data object with noticeList
        final noticeList = jsonResponse['data']['noticeList'] as List<dynamic>;
        String branchId = (await ProxyService.strategy.branch(
          serverId: ProxyService.box.getBranchId()!,
        ))!.id;
        noticeList.map((noticeJson) {
          // Generate a UUID for each notice since it's required by the model
          final id = Uuid().v4();
          return Notice.fromJson({
            ...noticeJson,
            'id': id,
            'branchId': branchId,
          });
        }).toList();
        // now check if there exist notice with same noticeNo it not save it in db using repository
        final repository = Repository();
        for (var noticeJson in noticeList) {
          // Create notice with branchId
          final id = Uuid().v4();
          final notice = Notice.fromJson({
            ...noticeJson,
            'id': id,
            'branchId': branchId,
          });

          // Check if notice exists with same noticeNo and branchId
          final noticeExists = await repository.get<Notice>(
            policy: OfflineFirstGetPolicy.awaitRemote,
            query: Query(
              where: [
                Where('noticeNo').isExactly(notice.noticeNo),
                Where('branchId').isExactly(branchId),
              ],
            ),
          );

          if (noticeExists.isEmpty) {
            await repository.upsert<Notice>(notice);
          }
        }
        return noticeList
            .map((noticeJson) => Notice.fromJson(noticeJson))
            .toList();
      } catch (e) {
        talker.error(e);
        rethrow;
      }
    } else {
      throw Exception(
        'Failed to fetch import items. Status code: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<Notice>> notices({required String branchId}) {
    final repository = Repository();
    return repository.get<Notice>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }
}
