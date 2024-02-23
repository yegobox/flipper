import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class RWTax implements TaxApi {
  String itemPrefix = "flip-";
  String ebmUrl = "https://turbo.yegobox.com";

  RWTax();

  @override
  Future<bool> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
  }) async {
    String? token = ProxyService.box.readString(key: 'bearerToken');
    EBM? ebm = await ProxyService.isar
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
  Future<bool> saveStock({required Stock stock}) async {
    try {
      /// because updating stock in in rra work is just passing item with updated qty
      /// we first get the item from db update the query from our stock model and pass it
      Variant? variant =
          await ProxyService.isar.getVariantById(id: stock.variantId);

      /// update the remaining stock of this item in rra
      variant!.rsdQty = stock.currentStock;
      http.Request request = buildRequest(ebmUrl, variant.toJson());
      http.StreamedResponse response = await request.send();
      final stringResponse = await response.stream.bytesToString();
      //handleResponseLogging(stringResponse, variant, stock);
      sendEmailLogging(
          requestBody: request.body, subject: "Worked", body: stringResponse);
      final data = EBMApiResponse.fromJson(
        json.decode(stringResponse),
      );
      if (data.resultCd != 000) {
        throw Exception(data.resultMsg);
      }
      return response.statusCode == 200;
    } catch (e, stackTrace) {
      throw Exception(stackTrace);
    }
  }

  http.Request buildRequest(String baseUrl, Map<String, dynamic>? data) {
    var request =
        http.Request('POST', Uri.parse('$baseUrl/stockMaster/saveStockMaster'));
    request.body = json.encode(data);
    request.headers.addAll({'Content-Type': 'application/json'});
    return request;
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
  Future<bool> saveItem({required Variant variation}) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(ebmUrl + '/items/saveItems'));

    request.body = json.encode(variation.toJson());

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final stringResponse = await response.stream.bytesToString();

      sendEmailLogging(
          requestBody: request.body, subject: "Worked", body: stringResponse);

      final data = EBMApiResponse.fromJson(
        json.decode(stringResponse),
      );
      if (data.resultCd != 000) {
        throw Exception(data.resultMsg);
      }
      return Future.value(true);
    } else {
      throw Exception("failed to save item");
    }
  }

  /// lastReqDt we do year +  0523000000 where 0523000000 seem to be constant
  /// this get a list of items that are saved in the server from saveItem endPoint

  @override
  Future<bool> selectItems({
    required String tinNumber,
    required String bhfId,
    String lastReqDt = "20210523000000",
  }) async {
    var headers = {'Content-Type': 'application/json'};
    EBM? ebm = await ProxyService.isar
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
    if (ebm == null) {
      return false;
    }
    var request = http.Request(
        'POST', Uri.parse(ebm.taxServerUrl! + '/items/selectItems'));
    request.body =
        json.encode({"tin": tinNumber, "bhfId": bhfId, "lastReqDt": lastReqDt});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final stringResponse = await response.stream.bytesToString();
      sendEmailLogging(
          requestBody: request.body, subject: "Worked", body: stringResponse);
      return Future.value(true);
    } else {
      // print(response.reasonPhrase);
      return Future.value(false);
    }
  }

  @override
  Future<EBMApiResponse?> generateReceiptSignature({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required String receiptType,
    required Counter counter,
    String? purchaseCode,
  }) async {
    Business? business = await ProxyService.isar.getBusiness();
    String date = DateTime.now()
        .toString()
        .replaceAll(RegExp(r'[:-\s]'), '')
        .substring(0, 14);

    var headers = {'Content-Type': 'application/json'};

    var request =
        http.Request('POST', Uri.parse('$ebmUrl/trnsSales/saveSales'));

    List<Map<String, dynamic>> itemsList =
        items.map((item) => item.toJson()).toList();

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
        salesTyCd = "T";
        rcptTyCd = "S";
        break;
    }
    Map<String, dynamic> data = {
      "tin": business?.tinNumber ?? 999909695,
      "bhfId": business?.bhfId ?? "00",
      "invcNo": counter.curRcptNo,
      "orgInvcNo": 0,
      "salesTyCd": salesTyCd,
      "rcptTyCd": rcptTyCd,
      "pmtTyCd": "01", // 01: is cash
      "salesSttsCd": "02", //02: Approved
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      "stockRlsDt": date,
      "totItemCnt": itemsList.length,
      "taxAmtB": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "totTaxblAmt": totalMinusExemptedProducts,
      "totTaxAmt": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "totAmt": totalMinusExemptedProducts,
      "prchrAcptcYn": "Y",
      "regrId": transaction.id,
      "regrNm": transaction.id,
      "modrId": transaction.id,
      "modrNm": transaction.id,
      "receipt": {
        "curRcptNo": counter.curRcptNo,
        "totRcptNo": counter.curRcptNo,
        "rptNo": date,
        "rcptPbctDt": date,
        "intrlData": itemPrefix +
            transaction.id.toString() +
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
        "rcptSign": transaction.id,
        "trdeNm": business?.name ?? "YB",
        "topMsg": "Shop with us",
        "btmMsg": "Welcome",
        "prchrAcptcYn": "Y"
      },
      "itemList": itemsList
    };
    Customer? customer =
        await ProxyService.isar.getCustomer(id: transaction.customerId);

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

    request.body = json.encode(finalData);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final stringResponse = await response.stream.bytesToString();
        sendEmailLogging(
          requestBody: request.body,
          subject: "Worked",
          body: stringResponse,
        );
        final data = EBMApiResponse.fromJson(
          json.decode(stringResponse),
        );
        if (data.resultCd != "000") {
          throw Exception(data.resultMsg);
        }
        return data;
      } else {
        throw Exception(
            "Failed to send request. Status Code: ${response.statusCode}");
      }
    } catch (e, st) {
      print("Exception: $e");
      print("Exception: $st");
      // Handle the exception or rethrow it based on your requirements.
      throw Exception("Failed to send request: $e");
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
    //TODO: remember we only force purchase code for business entity
    if (transaction.customerId != null && purchaseCode != null) {
      json[custTinKey] = customer.custTin;
      json[custNmKey] = customer.custNm;
      json[prcOrdCd] = purchaseCode;
    }

    return json;
  }

  @override
  Future saveCustomer({required Customer customer}) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
        'POST', Uri.parse(ebmUrl + '/branches/saveBrancheCustomers'));
    request.body = json.encode(customer.toJson());
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final stringResponse = await response.stream.bytesToString();

      sendEmailLogging(
          requestBody: request.body, subject: "Worked", body: stringResponse);

      final data = EBMApiResponse.fromJson(
        json.decode(stringResponse),
      );
      return data;
    } else {
      throw Exception(
          "Failed to send request. Status Code: ${response.statusCode}");
    }
  }
}
