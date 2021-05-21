import 'dart:convert';

import 'package:flipper_models/models/branch.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/color.dart';
import 'package:flipper_models/models/login.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/spenn.dart';
import 'package:flipper_models/models/stock.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/unit.dart';
import 'package:flipper_models/models/variant_stock.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/sync.dart';
import 'package:injectable/injectable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'abstractions/api.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_models/models/variation.dart';

import 'constants.dart';

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;
  final box = GetStorage();
  // ignore: sort_constructors_first
  ExtendedClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String? token = box.read('bearerToken');
    String? userId = box.read('userId');
    // you may want to pickup the value from tshared preferences, like:
    // customValue = await LocalStorage.getStringItem('token');
    request.headers['Authorization'] = token == null ? '' : token;
    request.headers['userId'] = userId == null ? '' : userId;
    return _inner.send(request);
  }
}

@lazySingleton
class HttpApi<T> implements Api {
  ExtendedClient client = ExtendedClient(http.Client());
  String flipperApi = "https://flipper.yegobox.com";
  String apihub = "https://apihub.yegobox.com";
  @override
  Future<Login> login({required String phone}) async {
    final response = await client
        .post(Uri.parse("$flipperApi/open-login"), body: {'phone': phone});
    final Login resp = loginFromJson(response.body);
    ProxyService.box.write(key: 'UToken', value: resp.token);
    return resp;
  }

  @override
  Future<Sync> authenticateWithOfflineDb({required String userId}) async {
    final response = await client.post(Uri.parse("$apihub/auth"),
        body: jsonEncode({'userId': userId}),
        headers: {'Content-Type': 'application/json'});
    //save the token in local storage.
    final box = GetStorage();

    box.write('bearerToken', syncFromJson(response.body).token);
    box.write('userId', syncFromJson(response.body).userId);
    return syncFromJson(response.body);
  }

  @override
  Future<List<Business>> businesses() async {
    final response = await client.get(Uri.parse("$apihub/api/businesses"));

    return businessFromJson(response.body);
  }

  @override
  Future<int> signup({required Map business}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/business"),
        body: jsonEncode(business),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<List<Product>> products() async {
    final response = await client.get(Uri.parse("$apihub/api/products"));
    return productFromJson(response.body);
  }

  @override
  Future<List<Stock>> stocks({required String productId}) async {
    final response = await client
        .get(Uri.parse("$apihub/api/stocks-byProductId/$productId"));

    return stockFromJson(response.body);
  }

  @override
  Future<List<Branch>> branches({required String businessId}) async {
    final response =
        await client.get(Uri.parse("$apihub/api/branches/$businessId"));

    return branchFromJson(response.body);
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/$endPoint"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<bool> logOut() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    return true;
  }

  @override
  Future<List<PColor>> colors({required String branchId}) async {
    final response =
        await client.get(Uri.parse("$apihub/api/colors/$branchId"));

    return pColorFromJson(response.body);
  }

  @override
  Future<List<Category>> categories({required String branchId}) async {
    final response =
        await client.get(Uri.parse("$apihub/api/categories/$branchId"));

    return categoryFromJson(response.body);
  }

  @override
  Future<List<Unit>> units({required String branchId}) async {
    final response = await client.get(Uri.parse("$apihub/api/units/$branchId"));

    return unitFromJson(response.body);
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId}) async {
    final response = await client
        .get(Uri.parse("$apihub/api/stock-variant/$branchId/$variantId"));

    return variantStockFromJson(response.body);
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    final response = await client.post(Uri.parse("$apihub/api/product"),
        body: jsonEncode(product),
        headers: {'Content-Type': 'application/json'});
    print(response.body);
    return sproductFromJson(response.body);
  }

  @override
  Future<List<Product>> isTempProductExist() async {
    final response = await client.get(Uri.parse("$apihub/api/Product/temp"));
    return productFromJson(response.body);
  }
  // FIXME: fix the api to retun variants by productId

