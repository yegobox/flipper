import 'dart:convert';
import 'dart:developer';
import 'package:supabase_models/brick/models/all_models.dart' as odm;
import 'package:dio/dio.dart';
import 'package:flipper_models/NetworkHelper.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/ITransactionItem.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
// ignore: unused_import
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class RWTax with NetworkHelper implements TaxApi {
  String itemPrefix = "flip-";
  // String eBMURL = "https://turbo.yegobox.com";
  // String eBMURL = "http://10.0.2.2:8080/rra";

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
  Future<bool> initApi(
      {required String tinNumber,
      required String bhfId,
      required String dvcSrlNo,
      required String URI}) async {
    String? token = ProxyService.box.readString(key: 'bearerToken');
    models.Ebm? ebm =
        await ProxyService.local.ebm(branchId: ProxyService.box.getBranchId()!);
    var headers = {'Authorization': token!, 'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ebm!.taxServerUrl + 'initializer/selectInitInfo'));
    request.body =
        json.encode({"tin": tinNumber, "bhfId": bhfId, "dvcSrlNo": dvcSrlNo});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      // print(response.reasonPhrase);
      return Future.value(false);
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
      String sarTyCd = "11",
      String custBhfId = "",
      required double totalSupplyPrice,
      required double totalvat,
      required double totalAmount,
      required String remark,
      required DateTime ocrnDt,
      required Realm realm,
      required String URI}) async {
    try {
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'stock/saveStockItems')
          .toString();
      final mod = randomNumber().toString();
      final sar = randomNumber();

      List<TransactionItem> items = realm.query<TransactionItem>(
          r'transactionId == $0', [transaction.id]).toList();

      List<Map<String, dynamic>> itemsList = items
          .map((item) => mapItemToJson(item, realm, bhfId: bhFId))
          .toList();
      if (itemsList.isEmpty) throw Exception("No items to save");

      /// add totDcAmt: "0"
      /// TODO: handle discount later.
      itemsList.forEach((item) {
        item['totDcAmt'] = "0";
      });
      final json = {
        "totItemCnt": items.length,
        "tin": tinNumber,
        "bhfId": bhFId,
        "regTyCd": regTyCd,
        "custTin": custTin.isValidTin() ? custTin : "",
        "custNm": customerName,
        "custBhfId": custBhfId,
        "sarTyCd": sarTyCd,
        "ocrnDt": ocrnDt.toYYYMMdd(),
        "totTaxblAmt": totalSupplyPrice,
        "totTaxAmt": totalvat,
        "totAmt": totalAmount,
        "remark": remark,
        "regrId": mod,
        "regrNm": mod,
        "modrId": sar,
        "modrNm": mod,
        "sarNo": "1",
        "orgSarNo": "1",
        "itemList": itemsList
      };
      // if custTin is invalid remove it from the json
      if (!custTin.isValidTin()) {
        json.remove('custTin');
      }
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
      {required IStock stock,
      required IVariant variant,
      required String URI}) async {
    try {
      final url = Uri.parse(URI)
          .replace(path: Uri.parse(URI).path + 'stockMaster/saveStockMaster')
          .toString();
      if (variant.productName == TEMP_PRODUCT) {
        throw Exception("Invalid product");
      }

      /// update the remaining stock of this item in rra
      variant.rsdQty = stock.currentStock;
      Response response = await sendPostRequest(url, variant.toJson());

      final data = RwApiResponse.fromJson(
        response.data,
      );
      return data;
    } catch (e) {
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
      {required IVariant variation, required String URI}) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'items/saveItems')
        .toString();

    try {
      final response = await sendPostRequest(url, variation.toJson());
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
    models.Ebm? ebm =
        await ProxyService.local.ebm(branchId: ProxyService.box.getBranchId()!);
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
    Business? business = await ProxyService.local.getBusiness();
    List<TransactionItem> items = await ProxyService.local
        .getTransactionItemsByTransactionId(transactionId: transaction.id);

    // Get the current date and time in the required format yyyyMMddHHmmss
    String date = timeToUser
        .toIso8601String()
        .replaceAll(RegExp(r'[:-\sT]'), '')
        .substring(0, 14);
    final bhfId = (await ProxyService.box.bhfId()) ?? "00";
    // Build item list
    List<Map<String, dynamic>> itemsList = items
        .map((item) =>
            mapItemToJson(item, ProxyService.local.realm!, bhfId: bhfId))
        .toList();

    // Calculate total for non-tax-exempt items
    double totalTaxable =
        items.where((item) => !item.isTaxExempted).fold(0, (sum, item) {
      double discountedPrice = item.dcRt != 0
          ? item.price *
              item.qty *
              (1 - (item.dcRt / 100)) // Fixed: Discount calculation
          : item.price * item.qty;
      return sum + discountedPrice; // Fixed: Add to sum
    });

    // Get sales and receipt type codes
    Map<String, String> receiptCodes = getReceiptCodes(receiptType);
    Map<String, double> taxTotals = calculateTaxTotals(itemsList);

    // Retrieve customer information
    Customer? customer =
        ProxyService.local.getCustomer(id: transaction.customerId);

    // Build request data
    Map<String, dynamic> requestData = buildRequestData(
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
        final data = RwApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          throw Exception(data.resultMsg);
        }

        // Update transaction and item statuses
        updateTransactionAndItems(transaction, items, receiptCodes['rcptTyCd']);
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
  Map<String, dynamic> mapItemToJson(TransactionItem item, Realm realm,
      {required String bhfId}) {
    Configurations taxConfig =
        realm.query<Configurations>(r'taxType == $0', [item.taxTyCd!]).first;

    // Base calculations
    final unitPrice = item.price;
    final quantity = item.qty;
    final baseTotal = unitPrice * quantity;

    // Calculate discount amount correctly for the total
    final discountRate = item.dcRt;
    final totalDiscountAmount = (baseTotal * discountRate) / 100;

    // Calculate total after discount
    final totalAfterDiscount = baseTotal - totalDiscountAmount;

    talker.warning("DISCOUNT${totalAfterDiscount}");

    // Get tax percentage and calculate tax
    final taxPercentage = taxConfig.taxPercentage ?? 0.0;
    double taxAmount =
        (totalAfterDiscount * taxPercentage) / (100 + taxPercentage);
    taxAmount = (taxAmount * 100).round() / 100;

    final itemJson = ITransactionItem(
      id: item.id,
      qty: quantity,
      discount: item.discount,
      remainingStock: item.remainingStock,
      itemCd: item.itemCd,
      variantId: item.id,
      qtyUnitCd: "U",
      regrNm: item.regrNm ?? "Registrar",

      // Fixed calculations
      dcRt: discountRate,
      dcAmt: totalDiscountAmount,
      totAmt: totalAfterDiscount,

      pkg: quantity.toInt(),
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
      modrId: item.modrId ?? "ModifierID",
      modrNm: item.modrNm ?? "Modifier",
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
  Map<String, dynamic> buildRequestData({
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
  }) {
    Configurations taxConfigTaxB =
        ProxyService.local.getByTaxType(taxtype: "B");
    Configurations taxConfigTaxA =
        ProxyService.local.getByTaxType(taxtype: "A");
    Configurations taxConfigTaxC =
        ProxyService.local.getByTaxType(taxtype: "C");
    Configurations taxConfigTaxD =
        ProxyService.local.getByTaxType(taxtype: "D");
    if (transaction.customerId != null) {
      //  it mighbe a copy re-assign a customer
      talker.warning("Overriding customer");
      Customer? cus =
          ProxyService.local.getCustomer(id: transaction.customerId!);
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

    Map<String, dynamic> json = {
      "tin": business?.tinNumber.toString() ?? "999909695",
      "bhfId": bhFId,
      "invcNo": counter.invcNo,
      "orgInvcNo": 0,
      "salesTyCd": receiptCodes['salesTyCd'],
      "rcptTyCd": receiptCodes['rcptTyCd'],
      "pmtTyCd": "01",
      "salesSttsCd": "02",
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      "stockRlsDt": date,
      "totItemCnt": itemsList.length,

      // Ensure tax amounts and taxable amounts are set to 0 if null
      "taxblAmtA": taxTotals['A'] ?? 0.0,
      "taxblAmtB": (taxTotals['B'] ?? 0.0),
      "taxblAmtC": taxTotals['C'] ?? 0.0,
      "taxblAmtD": taxTotals['D'] ?? 0.0,

      "taxAmtA": ((taxTotals['A'] ?? 0.0) *
              (taxConfigTaxA.taxPercentage ?? 0) /
              (100 + (taxConfigTaxA.taxPercentage ?? 0)))
          .toStringAsFixed(2),
      "taxAmtB":
          double.parse(((taxTotals['B'] ?? 0.0) * 18 / 118).toStringAsFixed(2)),
      "taxAmtC": double.parse(((taxTotals['C'] ?? 0.0) *
              (taxConfigTaxC.taxPercentage ?? 0) /
              (100 + (taxConfigTaxC.taxPercentage ?? 0)))
          .toStringAsFixed(2)),
      "taxAmtD": double.parse(((taxTotals['D'] ?? 0.0) *
              (taxConfigTaxD.taxPercentage ?? 0) /
              (100 + (taxConfigTaxD.taxPercentage ?? 0)))
          .toStringAsFixed(2)),

      "taxRtA": taxConfigTaxA.taxPercentage,
      "taxRtB": taxConfigTaxB.taxPercentage,
      "taxRtC": taxConfigTaxC.taxPercentage,
      "taxRtD": taxConfigTaxD.taxPercentage,

      "totTaxblAmt": totalTaxable,

      "totTaxAmt": double.parse(totalTax.toStringAsFixed(2)),
      "totAmt": totalTaxable,

      "regrId": transaction.id,
      "regrNm": transaction.id,
      "modrId": transaction.id,
      "modrNm": transaction.id,
      "custNm": customer?.custNm ?? ProxyService.box.customerName() ?? "N/A",
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
    if (receiptType == "NR" || receiptType == "CR") {
      json['rfdRsnCd'] = ProxyService.box.getRefundReason() ?? "05";
    }
    if (receiptType == "NR" || receiptType == "CR" || receiptType == "TR") {
      /// this is normal refund add rfdDt refunded date
      /// ATTENTION: rfdDt was added later and it might cause trouble we need to watch out.
      /// 'rfdDt': Must be a valid date in yyyyMMddHHmmss format. rejected value: '20241107'
      json['rfdDt'] = timeToUse.toYYYMMddHHmmss();

      // get a transaction being refunded
      // final trans = ProxyService.local.getTransactionById(
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

// Helper function to update transaction and item statuses
  void updateTransactionAndItems(ITransaction transaction,
      List<TransactionItem> items, String? receiptType) {
    for (TransactionItem item in items) {
      Stock? stock = ProxyService.local.stockByVariantId(
        variantId: item.variantId!,
        branchId: ProxyService.box.getBranchId()!,
      );

      ProxyService.local.realm!.write(() {
        item.ebmSynced = true;
        stock?.ebmSynced = false;
        if (receiptType == "R") {
          item.isRefunded = true;
        }
      });
    }

    ProxyService.local.realm!.write(() {
      transaction.ebmSynced = true;
      transaction.isRefunded = receiptType == "R";
    });
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
      final response = await sendPostRequest(url, customer.toJson());

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
  Future<RwApiResponse> savePurchases(
      {required SaleList item,
      required String URI,
      String rcptTyCd = "S",
      required String bhfId,
      required Realm realm}) async {
    final url = Uri.parse(URI)
        .replace(path: Uri.parse(URI).path + 'trnsPurchase/savePurchases')
        .toString();
    Business? business =
        realm.query<Business>(r'isDefault == $0', [true]).firstOrNull;
    Map<String, dynamic> data = item.toJson();
    data['tin'] = business?.tinNumber ?? 999909695;
    data['bhfId'] = bhfId;
    data['pchsDt'] = convertDateToString(DateTime.now()).substring(0, 8);
    data['invcNo'] = item.spplrInvcNo;
    data['regrId'] = randomNumber().toString();
    data['pchsSttsCd'] = '02';
    data['modrNm'] = randomNumber().toString();
    data['orgInvcNo'] = item.spplrInvcNo;
    data['regrNm'] = randomNumber();
    data['pchsTyCd'] = 'N';
    data['cfmDt'] = convertDateToString(DateTime.now());
    data['regTyCd'] = 'A';
    data['modrId'] = randomNumber();
    // P is refund after sale
    data['rcptTyCd'] = rcptTyCd;
    final talker = Talker();
    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final respond = RwApiResponse.fromJson(jsonResponse);
        if (respond.resultCd == "894" || respond.resultCd != "000") {
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
      {required Item item, required String URI}) async {
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
        if (respond.resultCd == "894" || respond.resultCd != "000") {
          throw Exception(respond.resultMsg);
        }

        /// save the item in our system, rely on the name as when user
        /// typed to edit a name we helped a user to search through
        /// existing product and use the name that exist,
        /// that way we will be updating the product's variant with no question
        /// otherwise then create a complete new product.
        ProxyService.local.createProduct(
          bhFId: (await ProxyService.box.bhfId()) ?? "00",
          tinNumber: ProxyService.box.tin(),
          businessId: ProxyService.box.getBusinessId()!,
          branchId: ProxyService.box.getBranchId()!,
          product: Product(
            ObjectId(),
            name: item.itemNm,
            lastTouched: DateTime.now(),
            branchId: ProxyService.box.getBranchId(),
            businessId: ProxyService.box.getBusinessId(),
            createdAt: DateTime.now().toIso8601String(),
            spplrNm: item.spplrNm,
          ),
          supplyPrice: item.supplyPrice!,
          retailPrice: item.retailPrice!,
          itemSeq: item.itemSeq,
          // since this is import we do not need to sync back the same item back to RRA
          ebmSynced: true,
        );

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
}
