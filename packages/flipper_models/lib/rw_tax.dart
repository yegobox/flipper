import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/helperModels/receipt_signature.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

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
  Future<bool> saveStock({required Stock stock}) async {
    try {
      /// because updating stock in in rra work is just passing item with updated qty
      /// we first get the item from db update the query from our stock model and pass it
      Variant? variant =
          await ProxyService.realm.getVariantById(id: stock.variantId!);

      /// update the remaining stock of this item in rra
      variant!.rsdQty = stock.currentStock;
      Response response = await sendPostRequest(
          ebmUrl + "/stockMaster/saveStockMaster",
          variant.toEJson() as Map<String, dynamic>);
      final stringResponse = response.data.toString();
      //handleResponseLogging(stringResponse, variant, stock);
      sendEmailLogging(
          requestBody: response.requestOptions.data,
          subject: "Worked",
          body: stringResponse);
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

    try {
      final response = await dio.post(
        baseUrl,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle the error
      throw Exception('Error sending POST request: ${e.message}');
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
  Future<bool> saveItem({required Variant variation}) async {
    final url = '$ebmUrl/items/saveItems';
    try {
      final response = await sendPostRequest(
          url, variation.toEJson() as Map<String, dynamic>);
      if (response.statusCode == 200) {
        final data = EBMApiResponse.fromJson(response.data);
        if (data.resultCd != 000) {
          throw Exception(data.resultMsg);
        }
        sendEmailLogging(
          requestBody: variation.toEJson().toString(),
          subject: "Worked",
          body: response.data.toString(),
        );
        return true;
      } else {
        throw Exception("failed to save item");
      }
    } catch (e) {
      // Handle the exception
      print(e);
      return false;
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
        sendEmailLogging(
          requestBody: data.toString(),
          subject: "Worked",
          body: response.data.toString(),
        );
        return true;
      } else {
        // print(response.reasonPhrase);
        return false;
      }
    } catch (e) {
      // Handle the exception
      print(e);
      return false;
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
    Business? business = await ProxyService.realm.getBusiness();
    String date = DateTime.now()
        .toString()
        .replaceAll(RegExp(r'[:-\s]'), '')
        .substring(0, 14);

    List<Map<String, dynamic>> itemsList =
        items.map((item) => item.toEJson() as Map<String, dynamic>).toList();

    double totalMinusExemptedProducts = items
        .where((item) => !item.isTaxExempted!)
        .fold(0, (sum, item) => sum + (item.prc! * item.qty!));

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
        await ProxyService.realm.getCustomer(id: transaction.customerId);

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

    try {
      final url = '$ebmUrl/trnsSales/saveSales';
      final response = await sendPostRequest(url, finalData);

      if (response.statusCode == 200) {
        sendEmailLogging(
          requestBody: finalData.toString(),
          subject: "Worked",
          body: response.data.toString(),
        );

        final data = EBMApiResponse.fromJson(response.data);
        if (data.resultCd != "000") {
          throw Exception(
            "Failed to send request with invoice number ${counter.curRcptNo}: ${data.resultMsg}",
          );
        }
        return data;
      } else {
        throw Exception(
          "Failed to send request. Status Code: ${response.statusCode}",
        );
      }
    } catch (e, st) {
      print("Exception: $e");
      print("Exception: $st");
      throw Exception(
        "Failed to send request with invoice number ${counter.curRcptNo}: $e",
      );
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
    /// I have a dilema, for example a business should know that a purchase code is mandatory
    /// if a customer is a business, given to ease of use  I think if purchase code is not provided
    /// it is safe to assume that this is not a business, but of cause I can change this
    /// after I learn more on how business use software.
    if (transaction.customerId != null && purchaseCode != null) {
      json[custTinKey] = customer.custTin;
      json[custNmKey] = customer.custNm;
      json[prcOrdCd] = purchaseCode;
    }

    return json;
  }

  @override
  Future<EBMApiResponse> saveCustomer({required Customer customer}) async {
    final url = '$ebmUrl/branches/saveBrancheCustomers';

    try {
      final response = await sendPostRequest(
          url, customer.toEJson() as Map<String, dynamic>);

      if (response.statusCode == 200) {
        sendEmailLogging(
          requestBody: customer.toEJson().toString(),
          subject: "Worked",
          body: response.data.toString(),
        );

        final data = EBMApiResponse.fromJson(response.data);
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
}
