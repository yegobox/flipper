import 'dart:convert';
import 'dart:developer';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class RWTax implements TaxApi {
  String itemPrefix = "flip-";
  late String apihub;

  RWTax({required this.apihub});

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
        await ProxyService.isarApi.getVariantById(id: stock.variantId);
    var request = http.Request(
        'POST', Uri.parse(apihub + '/stockMaster/saveStockMaster'));
    variant?.rsdQty = stock.rsdQty;
    request.body = json.encode(variant?.toJson());
    request.headers.addAll(headers);
    // log(variant!.toJson().toString());
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
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
    var request = http.Request('POST', Uri.parse(apihub + '/items/saveItems'));
    // log(variation.toJson().toString());
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
  Future<ReceiptSignature?> createReceipt(
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
        http.Request('POST', Uri.parse(apihub + '/trnsSales/saveSales'));
    List<Map<String, dynamic>> itemsList = [];
    for (var item in items) {
      itemsList.add(item.toJson());
    }

    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      "invcNo": order.id + DateTime.now().microsecond,
      "orgInvcNo": 0,
      "custTin": customer == null ? "" : customer.tinNumber,
      "custNm": customer == null ? "" : customer.name,
      //TODONormal Sale Make this dynamic later.
      "salesTyCd": "N",
      //TODOThis is a sale not a refund Make this dynamic later.s
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
      "totItemCnt": itemsList.length,
      "taxblAmtA": 0,
      "taxblAmtB": order.subTotal,
      "taxblAmtC": 0,
      "taxblAmtD": 0,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "taxAmtA": 0,
      "taxAmtB": (order.subTotal * 18 / 118).toStringAsFixed(2),
      "taxAmtC": 0,
      "taxAmtD": 0,
      "totTaxblAmt": order.subTotal,
      "totTaxAmt": (order.subTotal * 18 / 118).toStringAsFixed(2),
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
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
        "rcptSign": itemPrefix +
            order.id.toString() +
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
      return Future.value(ReceiptSignature.fromJson(
          json.decode(await response.stream.bytesToString())));
    } else {
      return null;
    }
  }
}
