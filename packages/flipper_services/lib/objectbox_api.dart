import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flipper_services/mobile_upload.dart';
import 'package:flutter/foundation.dart' as kDebugMode;
import 'package:get_storage/get_storage.dart';
import 'package:random_string/random_string.dart';
// import 'package:flipper_services/pdf_api.dart';
import 'package:flipper_models/customer.dart';
import 'package:flipper_models/invoice.dart';
import 'package:flipper_models/supplier.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/setting.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/product_mock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/unit.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
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

// import 'api_result.dart';
// import 'network_exceptions.dart';
final socketUrl = 'https://apihub.yegobox.com/ws-message';
late Store store;

class ObjectBoxApi extends MobileUpload implements Api {
  ExtendedClient client = ExtendedClient(http.Client());

  String flipperApi = "https://flipper.yegobox.com";
  // late DioClient dioClient;
  String apihub = "https://apihub.yegobox.com";
  final log = getLogger('ObjectBoxAPi');
  // late
  static getDir({required String dbName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');
  }

  StompClient? stompMessageClient;
  StreamController<Message> messageStreamController =
      StreamController<Message>.broadcast();

  StompClient? stompUsersClient;
  StreamController<Business> usersStreamController =
      StreamController<Business>.broadcast();
  void onConnect(StompFrame frame) {
    /// for message
    stompMessageClient?.subscribe(
        destination: '/topic/messages',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Message result = sMessageJson(frame.body!);
            messageStreamController.add(result);
          }
        });

