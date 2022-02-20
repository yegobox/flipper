import 'dart:convert';
import 'dart:io';
// Decision three
// can't use import because the part won't be imported
// can't use same interface since will be a waste as bcs of the first issue
// can use separate interface and would work but will mean that I need to re-write every call.
// Do I need to mimick desktop app to web?
// no->then this will work as web will not have 100 % feature as the rest of the app
// ->ditch objectbox to isar, but need a way to migrate old data to new.
// ->right now ditch is comlicated bcs isar still need some feature required for this easy migration
// ->migrating slowly on web will give more insight as we wait for the feature to be omplemented on isar side
// ->isar won't need to use same interface as objectbox since isar support all platforms
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/proxy.dart';

import 'interface.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'isar/points.dart';
import 'isar/pin.dart';
import 'isar/order_item.dart';
import 'isar/order.dart';
import 'isar/message.dart';
import 'isar/feature.dart';
import 'isar/discount.dart';
import 'isar/customer.dart';
import 'isar/color.dart';
import 'isar/category.dart';
import 'isar/business_local.dart';
import 'isar/branch.dart';
import 'isar/voucher.dart';
import 'isar/variant_sync.dart';
import 'isar/unit.dart';
import 'isar/tenant.dart';
import 'isar/sync.dart';
import 'isar/subscription.dart';
import 'isar/stock_sync.dart';
import 'isar/spenn.dart';
import 'isar/setting.dart';
import 'isar/profile.dart';
import 'isar/product_sync.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'models/exceptions.dart';

late Isar isar;

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  ExtendedClient(this._inner);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String? token = "ProxyService.box.read(key: 'bearerToken')";
    String? userId = "ProxyService.box.read(key: 'userId')";
    request.headers['Authorization'] = token;
    request.headers['userId'] = userId;
    request.headers['Content-Type'] = 'application/json';
    // request.headers['Connection'] = "Keep-Alive";
    // request.headers['Keep-Alive'] = "timeout=5, max=1000";
    return _inner.send(request);
  }
}

class IsarAPI implements Api {
  final log = getLogger('IsarAPI');
  ExtendedClient client = ExtendedClient(http.Client());
  String apihub = "https://apihub.yegobox.com";
  static getDir({required String dbName}) async {
    isar = isar = await Isar.open(
      directory: dbName,
      schemas: [
        OrderFSyncSchema,
      ],
      inspector: false,
    );
  }

  IsarAPI({String? dbName, Directory? dir}) {
    getDir(dbName: dbName!);
    log.d('dbName: $dbName');
  }

