import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/dio_client.dart';
import 'package:flipper_services/mobile_upload.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:flipper_services/pdf_api.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'abstractions/api.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

///
///final isWeb = UniversalPlatform.isWeb;
// import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/models/objectbox.dart';
import 'package:flipper_routing/routes.logger.dart';

// import 'api_result.dart';
// import 'network_exceptions.dart';
// final socketUrl = 'https://apihub.yegobox.com/stomp';
late Store store;

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  ExtendedClient(this._inner);
  final log = getLogger('ExtendedClient');
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String? token = ProxyService.box.read(key: 'bearerToken');
    String? userId = ProxyService.box.read(key: 'userId');
    request.headers['Authorization'] = token ?? '';
    request.headers['userId'] = userId ?? '';
    request.headers['Content-Type'] = 'application/json';
    // request.headers['Connection'] = "Keep-Alive";
    // request.headers['Keep-Alive'] = "timeout=5, max=1000";
    return _inner.send(request);
  }
}

class ObjectBoxApi extends MobileUpload implements Api {
  ExtendedClient client = ExtendedClient(http.Client());

  String flipperApi = "https://flipper.yegobox.com";
  late DioClient dioClient;
  // String apihub = "https://turbo.yegobox.com";
  String apihub = "https://apihub.yegobox.com";
  final log = getLogger('ObjectBoxAPi');
  // late
  static getDir({required String dbName}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    // final log = getLogger('ObjectBoxAPi');
    // log.i('Path' + dir.path + '/$dbName');
    store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');

    // if (Sync.isAvailable() && ProxyService.billing.activeSubscription()) {
    SyncClient syncClient = Sync.client(
      store,
      'ws://sync.yegobox.com:908', // wss for SSL, ws for unencrypted traffic
      SyncCredentials.sharedSecretString("!@2022aurora"),
    );

    /// if a user is paying then use this config or otherwise
    syncClient.requestUpdates(subscribeForFuturePushes: true);

    /// set sync to manual for now until futher notice!
    syncClient.setRequestUpdatesMode(SyncRequestUpdatesMode.auto);

    syncClient.start();
    syncClient.loginEvents.listen((event) {
      if (event == SyncLoginEvent.loggedIn) print('Logged in successfully');
    });

    ProxyService.api.migrateToSync();
    // }
  }

  ///FIXMEsocket has some issue now so stoping it now
  // StompClient? stompMessageClient;
  // StreamController<Message> messageStreamController =
  //     StreamController<Message>.broadcast();

  // StompClient? stompUsersClient;
  // StreamController<Business> usersStreamController =
  //     StreamController<Business>.broadcast();
  // void onConnect(StompFrame frame) {
  //   log.i('onConnect');

  //   /// for message
  //   stompMessageClient?.subscribe(
  //       destination: '/topic/messages',
  //       callback: (StompFrame frame) {
  //         if (frame.body != null) {
  //           Message result = sMessageJson(frame.body!);
  //           messageStreamController.add(result);
  //         }
  //       });

  //   /// for users socket listner
  //   stompUsersClient?.subscribe(
  //       destination: '/topic/users',
  //       callback: (StompFrame frame) {
  //         if (frame.body != null) {
  //           Business result = sbusinessFromJson(frame.body!);
  //           usersStreamController.add(result);
  //         }
  //       });
  // }

