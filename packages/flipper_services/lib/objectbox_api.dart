import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flipper_services/dio_client.dart';
import 'package:flipper_services/mobile_upload.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:flipper_services/pdf_api.dart';
import 'package:flipper_models/customer.dart';
import 'package:flipper_models/queue_item.dart';
import 'package:flipper_models/discount.dart';
import 'package:flipper_models/invoice.dart';
import 'package:flipper_models/supplier.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/conversation.dart';
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
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// import 'api_result.dart';
// import 'network_exceptions.dart';
final socketUrl = 'https://apihub.yegobox.com/stomp';
late Store store;

class ObjectBoxApi extends MobileUpload implements Api {
  ExtendedClient client = ExtendedClient(http.Client());

  String flipperApi = "https://flipper.yegobox.com";
  late DioClient dioClient;
  String apihub = "https://apihub.yegobox.com";
  final log = getLogger('ObjectBoxAPi');
  // late
  static getDir({required String dbName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    // final log = getLogger('ObjectBoxAPi');
    // log.i('Path' + dir.path + '/$dbName');
    store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');
  }

  StompClient? stompMessageClient;
  StreamController<Message> messageStreamController =
      StreamController<Message>.broadcast();

  StompClient? stompUsersClient;
  StreamController<Business> usersStreamController =
      StreamController<Business>.broadcast();
  void onConnect(StompFrame frame) {
    log.i('onConnect');

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
    dioClient = DioClient(apihub, interceptors: []);
    //connect socket
    if (stompMessageClient == null && stompUsersClient == null) {
      stompMessageClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => log.i(error.toString()),
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
  Future<List<Business>> businesses({required String userId}) async {
    return await loadingBusinesses("businesses");
  }

  /// this load the user business using the userId that is sent in header
  /// the userId is the userId of the user that is logged in
  Future<List<Business>> loadingBusinesses(String endPoint) async {
    final response = await client.get(Uri.parse("$apihub/v2/api/$endPoint"));
    log.i(response.statusCode);
    if (response.statusCode == 403) {
      return throw response.statusCode;
    }
    for (Business business in businessFromJson(response.body)) {
      final box = store.box<Business>();
      box.put(business, mode: PutMode.put);
    }
    return businessFromJson(response.body);
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
  List<Stock> stocks({required int productId}) {
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
      case 'conversation':
        store.box<Conversation>().remove(id);
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
      case 'business':
        store.box<Business>().remove(id);
        break;
      case 'discount':
        store.box<Discount>().remove(id);
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
    final response =
        await client.get(Uri.parse("$apihub/v2/api/branches/$businessId"));
    for (Branch branch in branchFromJson(response.body)) {
      final box = store.box<Branch>();
      box.put(branch, mode: PutMode.put);
    }
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
        branchId: ProxyService.box.read(key: 'branchId'),
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
    final ref = Uuid().v1();
    final orderNUmber = Uuid().v1();
    String userId = ProxyService.box.read(key: 'userId');
    int branchId = ProxyService.box.read(key: 'branchId');
    OrderF? existOrder = await pendingOrderExist(branchId: branchId);
    String name = '';
    if (variation.name == 'Regular') {
      if (variation.productName != 'Custom Amount') {
        name = variation.productName + '(Regular)';
      } else {
        name = variation.productName;
      }
    } else {
      if (variation.productName != 'Custom Amount') {
        name = variation.productName + '(${variation.name})';
      } else {
        name = variation.productName;
      }
    }
    if (existOrder == null) {
      final box = store.box<OrderF>();
      final id = box.put(
        OrderF(
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
        ),
      );

      OrderF ss = store.box<OrderF>().get(id)!;

      OrderItem orderItems = OrderItem(
        count: quantity,
        // name: useProductName ? variation.productName : variation.name,
        name: name,
        fvariantId: variation.id,
        price: price,
        forderId: id,
      );

      ss.orderItems.add(orderItems);

      box.put(ss);
      return ss;
    } else {
      OrderItem item = OrderItem(
        count: quantity,
        name: name,
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
  Future<OrderF?> order({required int branchId}) async {
    return store
        .box<OrderF>()
        .query(OrderF_.status
            .equals('pending')
            .and((OrderF_.fbranchId.equals(branchId))))
        .build()
        .findFirst();
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
          barCode: map['barCode'],
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
      case 'business':
        Business? business = store.box<Business>().get(id);
        Map map = business!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        Business ubusiness = Business(
          active: map['active'],
          name: map['name'],
          table: map['table'],
          channels: map['channels'],
          fcategoryId: map['fcategoryId'],
          id: map['id'],
          imageUrl: map['imageUrl'],
          businessUrl: map['businessUrl'],
          firstName: map['firstName'],
          lastSeen: map['lastSeen'],
          currency: map['currency'],
          role: map['role'],
          latitude: map['latitude'],
          longitude: map['longitude'],
          userId: map['userId'],
          country: map['country'],
          hexColor: map['hexColor'],
          type: map['type'],
          deviceToken: map['deviceToken'],
          backUpEnabled: map['backUpEnabled'],
          backupFileId: map['backupFileId'],
          isLastSubscriptionPaymentSucceeded:
              map['isLastSubscriptionPaymentSucceeded'],
          previousBillingDate: map['previousBillingDate'],
          nextBillingDate: map['nextBillingDate'],
          timeZone: map['timeZone'],
          typeId: map['typeId'],
          metadata: map['metadata'],
        );
        final box = store.box<Business>();
        box.put(ubusiness, mode: PutMode.update);
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
        OrderF? singleOrder = store.box<OrderF>().get(dn['id']);
        Map map = singleOrder!.toJson();
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
        //update relationship OrderItem
        // OrderItem? orderItem = store.box<OrderItem>().get(order.id);
        singleOrder.id = map['id'];
        // singleOrder.orderItems.add(element)
        //loop through singleOrder.orderItems find where fvariantId equal to the one in data map
        //update the element with the new data this will update the relationship
        List<OrderItem> updatedOrderItem = [];
        for (OrderItem item in singleOrder.orderItems) {
          if (item.fvariantId == data['fvariantId']) {
            item.fvariantId = data['fvariantId'];
            item.count = data['count'];
            item.price = data['price'];
            item.forderId = data['id'];
            item.fvariantId = data['fvariantId'];
            updatedOrderItem.add(item);
            log.i(item);
            store.box<OrderItem>().put(item, mode: PutMode.update);
          }
        }
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
            branchId: map['branchId'],
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
      case 'discount':
        Discount? discount = store.box<Discount>().get(id);
        Map map = discount!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        // 1.0.toInt();
        Discount kDiscount = Discount(
          branchId: map['branchId'],
          amount: map['amount'].toInt(),
          name: map['name'],
          id: map['id'],
        );
        final box = store.box<Discount>();
        box.put(kDiscount, mode: PutMode.update);
        break;

      /// when dealing with something that has a relationship
      /// we need to update it as the following.!
      case 'orderItem':
        OrderItem? orderItem = store.box<OrderItem>().get(id);

        orderItem!.forderId = data['forderId'];
        orderItem.fvariantId = data['fvariantId'];
        orderItem.count = data['count'];
        orderItem.price = data['price'];
        orderItem.id = data['id'];
        orderItem.name = data['name'];
        orderItem.discount = data['discount'];
        orderItem.type = data['type'];
        store.box<OrderItem>().put(orderItem);
        break;
      default:
        return 200;
    }
    return 200;
  }

  @override
  Future<SyncF> authenticateWithOfflineDb({required String userId}) async {
    final response = await http.post(
      Uri.parse('https://apihub.yegobox.com/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
        },
      ),
    );

    if (response.statusCode == 201) {
      ProxyService.box
          .write(key: 'bearerToken', value: syncFromJson(response.body).token);
      ProxyService.box
          .write(key: 'userId', value: syncFromJson(response.body).userId);
      return syncFromJson(response.body);
    } else {
      throw Exception('403 Error');
    }
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
  void sendMessage({required int receiverId, required Message message}) async {
    final convo = store.box<Conversation>().get(message.convoId);
    convo!.lastMessage = message.text;
    final box = store.box<Conversation>();

    convo.messages.add(message);

    box.put(convo);
    final response = await client.post(Uri.parse("$apihub/v2/api/message"),
        body: jsonEncode({
          'receiverId': message.receiverId,
          'text': message.text,
          'convoId': message.convoId,
          'senderId': message.senderId,
          'type': message.type,
          'status': message.status,
          'createdAt': message.createdAt,
          'senderName': message.senderName,
        }),
        headers: {'Content-Type': 'application/json'});
    // log.i(message.toJson());
    log.i(response.statusCode);
    if (response.statusCode == 201) {
      Conversation? kConvo = store.box<Conversation>().get(message.convoId);
      kConvo!.delivered = true;
      box.put(kConvo, mode: PutMode.update);
    }
  }

  @override
  Customer? addCustomer({required Map customer, required int orderId}) {
    int branchId = ProxyService.box.read(key: 'branchId');
    final box = store.box<Customer>();
    Customer kCustomer = Customer(
      name: customer['name'],
      branchId: branchId,
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
  Future<OrderF> getOrderById({required int id}) async {
    return store.box<OrderF>().getAll().firstWhere((v) => v.id == id);
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
  List<Variant> getVariantByProductId({required int productId}) {
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
  Future<int> sendReport({required List<OrderItem> orderItems}) async {
    final response = await client.post(Uri.parse("$apihub/v2/api/report"),
        body: jsonEncode(orderItems),
        headers: {'Content-Type': 'application/json'});
    log.i(response.body);
    log.i(orderItems);
    log.i(jsonEncode(orderItems));
    return response.statusCode;
  }

  @override
  Future<void> createGoogleSheetDoc() async {
    Business? business = getBusiness();
    String docName = business.name + '- Report';
    int id = int.parse(ProxyService.box.read(key: 'userId'));
    Setting? setting = getSetting(userId: id);
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
  Stream<List<Business>> contacts() async* {
    yield* store
        .box<Business>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Stream<List<Message>> messages({required int conversationId}) async* {
    yield* store
        .box<Message>()
        .query(Message_.convoId.equals(conversationId))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  Stream<List<Conversation>> conversationStreamList({int? receiverId}) async* {
    int? myBusinessId = ProxyService.box.read(key: 'businessId');
    if (receiverId == null) {
      receiverId = myBusinessId;
    }
    log.i(receiverId);
    //first I have to listen to a socket
    Stream<Message> stream = messageStreamController.stream;
    messageSubscription = stream.listen((message) async {
      /// all messages will be streamed here
      /// but not all message are of our intrest to use.
      /// a couple things might happen
      /// a message can be sent and the user is offline
      /// this case the server will keep trying as much as it can
      /// then once the user is online the message will be delivered
      /// the client will send another request to delete the message
      /// on success of the request an id of message  will be removed from queue item.
      /// we need a service in cron to keep sending the delete request
      /// until the queueItem is empty.
      /// a message.receiverId == myBusinessId means that the message is sent to me
      /// the message.convoId the conversation should exist in the store then should be created then
      if (message.receiverId == myBusinessId &&
          message.senderId != myBusinessId) {
        log.i("onNewMessage");
        Conversation? conversation =
            store.box<Conversation>().get(message.convoId);
        QueueItem queueItem = QueueItem(
          id: message.id,
        );
        Map<String, dynamic> author = types.User(
                id: message.senderId.toString(), firstName: message.senderImage)
            .toJson();
        //save queue item in store
        store.box<QueueItem>().put(queueItem);
        if (conversation == null) {
          conversation = Conversation(
            senderName: message.senderName!,
            id: message.convoId,
            receiverId: message.receiverId,
            senderId: message.senderId,
            createdAt: message.createdAt,
            lastMessage: message.text,
            status: message.status,
          );
          Message? messageExist = store.box<Message>().get(message.id);
          if (messageExist == null) {
            log.e("up");
            Message kmessage = messageBuilder(message, author);
            conversation.messages.add(kmessage);
            conversation.lastMessage = message.text;
            store.box<Conversation>().put(conversation);
          }
          emptySentMessageQueue();
        } else {
          Message? messageExist = store.box<Message>().get(message.id);
          if (messageExist == null) {
            log.e("down");
            Message kmessage = messageBuilder(message, author);
            conversation.messages.add(kmessage);
            conversation.lastMessage = message.text;
            store.box<Conversation>().put(conversation);
          }
          emptySentMessageQueue();
        }
        //load contacts just to update the list
        contacts();
      }
    });

    yield* store
        .box<Conversation>()
        .query(Conversation_.receiverId
            .equals(myBusinessId ?? 0)
            .or(Conversation_.senderId.equals(myBusinessId ?? 0)))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Message messageBuilder(Message message, Map<String, dynamic> author) {
    return Message(
      id: message.id,
      status: 'online',
      type: message.type,
      author: author,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      text: message.text,
      receiverId: message.receiverId,
      senderId: message.senderId,
      senderName: message.senderName,
      convoId: message.convoId,
    );
  }

  @override
  Business getBusinessById({required int id}) {
    return store
        .box<Business>()
        .query(Business_.id.equals(id))
        .build()
        .findFirst()!;
  }

  @override
  OrderItem? getOrderItemByVariantId({required int variantId}) {
    return store
        .box<OrderItem>()
        .query(OrderItem_.fvariantId.equals(variantId))
        .build()
        .findFirst();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) async {
    return store
        .box<Product>()
        .query(Product_.barCode.equals(barCode))
        .build()
        .findFirst();
  }

  @override
  Future<void> updateBusiness({required int id, required Map business}) async {
    await client.patch(Uri.parse("$apihub/v2/api/business/$id"),
        body: jsonEncode({
          'deviceToken': business['deviceToken'],
          'backupFileId': business['backupFileId'],
          'chatUid': business['chatUid']
        }),
        headers: {'Content-Type': 'application/json'});
  }

  @override
  int lifeTimeCustomersForbranch({required int branchId}) {
    return store
        .box<Customer>()
        .getAll()
        .where((unit) => unit.branchId == branchId)
        .toList()
        .length;
  }

  List<DateTime> getWeeksForRange(DateTime start, DateTime end) {
    var result = [];
    var date = start;
    List<DateTime> week = [];

    while (date.difference(end).inDays <= 0) {
      // start new week on Monday
      if (date.weekday == 1 && week.length > 0) {
        result.add(week);
      }

      week.add(date);
      date = date.add(const Duration(days: 1));
    }
    return week;
  }

  @override
  List<OrderF> weeklyOrdersReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  }) {
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<OrderF> pastOrders = [];
    for (DateTime date in weekDates) {
      List<OrderF> orders = store
          .box<OrderF>()
          .getAll()
          .where((order) =>
              DateTime.parse(order.createdAt).difference(date).inDays >= -7 &&
              order.fbranchId == branchId)
          .toList();
      if (orders.length > 0) {
        //if in pastOrders there is no object orders[0] that exist then we add it in the list
        for (var i = 0; i < orders.length; i++) {
          //is orders[i] does not exist in pastOrders then we add it in the list
          pastOrders.add(orders[i]);
        }
      }
    }
    // filter list pastOrders for duplicate values of OrderF.orderNumber property
    Map<String, OrderF> mp = {};
    for (var item in pastOrders) {
      mp[item.orderNumber] = item;
    }
    return mp.values.toList();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) async {
    // create Discount object and add it to the store
    var discount =
        new Discount(name: name, amount: amount!.toInt(), branchId: branchId);
    store.box<Discount>().put(discount);
  }

  @override
  OrderF addOrderItem({required OrderF order, required Map data}) {
    OrderItem item = OrderItem(
      count: data['count'],
      name: data['name'],
      fvariantId: data['fvariantId'],
      price: data['price'],
      forderId: data['forderId'],
    );
    order.orderItems.add(item);
    final id = store.box<OrderF>().put(order);
    return store.box<OrderF>().get(id)!;
  }

  @override
  Conversation createConversation({required Conversation conversation}) {
    int id = store.box<Conversation>().put(conversation);
    return store.box<Conversation>().get(id)!;
  }

  @override
  Conversation? getConversationByContactId({required int contactId}) {
    return store
        .box<Conversation>()
        .query(Conversation_.receiverId
            .equals(contactId)
            .or(Conversation_.senderId.equals(contactId)))
        .build()
        .findFirst();
  }

  @override
  void emptySentMessageQueue() async {
    List<QueueItem> queueItems = store.box<QueueItem>().getAll();

    for (var item in queueItems) {
      int id = item.id;
      try {
        final response =
            await client.delete(Uri.parse("$apihub/v2/api/message/$id"));
        if (response.statusCode == 200) {
          log.i('emptied the queue');
          store.box<QueueItem>().remove(item.id);
        }
      } catch (e) {}
    }
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return store
        .box<Discount>()
        .query(Discount_.branchId.equals(branchId))
        .build()
        .find()
        .toList();
  }

  @override
  Future<List<Business>> getContacts() async {
    final response = await client.get(Uri.parse("$apihub/v2/api/users"));
    log.i('now fetching new contacts business now');
    for (Business business in businessFromJson(response.body)) {
      /// a user mast have been opted in to the app. chat feature.
      /// this is because there is old business that does not know about this feature
      /// otherwise it won't required as this step is part of startup logic.
      if (business.chatUid != null) {
        final box = store.box<Business>();
        box.put(business);
      }
    }
    int businessId = ProxyService.box.read(key: 'businessId');
    return store
        .box<Business>()
        .getAll()
        .where((unit) => unit.id != businessId)
        .toList();
  }

  @override
  bool suggestRestore() {
    // TODO: implement suggestRestore
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> lBusinesses({required String userId}) async {
    String? userId = ProxyService.box.read(key: 'userId');
    return store
        .box<Business>()
        .getAll()
        .where((unit) => unit.userId == userId)
        .toList();
  }

  @override
  Future<List<Branch>> lbranches({required int businessId}) async {
    return store
        .box<Branch>()
        .getAll()
        .where((unit) => unit.fbusinessId == businessId)
        .toList();
  }
}