  @override
  CustomerSync? addCustomer({required Map customer, required int orderId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  Future<OrderFSync?> pendingOrderExist({required int branchId}) async {
    return isar.writeTxnSync((isar) {
      return isar.orderFSyncs
          .filter()
          .fbranchIdEqualTo(branchId)
          .statusEqualTo('pending')
          .findFirst();
    });
  }

  @override
  Future<OrderFSync> createOrder(
      {required double customAmount,
      required VariantSync variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) async {
    final ref = const Uuid().v1();

    final String orderNUmber = const Uuid().v1();
    String userId = "1";
    int branchId = 1;
    String name = '';
    OrderFSync? existOrder = await pendingOrderExist(branchId: branchId);
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
      final order = OrderFSync(
        reference: ref,
        orderNumber: orderNUmber,
        status: 'pending',
        orderType: orderType,
        active: true,
        draft: true,
        channels: [userId],
        subTotal: customAmount,
        table: 'orders',
        cashReceived: customAmount,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0, //fix this
        paymentType: 'Cash',
        fbranchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );
      // save order to db
      OrderFSync createdOrder = await isar.writeTxnSync((isar) async {
        int id = await isar.orderFSyncs.put(order);
        return isar.orderFSyncs.getSync(id)!;
      });
      // get stock by variation.id
      StockSync stock = isar.stockSyncs
          .filter()
          .fvariantIdEqualTo(variation.id)
          .findFirstSync()!;
      OrderItemSync orderItems = OrderItemSync(
        count: quantity,
        // name: useProductName ? variation.productName : variation.name,
        name: name,
        fvariantId: variation.id,
        price: price,
        forderId: createdOrder.id,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        remainingStock: stock.currentStock.toInt() - quantity.toInt(),
      );
      createdOrder.orderItems.value = orderItems;
      return createdOrder;
    } else {
      // get StockSync by variation.id
      StockSync stock = isar.stockSyncs
          .filter()
          .fvariantIdEqualTo(variation.id)
          .findFirstSync()!;
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
      existOrder.orderItems.value = item;
      // update order
      OrderFSync updatedOrder = await isar.writeTxnSync((isar) async {
        int id = await isar.orderFSyncs.put(existOrder);
        return isar.orderFSyncs.getSync(id)!;
      });
      return updatedOrder;
    }
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
    order.orderItems.value = item;
    return isar.writeTxnSync((isar) {
      int id = isar.orderFSyncs.putSync(order);
      return isar.orderFSyncs.getSync(id)!;
    });
  }

  // get point where userId = userId from db
  @override
  Points addPoint({required int userId, required int point}) {
    return isar.pointss.filter().userIdEqualTo(userId).findFirstSync()!;
  }

  @override
  Future<int> addUnits({required Map data}) async {
    // GOOD
    await isar.writeTxn((isar) async {
      for (Map map in data['units']) {
        final unit = Unit(
          active: false,
          table: data['table'],
          value: map['value'],
          name: map['name'],
          fbranchId: 1,
        );
        // save unit to db
        await isar.units.put(unit);
      }
    });

    return Future.value(200);
  }

  @override
  Subscription addUpdateSubscription(
      {required int userId,
      required int interval,
      required double recurringAmount,
      required String descriptor,
      required List<Feature> features}) {
    // get Subscription where userId = userId from db
    Subscription? subscription =
        isar.subscriptions.filter().userIdEqualTo(userId).findFirstSync();
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
    subscription ??= Subscription(
      userId: userId,
      lastBillingDate: subscription!.nextBillingDate,
      nextBillingDate: nextBillingDate.toIso8601String(),
      interval: interval,
      descriptor: descriptor,
      recurring: recurringAmount,
    );
    // save subscription to db and return subscription
    Subscription sub = isar.writeTxnSync((isar) {
      int id = isar.subscriptions.putSync(subscription!);
      return isar.subscriptions.getSync(id)!;
    });
    for (var feature in features) {
      sub.features.value = feature;
    }
    // update sub to db
    return isar.writeTxnSync((isar) {
      int id = isar.subscriptions.putSync(sub);
      return isar.subscriptions.getSync(id)!;
    });
  }

  @override
  Future<int> addVariant(
      {required List<VariantSync> data,
      required double retailPrice,
      required double supplyPrice}) async {
    await isar.writeTxn((isar) async {
      for (VariantSync variation in data) {
        Map d = variation.toJson();
        // save variation to db
        int variantId = await isar.variantSyncs.put(variation);
        final stockId = DateTime.now().millisecondsSinceEpoch;
        String? userId = "1";
        final stock = StockSync(
          id: stockId,
          fvariantId: variantId,
          lowStock: 0.0,
          currentStock: 0.0,
          supplyPrice: supplyPrice,
          retailPrice: retailPrice,
          canTrackingStock: false,
          showLowStockAlert: false,
          channels: [userId],
          table: "stocks",
          fproductId: int.parse(d['productId'].toString()),
          value: 0,
          active: false,
        );
        // save stock to db
        await isar.stockSyncs.put(stock);
      }
    });
    return Future.value(200);
  }

  @override
  Future assingOrderToCustomer(
      {required int customerId, required int orderId}) async {
    // get order where id = orderId from db
    OrderFSync? order = await isar.orderFSyncs.get(orderId);

    order!.customerId = customerId;
    // update order to db
    await isar.writeTxn((isar) async {
      int id = await isar.orderFSyncs.put(order);
      return isar.orderFSyncs.getSync(id)!;
    });
    // get customer where id = customerId from db
    //// and updat this customer with timestamp so it can trigger change!.
    CustomerSync? customer = await isar.customerSyncs.get(customerId);
    customer!.updatedAt = DateTime.now().toIso8601String();
    customer.orderId = orderId;
    // save customer to db
    await isar.writeTxn((isar) async {
      int id = await isar.customerSyncs.put(customer);
      return isar.customerSyncs.getSync(id)!;
    });
  }

  @override
  Future<List<BranchSync>> branches({required int businessId}) async {
    final response =
        await client.get(Uri.parse("$apihub/v2/api/branches/$businessId"));
    if (response.statusCode == 200) {
      await isar.writeTxn((isar) async {
        for (BranchSync branch in branchsFromJson(response.body)) {
          // save branch in db
          await isar.branchSyncs.put(branch);
        }
      });
      // return all branches from db
      return isar.branchSyncs.filter().fbusinessIdEqualTo(businessId).findAll();
    }
    throw Exception('Failed to load branch');
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    // get all categories from isar db
    return isar.categorys.filter().fbranchIdEqualTo(branchId).findAll();
  }

  @override
  Future<bool> checkIn({required String? checkInCode}) async {
    //  String? checkIn = ProxyService.box.read(key: 'checkIn');
    String? checkIn;
    if (checkIn != null) {
      return true;
    }
    final businessName = checkInCode!.split('-')[0];
    final businessId = int.parse(checkInCode.split('-')[1]);
    final submitTo = checkInCode.split('-')[2];

    // get the profile from store
    // Profile? profile = store.box<Profile>().get(1);
    Profile? profile;
    //then send the data to api
    DateTime _now = DateTime.now();

    /// add flag for checkin as early as possible because we might get so many scan result
    /// or the user might scann for too long which can result into multiple checkin
    /// to avoid that we add a flag to checkin then if we fail we remove it to enable next check in attempt
    // ProxyService.box.write(key: 'checkIn', value: 'checkIn');
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
      // ProxyService.box.remove(key: 'checkIn');
      return false;
    }
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderFSync order}) async {
    order.status = 'complete';
    order.reported = false;
    order.cashReceived = cashReceived;
    // update order in isar db
    await isar.writeTxn((isar) async {
      int id = await isar.orderFSyncs.put(order);
      return isar.orderFSyncs.getSync(id)!;
    });
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    // get all colors from isar db
    return isar.pColors.filter().fbranchIdEqualTo(branchId).findAll();
  }