    /// for users socket listner
    stompUsersClient?.subscribe(
        destination: '/topic/users',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Business result = sbusinessFromJson(frame.body!);
            usersStreamController.add(result);
          }
        });
  }

  ObjectBoxApi({String? dbName, Directory? dir}) {
    // dioClient = DioClient(apihub, dio, interceptors: []);
    //connect socket
    if (stompMessageClient == null && stompUsersClient == null) {
      stompMessageClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));

      stompMessageClient?.activate();

      /// activate the users client
      stompUsersClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));

      stompUsersClient?.activate();
    }
    // get store initialized.
    if (dbName != null) {
      getDir(dbName: dbName);
    }
  }
  @override
  Future<List<Unit>> units({required int branchId}) async {
    return store
        .box<Unit>()
        .getAll()
        .where((unit) => unit.fbranchId == branchId)
        .toList();
  }

  @override
  Future<List<Business>> businesses() async {
    // await Future.delayed(Duration(microseconds: 2000));
    List<Business> businessList = store.box<Business>().getAll().toList();
    if (businessList.isNotEmpty) {
      return businessList;
    }
    return await loadingBusinesses(businessList, "businesses");
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

  /// this load the user business using the userId that is sent in header
  Future<List<Business>> loadingBusinesses(
      List<Business> businessList, String endPoint) async {
    List<Business> businesses = [];
    try {
      final response = await client.get(Uri.parse("$apihub/v2/api/$endPoint"));
      if (businessList.isEmpty) {
        log.i(response.body);
        for (Business business in businessFromJson(response.body)) {
          final box = store.box<Business>();
          box.put(business);
        }
      }

      return businessFromJson(response.body);
    } catch (e) {
      return businesses;
    }
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    return store
        .box<Category>()
        .getAll()
        .where((category) => category.fbranchId == branchId)
        .toList();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return store
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
        final box = store.box<PColor>();
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
      final box = store.box<Category>();
      box.put(category);
      return 200;
    }
    return 200;
  }

  @override
  Future<List<Product>> isTempProductExist({required int branchId}) async {
    return store
        .box<Product>()
        .getAll()
        .where((v) => v.fbranchId == branchId)
        .where((product) => product.name == 'temp')
        .toList();
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return store
        .box<Product>()
        .getAll()
        .where((v) => v.fbranchId == branchId)
        .toList();
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
    List<Stock> stocks = store
        .box<Stock>()
        .getAll()
        .where((stock) => stock.fproductId == productId)
        .toList();
    return stocks;
  }

  @override
  Future<Variant?> variant({required int variantId}) async {
    return store.box<Variant>().get(variantId);
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, required int productId}) async {
    return store
        .box<Variant>()
        .getAll()
        .where((v) => v.fproductId == productId)
        .where((v) => v.fbranchId == branchId)
        .toList();
  }

  @override
  Future<int> addUnits({required Map data}) async {
    for (Map map in data['units']) {
      final box = store.box<Unit>();

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
    List<Stock> stocks = store
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
        store.box<PColor>().remove(id);
        break;
      case 'orderItem':
        store.box<OrderItem>().remove(id);
        break;
      case 'product':
        store.box<Product>().remove(id);
        break;
      case 'stock':
        store.box<Stock>().remove(id);
        break;
      case 'variation':
        store.box<Variant>().remove(id);
        break;
      case 'message':
        store.box<Message>().remove(id);
        break;
      case 'order':
        store.box<OrderF>().remove(id);
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
      final box = store.box<Variant>();
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
      final stockBox = store.box<Stock>();
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
    data['status'] = completeStatus;
    data['reported'] = false;
    data['draft'] = false;
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: 'Sarah Field',
        address: 'Sarah Street 9, Beijing, China',
        paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      customer: Customer(
        name: 'Apple Inc.',
        address: 'Apple Street, Cupertino, CA 95014',
        email: '',
        phone: '',
        orderId: 0,
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'My description...',
        number: '${DateTime.now().year}-9999',
      ),
      items: [
        InvoiceItem(
          description: 'Coffee',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 5.99,
        ),
        InvoiceItem(
          description: 'Water',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Apple',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 3.99,
        ),
        InvoiceItem(
          description: 'Mango',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 1.59,
        ),
        InvoiceItem(
          description: 'Blue Berries',
          date: DateTime.now(),
          quantity: 5,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Lemon',
          date: DateTime.now(),
          quantity: 4,
          vat: 0.19,
          unitPrice: 1.29,
        ),
      ],
    );

    update(data: data, endPoint: 'order');

    if (ProxyService.remoteConfig.isPrinterAvailable()) {
      final pdfFile =
          await ProxyService.pdfInvoice.generate(invoice, order.id.toString());

      /// read user setting and see if he choose to open a receipt file on complete of a sale.
      /// this is handy in case a client want to print on his machine directly
      String userId = ProxyService.box.read(key: 'userId');
      Setting? setting = await getSetting(userId: int.parse(userId));
      if (setting != null &&
          setting.openReceiptFileOSaleComplete != null &&
          setting.openReceiptFileOSaleComplete == true) {
        ProxyService.pdfApi.openFile(pdfFile);
      }
      if (setting != null &&
          setting.autoPrint != null &&
          setting.autoPrint == true) {
        // ProxyService.pdfApi.openFile(pdfFile);
        // TODOnow call the printing service
      }
    }
  }

  Future<OrderF?> pendingOrderExist({required int branchId}) async {
    return store
        .box<OrderF>()
        .query(OrderF_.status
            .equals('pending')
            .and(OrderF_.fbranchId.equals(branchId)))
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
    OrderF? existOrder = await pendingOrderExist(branchId: branchId);
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
      log.i(quantity);
      OrderItem orderItems = OrderItem(
        count: quantity,
        name: useProductName ? variation.productName : variation.name,
        fvariantId: variation.id,
        price: price,
        forderId: order.id,
      );
      order.orderItems.add(orderItems);
      final box = store.box<OrderF>();
      final id = box.put(order);
      return store.box<OrderF>().get(id)!;
    } else {
      log.i(quantity);
      OrderItem item = OrderItem(
        count: quantity,
        name: useProductName ? variation.productName : variation.name,
        fvariantId: variation.id,
        price: price,
        forderId: existOrder.id,
      );
      existOrder.orderItems.add(item);
      // final box = store.box<OrderF>();
      // final id = box.put(existOrder, mode: PutMode.update);
      final id = store.box<OrderF>().put(existOrder);
      // update(data: existOrder.toJson(), endPoint: 'order');
      return store.box<OrderF>().get(id)!;
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
    final productBox = store.box<Product>();
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
    final productId = store.box<Product>().put(products);
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
    final stockBox = store.box<Stock>();
    stockBox.put(stock);
    return store.box<Product>().get(productId)!;
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) async {
    return store.box<PColor>().get(id);
  }

  Variant getV() {
    Product product = store
        .box<Product>()
        .getAll()
        .where((v) => v.name == 'Custom Amount')
        .toList()[0];
    return store
        .box<Variant>()
        .getAll()
        .where((v) => v.fproductId == product.id)
        .toList()[0];
  }

  @override
  Future<Variant> getCustomProductVariant() async {
    try {
      return getV();
    } catch (e) {
      createProduct(product: customProductMock);
      return getV();
    }
  }

  @override
  Future<Product?> getProduct({required int id}) async {
    return store.box<Product>().get(id);
  }

  @override
  Future<List<OrderF>> orders({required int branchId}) async {
    return store
        .box<OrderF>()
        .getAll()
        .where((v) => v.status == 'pending')
        .where((v) => v.fbranchId == branchId)
        .toList();
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    String userId = ProxyService.box.read(key: 'userId');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    String businessName = getBusiness().name;
    log.i(businessName);
    // TODOpass in the item being sold and note if available
    log.i({
      'amount': amount.toString(),
      'message': 'Pay ' + businessName,
      'phoneNumber': '+25' + phoneNumber,
      'uid': userId,
      'userId': userId
    });
    final response = await client.post(Uri.parse("$flipperApi/pay"),
        body: {
          // add the business owner phone number
          'userPhone': ProxyService.box.read(key: 'userPhone'),
          'amount': amount.toString(),
          'message': 'Pay ' + businessName,
          'phoneNumber': '+25' + phoneNumber,
          'paymentType': 'SPENN',
          'itemName': '', //TODOget this item name from the item being sold
          'note': '', //TODOget this note from the item being sold
          'uid': userId,
          'userId': userId
        },
        headers: headers);
    log.i(response.body);
    return spennFromJson(response.body);
  }

  @override
  Future<Stock> stockByVariantId({required int variantId}) async {
    return store
        .box<Stock>()
        .getAll()
        .where((v) => v.fvariantId == variantId)
        .toList()[0];
  }

  @override
  Stream<Stock> stockByVariantIdStream({required int variantId}) {
    return store
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
        Product? kProduct = store.box<Product>().get(data['id']);
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
          expiryDate: map['expiryDate'],
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
        final box = store.box<Product>();
        box.put(product, mode: PutMode.update);
        break;
      case 'stock':
        Stock? color = store.box<Stock>().get(id);
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
        final box = store.box<Stock>();
        box.put(stock, mode: PutMode.update);
        break;
      case 'category':
        Category? color = store.box<Category>().get(id);
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
        final box = store.box<Category>();
        box.put(category, mode: PutMode.update);
        break;
      case 'variant':
        Variant? variation = store.box<Variant>().get(id);
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
        final box = store.box<Variant>();
        box.put(variant, mode: PutMode.update);
        break;
      case 'unit':
        Unit? color = store.box<Unit>().get(id);
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
        final box = store.box<Unit>();
        box.put(unit, mode: PutMode.update);
        break;
      case 'color':
        PColor? color = store.box<PColor>().get(id);
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
        final box = store.box<PColor>();
        box.put(pcolor, mode: PutMode.update);
        break;
      case 'order':
        OrderF? orders = store.box<OrderF>().get(dn['id']);
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
          note: map['note'],
          cashReceived: map['cashReceived'],
          customerId: map['customerId'],
          createdAt: map['createdAt'],
          reported: map['reported'],
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
        final box = store.box<OrderF>();
        box.put(order, mode: PutMode.update);
        break;
      case 'settings':
        Setting? setting = store.box<Setting>().get(id);
        Map map = setting!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });

        Setting Ksetting = Setting(
            email: map['email'],
            hasPin: map['hasPin'],
            defaultLanguage: map['defaultLanguage'],
            googleSheetDocCreated: map['googleSheetDocCreated'],
            sendDailyReport: map['sendDailyReport'],
            userId: map['userId'],
            openReceiptFileOSaleComplete: map['openReceiptFileOSaleComplete'],
            autoPrint: map['autoPrint'],
            id: map['id']);
        final box = store.box<Setting>();
        box.put(Ksetting, mode: PutMode.update);
        break;
      case 'customer':
        Customer? customer = store.box<Customer>().get(id);
        log.i(customer!.id);
        Map map = customer.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Customer kCustomer = Customer(
            email: map['email'],
            updatedAt: map['updatedAt'],
            phone: map['phone'],
            name: map['name'],
            orderId: map['orderId'],
            address: map['address'],
            id: map['id']);
        log.i(kCustomer.toJson());
        final box = store.box<Customer>();
        box.put(kCustomer, mode: PutMode.update);
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
    return store.box<OrderItem>().get(id);
  }

  @override
  Future<Setting?> createSetting(
      {required int userId, required Setting setting}) async {
    final box = store.box<Setting>();
    final id = box.put(setting);
    return store.box<Setting>().get(id);
  }

  @override
  Setting? getSetting({required int userId}) {
    final box = store.box<Setting>();
    Query<Setting> query = box.query(Setting_.userId.equals(userId)).build();
    return query.findFirst();
  }

  late StreamSubscription<Message> messageSubscription;
  @override
  Stream<List<Message>> getChats({int? receiverId}) async* {
    if (kDebugMode.kDebugMode) {
      List<Message> messages = [];
      for (var i = 0; i < 1000; i++) {
        messages.add(Message(
          createdAt: new DateTime.now().toIso8601String(),
          id: 2000,
          message: randomAlpha(120),
          receiverId: 1,
          senderId: 1,
          lastActiveId: 1,
          senderName: 'Richie',
          status: i % 2 == 0 ? true : false,
          senderImage:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxoBnq05850hAXAOcv0CciJtz3dASMTGcBQY38EssxzZkD7mpDlgUj1HUlhHaFJlo5gEk&usqp=CAU',
        ));
      }
      yield messages;
      return;
    }
    int? myBusinessId = ProxyService.box.read(key: 'businessId');
    if (receiverId == null) {
      receiverId = myBusinessId;
    }
    log.i(receiverId);
    //first I have to listen to a socket
    Stream<Message> stream = messageStreamController.stream;
    messageSubscription = stream.listen((message) {
      Message? kMessage = store.box<Message>().get(message.id);

      log.i(message.receiverId == myBusinessId);
      log.i(kMessage);
      // ignore: unnecessary_null_comparison
      if (kMessage == null &&
          message.receiverId == myBusinessId &&
          message.senderId != myBusinessId) {
        log.i("now inserting new object");
        final box = store.box<Message>();
        box.put(message);
      }
    });

    yield* store
        .box<Message>()
        .query(Message_.receiverId
            .equals(myBusinessId ?? 0)
            .or(Message_.senderId.equals(myBusinessId ?? 0)))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Business getBusiness() {
    String? userId = ProxyService.box.read(key: 'userId');
    return store
        .box<Business>()
        .getAll()
        .firstWhere((unit) => unit.userId == userId);
  }

  late StreamSubscription<Business> userSubs;
  @override
  Stream<List<Business>> users() {
    Stream<Business> stream = usersStreamController.stream;
    userSubs = stream.listen((business) {
      Business? kBusiness = store.box<Business>().get(business.id);

      if (kBusiness == null) {
        log.i("now inserting new business" + business.id.toString());
        final box = store.box<Business>();
        box.put(business);
      } else {
        //updat this business with the update object
        final box = store.box<Business>();
        log.i(business.imageUrl);
        box.put(business, mode: PutMode.update);
      }
    });
    return store
        .box<Business>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  void sendMessage({required int receiverId, required String message}) {
    if (kDebugMode.kDebugMode) {
      //mock adding a message
    }
    int? myBusinessId = ProxyService.box.read(key: 'businessId');
    Business? business = store.box<Business>().get(myBusinessId!);
    final box = store.box<Message>();
    Message kMessage = Message(
      status: false,
      createdAt: DateTime.now().toIso8601String(),
      lastActiveId: myBusinessId,
      message: message,
      receiverId: receiverId,
      senderId: myBusinessId,
      senderName: business!.name,
    );
    box.put(kMessage, mode: PutMode.insert);
  }

  @override
  Customer? addCustomer({required Map customer, required int orderId}) {
    final box = store.box<Customer>();
    Customer kCustomer = Customer(
      name: customer['name'],
      email: customer['email'],
      phone: customer['phone'],
      address: customer['address'] ?? '',
      orderId: orderId,
    );
    int id = box.put(kCustomer, mode: PutMode.insert);
    return store.box<Customer>().get(id);
  }

  @override
  Future assingOrderToCustomer(
      {required int customerId, required int orderId}) async {
    OrderF? order = store.box<OrderF>().get(orderId)!;
    Map korder = order.toJson();
    korder['customerId'] = customerId;
    update(data: korder, endPoint: 'order');

    // and updat this customer with timestamp so it can trigger change!.
    Customer? customer = store.box<Customer>().get(customerId)!;
    Map kCustomer = customer.toJson();
    kCustomer['updatedAt'] = DateTime.now().toIso8601String();
    kCustomer['orderId'] = orderId;
    // kCustomer['orderId'] = DateTime.now().toIso8601String();
    int id = kCustomer['id'];
    await update(data: kCustomer, endPoint: 'customer/$id');
  }

  @override
  Stream<Customer?> getCustomer({required String key}) {
    return store
        .box<Customer>()
        .query(Customer_.name
            .equals(key)
            .or((Customer_.phone.equals(key)).or(Customer_.email.equals(key))))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  @override
  Stream<Customer?> getCustomerByOrderId({required int id}) {
    log.i(id);
    return store
        .box<Customer>()
        .query(Customer_.orderId.equals(id))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  @override
  Future<List<OrderF>> getOrderById({required int id}) async {
    return store.box<OrderF>().getAll().where((v) => v.id == id).toList();
  }

  @override
  Future<List<OrderF>> tickets() async {
    return store
        .box<OrderF>()
        .getAll()
        .where((v) => v.status == parkedStatus)
        .toList();
  }

  @override
  Future<List<Variant>> getVariantByProductId({required int productId}) async {
    return store
        .box<Variant>()
        .getAll()
        .where((v) => v.fproductId == productId)
        .toList();
  }

  @override
  Future<List<OrderF>> getOrderByStatus({required String status}) async {
    return store
        .box<OrderF>()
        .query(
            OrderF_.status.equals(status).and((OrderF_.reported.equals(false))))
        .build()
        .find();
  }

  @override
  Future<void> sendReport({required List<OrderF> orders}) async {
    final response = await client.post(Uri.parse("$apihub/v2/api/report"),
        body: jsonEncode(orders),
        headers: {'Content-Type': 'application/json'});
    log.i(response.body);
    log.i(orders);
    log.i(jsonEncode(orders));
  }

  @override
  Future<void> createGoogleSheetDoc() async {
    Business? business = getBusiness();
    String docName = business.name + '- Report';
    Setting? setting =
        getSetting(userId: int.parse(ProxyService.box.read(key: 'userId')));
    await client.post(Uri.parse("$apihub/v2/api/createSheetDocument"),
        body: jsonEncode({"title": docName, "shareToEmail": setting!.email}),
        headers: {'Content-Type': 'application/json'});
  }

  ///in normal case the business is arleady streamed to users() method.
  ///but there is case when is not, then we fetch it first using http and
  ///only insert it to the store. only if it does not exist. and we do this only if there
  ///is internet. because the method can take some time. it is advised to schedule it
  ///in cron so it can run in app backgroup like every hour.
  @override
  Future<List<Business>> contacts() async {
    bool isInternetAvaible = await isInternetAvailable();
    List<Business> businesses = store.box<Business>().getAll().toList();
    if (isInternetAvaible) {
      log.i('got the network');
      log.i("$apihub/v2/api/users");
      final response = await client.get(Uri.parse("$apihub/v2/api/users"));
      log.i(response.body);
      for (Business business in businessFromJson(response.body)) {
        if (!businesses.contains(business)) {
          final box = store.box<Business>();
          box.put(business);
        }
      }
    }
    return businesses;
  }

  @override
  Future<Message> getConversations({required int authorId}) async {
    // TODO: implement getMessage
    throw UnimplementedError();
    // List<Message> message = [
    //  Message(
    //     author: {
    //       "firstName": "Alex",
    //       "id": "b4878b96-efbc-479a-8291-474ef323dec7",
    //       "imageUrl": "https://avatars.githubusercontent.com/u/14123304?v=4"
    //     },
    //     createdAt: 1598438797000,
    //     id": "e7a673e9-86eb-4572-936f-2882b0183cdc",
    //     status: "seen",
    //     text: "https://flyer.chat",
    //     type: "text"
    //   }
    //  )
    // ];
  }

  @override
  Business getBusinessById({required int id}) {
    return store
        .box<Business>()
        .getAll()
        .firstWhere((business) => business.id == id);
  }
}
