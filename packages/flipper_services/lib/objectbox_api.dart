import 'dart:convert';
import 'dart:io';

import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_models/order_item.dart';

import 'package:flipper_models/variant_stock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/unit.dart';

import 'package:flipper_models/sync.dart';

import 'package:flipper_models/stock.dart';

import 'package:flipper_models/product.dart';

import 'package:flipper_models/login.dart';

import 'package:flipper_models/color.dart';

import 'package:flipper_models/category.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/business.dart';

import 'package:flipper_models/branch.dart';
import 'package:flipper_services/http_api.dart';
import 'abstractions/api.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
// import 'api_result.dart';
import 'dio_client.dart';
// import 'network_exceptions.dart';

class ObjectBoxApi implements Api {
  ExtendedClient client = ExtendedClient(http.Client());
  String flipperApi = "https://flipper.yegobox.com";
  // late DioClient dioClient;
  String apihub = "https://apihub.yegobox.com";
  late Store _store;
  getDir({required String dbName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    _store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');
  }

  ObjectBoxApi({required String dbName, Directory? dir}) {
    // var dio = Dio();
    // dioClient = DioClient(apihub, dio, interceptors: []);
    if (dir != null) {
      _store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');
    } else {
      getDir(dbName: dbName);
    }
  }
  @override
  Future<List<Unit>> units({required int branchId}) async {
    return _store
        .box<Unit>()
        .getAll()
        .where((unit) => unit.fbranchId == branchId)
        .toList();
  }

  @override
  Future<List<Business>> businesses() async {
    final response = await client.get(Uri.parse("$apihub/v2/api/businesses"));

    return businessFromJson(response.body);
    // final response = await dioClient.get(
    //   "$apihub/v2/api/businesses",
    // );
    // List<Business> businesses = [];
    // try {
    //   return businessFromJson(response);
    // } catch (e) {
    //   print(e);
    // }
    // return businesses;
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    return _store
        .box<Category>()
        .getAll()
        .where((category) => category.fbranchId == branchId)
        .toList();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return _store
        .box<PColor>()
        .getAll()
        .where((color) => color.fbranchId == branchId)
        .toList();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) async {
    if (endPoint == 'color') {
      for (String co in data['colors']) {
        final color = PColor(
            name: co,
            table: data['table'],
            active: data['active'],
            fbranchId: ProxyService.box.read(key: 'branchId'));
        final box = _store.box<PColor>();
        box.put(color);
      }
      return 200;
    }
    if (endPoint == 'category') {
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch,
        name: data['name'],
        table: data['table'],
        active: data['active'],
        fbranchId: ProxyService.box.read(key: 'branchId'),
        focused: false,
      );
      final box = _store.box<Category>();
      box.put(category);
      return 200;
    }
    return 200;
  }

  @override
  Future<List<Product>> isTempProductExist() async {
    return _store
        .box<Product>()
        .getAll()
        .where((product) => product.name == 'temp')
        .toList();
  }

  @override
  Future<List<Product>> products() async {
    return _store.box<Product>().getAll();
  }