  @override
  void consumePoints({required int userId, required int points}) async {
    // get Points where userId = userId from db
    // and update this Points with new points
    Points? po = await isar.pointss.filter().userIdEqualTo(userId).findFirst();
    //po ??= Points(userId: userId, points: 0, value: 0);
    // save po to db
    po!.value = po.value - points;
    await isar.writeTxn((isar) async {
      int id = await isar.pointss.put(po);
      return isar.pointss.getSync(id)!;
    });
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
  Stream<List<Business>> contacts() {
    // TODO: implement contacts
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) async {
    // TODOre-work on this until it work 100%;
    Business? business = getBusiness();
    String docName = business!.name + '- Report';

    await client.post(Uri.parse("$apihub/v2/api/createSheetDocument"),
        body: jsonEncode({"title": docName, "shareToEmail": email}),
        headers: {'Content-Type': 'application/json'});
  }

  @override
  Future<Pin?> createPin() async {
    //get existing pin where userId =1
    // if pin is null then create new pin
    Pin? pin = await isar.pins.filter().userIdEqualTo("1").findFirst();
    if (pin != null) {
      return pin;
    }
    String id = "1";
    final http.Response response =
        await client.post(Uri.parse("$apihub/v2/api/pin"),
            body: jsonEncode(
              <String, String>{
                'userId': '1',
                'branchId': "1",
                'businessId': "1",
                'phoneNumber': '',
                'pin': id
              },
            ),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Pin pin = pinFromMap(response.body);
      int id = await isar.pins.put(pin);
      return isar.pins.getSync(id)!;
    }
    return null;
  }

  @override
  Future<ProductSync> createProduct({required ProductSync product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required id, String? endPoint}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) {
    // TODO: implement enableAttendance
    throw UnimplementedError();
  }

  @override
  Business? getBusiness() {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Business getBusinessById({required int id}) {
    // TODO: implement getBusinessById
    throw UnimplementedError();
  }

  @override
  Future<Business> getBusinessFromOnlineGivenId({required int id}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<VariantSync?> getCustomProductVariant() {
    // TODO: implement getCustomProductVariant
    throw UnimplementedError();
  }

  @override
  Stream<CustomerSync?> getCustomer({required String key}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Stream<CustomerSync?> getCustomerByOrderId({required int id}) {
    // TODO: implement getCustomerByOrderId
    throw UnimplementedError();
  }

  @override
  Future<List<DiscountSync>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError();
  }

  @override
  Future<List<BranchSync>> getLocalBranches({required int businessId}) async {
    // get all branch from isar db
    List<BranchSync> kBranches = await isar.branchSyncs
        .filter()
        .fbusinessIdEqualTo(businessId)
        .findAll();
    if (kBranches.isEmpty) {
      return await branches(businessId: businessId);
    }
    return kBranches;
  }

  @override
  Future<List<Business>> getLocalOrOnlineBusiness({required String userId}) {
    // TODO: implement getLocalOrOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getOnlineBusiness({required String userId}) async {
    final response =
        await client.get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));
    List<Business> businesses = [];
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw NotFoundException(term: "Business not found");
    }
    // final box = store.box<Business>();
    Business? business = isar.businesss.getSync(fromJson(response.body).id);
    if (business == null) {
      // box.put(fromJson(response.body), mode: PutMode.put);
      // save fromJson(response.body) to db
      isar.businesss.put(fromJson(response.body));
      // return all business from isar db
      return isar.businesss.filter().userIdEqualTo(userId).findAll();
    }

    businesses.add(fromJson(response.body));
    return businesses;
  }

