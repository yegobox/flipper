import 'dart:convert';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/tax_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class RWTax implements TaxInterface {
  String apihub = "https://turbo.yegobox.com";

  @override
  Future<bool> saveStock({required Stock stock}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(apihub + '/stockMaster/saveStockMaster'));
    request.body = json.encode({
      "tin": "999909695",
      "bhfId": "00",
      "itemCd": "Flipper-" + stock.id.toString(),
      "rsdQty": 0,
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

  @override
  Future<bool> saveItem({required Variant product}) async {
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(apihub + '/items/saveItems'));
    request.body = json.encode({
      "tin": "999909695",
      "bhfId": "00",
      "itemCd": "Flipper-" + product.id.toString(),
      "itemClsCd": "Flipper-" + product.id.toString(),
      "itemTyCd": "1",
      "itemNm": product.name,
      "itemStdNm": product.name,
      "orgnNatCd": "RW",
      "pkgUnitCd": "NT",
      "qtyUnitCd": "CA",
      "taxTyCd": "B",
      "dftPrc": 400.0,
      "addInfo": "A",
      "isrcAplcbYn": "N",
      "useYn": "N",
      "regrId": product.id,
      "regrNm": product.name,
      "modrId": product.id,
      "modrNm": product.name
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}
