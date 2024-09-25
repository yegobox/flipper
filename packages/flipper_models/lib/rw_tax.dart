import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/IStock.dart';
import 'package:flipper_models/helperModels/ITransactionItem.dart';
import 'package:flipper_models/helperModels/IVariant.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/tax_api.dart';
// ignore: unused_import
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class RWTax implements TaxApi {
  String itemPrefix = "flip-";
  // String eBMURL = "https://turbo.yegobox.com";
  // String eBMURL = "http://10.0.2.2:8080/rra";

  Dio? _dio;
  Talker? _talker;
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
    EBM? ebm =
        await ProxyService.realm.ebm(branchId: ProxyService.box.getBranchId()!);
    var headers = {'Authorization': token!, 'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ebm!.taxServerUrl! + 'initializer/selectInitInfo'));
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

  /// save or update stock of item saved before.
  /// so it is an item i.e variant we pass back
  /// The API will not fail even if the item Code @[itemCd] is not found
  /// in a ist of saved Item.
  /// @[rsdQty] is the remaining stock of the item.
  /// it is very important to note that given on how RRA data is structured
  /// we ended up mixing data for stock and variant but data stay in related model
  /// we just borrow properties to simplify the accesibility
  @override
  Future<bool> saveStock(
      {required IStock stock,
      required IVariant variant,
      required String URI}) async {
    try {
      /// update the remaining stock of this item in rra
      variant.rsdQty = stock.currentStock;
      Response response = await sendPostRequest(
          URI + "/stockMaster/saveStockMaster", variant.toJson());
      // sendEmailLogging(
      //     requestBody: response.requestOptions.data,
      //     subject: "Worked",
      //     body: stringResponse);
      _talker!.warning(response.data);
      final data = RwApiResponse.fromJson(
        response.data,
      );
      if (data.resultCd != "000") {
        throw Exception(data.resultMsg);
      }
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  // Create the Dio instance and add the TalkerDioLogger interceptor

  Future<Response> sendPostRequest(
    String baseUrl,
    Map<String, dynamic>? data,
  ) async {
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await _dio!.post(
        baseUrl,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      print('Response received: ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      print('DioException caught: ${e.message}');
      final errorMessage = e.response?.data;
      // talker.error(s);
      throw Exception(
          'Error sending POST request: ${errorMessage ?? 'Bad Request'}');
    } catch (e, s) {
      print('General exception caught: $e');
      _talker!.info(e);
      _talker!.error(s);
      throw Exception(e);
    }
  }

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
  Future<bool> saveItem(
      {required IVariant variation, required String URI}) async {
    final url = '${URI}/items/saveItems';
    try {
      final response = await sendPostRequest(url, variation.toJson());
      if (response.statusCode == 200) {
        final data = RwApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          throw Exception(data.resultMsg);
        }
        // sendEmailLogging(
        //   requestBody: variation.toJson().toString(),
        //   subject: "Worked",
        //   body: response.data.toString(),
        // );
        return true;
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
    EBM? ebm =
        await ProxyService.realm.ebm(branchId: ProxyService.box.getBranchId()!);
    if (ebm == null) {
      return false;
    }

    final url = '${ebm.taxServerUrl}/items/selectItems';
    final data = {
      "tin": tinNumber,
      "bhfId": bhfId,
      "lastReqDt": lastReqDt,
    };

    try {
      final response = await sendPostRequest(url, data);
      if (response.statusCode == 200) {
        // sendEmailLogging(
        //   requestBody: data.toString(),
        //   subject: "Worked",
        //   body: response.data.toString(),
        // );
        return true;
      } else {
        // print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RwApiResponse?> generateReceiptSignature({
    required ITransaction transaction,
    required String receiptType,
    required Counter counter,
    String? purchaseCode,
    required String URI,
  }) async {
    // Get business details
    Business? business = await ProxyService.local.getBusiness();
    List<TransactionItem> items =
        await ProxyService.realm.getTransactionItemsByTransactionId(
      transactionId: transaction.id,
    );

    // Get the current date and time in the required format yyyyMMddHHmmss
    String date = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:-\sT]'), '')
        .substring(0, 14);

    // Build item list
    List<Map<String, dynamic>> itemsList =
        items.map((item) => mapItemToJson(item, business)).toList();

    // Calculate total for non-tax-exempt items
    double totalTaxable = items
        .where((item) => !item.isTaxExempted)
        .fold(0, (sum, item) => sum + (item.price * item.qty));

    // Get sales and receipt type codes
    Map<String, String> receiptCodes = getReceiptCodes(receiptType);
    Map<String, double> taxTotals = calculateTaxTotals(items);

    // Retrieve customer information
    Customer? customer =
        ProxyService.realm.getCustomer(id: transaction.customerId);

    // Build request data
    Map<String, dynamic> requestData = buildRequestData(
      business: business,
      counter: counter,
      transaction: transaction,
      date: date,
      totalTaxable: totalTaxable,
      taxTotals: taxTotals,
      receiptCodes: receiptCodes,
      customer: customer,
      itemsList: itemsList,
      purchaseCode: purchaseCode,
    );

    try {
      // Send request
      final url = '$URI/trnsSales/saveSales';
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
  Map<String, dynamic> mapItemToJson(TransactionItem item, Business? business) {
    return ITransactionItem(
      id: item.id,
      qty: item.qty,
      discount: item.discount,
      remainingStock: item.remainingStock,
      itemCd: item.itemCd,
      variantId: item.id,
      qtyUnitCd: item.qtyUnitCd,
      prc: item.price,
      regrNm: item.regrNm ?? "Registrar", // Ensure regrNm is not null
      dcRt: item.dcRt,
      pkg: item.pkg,
      dcAmt: item.dcAmt,
      taxblAmt: item.taxAmt,
      taxAmt: item.taxAmt,
      itemClsCd: item.itemClsCd,
      itemNm: item.name,
      totAmt: item.totAmt,
      itemSeq: item.itemSeq,
      isrccCd: item.isrccCd,
      isrccNm: item.isrccNm,
      isrcRt: item.isrcRt,
      isrcAmt: item.isrcAmt,
      taxTyCd: item.taxTyCd,
      bcd: item.bcd,
      itemTyCd: item.itemTyCd,
      itemStdNm: item.itemStdNm,
      orgnNatCd: item.orgnNatCd,
      pkgUnitCd: item.pkgUnitCd,
      splyAmt: item.splyAmt,
      tin: item.tin ?? business?.tinNumber,
      bhfId: item.bhfId ?? ProxyService.box.bhfId(),
      dftPrc: item.dftPrc,
      addInfo: item.addInfo,
      isrcAplcbYn: item.isrcAplcbYn,
      useYn: item.useYn,
      regrId:
          item.regrId ?? "RegistrarID", // Ensure regrId and modrId are not null
      modrId: item.modrId ?? "ModifierID",
      modrNm: item.modrNm ?? "Modifier", // Ensure modrNm is not null
      name: item.name,
    ).toJson();
  }

// Helper function to calculate tax totals
  Map<String, double> calculateTaxTotals(List<TransactionItem> items) {
    Map<String, double> taxTotals = {'A': 0.0, 'B': 0.0, 'C': 0.0, 'D': 0.0};
    for (var item in items) {
      String taxType = item.taxTyCd ?? 'B';
      double taxAmount = item.price * item.qty;
      taxTotals[taxType] = (taxTotals[taxType] ?? 0.0) + taxAmount;
    }
    return taxTotals;
  }

// Helper function to determine receipt type codes
  Map<String, String> getReceiptCodes(String receiptType) {
    switch (receiptType) {
      case 'NR':
        return {'salesTyCd': 'N', 'rcptTyCd': 'R'};
      case 'NS':
        return {'salesTyCd': 'N', 'rcptTyCd': 'S'};
      case 'CS':
        return {'salesTyCd': 'C', 'rcptTyCd': 'S'};
      case 'TS':
        return {'salesTyCd': 'T', 'rcptTyCd': 'S'};
      case 'PS':
        return {'salesTyCd': 'P', 'rcptTyCd': 'S'};
      default:
        return {'salesTyCd': 'N', 'rcptTyCd': 'S'};
    }
  }

// Helper function to build request data
  Map<String, dynamic> buildRequestData({
    required Business? business,
    required Counter counter,
    required ITransaction transaction,
    required String date,
    required double totalTaxable,
    required Map<String, double> taxTotals,
    required Map<String, String> receiptCodes,
    Customer? customer,
    required List<Map<String, dynamic>> itemsList,
    String? purchaseCode,
  }) {
    Configurations taxConfigTaxB =
        ProxyService.realm.getByTaxType(taxtype: "B");
    Configurations taxConfigTaxA =
        ProxyService.realm.getByTaxType(taxtype: "A");
    Configurations taxConfigTaxC =
        ProxyService.realm.getByTaxType(taxtype: "C");
    Configurations taxConfigTaxD =
        ProxyService.realm.getByTaxType(taxtype: "D");

    /// because other rate for tax are not known are set to 1/1
    final totalTax = ((taxTotals['B'] ?? 0.0) * 18 / 118);
    // final totalTax = ((taxTotals['B'] ?? 0.0) * 18 / 118) +
    //     ((taxTotals['A'] ?? 0.0) * 1 / 1) +
    //     ((taxTotals['C'] ?? 0.0) * 1 / 1) +
    //     ((taxTotals['D'] ?? 0.0) * 1 / 1);
    return {
      "tin": business?.tinNumber ?? 999909695,
      "bhfId": ProxyService.box.bhfId() ?? "00",
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
      "taxblAmtB": taxTotals['B'] ?? 0.0,
      "taxblAmtC": taxTotals['C'] ?? 0.0,
      "taxblAmtD": taxTotals['D'] ?? 0.0,

      "taxAmtA": ((taxTotals['A'] ?? 0.0) *
              (taxConfigTaxA.taxPercentage ?? 0) /
              (100 + (taxConfigTaxA.taxPercentage ?? 0)))
          .toStringAsFixed(2),
      "taxAmtB": ((taxTotals['B'] ?? 0.0) * 18 / 118).toStringAsFixed(2),
      "taxAmtC": ((taxTotals['C'] ?? 0.0) *
              (taxConfigTaxC.taxPercentage ?? 0) /
              (100 + (taxConfigTaxC.taxPercentage ?? 0)))
          .toStringAsFixed(2),
      "taxAmtD": ((taxTotals['D'] ?? 0.0) *
              (taxConfigTaxD.taxPercentage ?? 0) /
              (100 + (taxConfigTaxD.taxPercentage ?? 0)))
          .toStringAsFixed(2),

      "taxRtA": taxConfigTaxA.taxPercentage,
      "taxRtB": taxConfigTaxB.taxPercentage,
      "taxRtC": taxConfigTaxC.taxPercentage,
      "taxRtD": taxConfigTaxD.taxPercentage,

      "totTaxblAmt": totalTaxable,

      "totTaxAmt": totalTax.toStringAsFixed(2),
      "totAmt": totalTaxable,

      "regrId": transaction.id,
      "regrNm": transaction.id,
      "modrId": transaction.id,
      "modrNm": transaction.id,
      "rfdRsnCd": ProxyService.box.getRefundReason(),

      "custNm": customer?.custNm ?? "N/A",
      "remark": "",
      "prchrAcptcYn": "Y",
      // Receipt info
      "receipt": {
        "prchrAcptcYn": "Y", // Ensure this is not null
        "rptNo": counter.invcNo,
        "adrs": "Kigali, Rwanda",
        "topMsg":
            "${business?.name}\n\nAddress:${business?.adrs}\nTEL: ${ProxyService.box.getUserPhone()}\nTIN: ${business?.tinNumber}",
        "btmMsg": "Welcome",
        "custMblNo": customer == null
            ? ProxyService.box.currentSaleCustomerPhoneNumber()
            : customer.tin,
      },
      "itemList": itemsList,
    };
  }

// Helper function to update transaction and item statuses
  void updateTransactionAndItems(ITransaction transaction,
      List<TransactionItem> items, String? receiptType) {
    for (TransactionItem item in items) {
      Stock? stock = ProxyService.realm.stockByVariantId(
        variantId: item.variantId!,
        branchId: ProxyService.box.getBranchId()!,
      );

      ProxyService.realm.realm!.write(() {
        item.ebmSynced = true;
        stock?.ebmSynced = false;
        if (receiptType == "R") {
          item.isRefunded = true;
        }
      });
    }

    ProxyService.realm.realm!.write(() {
      transaction.ebmSynced = true;
      transaction.isRefunded = receiptType == "R";
    });
  }

  // Define these constants at the top level of your file
  String customerTypeBusiness = "Business";
  String custTinKey = "custTin";
  String custNmKey = "custNm";
  String prcOrdCd = "prcOrdCd";

  Map<String, dynamic> addFieldIfCondition({
    required Map<String, dynamic> json,
    required ITransaction transaction,
    required Customer customer,
    String? purchaseCode,
  }) {
    if (transaction.customerId != null && purchaseCode != null) {
      json[custTinKey] = customer.custTin;
      json[custNmKey] = customer.custNm;
      json[prcOrdCd] = purchaseCode;
    }

    return json;
  }

  @override
  Future<RwApiResponse> saveCustomer(
      {required ICustomer customer, required String URI}) async {
    final url = '${URI}/branches/saveBrancheCustomers';

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
      {required SaleList item, required String URI}) async {
    final baseUrl = URI + '/trnsPurchase/savePurchases';
    //TODO: finalize the remove the hardcoded value such as 999909695 and "00"
    Map<String, dynamic> data = item.toJson();
    data['tin'] = 999909695;
    data['bhfId'] = ProxyService.box.bhfId() ?? "00";
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
    data['rcptTyCd'] = "P";
    final talker = Talker();
    try {
      final response = await sendPostRequest(baseUrl, data);
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
        /// TODO: uncomment the bellow to save product tuvuye kurangura or update them!
        // ProxyService.realm.createProduct(
        //   product: Product(
        //     ObjectId(),
        //     name: item.itemNm,
        //     lastTouched: DateTime.now(),
        //     branchId: ProxyService.box.getBranchId(),
        //     businessId: ProxyService.box.getBusinessId(),
        //     createdAt: DateTime.now().toIso8601String(),
        //     spplrNm: item.spplrNm,
        //   ),
        //   supplyPrice: item.supplyPrice!,
        //   retailPrice: item.retailPrice!,
        //   itemSeq: item.itemSeq,
        //   // since this is import we do not need to sync back the same item back to RRA
        //   ebmSynced: true,
        // );

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
  Future<RwApiResponse> selectImportItems(
      {required int tin,
      required String bhfId,
      required String lastReqDt,
      required String URI}) async {
    final baseUrl = URI + '/imports/selectImportItems';
    final talker = Talker();
    final data = {
      'tin': tin,
      'bhfId': bhfId,
      'lastReqDt': lastReqDt,
    };

    try {
      final response = await sendPostRequest(baseUrl, data);
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
    final baseUrl = URI + '/trnsPurchase/selectTrnsPurchaseSales';
    final data = {
      'tin': tin,
      'bhfId': bhfId,
      'lastReqDt': lastReqDt,
    };
    final talker = Talker();
    try {
      final response = await sendPostRequest(baseUrl, data);
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
    final baseUrl = URI + '/imports/updateImportItems';
    final data = item.toJson();
    final talker = Talker();

    try {
      final response = await sendPostRequest(baseUrl, data);
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
        ProxyService.realm.createProduct(
          bhFId: ProxyService.box.bhfId() ?? "00",
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