  @override
  Future<OrderFSync> getOrderById({required int id}) {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<List<OrderFSync>> getOrderByStatus({required String status}) {
    // TODO: implement getOrderByStatus
    throw UnimplementedError();
  }

  @override
  Future<OrderItemSync?> getOrderItem({required int id}) {
    // TODO: implement getOrderItem
    throw UnimplementedError();
  }

  @override
  OrderItemSync? getOrderItemByVariantId(
      {required int variantId, required int orderId}) {
    // TODO: implement getOrderItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<Pin?> getPin({required String pin}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Points? getPoints({required int userId}) {
    // TODO: implement getPoints
    throw UnimplementedError();
  }

  @override
  Future<ProductSync?> getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductSync?> getProductByBarCode({required String barCode}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Setting? getSetting({required int userId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<StockSync?> getStock({required int branchId, required int variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Subscription? getSubscription({required int userId}) {
    // TODO: implement getSubscription
    throw UnimplementedError();
  }

  @override
  List<VariantSync> getVariantByProductId({required int productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSync>> isTempProductExist({required int branchId}) {
    // TODO: implement isTempProductExist
    throw UnimplementedError();
  }

  @override
  Future<TenantSync?> isTenant({required String phoneNumber}) {
    // TODO: implement isTenant
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required int branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
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
    log.d(response.body);
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
  Stream<List<Message>> messages({required int conversationId}) {
    // TODO: implement messages
    throw UnimplementedError();
  }

  @override
  void migrateToSync() {
    // TODO: implement migrateToSync
  }

  @override
  Future<OrderFSync?> order({required int branchId}) {
    // TODO: implement order
    throw UnimplementedError();
  }

  @override
  Future<List<OrderFSync>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Stream<List<ProductSync>> productStreams({required int branchId}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSync>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Profile? profile({required int businessId}) {
    // TODO: implement profile
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  void saveTenant({required String phoneNumber}) {
    // TODO: implement saveTenant
  }

  @override
  void sendMessage({required int receiverId, required Message message}) {
    // TODO: implement sendMessage
  }

  @override
  Future<int> sendReport({required List<OrderItemSync> orderItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<int> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<StockSync> stockByVariantId({required int variantId}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Stream<StockSync> stockByVariantIdStream({required int variantId}) {
    // TODO: implement stockByVariantIdStream
    throw UnimplementedError();
  }

  @override
  List<StockSync> stocks({required int productId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  bool subscribe(
      {required String feature,
      required int businessId,
      required int agentCode}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  bool suggestRestore() {
    // TODO: implement suggestRestore
    throw UnimplementedError();
  }

  @override
  Future<void> syncProduct(
      {required ProductSync product,
      required VariantSync variant,
      required StockSync stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<OrderFSync>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Future<List<Unit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> updateBusiness({required int id, required Map business}) {
    // TODO: implement updateBusiness
    throw UnimplementedError();
  }

  @override
  Profile? updateProfile({required Profile profile}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({required String name}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Stream<List<Business>> users() {
    // TODO: implement users
    throw UnimplementedError();
  }

  @override
  Future<VariantSync?> variant({required int variantId}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<VariantSync>> variants(
      {required int branchId, required int productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  List<OrderFSync> weeklyOrdersReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) {
    // TODO: implement weeklyOrdersReport
    throw UnimplementedError();
  }
}
