import 'dart:convert';
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
    var request = http.Request('POST',
        Uri.parse('https://apihub.yegobox.com/initializer/selectInitInfo'));
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
    Business? business = await ProxyService.isarApi.getBusiness();
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(apihub + '/stockMaster/saveStockMaster'));
    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      "itemCd": itemPrefix + stock.variantId.toString(),
      // remaining stock
      "rsdQty": stock.currentStock,
      "modrNm": stock.productId,
      "regrId": stock.productId,
      "regrNm": stock.productId,
      "modrId": stock.id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
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
    Business? business = await ProxyService.isarApi.getBusiness();
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(apihub + '/items/saveItems'));
    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      // item code
      "itemCd": itemPrefix + variation.id.toString(),
      // item clasification code
      "itemClsCd": itemPrefix + variation.id.toString(),
      // Item Type code
      "itemTyCd": "1",
      "itemNm": variation.name,
      "itemStdNm": variation.name,
      // Origin place code
      "orgnNatCd": "RW",
      // package unit code
      "pkgUnitCd": "NT",
      // Quantity unit code
      "qtyUnitCd": "CA",
      "taxTyCd": "B",
      "dftPrc": 400.0,
      "addInfo": "A",
      // insurance applicable
      "isrcAplcbYn": "N",
      // Used
      "useYn": "N",
      "regrId": variation.id,
      "regrNm": variation.name,
      "modrId": variation.id,
      "modrNm": variation.name
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
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
      // Validated Date
      // yyyMMddhhmmss
      "cfmDt": "20210709120300",
      "salesDt": "20210709",
      // Stock Released Date
      // YYYY-MM-DD HH24:MI:SS
      "stockRlsDt": "20210709120300",
      // "cnclReqDt": null,
      // "cnclDt": null,
      // "rfdDt": null,
      // "rfdRsnCd": null,
      "totItemCnt": 2,
      "taxblAmtA": 0,
      "taxblAmtB": 250000,
      "taxblAmtC": 0,
      "taxblAmtD": 0,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "taxAmtA": 0,
      "taxAmtB": 94576,
      "taxAmtC": 0,
      "taxAmtD": 0,
      "totTaxblAmt": 250000,
      "totTaxAmt": 38135,
      "totAmt": 250000,
      "prchrAcptcYn": "N",
      "remark": null,
      "regrId": "11999",
      "regrNm": "Test VSDC",
      // Modifier ID
      "modrId": order.id,
      // Modifier name
      "modrNm": order.id + order.branchId,
      "receipt": {
        // Current Receipt number
        "curRcptNo": 1,
        // Total Receipt Number
        "totRcptNo": 1,
        "custTin": customer == null ? "" : customer.tinNumber,
        "custMblNo": customer == null ? "" : customer.phone,
        "rptNo": 248,
        "rcptPbctDt": "20201118120300",
        "intrlData": itemPrefix +
            order.id.toString() +
            DateTime.now().millisecond.toString(),
        "rcptSign":
            itemPrefix + order.id.toString() + DateTime.now().toString(),
        // "jrnl": "",
        "trdeNm": business.name,
        "adrs": business.adrs,
        "topMsg": "Shopwithus",
        "btmMsg": "Welcome",
        // Whether buyers receive item or not. default to Y es
        "prchrAcptcYn": "Y"
      },
      "itemList": [
        {
          "itemSeq": 1,
          "itemCd": "RW1NTXU0000001",
          "itemClsCd": "5059690800",
          "itemNm": "OutDoorUnit",
          "bcd": null,
          "pkgUnitCd": "NT",
          "pkg": 1,
          "qtyUnitCd": "U",
          "qty": 1,
          // unit price, no
          "prc": 200000,
          // supply amount, no
          "splyAmt": 200000,
          // discount rate, no
          "dcRt": 0,
          // discount amount, no
          "dcAmt": 0,
          "isrccCd": null,
          "isrccNm": null,
          "isrcRt": null,
          "isrcAmt": null,
          "taxTyCd": "B",
          // no, taxable amount
          "taxblAmt": 200000,
          // Tax, amount
          "taxAmt": 30508,
          // total amount
          "totAmt": 200000
        }
      ]
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
