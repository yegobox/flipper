import 'dart:convert';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/tax_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class RWTax implements TaxInterface {
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
      "itemCd": itemPrefix + variation.id.toString(),
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
      print(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      print(response.reasonPhrase);
      return Future.value(false);
    }
  }

  @override
  Future<bool> savePurchases({
    required Order order,
    required List<OrderItem> items,
  }) async {
    Business? business = await ProxyService.isarApi.getBusiness();
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(apihub + 'trnsPurchase/savePurchases'));
    request.body = json.encode({
      "tin": business!.tinNumber,
      "bhfId": business.bhfId,
      "invcNo": order.id + DateTime.now().millisecond,
      "orgInvcNo": 0,
      "spplrTin": null,
      "spplrBhfId": null,
      "spplrNm": null,
      "spplrInvcNo": null,
      "regTyCd": "M",
      "pchsTyCd": "N",
      "rcptTyCd": "P",
      "pmtTyCd": "01",
      "pchsSttsCd": "02",
      "cfmDt": "20200127210300",
      "pchsDt": "20200127",
      "wrhsDt": "",
      "cnclReqDt": "",
      "cnclDt": "",
      "rfdDt": "",
      "totItemCnt": 2,
      "taxblAmtA": 0,
      "taxblAmtB": 10500,
      "taxblAmtC": 0,
      "taxblAmtD": 0,
      "taxRtA": 0,
      "taxRtB": 18,
      "taxRtC": 0,
      "taxRtD": 0,
      "taxAmtA": 0,
      "taxAmtB": 1890,
      "taxAmtC": 0,
      "taxAmtD": 0,
      "totTaxblAmt": order.subTotal,
      "totTaxAmt": 1890,
      // is Total Taxable Amount different from totTaxblAmt Total Tax amount (totTaxAmt)?
      "totAmt": order.subTotal,
      "remark": null,
      "modrId": 123,
      "modrNm": "name",
      "regrId": 1,
      "regrNm": "name",
      "itemList": items
      // "itemList": [
      //   {
      //     "itemSeq": 1,
      //     "itemCd": "RW1NTXU0000001",
      //     "itemClsCd": "5059690800",
      //     "itemNm": "test item 1",
      //     "bcd": "",
      //     "spplrItemClsCd": null,
      //     "spplrItemCd": null,
      //     "spplrItemNm": null,
      //     "pkgUnitCd": "NT",
      //     "pkg": 2,
      //     "qtyUnitCd": "U",
      //     "qty": 2,
      //     "prc": 3500,
      //     "splyAmt": 7000,
      //     "dcRt": 0,
      //     "dcAmt": 0,
      //     "taxblAmt": 7000,
      //     "taxTyCd": "B",
      //     "taxAmt": 1260,
      //     "totAmt": 7000,
      //     "itemExprDt": null
      //   }
      // ]
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