  @override
  Future<bool> logOut() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'branchId');
    return true;
  }

  @override
  Future<Login> login({required String phone}) async {
    final response = await client
        .post(Uri.parse("$flipperApi/open-login"), body: {'phone': phone});
    final Login resp = loginFromJson(response.body);
    ProxyService.box.write(key: 'UToken', value: resp.token);
    return resp;
  }

  @override
  Future<int> signup({required Map business}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/v2/api/business"),
        body: jsonEncode(business),
        headers: {'Content-Type': 'application/json'});
    return response.statusCode;
  }

  @override
  Future<List<Stock>> stocks({required int productId}) async {
    List<Stock> stocks = _store
        .box<Stock>()
        .getAll()
        .where((stock) => stock.fproductId == productId)
        .toList();
    return stocks;
  }

  @override
  Future<Variant?> variant({required int variantId}) async {
    return _store.box<Variant>().get(variantId);
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, required int productId}) async {
    return _store
        .box<Variant>()
        .getAll()
        .where((v) => v.fproductId == productId)
        .toList();
  }

  @override
  Future<int> addUnits({required Map data}) async {
    for (Map map in data['units']) {
      final box = _store.box<Unit>();

      final unit = Unit(
          active: false,
          table: data['table'],
          value: map['value'],
          name: map['name'],
          fbranchId: ProxyService.box.read(key: 'branchId'));

      box.put(unit);
    }
    return 200;
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required int variantId}) async {
    List<Stock> stocks = _store
        .box<Stock>()
        .getAll()
        .where((v) => v.fvariantId == variantId)
        .toList();
    if (stocks.length > 0) {
      return stocks[0];
    }
    return null;
  }

  @override
  Future<bool> delete({required dynamic id, String? endPoint}) async {
    switch (endPoint) {
      case 'color':
        _store.box<PColor>().remove(id);
        break;
      case 'orderItem':
        _store.box<OrderItem>().remove(id);
        break;
      case 'product':
        _store.box<Product>().remove(id);
        break;
      case 'stock':
        _store.box<Stock>().remove(id);
        break;
      case 'variation':
        _store.box<Variant>().remove(id);
        break;
      default:
    }
    return true;
  }

  @override
  Future<int> addVariant(
      {required List<Variant> data,
      required double retailPrice,
      required double supplyPrice}) async {
    for (Variant variation in data) {
      Map d = variation.toJson();
      final box = _store.box<Variant>();
      final variantId = box.put(variation);
      final stockId = DateTime.now().millisecondsSinceEpoch;
      String? userId = ProxyService.box.read(key: 'userId');
      final stock = new Stock(
        id: stockId,
        fvariantId: variantId,
        lowStock: 0.0,
        currentStock: 0.0,
        supplyPrice: supplyPrice,
        retailPrice: retailPrice,
        canTrackingStock: false,
        showLowStockAlert: false,
        channels: [userId!],
        table: AppTables.stock,
        fproductId: int.parse(d['productId'].toString()),
        value: 0,
        active: false,
      );
      final stockBox = _store.box<Stock>();
      stockBox.put(stock);
    }
    return 200;
  }

  @override
  Future<List<Branch>> branches({required int businessId}) async {
    // final response = await dioClient.get(
    //   "$apihub/v2/api/branches/$businessId",
    // );
    // print(response);
    // List<Branch> branches = branchFromJson(response);
    // return branches;
    final response =
        await client.get(Uri.parse("$apihub/v2/api/branches/$businessId"));
    return branchFromJson(response.body);
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order}) async {
    Map data = order.toJson();
    data['cashReceived'] = cashReceived;
    data['status'] = 'completed';
    data['draft'] = false;
    update(data: data, endPoint: 'order');
  }

  Future<OrderF?> pendingOrderExist() async {
    return _store
        .box<OrderF>()
        .query(OrderF_.status.equals('pending'))
        .build()
        .findFirst();
  }

  @override
  Future<OrderF> createOrder(
      {required double customAmount,
      required Variant variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) async {
    // final orderItemId = DateTime.now().millisecondsSinceEpoch;
    final ref = Uuid().v1();
    final orderNUmber = Uuid().v1();
    String userId = ProxyService.box.read(key: 'userId');
    int branchId = ProxyService.box.read(key: 'branchId');
    OrderF? existOrder = await pendingOrderExist();
    if (existOrder == null) {
      final order = new OrderF(
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
        fbranchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );
      OrderItem orderItems = OrderItem(
        count: quantity,
        name: useProductName ? variation.productName : variation.name,
        fvariantId: variation.id,
        price: price,
        forderId: order.id,
      );
      order.orderItems.add(orderItems);
      final box = _store.box<OrderF>();
      final id = box.put(order);
      return _store.box<OrderF>().get(id)!;
    } else {
      OrderItem item = OrderItem(
        count: 1,
        name: useProductName ? variation.productName : variation.name,
        fvariantId: variation.id,
        price: price,
        forderId: existOrder.id,
      );
      existOrder.orderItems.add(item);
      // final box = _store.box<OrderF>();
      // final id = box.put(existOrder, mode: PutMode.update);
      final id = _store.box<OrderF>().put(existOrder);
      // update(data: existOrder.toJson(), endPoint: 'order');
      return _store.box<OrderF>().get(id)!;
    }
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    final Map data = product.toJson();

    data['active'] = false;
    data['description'] = 'description';
    data['hasPicture'] = false;
    data['fbusinessId'] = ProxyService.box.read(key: 'businessId');
    data['fbranchId'] = ProxyService.box.read(key: 'branchId');
    data['taxId'] = 'XX';
    Product products = Product(
        active: data['active'],
        fbranchId: data['fbranchId'],
        fbusinessId: data['fbusinessId'],
        color: data['color'],
        description: data['description'],
        hasPicture: data['hasPicture'],
        name: data['name'],
        table: data['table'],
        unit: data['unit'],
        createdAt: data['createdAt'],
        currentUpdate: data['currentUpdate'],
        draft: data['draft'],
        imageLocal: data['imageLocal'],
        imageUrl: data['imageUrl'],
        fsupplierId: data['fsupplierId'],
        ftaxId: data['ftaxId']);
    final String? userId = ProxyService.box.read(key: 'userId');
    final int? branchId = ProxyService.box.read(key: 'branchId');
    final productBox = _store.box<Product>();
    final id = productBox.put(products);
    Variant variant = Variant(
      name: 'Regular',
      sku: 'sku',
      fproductId: id,
      unit: 'Per Item',
      table: AppTables.variation,
      channels: [userId!],
      productName: data['name'],
      fbranchId: branchId!,
      taxName: 'N/A',
      taxPercentage: 0.0,
      retailPrice: 0.0,
      supplyPrice: 0.0,
    );

    products.variations.add(variant);
    final productId = _store.box<Product>().put(products);
    List<Variant> v = await variants(branchId: branchId, productId: productId);

    final stock = new Stock(
      fbranchId: branchId,
      fvariantId: v[0].id,
      lowStock: 0.0,
      currentStock: 0.0,
      supplyPrice: 0.0,
      retailPrice: 0.0,
      canTrackingStock: false,
      showLowStockAlert: false,
      channels: [userId],
      table: AppTables.stock,
      fproductId: productId,
      active: false,
      value: 0,
    );
    final stockBox = _store.box<Stock>();
    stockBox.put(stock);
    return _store.box<Product>().get(productId)!;
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) async {
    return _store.box<PColor>().get(id);
  }

  @override
  Future<Variant> getCustomProductVariant() async {
    // TODOthis is errorring.
    Product product = _store
        .box<Product>()
        .getAll()
        .where((v) => v.name == 'Custom Amount')
        .toList()[0];
    //once we have the product with the name then get related variants
    return _store
        .box<Variant>()
        .getAll()
        .where((v) => v.fproductId == product.id)
        .toList()[0];
  }

  @override
  Future<Product?> getProduct({required int id}) async {
    return _store.box<Product>().get(id);
  }

  @override
  Future<List<OrderF>> orders() async {
    return _store.box<OrderF>().getAll();
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    final int transactionNumber = DateTime.now().millisecondsSinceEpoch;
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
  Future<Stock> stockByVariantId({required int variantId}) async {
    return _store
        .box<Stock>()
        .getAll()
        .where((v) => v.fvariantId == variantId)
        .toList()[0];
  }

  @override
  Stream<Stock> stockByVariantIdStream({required int variantId}) {
    return _store
        .box<Stock>()
        .query(Stock_.fvariantId.equals(variantId))
        .watch(triggerImmediately: true)
        // Watching the query produces a Stream<Query<Stock>>
        // To get the actual data inside a List<Stock>, we need to call find() on the query
        .map((query) => query.find()[0]);
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) async {
    //clean the endPoint so we are able to use switch with no problem
    //the endPoint can be unit/1 so we want unit and 1 separately
    final split = endPoint.split('/');
    String point = endPoint;

    int id = 0;
    if (split.length == 2) {
      point = endPoint.split('/')[0];
      id = int.parse(endPoint.split('/')[1]);
    }
    final Map dn = data;
    switch (point) {
      case 'product':
        Product? kProduct = _store.box<Product>().get(data['id']);
        Map map = kProduct!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Product product = Product(
          active: map['active'],
          fbranchId: map['fbranchId'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          fbusinessId: map['fbusinessId'],
          fcategoryId: map['fcategoryId'],
          color: map['color'],
          description: map['description'],
          hasPicture: map['hasPicture'],
          name: map['name'],
          unit: map['unit'],
          createdAt: map['createdAt'],
          currentUpdate: map['currentUpdate'],
          draft: map['draft'],
          imageLocal: map['imageLocal'],
          imageUrl: map['imageUrl'],
          fsupplierId: map['fsupplierId'],
          ftaxId: map['ftaxId'],
        );
        final box = _store.box<Product>();
        box.put(product, mode: PutMode.update);
        break;
      case 'stock':
        Stock? color = _store.box<Stock>().get(id);
        Map map = color!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Stock stock = Stock(
          active: map['active'],
          fbranchId: map['branchId'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          canTrackingStock: map['canTrackingStock'],
          currentStock: map['currentStock'],
          lowStock: map['lowStock'],
          fproductId: map['fproductId'],
          retailPrice: map['retailPrice'],
          showLowStockAlert: map['showLowStockAlert'],
          supplyPrice: map['supplyPrice'],
          value: map['value'],
          fvariantId: map['fvariantId'],
        );
        final box = _store.box<Stock>();
        box.put(stock, mode: PutMode.update);
        break;
      case 'category':
        Category? color = _store.box<Category>().get(id);
        Map map = color!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Category category = Category(
          active: map['active'],
          fbranchId: map['fbranchId'],
          name: map['name'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          focused: map['focused'],
        );
        final box = _store.box<Category>();
        box.put(category, mode: PutMode.update);
        break;
      case 'variant':
        Variant? variation = _store.box<Variant>().get(id);
        Map map = variation!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Variant variant = Variant(
          fbranchId: map['fbranchId'],
          name: map['name'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          fproductId: map['fproductId'],
          productName: map['productName'],
          retailPrice: map['retailPrice'],
          sku: map['sku'],
          supplyPrice: map['supplyPrice'],
          unit: map['unit'],
        );
        final box = _store.box<Variant>();
        box.put(variant, mode: PutMode.update);
        break;
      case 'unit':
        Unit? color = _store.box<Unit>().get(id);
        Map map = color!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Unit unit = Unit(
          active: map['active'],
          fbranchId: map['branchId'],
          name: map['name'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          value: map['value'],
        );
        final box = _store.box<Unit>();
        box.put(unit, mode: PutMode.update);
        break;
      case 'color':
        PColor? color = _store.box<PColor>().get(id);
        Map map = color!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        PColor pcolor = PColor(
          active: map['active'],
          fbranchId: map['branchId'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          name: map['name'],
        );
        final box = _store.box<PColor>();
        box.put(pcolor, mode: PutMode.update);
        break;
      case 'order':
        OrderF? orders = _store.box<OrderF>().get(dn['id']);
        Map map = orders!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        OrderF order = OrderF(
          active: map['active'],
          fbranchId: map['fbranchId'],
          table: map['table'],
          channels: map['channels'],
          id: map['id'],
          cashReceived: map['cashReceived'],
          createdAt: map['createdAt'],
          customerChangeDue: map['customerChangeDue'],
          draft: map['draft'],
          orderNumber: map['orderNumber'],
          orderType: map['orderType'],
          paymentType: map['paymentType'],
          reference: map['reference'],
          status: map['status'],
          subTotal: map['subTotal'],
          updatedAt: map['updatedAt'],
        );
        final box = _store.box<OrderF>();
        box.put(order, mode: PutMode.update);
        break;
      // case 'category'
      default:
        return 200;
    }
    return 200;
  }

  @override
  Future<SyncF> authenticateWithOfflineDb({required String userId}) async {
    final response = await client.post(Uri.parse("$apihub/auth"),
        body: jsonEncode({'userId': userId}),
        headers: {'Content-Type': 'application/json'});

    ProxyService.box
        .write(key: 'bearerToken', value: syncFromJson(response.body).token);
    ProxyService.box
        .write(key: 'userId', value: syncFromJson(response.body).userId);
    return syncFromJson(response.body);
  }

  @override
  Future<OrderItem?> getOrderItem({required int id}) async {
    return _store.box<OrderItem>().get(id);
  }
}
