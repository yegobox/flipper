import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/mail_log.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

class RWTax implements TaxApi {
  String itemPrefix = "flip-";

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
    var headers = {'Content-Type': 'application/json'};
    Variant? variant =
        await ProxyService.isar.getVariantById(id: stock.variantId);
    EBM? ebm = await ProxyService.isar
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
    var request = http.Request(
        'POST', Uri.parse(ebm!.taxServerUrl! + '/stockMaster/saveStockMaster'));
    variant?.rsdQty = stock.rsdQty;
    request.body = json.encode(variant?.toJson());
    request.headers.addAll(headers);
    // log(variant!.toJson().toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ProxyService.sentry.debug(event: stock.toJson().toString());
      log(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      log(response.reasonPhrase!);
      return Future.value(false);
    }
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
    EBM? ebm = await ProxyService.isar
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
    if (ebm == null) {
      return false;
    }
    var request =
        http.Request('POST', Uri.parse(ebm.taxServerUrl! + '/items/saveItems'));
    // log(variation.toJson().toString());
    request.body = json.encode(variation.toJson());

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      sendEmailNotification(
          requestData: variation.toJson().toString(),
          responseData: response.stream.bytesToString().toString());
      ProxyService.sentry.debug(event: variation.toJson().toString());
      // log(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      return Future.value(false);
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
      sendEmailNotification(
          requestData: {
            "tin": tinNumber,
            "bhfId": bhfId,
            "lastReqDt": lastReqDt
          }.toString(),
          responseData: response.stream.bytesToString().toString());
      return Future.value(true);
    } else {
      // print(response.reasonPhrase);
      return Future.value(false);
    }
  }

  @override
  Future<ReceiptSignature?> createReceipt(
      {Customer? customer,
      required ITransaction transaction,
      required List<TransactionItem> items,
      required String receiptType,
      required Counter counter}) async {
    Business? business = await ProxyService.isar.getBusiness();

    String date = DateTime.now()
        .toString()
        .replaceAll(":", "")
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .substring(0, 14);
    var headers = {'Content-Type': 'application/json'};
    EBM? ebm = await ProxyService.isar
        .getEbmByBranchId(branchId: ProxyService.box.getBranchId()!);
    if (ebm == null) {
      return null;
    }
    var request = http.Request(
        'POST', Uri.parse(ebm.taxServerUrl! + '/trnsSales/saveSales'));
    List<Map<String, dynamic>> itemsList = [];
    for (var item in items) {
      itemsList.add(item.toJson());
    }

    double totalMinusExemptedProducts = 0;
    for (var item in items) {
      if (!item.isTaxExempted) {
        totalMinusExemptedProducts += (item.prc! * item.qty);
      }
    }
    // default is Normal sale
    String salesTyCd = "N";
    String rcptTyCd = "S";
    // normal refund
    if (receiptType == "NR") {
      salesTyCd = "N";
      rcptTyCd = "R";
    }
    // copy sale
    if (receiptType == "CS") {
      salesTyCd = "C";
      rcptTyCd = "S";
    }
    // training sale
    if (receiptType == "TS") {
      salesTyCd = "T";
      rcptTyCd = "S";
    }
    // profoma invoice
    if (receiptType == "PS") {
      salesTyCd = "P";
      rcptTyCd = "S";
    }

    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      "invcNo": transaction.id.substring(0, 10),
      "orgInvcNo": 0,
      "custTin": customer == null ? "" : customer.tinNumber,
      "custNm": customer == null ? "" : customer.name,
      "salesTyCd": salesTyCd,
      "rcptTyCd": rcptTyCd,
      "pmtTyCd": "01",
      "salesSttsCd": "02",
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      "stockRlsDt": date,
      "cnclReqDt": null,
      "cnclDt": null,
      "rfdDt": null,
      "rfdRsnCd": null,
      "totItemCnt": itemsList.length,
      "taxblAmtA": 0,
      "taxblAmtB": totalMinusExemptedProducts,
      "taxblAmtC": 0,
      "taxblAmtD": 0,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "taxAmtA": 0,
      "taxAmtB": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "taxAmtC": 0,
      "taxAmtD": 0,
      "totTaxblAmt": totalMinusExemptedProducts,
      "totTaxAmt": (totalMinusExemptedProducts * 18 / 118).toStringAsFixed(2),
      "totAmt": totalMinusExemptedProducts,
      "prchrAcptcYn": "N",
      "remark": null,
      "regrId": transaction.id,
      "regrNm": transaction.id,
      "modrId": transaction.id,
      "modrNm": transaction.id,
      "receipt": {
        "curRcptNo": counter.curRcptNo,
        "totRcptNo": counter.totRcptNo,
        "custTin": customer == null ? "" : customer.tinNumber,
        "custMblNo": customer == null ? "" : customer.phone,
        "rptNo": date,
        "rcptPbctDt": date,
        "intrlData": itemPrefix +
            transaction.id.toString() +
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
        "rcptSign": itemPrefix +
            transaction.id.toString() +
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 11),
        "jrnl": "",
        "trdeNm": business.name,
        "adrs": business.adrs,
        "topMsg": "Shop with us",
        "btmMsg": "Welcome",
        // Whether buyers receive item or not. default to Y es
        "prchrAcptcYn": "Y"
      },
      "itemList": itemsList
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ProxyService.sentry.debug(event: request.body.toString());

      sendEmailNotification(
          requestData: request.body,
          responseData: response.stream.bytesToString().toString());
      if (ProxyService.remoteConfig.isMarketingFeatureEnabled()) {
        SentryId sentryId = await Sentry.captureMessage("EBM-JSON");

        final userFeedback = SentryUserFeedback(
          eventId: sentryId,
          comments: request.body,
          email: ProxyService.box.getUserPhone(),
          name: ProxyService.box.getUserPhone(),
        );

        Sentry.captureUserFeedback(userFeedback);
      }
      return Future.value(ReceiptSignature.fromJson(
          json.decode(await response.stream.bytesToString())));
    } else {
      return null;
    }
  }
}
