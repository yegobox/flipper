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
import 'package:flipper_services/constants.dart';
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

  RWTax();

  @override
  Future<bool> initApi(
      {required String tinNumber,
      required String bhfId,
      required String dvcSrlNo,
      required String URI}) async {
    String? token = ProxyService.box.readString(key: 'bearerToken');
    EBM? ebm = await ProxyService.realm
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
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
      talker.warning(response.data);
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
  final talker = Talker();
  final dio = Dio();

  Future<Response> sendPostRequest(
    String baseUrl,
    Map<String, dynamic>? data,
  ) async {
    final headers = {'Content-Type': 'application/json'};
    dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    ));
    //final jsonData = json.encode(data);

    // Clipboard.setData(ClipboardData(text: jsonData.toString()));
    try {
      final response = await dio.post(
        baseUrl,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle the error
      final errorMessage = e.response?.data;

      // Throw an exception with the error message or a default message
      throw Exception(
          'Error sending POST request: ${errorMessage ?? 'Bad Request'}');
    }
  }

  Future<Response> sendGetRequest(
    String baseUrl,
    Map<String, dynamic>? queryParameters,
  ) async {
    final headers = {'Content-Type': 'application/json'};

    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );

    try {
      final response = await dio.get(
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
  /// the server. For more information, refer to ‘3.2.4.1 ItemSaveReq/Res’
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
    EBM? ebm = await ProxyService.realm
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
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
  Future<RwApiResponse?> generateReceiptSignature(
      {required ITransaction transaction,
      required String receiptType,
      required Counter counter,
      String? purchaseCode,
      required String URI}) async {
    Business? business = await ProxyService.local.getBusiness();

    List<TransactionItem> items =
        await ProxyService.realm.getTransactionItemsByTransactionId(
      transactionId: transaction.id,
    );
    String date = DateTime.now()
        .toString()
        .replaceAll(RegExp(r'[:-\s]'), '')
        .substring(0, 14);

    List<Map<String, dynamic>> itemsList = items
        .map((item) => ITransactionItem(
                id: item.id,
                qty: item.qty,
                discount: item.discount,
                remainingStock: item.remainingStock,
                itemCd: item.itemCd,
                variantId: item.id,
                qtyUnitCd: item.qtyUnitCd,
                prc: item.price,
                regrNm: item.regrNm,
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
                tin: item.tin,
                bhfId: item.bhfId,
                dftPrc: item.dftPrc,
                addInfo: item.addInfo,
                isrcAplcbYn: item.isrcAplcbYn,
                useYn: item.useYn,
                regrId: item.regrId,
                modrId: item.modrId,
                modrNm: item.modrNm,
                name: item.name)
            .toJson())
        .toList();

    double totalMinusExemptedProducts = items
        .where((item) => !item.isTaxExempted)
        .fold(0, (sum, item) => sum + (item.prc * item.qty));

    String salesTyCd;
    String rcptTyCd;

    switch (receiptType) {
      case "NR":
        salesTyCd = "N";
        rcptTyCd = "R";
        break;
      case "NS":
        salesTyCd = "N";
        rcptTyCd = "S";
        break;
      case "CS":
        salesTyCd = "C";
        rcptTyCd = "S";
        break;
      case "TS":
        salesTyCd = "T";
        rcptTyCd = "S";
        break;
      case "PS":
        salesTyCd = "P";
        rcptTyCd = "S";
        break;
      default:
        salesTyCd = "N";
        rcptTyCd = "S";
        break;
    }

    ///TODO: refactor required I have code like this in TaxController I will look for a way to put into one place
    Map<String, double> taxTotals = {
      'A': 0.0,
      'B': 0.0,
      'C': 0.0,
      'D': 0.0,
    };

    try {
      for (var item in items) {
        // Log the item details
        talker.warning(
            "Processing item with price: ${(item.price == 0.0 ? 1 : item.price)} and quantity: ${item.qty}");

        // Fetch the tax configuration
        var taxConfig =
            await ProxyService.realm.getByTaxType(taxtype: item.taxTyCd ?? "B");

        talker.info("Tax To be applied on: ${item.taxTyCd}");
        // Ensure taxPercentage is not null
        if (taxConfig.taxPercentage == 0.0) {
          talker.warning(
              "Tax percentage is null for tax type: ${item.taxTyCd ?? "B"}");
          continue; // Skip this item if tax percentage is null
        }

        // Calculate the tax amount
        double taxAmount = (((item.price == 0.0 ? 1 : item.price) * item.qty));

        // Accumulate tax amount instead of overwriting
        String taxType = item.taxTyCd ?? "B";
        taxTotals[taxType] = (taxTotals[taxType] ?? 0.0) + taxAmount;

        // Log the accumulated tax amount
        talker.warning(
            "Accumulated tax amount for ${taxType}: ${taxTotals[taxType]}");
      }
    } catch (s) {
      talker.error(s);
    }

    Customer? customer =
        ProxyService.realm.getCustomer(id: transaction.customerId);

    double totalTaxA = taxTotals['A'] ?? 0.0;
    double totalTaxB = taxTotals['B'] ?? 0.0;
    double totalTaxC = taxTotals['C'] ?? 0.0;
    double totalTaxD = taxTotals['D'] ?? 0.0;
    Map<String, dynamic> data = {
      "tin": business.tinNumber ?? 999909695,
      "bhfId": ProxyService.box.bhfId() ?? "00",
      "invcNo": counter.invcNo,
      "orgInvcNo": 0,
      "salesTyCd": salesTyCd,
      "rcptTyCd": rcptTyCd,
      "pmtTyCd": "01", // 01: is cash
      "salesSttsCd": "02", //02: Approved
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      "stockRlsDt": date,
      "totItemCnt": itemsList.length,
      "taxblAmtB": totalTaxB,
      "taxblAmtA": totalTaxA,
      "taxblAmtC": totalTaxC,
      "taxblAmtD": totalTaxD,
      "taxAmtC": totalTaxC,
      "taxAmtA": totalTaxA,
      "taxAmtD": totalTaxD,
      "taxAmtB": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "totTaxblAmt": totalMinusExemptedProducts,
      "totTaxAmt": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "totAmt": totalMinusExemptedProducts,
      "prchrAcptcYn": "Y",
      "regrId": transaction.id,
      "regrNm": transaction.id,
      "modrId": transaction.id,
      "modrNm": transaction.id,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "custNm": customer?.custNm ?? "N/A",
      "prcOrdCd": null,
      "cnclDt": null,
      "rfdDt": null,
      "rfdRsnCd": null,
      "remark": "",

      "receipt": {
        "rptNo": counter.invcNo,
        "adrs": "",
        // "rcptPbctDt": date,
        // "intrlData": itemPrefix +
        //     transaction.id.toString() +
        //     DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
        // "rcptSign": transaction.id,
        "trdeNm": business.name ?? "YEGOBOX",
        // "topMsg": "Shop with us",
        "topMsg":
            "${business.name}\n\nAddress:${business.adrs}\nTEL: ${ProxyService.box.getUserPhone()}\nTIN: ${business.tinNumber}",
        "btmMsg": "Welcome",
        "prchrAcptcYn": "N",
        "custMblNo": ProxyService.box.currentSaleCustomerPhoneNumber(),
      },
      "itemList": itemsList
    };

    Map<String, dynamic> finalData;

    if (customer != null) {
      finalData = addFieldIfCondition(
          json: data,
          transaction: transaction,
          customer: customer,
          purchaseCode: purchaseCode);
    } else {
      finalData = data;
    }
    talker.warning(finalData);
    try {
      final url = '${URI}/trnsSales/saveSales';
      final response = await sendPostRequest(url, finalData);
      // Clipboard.setData(ClipboardData(text: finalData.toString()));
      if (response.statusCode == 200) {
        final data = RwApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          throw Exception(
            "Failed to send request with invoice number ${counter.curRcptNo}: ${data.resultMsg}",
          );
        }

        /// update transaction.ebmSynced to true;
        /// update transaction.refunded to false < get this flag given to the type of sale type being used.
        for (TransactionItem item in items) {
          /// here we update stock, so it is updated back to rra backoffice as we have new!

          Stock? stock =
              ProxyService.realm.stockByVariantId(variantId: item.variantId!);

          ProxyService.realm.realm!.write(() {
            item.ebmSynced = true;
            if (stock != null) {
              stock.ebmSynced = false;
            }
            if (rcptTyCd == "R") {
              item.isRefunded = true;
            }
          });
        }
        ProxyService.realm.realm!.write(() {
          transaction.ebmSynced = true;
          if (rcptTyCd == "R") {
            transaction.isRefunded = true;
          } else {
            transaction.isRefunded = false;
          }
        });
        return data;
      } else {
        throw Exception(
          "Failed to send request. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      rethrow;
    }
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
