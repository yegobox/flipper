import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:supabase_models/brick/models/all_models.dart' as odm;
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:flipper_models/NetworkHelper.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
// ignore: unused_import
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:supabase_models/brick/models/notice.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

class RWTax with NetworkHelper, TransactionMixinOld implements TaxApi {
  String itemPrefix = "flip-";
  Dio? _dio;
  Talker? _talker;

  @override
  Dio? get dioInstance => _dio;

  @override
  get talkerInstance => _talker;
  RWTax() {
    _talker = Talker();
    _dio = Dio(BaseOptions(
      // Set default connect timeout to 5 seconds
      connectTimeout: const Duration(seconds: 5),
      // Set default receive timeout to 3 seconds
      receiveTimeout: const Duration(seconds: 30),
      // Set default send timeout to 3 seconds
      sendTimeout: const Duration(seconds: 3),
    ));

    _dio!.interceptors.add(TalkerDioLogger(
      talker: _talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseMessage: true,
      ),
    ));
  }

  @override
  Future<BusinessInfo> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
    required String URI, // You're not currently using this URI parameter
  }) async {
    String? token = ProxyService.box.readString(key: 'bearerToken');
    models.Ebm? ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    var headers = {'Authorization': token!, 'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ebm!.taxServerUrl + 'initializer/selectInitInfo'));
    request.body =
        json.encode({"tin": tinNumber, "bhfId": bhfId, "dvcSrlNo": dvcSrlNo});
    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      // Read the response body as a string
      String responseBody = await streamedResponse.stream.bytesToString();

      // Decode the JSON string into a Map
      Map<String, dynamic> jsonMap = jsonDecode(responseBody);

      // Create a BusinessInfoResponse object from the Map
      BusinessInfoResponse response = BusinessInfoResponse.fromJson(jsonMap);

      // Return the BusinessInfo object from the BusinessInfoResponse
      return response.data.info;
    } else {
      // Handle the error case
      print(streamedResponse.reasonPhrase);
      throw Exception(
          'Failed to load BusinessInfo: ${streamedResponse.reasonPhrase}'); // Throw an exception to indicate failure
    }
  }

  @override
  Future<RwApiResponse> saveStockItems(
      {required ITransaction transaction,
      required String tinNumber,
      required String bhFId,
      required String customerName,
      required String custTin,
      String? regTyCd = "A",
      //sarTyCd 11 is for sale
      required String sarTyCd,
      bool isStockIn = false,
      String custBhfId = "",
      required double totalSupplyPrice,
      required double totalvat,
      required double totalAmount,
      required String remark,
      required DateTime ocrnDt,
      required String URI}) async {
    try {
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'stock/saveStockItems')
          .toString();
      final mod = randomNumber().toString();
      final sar = randomNumber();
      final branchId = (await ProxyService.strategy.activeBranch()).id;
      // Query active, done items only
      final items = await ProxyService.strategy.transactionItems(
        branchId: branchId,
        transactionId: transaction.id,
        doneWithTransaction: true,
        active: true,
      );

      List<Map<String, dynamic>> itemsList = await Future.wait(items
          .map((item) async => await mapItemToJson(item, bhfId: bhFId))
          .toList());
      if (itemsList.isEmpty) throw Exception("No items to save");

      itemsList.forEach((item) {
        item['totDcAmt'] = "0";
      });
      // Log the customer name for debugging
      talker.info('Customer name from parameter: $customerName');
      talker.info(
          'Customer name from storage: ${ProxyService.box.customerName()}');

      // Always use the customer name from ProxyService.box.customerName()
      // This ensures consistency with what's entered in QuickSellingView
      final effectiveCustomerName = ProxyService.box.customerName() ?? "N/A";
      talker.info('Using customer name from storage: $effectiveCustomerName');

      final json = {
        "totItemCnt": items.length,
        "tin": tinNumber,
        "bhfId": bhFId,
        "regTyCd": regTyCd,
        "custTin": custTin.isValidTin() ? custTin : "",
        "custNm": effectiveCustomerName,
        "custBhfId": custBhfId,
        "sarTyCd": sarTyCd,
        "ocrnDt": ocrnDt.toYYYMMdd(),
        "totTaxblAmt": totalSupplyPrice,
        "totTaxAmt": totalvat.roundToTwoDecimalPlaces(),
        "totAmt": totalAmount,
        "remark": remark,
        "regrId": mod,
        "regrNm": mod,
        "modrId": sar,
        "modrNm": mod,
        "sarNo": transaction.sarNo,
        "orgSarNo": transaction.orgSarNo,
        "itemList": itemsList
      };
      // if custTin is invalid remove it from the json
      if (!custTin.isValidTin()) {
        json.remove('custTin');
      }
      talker.info(json);
      Response response = await sendPostRequest(url, json);

      final data = RwApiResponse.fromJson(
        response.data,
      );

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
  Future<RwApiResponse> saveStockMaster(
      {required Variant variant, required String URI}) async {
    try {
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'stockMaster/saveStockMaster')
          .toString();

      /// update the remaining stock of this item in rra
      if (variant.stock?.currentStock != null) {
        // Truncate/round to 2 decimal places for RRA compatibility
        variant.rsdQty =
            double.parse(variant.stock!.currentStock!.toStringAsFixed(2));
      } else {
        variant.rsdQty = null;
      }
      if (variant.tin == null) {
        return RwApiResponse(resultCd: "000", resultMsg: "Missing TIN number");
      }

      if (variant.rsdQty == null) {
        return RwApiResponse(
            resultCd: "000", resultMsg: "Missing remaining stock quantity");
      }

      if (variant.itemCd == 'null' || variant.itemCd == null) {
        return RwApiResponse(resultCd: "000", resultMsg: "Missing item code");
      }
      if (variant.itemCd!.isEmpty) {
        return RwApiResponse(
            resultCd: "000", resultMsg: "Invalid data while saving stock");
      }
      if (variant.productName == TEMP_PRODUCT) {
        return RwApiResponse(resultCd: "000", resultMsg: "Invalid product");
      }

      variant.rsdQty =
          double.parse(variant.stock!.currentStock!.toStringAsFixed(2));
      talker.warning("RSD QTY: ${variant.toJson()}");
      // if variant?.itemTyCd  == '3' it means it is a servcice, keep qty to 0, as service does not have stock.
      if (variant.itemTyCd == '3') {
        variant.rsdQty = 0;
      }
      Response response = await sendPostRequest(url, variant.toJson());

      final data = RwApiResponse.fromJson(
        response.data,
      );
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

  void sendEmailLogging(
      {required dynamic requestBody,
      required String subject,
      required String body}) async {
    sendEmailNotification(
        requestBody: json.encode(requestBody).toString(), response: body);
  }

  void logError(dynamic error, StackTrace stackTrace) {
    log('Error: $error\nStack Trace: $stackTrace');
  }

  /// save item to rra api for later purchase
  /// in flipper we don't save product we have variation of product
  /// since this variation are the one to be reported to EBM server at the end.
  /// @[itemCd] @[itemClsCd] @[itemStdNm] and others will be required to be passed
  /// when creating an invoice or receipt
  ///  you can save the product information in server. This API function performs storing item information managed by the taxpayer client in
  /// the server. For more information, refer to '3.2.4.1 ItemSaveReq/Res'
  /// After saving item then we can use items/selectItems endPoint to get the item information. of item saved before
  @override
  Future<RwApiResponse> saveItem(
      {required Variant variation, required String URI}) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'items/saveItems')
        .toString();

    try {
      if (variation.tin == null) {
        return RwApiResponse(
            resultCd: "001", resultMsg: "Invalid Tin Number ${variation.name}");
      }
      if (variation.itemTyCd == null) {
        return RwApiResponse(
            resultCd: "001", resultMsg: "itemTyCd is null ${variation.name}");
      }
      if (variation.itemTyCd?.isEmpty == true) {
        return RwApiResponse(
            resultCd: "001", resultMsg: "Empty itemTyCd ${variation.name}");
      }

      /// first remove fields for imports
      final itemJson = variation.toJson();
      itemJson.removeWhere((key, value) =>
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
            "dcAmt"
          ].contains(key) ||
          value == null ||
          value == "");
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
    String lastReqDt = "20210523000000",
  }) async {
    models.Ebm? ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    if (ebm == null) {
      return false;
    }
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'items/selectItems')
        .toString();

    final data = {
      "tin": tinNumber,
      "bhfId": bhfId,
      "lastReqDt": lastReqDt,
    };

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

  @override
  Future<RwApiResponse> generateReceiptSignature({
    required ITransaction transaction,
    required String receiptType,
    required odm.Counter counter,
    String? purchaseCode,
    required DateTime timeToUser,
    required String URI,
  }) async {
    // Get business details
    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    List<TransactionItem> items = await ProxyService.strategy.transactionItems(
        // never pass in isDoneTransaction param here!
        transactionId: transaction.id,
        branchId: (await ProxyService.strategy.activeBranch()).id);

    // Get the current date and time in the required format yyyyMMddHHmmss
    String date = timeToUser
        .toIso8601String()
        .replaceAll(RegExp(r'[:-\sT]'), '')
        .substring(0, 14);
    final bhfId = (await ProxyService.box.bhfId()) ?? "00";
    // Build item list
    List<Future<Map<String, dynamic>>> itemsFutures =
        items.map((item) => mapItemToJson(item, bhfId: bhfId)).toList();
    List<Map<String, dynamic>> itemsList = await Future.wait(itemsFutures);

    // Calculate total for non-tax-exempt items
    //NOTE: before I was excluding tax of type D but in recent test it is no longer wokring
    // I removed where((item) => item.taxTyCd != "D") from bellow line
    double totalTaxable = items.fold(0.0, (sum, item) {
      double discountedPrice = item.dcRt != 0
          ? item.price *
              item.qty *
              (1 - (item.dcRt! / 100)) // Fixed: Discount calculation
          : item.price * item.qty;
      return sum + discountedPrice; // Fixed: Add to sum
    });

    // Get sales and receipt type codes
    Map<String, String> receiptCodes = getReceiptCodes(receiptType);
    Map<String, double> taxTotals = calculateTaxTotals(itemsList);

    // Retrieve customer information
    Customer? customer = (await ProxyService.strategy.customers(
            id: transaction.customerId,
            branchId: ProxyService.box.getBranchId()!))
        .firstOrNull;

    // Build request data
    Map<String, dynamic> requestData = await buildRequestData(
        business: business,
        counter: counter,
        bhFId: bhfId,
        transaction: transaction,
        date: date,
        totalTaxable: totalTaxable,
        taxTotals: taxTotals,
        receiptCodes: receiptCodes,
        customer: customer,
        itemsList: itemsList,
        purchaseCode: purchaseCode,
        timeToUse: timeToUser,
        receiptType: receiptType);

    try {
      // Send request
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'trnsSales/saveSales')
          .toString();

      final response = await sendPostRequest(url, requestData);

      // Handle response
      if (response.statusCode == 200) {
        ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
        final data = RwApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          // Use GlobalErrorHandler to log the error
          final errorMessage = data.resultMsg + " ${data.resultCd}";
          final exception = Exception(errorMessage);
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

        // Update transaction and item statuses
        updateTransactionAndItems(transaction, items, receiptCodes['rcptTyCd'],
            counter: counter);
        // mark item involved as need sync

        return data;
      } else {
        throw Exception(
            "Failed to send request. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      _talker?.error(e);
      rethrow;
    }
  }

// Helper function to map TransactionItem to JSON
  Future<Map<String, dynamic>> mapItemToJson(TransactionItem item,
      {required String bhfId}) async {
    final repository = Repository();

    List<Configurations> taxConfigs = await repository.get<Configurations>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query(where: [
          Where('taxType').isExactly(item.taxTyCd ?? "B"),
          Where('branchId').isExactly(ProxyService.box.getBranchId()!),
        ]));
    Configurations? taxConfig;
    try {
      taxConfig = taxConfigs.first;
    } catch (e) {
      throw Exception("Failed to get tax config");
    }

    // Base calculations
    final unitPrice = item.price;
    final quantity = item.qty;
    final baseTotal = unitPrice * quantity;

    // Calculate discount amount correctly for the total
    final discountRate = item.dcRt;
    final totalDiscountAmount = (baseTotal * discountRate!) / 100;

    // Calculate total after discount
    final totalAfterDiscount = baseTotal - totalDiscountAmount;

    talker.warning("DISCOUNT${totalAfterDiscount}");

    // Get tax percentage and calculate tax
    final taxPercentage = taxConfig.taxPercentage ?? 0.0;
    double taxAmount =
        (totalAfterDiscount * taxPercentage) / (100 + taxPercentage);
    taxAmount = (taxAmount * 100).round() / 100;

    final itemJson = TransactionItem(
      lastTouched: DateTime.now().toUtc(),
      qty: quantity,
      discount: item.discount,
      remainingStock: item.remainingStock!,
      itemCd: item.itemCd,
      variantId: item.variantId,
      qtyUnitCd: "U",
      regrNm: item.regrNm ?? "Registrar",

      // Fixed calculations
      dcRt: discountRate,
      dcAmt: totalDiscountAmount,
      totAmt: totalAfterDiscount,

      pkg: quantity.toString(),
      taxblAmt: totalAfterDiscount,
      taxAmt: taxAmount,
      itemClsCd: item.itemClsCd,
      itemNm: item.name,
      itemSeq: item.itemSeq,
      isrccCd: "",
      isrccNm: "",
      isrcRt: 0,
      isrcAmt: 0,
      taxTyCd: item.taxTyCd,
      bcd: item.bcd,
      itemTyCd: item.itemTyCd,
      itemStdNm: item.name,
      orgnNatCd: "RW",
      pkgUnitCd: "NT",
      splyAmt: item.price * item.qty,
      price: item.price,
      bhfId: item.bhfId ?? bhfId,
      // removed this as in richard example it was not there.
      // dftPrc: baseTotal,
      addInfo: "",
      isrcAplcbYn: "N",
      prc: item.price,
      useYn: "Y",
      regrId:
          item.regrId?.toString() ?? randomNumber().toString().substring(0, 20),
      modrId: item.modrId ?? randomString().substring(0, 8),
      modrNm: item.modrNm ?? randomString().substring(0, 8),
      name: item.name,
    ).toJson();
    itemJson.removeWhere((key, value) =>
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
          "branchId"
        ].contains(key) ||
        value == null ||
        value == "");

    if (itemJson["isrccCd"] == "" || itemJson["isrccNm"] == "") {
      itemJson
          .removeWhere((key, value) => key == "isrccCd" || key == "isrccNm");
    }
    // always make itemSeq be first in object

    Map<String, dynamic> sortedItemJson = Map.from(itemJson);
    final itemSeqValue = sortedItemJson.remove('itemSeq');
    sortedItemJson.addAll({'itemSeq': itemSeqValue});
    return sortedItemJson;
  }

  Map<String, double> calculateTaxTotals(List<Map<String, dynamic>> items) {
    // Initialize tax totals with zero values
    Map<String, double> taxTotals = {
      'A': 0.0,
      'B': 0.0,
      'C': 0.0,
      'D': 0.0,
    };

    for (var item in items) {
      try {
        // Validate and fetch data with default fallback
        String taxType = (item['taxTyCd'] as String?) ?? 'B';

        // Ensure taxType is one of the valid types
        if (!taxTotals.containsKey(taxType)) {
          print(
              'Warning: Invalid tax type $taxType found. Using default type B');
          taxType = 'B';
        }

        final unitPrice = item['price'];
        final quantity = (item['qty'] as num?)?.toDouble() ?? 0.0;
        final discountRate = item['dcRt'];

        // Calculate unit discount and taxable amount
        double unitDiscount = (unitPrice * discountRate) / 100;
        double unitTaxableAmount = unitPrice - unitDiscount;

        // Multiply by quantity
        double totalTaxableAmount = unitTaxableAmount * quantity;

        // Add to the appropriate tax type total using direct addition
        taxTotals[taxType] = taxTotals[taxType]! + totalTaxableAmount;

        // Optional: Add debug print to verify calculations
        print(
            'Processing item - Tax Type: $taxType, Amount: $totalTaxableAmount, New Total: ${taxTotals[taxType]}');
      } catch (e) {
        print('Error processing item: $item');
        print('Error details: $e');
      }
    }

    return taxTotals;
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
    required odm.Counter counter,
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
  }) async {
    odm.Configurations? taxConfigTaxB =
        await ProxyService.strategy.getByTaxType(taxtype: "B");
    odm.Configurations? taxConfigTaxA =
        await ProxyService.strategy.getByTaxType(taxtype: "A");
    odm.Configurations? taxConfigTaxC =
        await ProxyService.strategy.getByTaxType(taxtype: "C");
    odm.Configurations? taxConfigTaxD =
        await ProxyService.strategy.getByTaxType(taxtype: "D");
    if (transaction.customerId != null) {
      //  it mighbe a copy re-assign a customer
      talker.warning("Overriding customer");
      Customer? cus = (await ProxyService.strategy.customers(
              id: transaction.customerId!,
              branchId: ProxyService.box.getBranchId()!))
          .firstOrNull;
      customer = cus;
      talker.warning(customer);
    }

    /// TODO: for totalTax we are not accounting other taxes only B
    /// so need to account them in future
    final totalTax = ((taxTotals['B'] ?? 0.0) * 18 / 118);
    talker.warning("HARD COPY TOTALTAX: ${totalTax.toStringAsFixed(2)}");

    final topMessage =
        "${business?.name}\n${ProxyService.box.getUserPhone()!.replaceAll("+", "")}\n${business?.adrs?.isNotEmpty == true ? business?.adrs : 'Kigali, Rwanda'}\n${business?.tinNumber ?? '999909695'}";

    talker.error("TopMessage: $topMessage");
    talker.error("TINN: ${business?.tinNumber}");
    final pmtTyCd = ProxyService.box.pmtTyCd();
    Map<String, dynamic> json = {
      "tin": business?.tinNumber.toString() ?? "999909695",
      "bhfId": bhFId,
      "invcNo": counter.invcNo,
      "orgInvcNo": 0,
      "salesTyCd": receiptCodes['salesTyCd'],
      "rcptTyCd": receiptCodes['rcptTyCd'],
      "pmtTyCd": pmtTyCd,
      "salesSttsCd": "02",
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      // "stockRlsDt": timeToUse.toYYYYMMddHHmmss(),
      "stockRlsDt": date,
      "totItemCnt": itemsList.length,

      // Ensure tax amounts and taxable amounts are set to 0 if null
      "taxblAmtA": taxTotals['A'] ?? 0.0,
      "taxblAmtB": (taxTotals['B'] ?? 0.0),
      "taxblAmtC": taxTotals['C'] ?? 0.0,
      "taxblAmtD": taxTotals['D'] ?? 0.0,

      "taxAmtA": ((taxTotals['A'] ?? 0.0) *
              (taxConfigTaxA!.taxPercentage ?? 0) /
              (100 + (taxConfigTaxA.taxPercentage ?? 0)))
          .toStringAsFixed(2),
      "taxAmtB":
          double.parse(((taxTotals['B'] ?? 0.0) * 18 / 118).toStringAsFixed(2)),
      "taxAmtC": double.parse(((taxTotals['C'] ?? 0.0) *
              (taxConfigTaxC!.taxPercentage ?? 0) /
              (100 + (taxConfigTaxC.taxPercentage ?? 0)))
          .toStringAsFixed(2)),
      "taxAmtD": double.parse(((taxTotals['D'] ?? 0.0) *
              (taxConfigTaxD!.taxPercentage ?? 0) /
              (100 + (taxConfigTaxD.taxPercentage ?? 0)))
          .toStringAsFixed(2)),

      "taxRtA": taxConfigTaxA.taxPercentage,
      "taxRtB": taxConfigTaxB!.taxPercentage,
      "taxRtC": taxConfigTaxC.taxPercentage,
      "taxRtD": taxConfigTaxD.taxPercentage,

      "totTaxblAmt": totalTaxable,

      "totTaxAmt": (totalTax).roundToTwoDecimalPlaces(),
      "totAmt": totalTaxable,

      "regrId": transaction.id.substring(0, 5),
      "regrNm": transaction.id.substring(0, 5),
      "modrId": transaction.id.substring(0, 5),
      "modrNm": transaction.id.substring(0, 5),
      // Always use the customer name from ProxyService.box.customerName()
      // This ensures consistency with what's entered in QuickSellingView
      "custNm": ProxyService.box.customerName() ?? "N/A",

      // Log customer name source for debugging
      ...(() {
        final customerName = ProxyService.box.customerName();
        if (customer?.custNm != null) {
          talker.info('Using selected customer name: ${customer!.custNm}');
        } else if (customerName != null) {
          talker.info('Using manually entered customer name: $customerName');
        } else {
          talker.warning('No customer name available, using N/A');
        }
        return <String, dynamic>{};
      }()),
      "remark": "",
      "prchrAcptcYn": "Y",
      "receipt": {
        "prchrAcptcYn": "Y",
        "rptNo": counter.invcNo,
        "adrs": "Kigali, Rwanda",
        "topMsg": topMessage,
        "btmMsg": "THANK YOU COME BACK AGAIN",
        "custMblNo": customer == null
            ? "0" + ProxyService.box.currentSaleCustomerPhoneNumber()!
            : customer.telNo,
      },
      "itemList": itemsList,
    };
    if (receiptType == "NR" || receiptType == "CR" || receiptType == "TR") {
      json['rfdRsnCd'] = ProxyService.box.getRefundReason() ?? "05";
    }
    if (receiptType == "NR" || receiptType == "CR" || receiptType == "TR") {
      /// this is normal refund add rfdDt refunded date
      /// ATTENTION: rfdDt was added later and it might cause trouble we need to watch out.
      /// 'rfdDt': Must be a valid date in yyyyMMddHHmmss format. rejected value: '20241107'
      json['rfdDt'] = timeToUse.toYYYMMddHHmmss();

      // get a transaction being refunded
      // final trans = ProxyService.strategy.getTransactionById(
      //     id: transaction.id!);
      json['orgInvcNo'] = transaction.invoiceNumber;
      // json['orgInvcNo'] = counter.invcNo! - 1;
    }
    if (customer != null) {
      json = addFieldIfCondition(
          customer: customer,
          json: json,
          transaction: transaction,
          purchaseCode: purchaseCode ?? ProxyService.box.purchaseCode());
    }
    // print(json);
    return json;
  }

  /// Helper function to update transaction and item statuses
  Future<void> updateTransactionAndItems(ITransaction transaction,
      List<TransactionItem> items, String? receiptType,
      {required odm.Counter counter}) async {
    transaction.sarNo = counter.invcNo.toString();
    transaction.orgSarNo = counter.invcNo.toString();
    await repository.upsert(transaction);
  }

  // Define these constants at the top level of your file
  String customerTypeBusiness = "Business";
  String custTinKey = "custTin";
  String custNmKey = "custNm";
  String prcOrdCd = "prcOrdCd";

  Map<String, dynamic> addFieldIfCondition(
      {required Map<String, dynamic> json,
      required ITransaction transaction,
      required Customer customer,
      String? purchaseCode}) {
    if (transaction.customerId != null && purchaseCode != null) {
      json[custTinKey] = customer.custTin;
      json[custNmKey] = customer.custNm;
      json[prcOrdCd] = purchaseCode;
      json['receipt'][custTinKey] = customer.custTin;
    }
    return json;
  }

  @override
  Future<RwApiResponse> saveCustomer(
      {required ICustomer customer, required String URI}) async {
    talker.info("URI::1:${URI}");
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'branches/saveBrancheCustomers')
        .toString();

    try {
      final requiredObjc = {
        "tin": ProxyService.box.tin(),
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
        "regrNm": customer.custNm
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
    required String bhfId,
    required List<Variant> variants,
    required Business business,
    required String pchsSttsCd,
  }) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'trnsPurchase/savePurchases')
        .toString();

    Map<String, dynamic> data = item.toJson();
    data['tin'] = business.tinNumber ?? 999909695;
    data['bhfId'] = bhfId;
    data['pchsDt'] = convertDateToString(DateTime.now()).substring(0, 8);
    data['invcNo'] = item.spplrInvcNo;
    data['regrId'] = randomNumber().toString();
    data['pchsSttsCd'] = '02'; // purchase status 02= approved.
    data['modrNm'] = randomNumber().toString();
    data['orgInvcNo'] = item.spplrInvcNo;
    data['regrNm'] = randomNumber();
    data['totItemCnt'] = variants.length;
    data['pchsTyCd'] = 'N'; // transaction type N=normal
    data['cfmDt'] = convertDateToString(DateTime.now());
    data['regTyCd'] = 'A';
    data['modrId'] = randomNumber();
    // P is refund after sale
    data['rcptTyCd'] = rcptTyCd;
    data['itemList'] = variants.map((variant) {
      variant.qty = variant.stock?.currentStock ?? 0;
      return variant.toJson();
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
            'Failed to fetch import items. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin,
      required String bhfId,
      required String lastReqDt,
      required String URI}) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'imports/selectImportItems')
        .toString();

    final talker = Talker();
    final data = {
      'tin': tin,
      'bhfId': bhfId,
      'lastReqDt': lastReqDt,
    };

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
            'Failed to fetch import items. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> selectTrnsPurchaseSales(
      {required int tin,
      required String bhfId,
      required String URI,
      required String lastReqDt}) async {
    final url = Uri.parse(URI)
        .replace(
            path: Uri.parse(URI).path + 'trnsPurchase/selectTrnsPurchaseSales')
        .toString();

    final data = {
      'tin': tin,
      'bhfId': bhfId,
      'lastReqDt': lastReqDt,
    };
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
            'Failed to fetch import items. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<RwApiResponse> updateImportItems(
      {required Variant item, required String URI}) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'imports/updateImportItems')
        .toString();

    final data = item.toJson();
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
            'Failed to fetch import items. Status code: ${response.statusCode}');
      }
    } catch (e, s) {
      talker.warning(s);
      rethrow;
    }
  }

  @override
  Future<bool> stockIn(
      {required Map<String, Object?> json,
      required String URI,
      required String sarTyCd}) async {
    talker.warning("Processing stockIn");
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'stock/saveStockItems')
        .toString();
    await sendPostRequest(url, json);
    return true;
  }

  @override
  Future<bool> stockOut(
      {required Map<String, Object?> json,
      required String URI,
      required String sarTyCd}) async {
    talker.warning("Processing stockOut");
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'stock/saveStockItems')
        .toString();
    await sendPostRequest(url, json);
    return true;
  }

  @override
  Future<List<odm.Configurations>> taxConfigs({required int branchId}) async {
    final repository = Repository();
    List<Configurations> taxConfigs = await repository.get<Configurations>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query(where: [
          Where('branchId').isExactly(branchId),
        ]));
    return taxConfigs;
  }

  @override
  Future<List<Notice>> fetchNotices({required String URI}) async {
    talker.warning("Processing stockOut");
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'notices/selectNotices')
        .toString();
    final data = {
      "tin": ProxyService.box.tin(),
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
        String branchId = (await ProxyService.strategy
                .branch(serverId: ProxyService.box.getBranchId()!))!
            .id;
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
              query: Query(where: [
                Where('noticeNo').isExactly(notice.noticeNo),
                Where('branchId').isExactly(branchId),
              ]));

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
          'Failed to fetch import items. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Notice>> notices({required String branchId}) {
    final repository = Repository();
    return repository.get<Notice>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query(where: [
          Where('branchId').isExactly(branchId),
        ]));
  }
}