  ObjectBoxApi({String? dbName, Directory? dir}) {
    dioClient = DioClient(apihub, interceptors: []);
    //connect socket
    // FIXMEstoped socket
    // if (stompMessageClient == null && stompUsersClient == null) {
    //   stompMessageClient = StompClient(
    //       config: StompConfig.SockJS(
    //     url: socketUrl,
    //     onConnect: onConnect,
    //     onWebSocketError: (dynamic error) => log.i(error.toString()),
    //   ));

    //   stompMessageClient?.activate();

    //   /// activate the users client
    //   stompUsersClient = StompClient(
    //       config: StompConfig.SockJS(
    //     url: socketUrl,
    //     onConnect: onConnect,
    //     onWebSocketError: (dynamic error) => print(error.toString()),
    //   ));

    //   stompUsersClient?.activate();
    // }
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
  Future<List<ProductSync>> isTempProductExist({required int branchId}) async {
    return store
        .box<ProductSync>()
        .getAll()
        .where((v) => v.fbranchId == branchId)
        .where((product) => product.name == 'temp')
        .toList();
  }

  @override
  Future<List<ProductSync>> products({required int branchId}) async {
    return store
        .box<ProductSync>()
        .getAll()
        .where((v) => v.fbranchId == branchId)
        .toList();
  }

  @override
  Future<bool> logOut() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');

    FirebaseAuth.instance.signOut();

    return true;
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
  List<StockSync> stocks({required int productId}) {
    List<StockSync> stocks = store
        .box<StockSync>()
        .getAll()
        .where((stock) => stock.fproductId == productId)
        .toList();
    return stocks;
  }

  @override
  Future<VariantSync?> variant({required int variantId}) async {
    return store.box<VariantSync>().get(variantId);
  }

  @override
  Future<List<VariantSync>> variants(
      {required int branchId, required int productId}) async {
    return store
        .box<VariantSync>()
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
  Future<StockSync?> getStock(
      {required int branchId, required int variantId}) async {
    List<StockSync> stocks = store
        .box<StockSync>()
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
        store.box<OrderItemSync>().remove(id);
        break;
      // case 'conversation':
      //   store.box<Conversation>().remove(id);
      //   break;
      case 'product':
        store.box<ProductSync>().remove(id);
        break;
      case 'stock':
        store.box<StockSync>().remove(id);
        break;
      case 'variation':
        store.box<VariantSync>().remove(id);
        break;
      case 'message':
        store.box<Message>().remove(id);
        break;
      case 'business':
        store.box<BusinessSync>().remove(id);
        break;
      case 'discount':
        store.box<DiscountSync>().remove(id);
        break;
      case 'order':
        store.box<OrderFSync>().remove(id);
        break;
      default:
    }
    return true;
  }

  @override
  Future<int> addVariant(
      {required List<VariantSync> data,
      required double retailPrice,
      required double supplyPrice}) async {
    for (VariantSync variation in data) {
      Map d = variation.toJson();
      final box = store.box<VariantSync>();
      final variantId = box.put(variation);
      final stockId = DateTime.now().millisecondsSinceEpoch;
      String? userId = ProxyService.box.read(key: 'userId');
      final stock = new StockSync(
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
      final stockBox = store.box<StockSync>();
      stockBox.put(stock);
    }
    return 200;
  }

  @override
  Future<List<BranchSync>> branches({required int businessId}) async {
    final response =
        await client.get(Uri.parse("$apihub/v2/api/branches/$businessId"));
    for (BranchSync branch in branchFromJson(response.body)) {
      final box = store.box<BranchSync>();
      box.put(branch, mode: PutMode.put);
    }
    return branchFromJson(response.body);
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderFSync order}) async {
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
      customer: CustomerSync(
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
      // final pdfFile =
      //     await ProxyService.pdfInvoice.generate(invoice, order.id.toString());

      /// read user setting and see if he choose to open a receipt file on complete of a sale.
      /// this is handy in case a client want to print on his machine directly
      String userId = ProxyService.box.read(key: 'userId');
      Setting? setting = await getSetting(userId: int.parse(userId));
      if (setting != null &&
          setting.openReceiptFileOSaleComplete != null &&
          setting.openReceiptFileOSaleComplete == true) {
        // ProxyService.pdfApi.openFile(pdfFile);
      }
      if (setting != null &&
          setting.autoPrint != null &&
          setting.autoPrint == true) {
        // ProxyService.pdfApi.openFile(pdfFile);
        // TODOnow call the printing service
      }
    }
  }

  Future<OrderFSync?> pendingOrderExist({required int branchId}) async {
    return store
        .box<OrderFSync>()
        .query(OrderFSync_.status
            .equals('pending')
            .and(OrderFSync_.fbranchId.equals(branchId)))
        .build()
        .findFirst();
  }

  @override
  Future<OrderFSync> createOrder(
      {required double customAmount,
      required VariantSync variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) async {
    final ref = Uuid().v1();
    final orderNUmber = Uuid().v1();
    String userId = ProxyService.box.read(key: 'userId');
    int branchId = ProxyService.box.read(key: 'branchId');
    OrderFSync? existOrder = await pendingOrderExist(branchId: branchId);
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
      final box = store.box<OrderFSync>();
      final id = box.put(
        OrderFSync(
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

      OrderFSync ss = store.box<OrderFSync>().get(id)!;
      StockSync stock = await stockByVariantId(variantId: variation.id);
      OrderItemSync orderItems = OrderItemSync(
        count: quantity,
        // name: useProductName ? variation.productName : variation.name,
        name: name,
        fvariantId: variation.id,
        price: price,
        forderId: id,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        remainingStock: stock.currentStock.toInt() - quantity.toInt(),
      );

      ss.orderItems.add(orderItems);

      box.put(ss);
      return ss;
    } else {
      StockSync stock = await stockByVariantId(variantId: variation.id);
      OrderItemSync item = OrderItemSync(
        count: quantity,
        name: name,
        fvariantId: variation.id,
        price: price,
        forderId: existOrder.id,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        remainingStock: stock.currentStock.toInt() - quantity.toInt(),
      );
      existOrder.orderItems.add(item);
      // final box = store.box<OrderF>();
      // final id = box.put(existOrder, mode: PutMode.update);
      final id = store.box<OrderFSync>().put(existOrder);
      // update(data: existOrder.toJson(), endPoint: 'order');
      return store.box<OrderFSync>().get(id)!;
    }
  }

  @override
  Future<ProductSync> createProduct({required ProductSync product}) async {
    final Map data = product.toJson();

    data['active'] = false;
    data['description'] = 'description';
    data['hasPicture'] = false;
    data['fbusinessId'] = ProxyService.box.read(key: 'businessId');
    data['fbranchId'] = ProxyService.box.read(key: 'branchId');
    data['taxId'] = 'XX';
    ProductSync products = ProductSync(
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
      ftaxId: data['ftaxId'],
    );
    final String? userId = ProxyService.box.read(key: 'userId');
    final int? branchId = ProxyService.box.read(key: 'branchId');

    final productId =
        store.box<ProductSync>().put(products, mode: PutMode.insert);
    VariantSync variant = VariantSync(
      name: 'Regular',
      sku: 'sku',
      fproductId: productId,
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
    // get product from store
    final productFromStore = store.box<ProductSync>().get(productId)!;

    productFromStore.variations.add(variant);

    store.box<ProductSync>().put(productFromStore);

    // final productFromStore2 = store.box<ProductSync>().get(productId)!;

    // log.d(productFromStore2.variations[0].toJson());
    List<VariantSync> v =
        await variants(branchId: branchId, productId: productId);
    final stock = new StockSync(
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
    VariantSync vs = v[0];
    vs.stock.target = stock;

    store.box<VariantSync>().put(vs);

    final stockBox = store.box<StockSync>();
    stockBox.put(stock);
    return store.box<ProductSync>().get(productId)!;
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) async {
    return store.box<PColor>().get(id);
  }

  @override
  Future<VariantSync?> getCustomProductVariant() async {
    ProductSync? product = store
        .box<ProductSync>()
        .query(ProductSync_.name.equals('Custom Amount'))
        .build()
        .findFirst();

    if (product == null) {
      ProductSync p = await createProduct(product: customProductMock);
      return store
          .box<VariantSync>()
          .query(VariantSync_.fproductId.equals(p.id))
          .build()
          .findFirst()!;
    } else {
      return store
          .box<VariantSync>()
          .query(VariantSync_.fproductId.equals(product.id))
          .build()
          .findFirst()!;
    }
  }

  @override
  Future<ProductSync?> getProduct({required int id}) async {
    return store.box<ProductSync>().get(id);
  }

  @override
  Future<List<OrderFSync>> orders({required int branchId}) async {
    return store
        .box<OrderFSync>()
        .getAll()
        .where((v) => v.status == 'pending')
        .where((v) => v.fbranchId == branchId)
        .toList();
  }

  @override
  Future<OrderFSync?> order({required int branchId}) async {
    return store
        .box<OrderFSync>()
        .query(OrderFSync_.status
            .equals('pending')
            .and((OrderFSync_.fbranchId.equals(branchId))))
        .build()
        .findFirst();
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    String userId = ProxyService.box.read(key: 'userId');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    String businessName = getBusiness().name;

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

    return spennFromJson(response.body);
  }

  @override
  Future<StockSync> stockByVariantId({required int variantId}) async {
    return store
        .box<StockSync>()
        .getAll()
        .where((v) => v.fvariantId == variantId)
        .toList()[0];
  }

  @override
  Stream<StockSync> stockByVariantIdStream({required int variantId}) {
    return store
        .box<StockSync>()
        .query(StockSync_.fvariantId.equals(variantId))
        .watch(triggerImmediately: true)
        // Watching the query produces a Stream<Query<StockSync>>
        // To get the actual data inside a List<StockSync>, we need to call find() on the query
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
        ProductSync? kProduct = store.box<ProductSync>().get(data['id']);
        Map map = kProduct!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        ProductSync product = ProductSync(
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
          synced: map['synced'],
          ftaxId: map['ftaxId'],
        );
        List<VariantSync> variants =
            await ProxyService.api.getVariantByProductId(productId: map['id']);
        final box = store.box<ProductSync>();
        product.variations.addAll(variants);

        box.put(product, mode: PutMode.update);
        break;
      case 'stock':
        StockSync? color = store.box<StockSync>().get(id);
        Map map = color!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        StockSync stock = StockSync(
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
        final box = store.box<StockSync>();
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
        BusinessSync? business = store.box<BusinessSync>().get(id);
        Map map = business!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        BusinessSync ubusiness = BusinessSync(
          active: map['active'],
          name: map['name'],
          table: map['table'],
          channels: map['channels'],
          fcategoryId: 1,
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
          email: map['email'],
          lastDbBackup: map['lastDbBackup'],
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
        final box = store.box<BusinessSync>();
        box.put(ubusiness, mode: PutMode.update);
        break;
      case 'variant':
        VariantSync? variation = store.box<VariantSync>().get(id);
        Map map = variation!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        VariantSync variant = VariantSync(
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
        // get stock where  map['id']
        StockSync? stock =
            await getStock(branchId: map['fbranchId'], variantId: map['id']);
        variant.stock.target = stock!;
        final box = store.box<VariantSync>();
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
        OrderFSync? singleOrder = store.box<OrderFSync>().get(dn['id']);
        Map map = singleOrder!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        OrderFSync order = OrderFSync(
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
        final box = store.box<OrderFSync>();
        box.put(order, mode: PutMode.update);
        //update relationship OrderItem
        // OrderItem? orderItem = store.box<OrderItem>().get(order.id);
        singleOrder.id = map['id'];
        // singleOrder.orderItems.add(element)
        //loop through singleOrder.orderItems find where fvariantId equal to the one in data map
        //update the element with the new data this will update the relationship
        List<OrderItemSync> updatedOrderItem = [];
        for (OrderItemSync item in singleOrder.orderItems) {
          if (item.fvariantId == data['fvariantId']) {
            item.fvariantId = data['fvariantId'];
            item.count = data['count'];
            item.price = data['price'];
            item.forderId = data['id'];
            item.fvariantId = data['fvariantId'];
            updatedOrderItem.add(item);
            log.i(item);
            store.box<OrderItemSync>().put(item, mode: PutMode.update);
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
            attendnaceDocCreated: map['attendnaceDocCreated'],
            isAttendanceEnabled: map['isAttendanceEnabled'],
            openReceiptFileOSaleComplete: map['openReceiptFileOSaleComplete'],
            autoPrint: map['autoPrint'],
            id: map['id']);
        final box = store.box<Setting>();
        box.put(Ksetting, mode: PutMode.update);
        break;
      case 'customer':
        CustomerSync? customer = store.box<CustomerSync>().get(id);
        log.i(customer!.id);
        Map map = customer.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        CustomerSync kCustomer = CustomerSync(
            email: map['email'],
            branchId: map['branchId'],
            updatedAt: map['updatedAt'],
            phone: map['phone'],
            name: map['name'],
            orderId: map['orderId'],
            address: map['address'],
            id: map['id']);
        log.i(kCustomer.toJson());
        final box = store.box<CustomerSync>();
        box.put(kCustomer, mode: PutMode.update);
        break;
      case 'discount':
        DiscountSync? discount = store.box<DiscountSync>().get(id);
        Map map = discount!.toJson();
        data.forEach((key, value) {
          map[key] = value;
        });
        // 1.0.toInt();
        DiscountSync kDiscount = DiscountSync(
          branchId: map['branchId'],
          amount: map['amount'].toInt(),
          name: map['name'],
          id: map['id'],
        );
        final box = store.box<DiscountSync>();
        box.put(kDiscount, mode: PutMode.update);
        break;

      /// when dealing with something that has a relationship
      /// we need to update it as the following.!
      case 'orderItem':
        OrderItemSync? orderItem = store.box<OrderItemSync>().get(id);

        orderItem!.forderId = data['forderId'];
        orderItem.fvariantId = data['fvariantId'];
        orderItem.count = data['count'];
        orderItem.price = data['price'];
        orderItem.id = data['id'];
        orderItem.name = data['name'];
        orderItem.discount = data['discount'];
        orderItem.type = data['type'];
        store.box<OrderItemSync>().put(orderItem);
        break;
      default:
        return 200;
    }
    return 200;
  }

  @override
  Future<SyncF> login({required String userPhone}) async {
    final response = await http.post(
      Uri.parse(apihub + '/v2/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'phoneNumber': userPhone},
      ),
    );

    if (response.statusCode == 200) {
      ProxyService.box.write(
        key: 'bearerToken',
        value: syncFromJson(response.body).token,
      );
      ProxyService.box.write(
        key: 'userId',
        value: syncFromJson(response.body).id.toString(),
      );
      ProxyService.box.write(
        key: 'userPhone',
        value: userPhone,
      );
      return syncFromJson(response.body);
    } else {
      log.e('error');
      throw Exception('403 Error');
    }
  }

  @override
  Future<OrderItemSync?> getOrderItem({required int id}) async {
    return store.box<OrderItemSync>().get(id);
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) async {
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
  BusinessSync getBusiness() {
    String? userId = ProxyService.box.read(key: 'userId');
    return store
        .box<BusinessSync>()
        .getAll()
        .firstWhere((unit) => unit.userId == userId);
  }

  late StreamSubscription<BusinessSync> userSubs;
  @override
  Stream<List<BusinessSync>> users() {
    // FIXMEstoped streaming business in the app
    // Stream<Business> stream = usersStreamController.stream;
    // userSubs = stream.listen((business) {
    //   Business? kBusiness = store.box<Business>().get(business.id);

    //   if (kBusiness == null) {
    //     log.i("now inserting new business" + business.id.toString());
    //     final box = store.box<Business>();
    //     box.put(business);
    //   } else {
    //     //updat this business with the update object
    //     final box = store.box<Business>();
    //     log.i(business.imageUrl);
    //     box.put(business, mode: PutMode.update);
    //   }
    // });
    return store
        .box<BusinessSync>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  @override
  void sendMessage({required int receiverId, required Message message}) async {
    // final convo = store.box<Conversation>().get(message.convoId);
    // convo!.lastMessage = message.text;
    // final box = store.box<Conversation>();

    // convo.messages.add(message);

    // box.put(convo);
    // final response = await client.post(Uri.parse("$apihub/v2/api/message"),
    //     body: jsonEncode({
    //       'receiverId': message.receiverId,
    //       'text': message.text,
    //       'convoId': message.convoId,
    //       'senderId': message.senderId,
    //       'type': message.type,
    //       'status': message.status,
    //       'createdAt': message.createdAt,
    //       'senderName': message.senderName,
    //     }),
    //     headers: {'Content-Type': 'application/json'});
    // // log.i(message.toJson());
    // log.i(response.statusCode);
    // if (response.statusCode == 201) {
    //   Conversation? kConvo = store.box<Conversation>().get(message.convoId);
    //   kConvo!.delivered = true;
    //   box.put(kConvo, mode: PutMode.update);
    // }
  }

  @override
  CustomerSync? addCustomer({required Map customer, required int orderId}) {
    int branchId = ProxyService.box.read(key: 'branchId');
    final box = store.box<CustomerSync>();
    CustomerSync kCustomer = CustomerSync(
      name: customer['name'],
      branchId: branchId,
      email: customer['email'],
      phone: customer['phone'],
      address: customer['address'] ?? '',
      orderId: orderId,
    );
    int id = box.put(kCustomer, mode: PutMode.insert);
    return store.box<CustomerSync>().get(id);
  }

  @override
  Future assingOrderToCustomer(
      {required int customerId, required int orderId}) async {
    OrderFSync? order = store.box<OrderFSync>().get(orderId)!;
    Map korder = order.toJson();
    korder['customerId'] = customerId;
    update(data: korder, endPoint: 'order');

    // and updat this customer with timestamp so it can trigger change!.
    CustomerSync? customer = store.box<CustomerSync>().get(customerId)!;
    Map kCustomer = customer.toJson();
    kCustomer['updatedAt'] = DateTime.now().toIso8601String();
    kCustomer['orderId'] = orderId;
    // kCustomer['orderId'] = DateTime.now().toIso8601String();
    int id = kCustomer['id'];
    await update(data: kCustomer, endPoint: 'customer/$id');
  }

  @override
  Stream<CustomerSync?> getCustomer({required String key}) {
    return store
        .box<CustomerSync>()
        .query(CustomerSync_.name.equals(key).or(
            (CustomerSync_.phone.equals(key))
                .or(CustomerSync_.email.equals(key))))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  @override
  Stream<CustomerSync?> getCustomerByOrderId({required int id}) {
    log.i(id);
    return store
        .box<CustomerSync>()
        .query(CustomerSync_.orderId.equals(id))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  @override
  Future<OrderFSync> getOrderById({required int id}) async {
    return store.box<OrderFSync>().getAll().firstWhere((v) => v.id == id);
  }

  /// tickets return [OrderFSync] as tickets if we have
  /// order with parked status then they are tickets
  /// if first there is norder with [parkedStatus]
  /// then return [] empty list of tickets to signal that we can show save button
  /// for new ticket i.e order
  @override
  Future<List<OrderFSync>> tickets() async {
    List<OrderFSync> tickets = store
        .box<OrderFSync>()
        .getAll()
        .where((v) => v.status == pendingStatus)
        .toList();
    if (tickets.isNotEmpty) {
      return [];
    }
    return store
        .box<OrderFSync>()
        .getAll()
        .where((v) => v.status == parkedStatus)
        .toList();
  }

  @override
  List<VariantSync> getVariantByProductId({required int productId}) {
    return store
        .box<VariantSync>()
        .getAll()
        .where((v) => v.fproductId == productId)
        .toList();
  }

  @override
  Future<List<OrderFSync>> getOrderByStatus({required String status}) async {
    return store
        .box<OrderFSync>()
        .query(OrderFSync_.status
            .equals(status)
            .and((OrderFSync_.reported.equals(false))))
        .build()
        .find();
  }

  @override
  Future<int> sendReport({required List<OrderItemSync> orderItems}) async {
    final response = await client.post(Uri.parse("$apihub/v2/api/report"),
        body: jsonEncode(orderItems),
        headers: {'Content-Type': 'application/json'});
    log.i(response.body);
    log.i(orderItems);
    log.i(jsonEncode(orderItems));
    return response.statusCode;
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) async {
    // TODOre-work on this until it work 100%;
    BusinessSync? business = getBusiness();
    String docName = business.name + '- Report';

    final response = await client.post(
        Uri.parse("$apihub/v2/api/createSheetDocument"),
        body: jsonEncode({"title": docName, "shareToEmail": email}),
        headers: {'Content-Type': 'application/json'});
    log.i(response.body);
  }

  ///in normal case the business is arleady streamed to users() method.
  ///but there is case when is not, then we fetch it first using http and
  ///only insert it to the store. only if it does not exist. and we do this only if there
  ///is internet. because the method can take some time. it is advised to schedule it
  ///in cron so it can run in app backgroup like every hour.
  @override
  Stream<List<BusinessSync>> contacts() async* {
    yield* store
        .box<BusinessSync>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  // @override
  // Stream<List<Message>> messages({required int conversationId}) async* {
  //   yield* store
  //       .box<Message>()
  //       .query(Message_.convoId.equals(conversationId))
  //       .watch(triggerImmediately: true)
  //       .map((query) => query.find());
  // }

  // @override
  // Stream<List<Conversation>> conversationStreamList({int? receiverId}) async* {
  //   int? myBusinessId = ProxyService.box.read(key: 'businessId');
  //   if (receiverId == null) {
  //     receiverId = myBusinessId;
  //   }
  //   log.i(receiverId);
  //first I have to listen to a socket
  // FIXMEstoped streaming messages as we are using firebase now.
  // Stream<Message> stream = messageStreamController.stream;
  // messageSubscription = stream.listen((message) async {
  //   /// all messages will be streamed here
  //   /// but not all message are of our intrest to use.
  //   /// a couple things might happen
  //   /// a message can be sent and the user is offline
  //   /// this case the server will keep trying as much as it can
  //   /// then once the user is online the message will be delivered
  //   /// the client will send another request to delete the message
  //   /// on success of the request an id of message  will be removed from queue item.
  //   /// we need a service in cron to keep sending the delete request
  //   /// until the queueItem is empty.
  //   /// a message.receiverId == myBusinessId means that the message is sent to me
  //   /// the message.convoId the conversation should exist in the store then should be created then
  //   if (message.receiverId == myBusinessId &&
  //       message.senderId != myBusinessId) {
  //     log.i("onNewMessage");
  //     Conversation? conversation =
  //         store.box<Conversation>().get(message.convoId);
  //     QueueItem queueItem = QueueItem(
  //       id: message.id,
  //     );
  //     Map<String, dynamic> author = types.User(
  //             id: message.senderId.toString(), firstName: message.senderImage)
  //         .toJson();
  //     //save queue item in store
  //     store.box<QueueItem>().put(queueItem);
  //     if (conversation == null) {
  //       conversation = Conversation(
  //         senderName: message.senderName!,
  //         id: message.convoId,
  //         receiverId: message.receiverId,
  //         senderId: message.senderId,
  //         createdAt: message.createdAt,
  //         lastMessage: message.text,
  //         status: message.status,
  //       );
  //       Message? messageExist = store.box<Message>().get(message.id);
  //       if (messageExist == null) {
  //         log.e("up");
  //         Message kmessage = messageBuilder(message, author);
  //         conversation.messages.add(kmessage);
  //         conversation.lastMessage = message.text;
  //         store.box<Conversation>().put(conversation);
  //       }
  //       emptySentMessageQueue();
  //     } else {
  //       Message? messageExist = store.box<Message>().get(message.id);
  //       if (messageExist == null) {
  //         log.e("down");
  //         Message kmessage = messageBuilder(message, author);
  //         conversation.messages.add(kmessage);
  //         conversation.lastMessage = message.text;
  //         store.box<Conversation>().put(conversation);
  //       }
  //       emptySentMessageQueue();
  //     }
  //     //load contacts just to update the list
  //     contacts();
  //   }
  // });

  //   yield* store
  //       .box<Conversation>()
  //       .query(Conversation_.receiverId
  //           .equals(myBusinessId ?? 0)
  //           .or(Conversation_.senderId.equals(myBusinessId ?? 0)))
  //       .watch(triggerImmediately: true)
  //       .map((query) => query.find());
  // }

  // Message messageBuilder(Message message, Map<String, dynamic> author) {
  //   return Message(
  //     id: message.id,
  //     status: 'online',
  //     type: message.type,
  //     author: author,
  //     createdAt: DateTime.now().microsecondsSinceEpoch,
  //     text: message.text,
  //     receiverId: message.receiverId,
  //     senderId: message.senderId,
  //     senderName: message.senderName,
  //     convoId: message.convoId,
  //   );
  // }

  @override
  BusinessSync getBusinessById({required int id}) {
    return store
        .box<BusinessSync>()
        .query(BusinessSync_.id.equals(id))
        .build()
        .findFirst()!;
  }

  /// take the current [OrderFSync] and find related [OrderItemSync]
  /// if the [OrderItemSync] is not found then return null else return the [OrderItemSync]
  /// when fail to find an element it then throw StateError which means it failed to find the element in the list
  /// then this is the reason why we need to return null as there is no such item which current order.
  @override
  OrderItemSync? getOrderItemByVariantId(
      {required int variantId, required int orderId}) {
    OrderFSync? o = store
        .box<OrderFSync>()
        .query(OrderFSync_.id.equals(orderId))
        .build()
        .findFirst();
    try {
      return o!.orderItems.where((item) => item.fvariantId == variantId).first;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProductSync?> getProductByBarCode({required String barCode}) async {
    return store
        .box<ProductSync>()
        .query(ProductSync_.barCode.equals(barCode))
        .build()
        .findFirst();
  }

  @override
  Future<void> updateBusiness({required int id, required Map business}) async {
    try {
      await client.patch(Uri.parse("$apihub/v2/api/business/$id"),
          body: jsonEncode({
            'deviceToken': business['deviceToken'],
            'email': business['email'],
            'backUpEnabled': business['backUpEnabled'],
            'lastDbBackup': business['lastDbBackup'],
            'backupFileId': business['backupFileId'],
            'chatUid': business['chatUid']
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      log.e(e);
    }
  }

  @override
  int lifeTimeCustomersForbranch({required int branchId}) {
    return store
        .box<CustomerSync>()
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
  List<OrderFSync> weeklyOrdersReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  }) {
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<OrderFSync> pastOrders = [];
    for (DateTime date in weekDates) {
      List<OrderFSync> orders = store
          .box<OrderFSync>()
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
    Map<String, OrderFSync> mp = {};
    for (var item in pastOrders) {
      mp[item.orderNumber] = item;
    }
    return mp.values.toList();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) async {
    // create Discount object and add it to the store
    var discount = new DiscountSync(
        name: name, amount: amount!.toInt(), branchId: branchId);
    store.box<DiscountSync>().put(discount);
  }

  @override
  OrderFSync addOrderItem({required OrderFSync order, required Map data}) {
    OrderItemSync item = OrderItemSync(
      count: data['count'],
      name: data['name'],
      fvariantId: data['fvariantId'],
      price: data['price'],
      forderId: data['forderId'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      remainingStock: data['remainingStock'],
    );
    order.orderItems.add(item);
    final id = store.box<OrderFSync>().put(order);
    return store.box<OrderFSync>().get(id)!;
  }

  // @override
  // Conversation createConversation({required Conversation conversation}) {
  //   int id = store.box<Conversation>().put(conversation);
  //   return store.box<Conversation>().get(id)!;
  // }

  // @override
  // Conversation? getConversationByContactId({required int contactId}) {
  //   return store
  //       .box<Conversation>()
  //       .query(Conversation_.receiverId
  //           .equals(contactId)
  //           .or(Conversation_.senderId.equals(contactId)))
  //       .build()
  //       .findFirst();
  // }

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
  Future<List<DiscountSync>> getDiscounts({required int branchId}) async {
    return store
        .box<DiscountSync>()
        .query(DiscountSync_.branchId.equals(branchId))
        .build()
        .find()
        .toList();
  }

  @override
  Future<List<BusinessSync>> getContacts() async {
    final response = await client.get(Uri.parse("$apihub/v2/api/users"));
    log.i('now fetching new contacts business now');
    for (BusinessSync business in businessFromJson(response.body)) {
      /// a user mast have been opted in to the app. chat feature.
      /// this is because there is old business that does not know about this feature
      /// otherwise it won't required as this step is part of startup logic.
      if (business.chatUid != null) {
        final box = store.box<BusinessSync>();
        box.put(business);
      }
    }
    int businessId = ProxyService.box.read(key: 'businessId');
    return store
        .box<BusinessSync>()
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
  Future<List<BusinessSync>> getOnlineBusiness({required String userId}) async {
    final response =
        await client.get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));
    List<BusinessSync> businesses = [];
    if (response.statusCode != 200) {
      throw SessionException(term: "session expired");
    }
    final box = store.box<BusinessSync>();
    BusinessSync? business = box.get(sbusinessFromJson(response.body).id);
    if (business == null) {
      box.put(sbusinessFromJson(response.body), mode: PutMode.put);
    }

    businesses.add(sbusinessFromJson(response.body));
    return businesses;
  }

  @override
  Future<List<BusinessSync>> getLocalOrOnlineBusiness(
      {required String userId}) async {
    List<BusinessSync> businesses = store
        .box<BusinessSync>()
        .getAll()
        .where((business) => business.userId == userId)
        .toList();

    if (businesses.isEmpty) {
      return await getOnlineBusiness(userId: userId);
    } else {
      return businesses;
    }
  }

  @override
  Future<List<BranchSync>> getLocalBranches({required int businessId}) async {
    return store
        .box<BranchSync>()
        .getAll()
        .where((unit) => unit.fbusinessId == businessId)
        .toList();
  }

  @override
  Future<int> userNameAvailable({required String name}) async {
    log.d("$apihub/search?name=$name");
    final response = await client.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  TenantSync? isTenant({required String phoneNumber}) {
    // return TenantSync from store where phoneNumber
    return store
        .box<TenantSync>()
        .query(TenantSync_.phoneNumber.equals(phoneNumber))
        .build()
        .findFirst();
  }

  @override
  Future<BusinessSync> getBusinessFromOnlineGivenId({required int id}) async {
    if (store.box<BusinessSync>().get(id) != null)
      return store.box<BusinessSync>().get(id)!;

    final response = await client.get(Uri.parse("$apihub/v2/api/business/$id"));

    BusinessSync business = sbusinessFromJson(response.body);
    // save business to store
    // log.d(business.toJson());
    // store
    if (store.box<BusinessSync>().get(business.id) == null)
      store.box<BusinessSync>().put(business);
    return business;
  }

  @override
  Stream<List<ProductSync>> productStreams({required int branchId}) {
    return store
        .box<ProductSync>()
        .query(ProductSync_.fbranchId
            .equals(branchId)
            .and(ProductSync_.draft.equals(false))
            .and(ProductSync_.synced.equals(false)))
        .watch(triggerImmediately: true)
        // Watching the query produces a Stream<Query<StockSync>>
        // To get the actual data inside a List<StockSync>, we need to call find() on the query
        .map((query) => query.find());
  }

  @override
  Future<void> syncProduct({
    required ProductSync product,
    required VariantSync variant,
    required StockSync stock,
  }) async {
    ProductSync? kProduct = store.box<ProductSync>().get(product.id);

    /// this is a new product that we received from sync
    /// which means was not found on this device
    if (kProduct == null) {
      int id = store.box<ProductSync>().put(product);
      ProductSync? productFromStore = store.box<ProductSync>().get(id);

      /// so as the variants too changed variant.fproductId to the local product id
      /// since the product was not found on this device and the remote might not necessarily match
      variant.fproductId = id;
      productFromStore!.variations.add(variant);

      store.box<ProductSync>().put(productFromStore);
      // stock
      await syncStock(variant, id, stock);
    } else {
      int id = store.box<ProductSync>().put(product, mode: PutMode.update);
      ProductSync? productFromStore = store.box<ProductSync>().get(id);
      variant.fproductId = id;
      productFromStore!.variations.add(variant);

      store.box<ProductSync>().put(productFromStore);
      // stock
      await syncStock(variant, id, stock);
    }
  }

  Future<void> syncStock(VariantSync variant, int id, StockSync stock) async {
    List<VariantSync> v =
        await variants(branchId: variant.fbranchId, productId: id);

    VariantSync vs = v[0];
    vs.stock.target = stock;

    store.box<VariantSync>().put(vs);

    final stockBox = store.box<StockSync>();
    stockBox.put(stock);
  }

  @override
  void migrateToSync() async {
    List<Product> products = store
        .box<Product>()
        .getAll()
        .where(
            (product) => product.migrated == false || product.migrated == null)
        .toList();
    for (Product product in products) {
      ProductSync productSync = ProductSync(
        active: product.active,
        fbranchId: product.fbranchId,
        fbusinessId: product.fbranchId,
        color: product.color,
        description: product.description,
        hasPicture: product.hasPicture,
        name: product.name,
        table: product.table,
        unit: product.unit,
        createdAt: product.createdAt,
        currentUpdate: product.currentUpdate,
        draft: product.draft,
        imageLocal: product.imageLocal,
        imageUrl: product.imageUrl,
        fsupplierId: product.fsupplierId,
        ftaxId: product.ftaxId,
      );
      // update product.migrated to true

      final int? branchId = ProxyService.box.read(key: 'branchId');

      /// save old product in new model
      final productId =
          store.box<ProductSync>().put(productSync, mode: PutMode.insert);

      /// get old variants as list
      List<Variant> variantss = store
          .box<Variant>()
          .getAll()
          .where((v) => v.fproductId == product.id)
          .toList();
      // get the product from store the new model
      final productFromStore = store.box<ProductSync>().get(productId)!;

      /// build new variants with new model
      VariantSync variant = VariantSync(
        name: variantss[0].name,
        sku: 'sku',
        fproductId: productId,
        unit: variantss[0].unit,
        table: AppTables.variation,
        channels: ["0"],
        productName: variantss[0].productName,
        fbranchId: branchId!,
        taxName: 'N/A',
        taxPercentage: 0.0,
        retailPrice: variantss[0].retailPrice,
        supplyPrice: variantss[0].supplyPrice,
        id: variantss[0].id,
      );
      // from new product model add the variation
      productFromStore.variations.add(variant);
      // save the new product model updated with variation
      store.box<ProductSync>().put(productFromStore);

      /// get variants from store in new model
      List<VariantSync> v =
          await variants(branchId: branchId, productId: productId);

      /// get old stock
      final stock = store
          .box<Stock>()
          .getAll()
          .where((v) => v.fvariantId == variantss[0].id)
          .toList()[0];

      /// build new stock with new model
      StockSync sStock = StockSync(
        fbranchId: stock.fbranchId,
        fvariantId: stock.id,
        lowStock: stock.lowStock,
        currentStock: stock.currentStock,
        supplyPrice: stock.supplyPrice,
        retailPrice: stock.retailPrice,
        canTrackingStock: stock.canTrackingStock,
        showLowStockAlert: stock.showLowStockAlert,
        channels: ["0"],
        table: AppTables.stock,
        fproductId: productId,
        active: stock.active,
        value: stock.value,
      );

      /// from new variant model add the stock
      VariantSync vs = v[0];
      vs.stock.target = sStock;

      /// save the new variant model updated with stock
      store.box<VariantSync>().put(vs);

      /// save the new stock model
      final stockBox = store.box<StockSync>();
      stockBox.put(sStock);

      /// update product.migrated to true
      //store.box<ProductSync>().get(productId)!;
      product.migrated = true;
      store.box<Product>().put(product);
      //store.box<ProductSync>().put(productSync);
    }
    // do the same with variants
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    return true;
  }

  @override
  bool subscribe({
    required String feature,
    required int businessId,
    required int agentCode,
  }) {
    return false;
  }

  /// checkin code is in format of businessName-businessId-userId
  @override
  Future<bool> checkIn({required String? checkInCode}) async {
    // get the given business from the api
    // split checkin code on - where first pass is the business name
    // and second pass is the business id
    String? checkIn = ProxyService.box.read(key: 'checkIn');
    if (checkIn != null) {
      return true;
    }
    final businessName = checkInCode!.split('-')[0];
    final businessId = int.parse(checkInCode.split('-')[1]);
    final submitTo = checkInCode.split('-')[2];

    // get the profile from store
    Profile? profile = store.box<Profile>().get(1);
    //then send the data to api
    DateTime _now = DateTime.now();

    /// add flag for checkin as early as possible because we might get so many scan result
    /// or the user might scann for too long which can result into multiple checkin
    /// to avoid that we add a flag to checkin then if we fail we remove it to enable next check in attempt
    ProxyService.box.write(key: 'checkIn', value: 'checkIn');
    final http.Response response =
        await client.post(Uri.parse("$apihub/v2/api/attendance"),
            body: jsonEncode({
              "businessId": businessId,
              "businessName": businessName,
              "fullName": profile!.name,
              "phoneNumber": profile.phone,
              "checkInDate": DateTime.now().toIso8601String(),
              "checkInTime":
                  '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}',
              "vaccinationCode": profile.vaccinationCode,
              "livingAt": profile.livingAt,
              "cell": profile.cell,
              "district": profile.district,
              "submitTo": submitTo
            }),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      /// removing checkIn flag will allow the user to check in again
      ProxyService.box.remove(key: 'checkIn');
      return false;
    }
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) async {
    /// call to create attendance document
    /// get business from store

    final business = store.box<BusinessSync>().get(businessId);
    final http.Response response = await client.post(
        Uri.parse("$apihub/v2/api/createAttendanceDoc"),
        body: jsonEncode({
          "title": business!.name + '-' + 'Attendance',
          "shareToEmail": email
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      log.d('created attendance document');
      // update settings with enableAttendance = true
      String userId = ProxyService.box.read(key: 'userId');
      Setting? setting =
          await ProxyService.api.getSetting(userId: int.parse(userId));
      setting!.attendnaceDocCreated = true;
      int id = setting.id;
      update(data: setting.toJson(), endPoint: "settings/$id");
      return true;
    }

    return false;
  }

  @override
  Profile? profile({required int businessId}) {
    return store
        .box<Profile>()
        .query(Profile_.businessId.equals(businessId))
        .build()
        .findFirst();
  }

  @override
  Profile? updateProfile({required Profile profile}) {
    // update profile in store
    int id = store.box<Profile>().put(profile);
    //get profile from store
    return store.box<Profile>().get(id)!;
  }

  @override
  void saveTenant({required String phoneNumber}) async {
    final response = await client
        .get(Uri.parse("$apihub/v2/api/tenantByPhone/$phoneNumber"));
    if (response.statusCode == 200) {
      TenantSync tenant = stenantFromJson(response.body);
      if (store.box<TenantSync>().get(tenant.id) == null)
        store.box<TenantSync>().put(tenant);
    }
  }

  @override
  String toString() =>
      'ObjectBoxApi(flipperApi: $flipperApi, dioClient: $dioClient, apihub: $apihub)';

  @override
  Stream<List<Message>> messages({required int conversationId}) {
    // TODO: implement messages
    throw UnimplementedError();
  }

  @override
  Future<Voucher?> consumeVoucher({required int voucherCode}) async {
    final http.Response response =
        await client.patch(Uri.parse("$apihub/v2/api/voucher"),
            body: jsonEncode(
              <String, int>{'id': voucherCode},
            ),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 422) return null;
    return Voucher.fromMap(json.decode(response.body));
  }

  @override
  Points addPoint({required int userId, required int point}) {
    Points? po = store
        .box<Points>()
        .query(Points_.userId.equals(userId))
        .build()
        .findFirst();
    if (po == null) {
      // create new point
      po = Points(userId: userId, value: point);
      int id = store.box<Points>().put(po);
      // get Points using Id
      return store.box<Points>().get(id)!;
    } else {
      // update point
      po.value = po.value + point;
      store.box<Points>().put(po);
      return store.box<Points>().get(po.id)!;
    }
  }

  @override
  Subscription addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  }) {
    Subscription? sub = store
        .box<Subscription>()
        .query(Subscription_.userId.equals(userId))
        .build()
        .findFirst();

    late DateTime nextBillingDate;
    switch (descriptor) {
      case "Monthly":
        nextBillingDate = DateTime.now().add(
          Duration(days: interval),
        );
        break;
      case "Yearly":
        nextBillingDate = DateTime.now().add(
          Duration(days: interval * 365),
        );
        break;
      case "Daily":
        nextBillingDate = DateTime.now().add(
          Duration(days: interval),
        );
        break;
      default:
    }

    if (sub == null) {
      sub = Subscription(
        descriptor: descriptor,
        userId: userId,
        interval: interval,
        lastBillingDate: DateTime.now().toIso8601String(),
        nextBillingDate: nextBillingDate.toIso8601String(),
        recurring: recurringAmount,
      );
      int id = store.box<Subscription>().put(sub);
      Subscription s = store.box<Subscription>().get(id)!;
      for (var feature in features) {
        s.features.add(feature);
      }
      store.box<Subscription>().put(s);
      return store.box<Subscription>().get(id)!;
    } else {
      sub.interval = interval;
      sub.recurring = recurringAmount;
      sub.descriptor = descriptor;
      sub.lastBillingDate = sub.nextBillingDate;
      sub.nextBillingDate = nextBillingDate.toIso8601String();
      store.box<Subscription>().put(sub);
      return store.box<Subscription>().get(sub.id)!;
    }
  }

  @override
  Subscription? getSubscription({required int userId}) {
    return store
        .box<Subscription>()
        .query(Subscription_.userId.equals(userId))
        .build()
        .findFirst();
  }

  @override
  Points? getPoints({required int userId}) {
    // get points from store
    return store
        .box<Points>()
        .query(Points_.userId.equals(userId))
        .build()
        .findFirst();
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // consome points from store
    Points? po = store
        .box<Points>()
        .query(Points_.userId.equals(userId))
        .build()
        .findFirst();
    if (po != null) {
      po.value = po.value - points;
      store.box<Points>().put(po);
    }
  }
}