  @override
  Future<List<Variation>> variants(
      {required String branchId, required String productId}) async {
    final response =
        await client.get(Uri.parse("$apihub/api/variants/$productId"));

    return variationFromJson(response.body);
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) async {
    final response = await client.patch(Uri.parse("$apihub/api/$endPoint"),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) async {
    final response =
        await client.delete(Uri.parse("$apihub/api/$endPoint/$id"));
    return response.statusCode == 200;
  }

  @override
  Future<int> addUnits({required Map data}) async {
    final unitId = Uuid().v1();
    data['id'] = unitId;
    data['table'] = AppTables.unit;
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/unit"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<PColor> getColor({required String id, String? endPoint}) async {
    final response = await client.get(Uri.parse("$apihub/api/$endPoint/$id"));
    return spColorFromJson(response.body);
  }

  @override
  Future<int> addVariant(
      {required List<Variation> data,
      required double retailPrice,
      required double supplyPrice}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/api/variant"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    return response.statusCode;
  }

  @override
  Future<Product> getProduct({required String id}) async {
    final response = await client.get(Uri.parse("$apihub/api/product/$id"));
    return sproductFromJson(response.body);
  }

  @override
  Future<Stock> stockByVariantId({required String variantId}) async {
    final response = await client
        .get(Uri.parse("$apihub/api/stocks-byVariantId/$variantId"));

    return stockFromJson(response.body)[0];
  }

  @override
  Stream<Stock> stockByVariantIdStream({required String variantId}) async* {
    final response = await client
        .get(Uri.parse("$apihub/api/stocks-byVariantId/$variantId"));
    print('stream:$variantId');

    yield stockFromJson(response.body)[0];
  }

  Future<Order?> pendingOrderExist() async {
    final response = await client.get(Uri.parse("$apihub/api/draft-order"));

    return sorderFromJson(response.body[0]);
  }

  @override
  Future<Order> createOrder(
      {required double customAmount,
      required Variation variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) async {
    final id4 = Uuid().v1();
    final orderItemId = Uuid().v1();
    final ref = Uuid().v1();
    final orderNUmber = Uuid().v1();
    String userId = ProxyService.box.read(key: 'userId');
    String branchId = ProxyService.box.read(key: 'branchId');
    Order? existOrder = await pendingOrderExist();

    // Document docStock = db.getDocument(stockId);
    // Stock stock = sstockFromJson(docStock.json);

    if (existOrder == null) {
      Order order = new Order(
        id: id4,
        reference: ref,
        orderNumber: orderNUmber,
        status: 'pending',
        orderType: orderType,
        active: true,
        draft: true,
        channels: [userId],
        subTotal: customAmount,
        table: AppTables.order,
        cashReceived: customAmount,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0, //fix this
        paymentType: 'Cash',
        branchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
        orderItems: [
          OrderItem(
            count: quantity,
            name: useProductName ? variation.productName : variation.name,
            variantId: variation.id,
            id: orderItemId,
            price: price,
            orderId: id4,
          )
        ],
      );

      final http.Response response = await client.post(
          Uri.parse("$apihub/api/order"),
          body: jsonEncode(order.toJson()),
          headers: {'Content-Type': 'application/json'});

      return sorderFromJson(response.body[0]);
    } else {
      OrderItem item = OrderItem(
        count: 1,
        name: useProductName ? variation.productName : variation.name,
        variantId: variation.id,
        id: orderItemId,
        price: price,
        orderId: existOrder.id,
      );
      existOrder.orderItems.add(item);
      update(data: existOrder.toJson(), endPoint: 'order');
      return existOrder;
    }
  }

  @override
  Future<Variation> getCustomProductVariant() async {
    final response =
        await client.get(Uri.parse("$apihub/api/variantCustomProduct"));

    return svariationFromJson(response.body[0]);
  }

  @override
  Future<List<Order>> orders() async {
    final response = await client.get(Uri.parse("$apihub/api/orders"));

    return orderFromJson(response.body);
  }

  @override
  Future<Variation> variant({required String variantId}) async {
    final response =
        await client.get(Uri.parse("$apihub/api/variant/$variantId"));

    return svariationFromJson(response.body[0]);
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    String userId = ProxyService.box.read(key: 'userId');
    // final response = await client.post(Uri.parse("$flipperApi/pay"),
    //     body: jsonEncode({
    //       'amount': amount,
    //       'message': '-' + transactionNumber.substring(0, 4),
    //       'phoneNumber': '+25' + phoneNumber,
    //       'uid': userId
    //     }),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json'
    //     });
    // return spennFromJson(response.body);
    print('+25' + phoneNumber);
    Spenn spenn = new Spenn(id: '1', requestId: 'uid', status: 'complented');
    return spenn;
    //
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required Order order}) async {
    final endPoint = "order";
    Map data = order.toJson();
    data['cashReceived'] = cashReceived;
    data['status'] = 'completed';
    data['draft'] = false;

    await client.patch(Uri.parse("$apihub/api/$endPoint/$data['id']"),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }
}
