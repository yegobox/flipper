import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class RWTax implements TaxApi {
  String apihub = "https://turbo.yegobox.com";
  String itemPrefix = "flipper-";

  @override
  Future<bool> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
  }) async {
    String? token = ProxyService.box.read(key: 'bearerToken');
    var headers = {'Authorization': token!, 'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(apihub + 'initializer/selectInitInfo'));
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
  /// The API will not fail even if the item Code @[itemCd] is not found
  /// in a ist of saved Item.
  /// @[rsdQty] is the remaining stock of the item.
  @override
  Future<bool> saveStock({required Stock stock}) async {
    var headers = {'Content-Type': 'application/json'};
    Variant? variant =
        await ProxyService.isarApi.getVariantById(id: stock.variantId);
    var request = http.Request(
        'POST', Uri.parse(apihub + '/stockMaster/saveStockMaster'));
    request.body = json.encode(variant?.toJson());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // log(variant!.toJson().toString());
      // log(await response.stream.bytesToString());
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
    var request = http.Request('POST', Uri.parse(apihub + '/items/saveItems'));
    log(variation.toJson().toString());
    request.body = json.encode(variation.toJson());

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
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
    var request =
        http.Request('POST', Uri.parse(apihub + '/items/selectItems'));
    request.body =
        json.encode({"tin": tinNumber, "bhfId": bhfId, "lastReqDt": lastReqDt});
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
  Future<bool> createReceipt(
      {Customer? customer,
      required Order order,
      required List<OrderItem> items,
      re}) async {
    Business? business = await ProxyService.isarApi.getBusiness();

    String date = DateTime.now()
        .toString()
        .replaceAll(":", "")
        .replaceAll("-", "")
        .replaceAll(" ", "")
        .substring(0, 14);
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(apihub + 'trnsSales/saveSales'));
    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      "invcNo": order.id + DateTime.now().millisecond,
      "orgInvcNo": 0,
      "custTin": customer == null ? "" : customer.tinNumber,
      "custNm": customer == null ? "" : customer.name,
      "salesTyCd": "N",
      "rcptTyCd": "S",
      "pmtTyCd": "01",
      "salesSttsCd": "02",
      "cfmDt": date,
      "salesDt": date.substring(0, 8),
      "stockRlsDt": date,
      "cnclReqDt": null,
      "cnclDt": null,
      "rfdDt": null,
      "rfdRsnCd": null,
      "totItemCnt": 2,
      "taxblAmtA": 0,
      "taxblAmtB": order.subTotal,
      "taxblAmtC": 0,
      "taxblAmtD": 0,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "taxAmtA": 0,
      "taxAmtB": order.subTotal * 18 / 118,
      "taxAmtC": 0,
      "taxAmtD": 0,
      "totTaxblAmt": order.subTotal,
      "totTaxAmt": order.subTotal * 18 / 118,
      "totAmt": order.subTotal,
      "prchrAcptcYn": "N",
      "remark": null,
      "regrId": order.id,
      "regrNm": order.id,
      "modrId": order.id,
      "modrNm": order.id + order.branchId,
      "receipt": {
        // Current Receipt number
        "curRcptNo": order.id,
        // Total Receipt Number
        "totRcptNo": 1,
        "custTin": customer == null ? "" : customer.tinNumber,
        "custMblNo": customer == null ? "" : customer.phone,
        "rptNo": date,
        "rcptPbctDt": date,
        "intrlData": itemPrefix +
            order.id.toString() +
            DateTime.now().millisecond.toString(),
        "rcptSign":
            itemPrefix + order.id.toString() + DateTime.now().toString(),
        "jrnl": "",
        "trdeNm": business.name,
        "adrs": business.adrs,
        "topMsg": "Shop with us",
        "btmMsg": "Welcome",
        // Whether buyers receive item or not. default to Y es
        "prchrAcptcYn": "Y"
      },
      "itemList": items
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
