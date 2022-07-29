import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/data.loads/jcounter.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:universal_platform/universal_platform.dart';
import 'view_models/gate.dart';

final isAndroid = UniversalPlatform.isAndroid;

class ExtendedClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  ExtendedClient(this._inner);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    String? token = ProxyService.box.read(key: 'bearerToken');
    String? userId = ProxyService.box.read(key: 'userId');
    request.headers['Authorization'] = token ?? '';
    request.headers['userId'] = userId ?? '';
    request.headers['Content-Type'] = 'application/json';
    return _inner.send(request);
  }
}

class IsarAPI implements IsarApiInterface {
  final log = getLogger('IsarAPI');
  ExtendedClient client = ExtendedClient(http.Client());
  late String apihub;
  late Isar isar;
  Future<IsarApiInterface> getInstance({Isar? iisar}) async {
    if (foundation.kDebugMode && !isAndroid) {
      apihub = "http://localhost:8082";
    } else if (foundation.kDebugMode && isAndroid) {
      // apihub = "http://10.0.2.2:8082";
      apihub = "https://apihub.yegobox.com";
    } else {
      apihub = "https://apihub.yegobox.com";
    }
    if (iisar == null) {
      isar = await Isar.open(
        [
          OrderSchema,
          BusinessSchema,
          BranchSchema,
          OrderItemSchema,
          ProductSchema,
          VariantSchema,
          ProfileSchema,
          SubscriptionSchema,
          IPointSchema,
          StockSchema,
          FeatureSchema,
          VoucherSchema,
          PColorSchema,
          CategorySchema,
          IUnitSchema,
          SettingSchema,
          DiscountSchema,
          CustomerSchema,
          PinSchema,
          ReceiptSchema,
          DrawersSchema,
          ITenantSchema,
          PermissionSchema,
          CounterSchema,
          TokenSchema
        ],
      );
    } else {
      isar = iisar;
    }

    log.i(isar.path);
    return this;
  }

  @override
  Future<Customer?> addCustomer(
      {required Map customer, required int orderId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    Customer kCustomer = Customer()
      ..name = customer['name']
      ..updatedAt = DateTime.now().toString()
      ..branchId = branchId
      ..tinNumber = customer['tinNumber']
      ..email = customer['email']
      ..phone = customer['phone']
      ..address = customer['address']
      ..orderId = orderId;
    Customer? kcustomer = await isar.writeTxn(() async {
      int id = await isar.customers.put(kCustomer);
      return await isar.customers.get(id);
    });
    Order? order = await isar.writeTxn(() async {
      return await isar.orders.get(orderId);
    });
    order!.customerId = kcustomer!.id;
    // update the order with the customerID
    await update(data: order);
    return kcustomer;
  }

  @override
  Future<List<Order>> completedOrders(
      {required int branchId, String? status = completeStatus}) {
    return isar.writeTxn(() async {
      return isar.orders
          .where()
          .statusBranchIdEqualTo(status!, branchId)
          .findAll();
    });
  }

  @override
  Stream<Order?> pendingOrderStream() {
    int? currentOrderId = ProxyService.box.currentOrderId();
    log.d('currentOrderId: $currentOrderId');
    return isar.orders.watchObject(currentOrderId ?? 0, initialReturn: true);
  }

  @override
  Future<Order> manageOrder({
    String orderType = 'custom',
  }) async {
    final ref = const Uuid().v1().substring(0, 8);

    final String orderNumber = const Uuid().v1().substring(0, 8);

    int branchId = ProxyService.box.getBranchId()!;

    Order? existOrder = await pendingOrder(branchId: branchId);

    if (existOrder == null) {
      final order = Order()
        ..reference = ref
        ..orderNumber = orderNumber
        ..status = pendingStatus
        ..orderType = orderType
        ..active = true
        ..draft = true
        ..subTotal = 0
        ..cashReceived = 0
        ..updatedAt = DateTime.now().toIso8601String()
        ..customerChangeDue = 0.0
        ..paymentType = 'Cash'
        ..branchId = branchId
        ..createdAt = DateTime.now().toIso8601String();
      // save order to db
      Order? createdOrder = await isar.writeTxn(() async {
        int id = await isar.orders.put(order);
        ProxyService.box.write(key: 'currentOrderId', value: id);
        return isar.orders.get(id);
      });
      return createdOrder!;
    } else {
      return existOrder;
    }
  }

  @override
  Future<void> addOrderItem({required Order order, OrderItem? item}) async {
    if (item != null) {
      return isar.writeTxn(() async {
        isar.orderItems.put(item);
      });
    }
  }

  // get point where userId = userId from db
  @override
  IPoint addPoint({required int userId, required int point}) {
    return isar.iPoints.filter().userIdEqualTo(userId).findFirstSync()!;
  }

  @override
  Future<int> addUnits<T>({required T data}) async {
    await isar.writeTxn(() async {
      IUnit units = data as IUnit;
      for (Map map in units.units!) {
        final unit = IUnit()
          ..active = false
          ..value = units.value
          ..name = map['name']
          ..branchId = units.branchId;
        // save unit to db
        await isar.iUnits.put(unit);
      }
    });
    return Future.value(200);
  }

  @override
  Future<Subscription?> addUpdateSubscription(
      {required int userId,
      required int interval,
      required double recurringAmount,
      required String descriptor,
      required List<Feature> features}) async {
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
    Subscription? sub = await isar.writeTxn(() async {
      int id = await isar.subscriptions.put(subscription!);
      return isar.subscriptions.get(id);
    });
    for (var feature in features) {
      sub!.features.value = feature;
    }
    // update sub to db
    return isar.writeTxn(() async {
      int id = await isar.subscriptions.put(sub!);
      return isar.subscriptions.get(id);
    });
  }

  @override
  Future<int> addVariant(
      {required List<Variant> data,
      required double retailPrice,
      required double supplyPrice}) async {
    await isar.writeTxn(() async {
      for (Variant variation in data) {
        // save variation to db
        // FIXMEneed to know if all item will have same itemClsCd
        variation.itemClsCd = "5020230602";
        variation.pkg = "1";
        int variantId = await isar.variants.put(variation);
        final stockId = DateTime.now().millisecondsSinceEpoch;
        final stock = Stock()
          ..id = stockId
          ..variantId = variantId
          ..lowStock = 0.0
          ..branchId = ProxyService.box.getBranchId()!
          ..currentStock = 0.0
          ..supplyPrice = supplyPrice
          ..retailPrice = retailPrice
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..productId = variation.productId
          ..value = 0
          ..active = false;
        await isar.stocks.put(stock);
      }
    });
    return Future.value(200);
  }

  @override
  Future assingOrderToCustomer(
      {required int customerId, required int orderId}) async {
    // get order where id = orderId from db
    Order? order = await isar.orders.get(orderId);

    order!.customerId = customerId;
    // update order to db
    await isar.writeTxn(() async {
      int id = await isar.orders.put(order);
      return isar.orders.get(id);
    });
    // get customer where id = customerId from db
    //// and updat this customer with timestamp so it can trigger change!.
    Customer? customer = await isar.customers.get(customerId);
    customer!.updatedAt = DateTime.now().toIso8601String();
    customer.orderId = orderId;
    // save customer to db
    await isar.writeTxn(() async {
      int id = await isar.customers.put(customer);
      return isar.customers.get(id);
    });
  }

  @override
  Future<List<Branch>> branches({required int businessId}) async {
    List<Branch> kBranches =
        await isar.branchs.filter().businessIdEqualTo(businessId).findAll();
    return kBranches;
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
      return false;
    }
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required Order order}) async {
    order.status = completeStatus;
    order.reported = false;
    order.cashReceived = cashReceived;
    List<OrderItem> items = await orderItems(orderId: order.id);

    for (OrderItem item in items) {
      Stock? stock = await stockByVariantId(variantId: item.variantId);
      stock?.currentStock = stock.currentStock - item.qty;
      update(data: stock);
    }
    await isar.writeTxn(() async {
      int id = await isar.orders.put(order);
      return isar.orders.get(id);
    });
    // remove currentOrderId from local storage to leave a room
    // for listening to new order that will be created
    ProxyService.box.remove(key: 'currentOrderId');
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return isar.writeTxn(() async {
      return isar.pColors.filter().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  void consumePoints({required int userId, required int points}) async {
    // get Points where userId = userId from db
    // and update this Points with new points
    IPoint? po = await isar.iPoints.filter().userIdEqualTo(userId).findFirst();
    //po ??= Points(userId: userId, points: 0, value: 0);
    // save po to db
    po!.value = po.value - points;
    await isar.writeTxn(() async {
      int id = await isar.iPoints.put(po);
      return isar.iPoints.getSync(id)!;
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
    return Voucher()
      ..createdAt = json.decode(response.body)['createdAt']
      ..usedAt = json.decode(response.body)['usedAt']
      ..descriptor = json.decode(response.body)['descriptor']
      ..interval = json.decode(response.body)['interval']
      ..value = json.decode(response.body)['value'];
  }

  @override
  Stream<List<Business>> contacts() {
    // TODO: implement contacts
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required T data, required String endPoint}) {
    if (endPoint == 'color') {
      PColor color = data as PColor;
      isar.writeTxn(() async {
        for (String colorName in data.colors!) {
          await isar.pColors.put(PColor()
            ..name = colorName
            ..active = color.active
            ..branchId = color.branchId);
        }
      });
    }
    if (endPoint == 'category') {
      Category category = data as Category;
      isar.writeTxn(() {
        return isar.categorys.put(category);
      });
    }
    return Future.value(200);
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) async {
    // TODOre-work on this until it work 100%;
    Business? business = await getBusiness();
    String docName = business!.name! + '- Report';

    await client.post(Uri.parse("$apihub/v2/api/createSheetDocument"),
        body: jsonEncode({"title": docName, "shareToEmail": email}),
        headers: {'Content-Type': 'application/json'});
  }

  @override
  Future<Pin?> createPin() async {
    String id = ProxyService.box.getUserId()!;
    //get existing pin where userId =1
    // if pin is null then create new pin
    Pin? pin = await isar.pins.filter().userIdEqualTo(id).findFirst();
    if (pin != null) {
      return pin;
    }

    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    String phoneNumber = ProxyService.box.getUserPhone()!;
    final http.Response response =
        await client.post(Uri.parse("$apihub/v2/api/pin"),
            body: jsonEncode(
              <String, String>{
                'userId': id,
                'branchId': branchId.toString(),
                'businessId': businessId.toString(),
                'phoneNumber': phoneNumber,
                'pin': id
              },
            ),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Pin pin = pinFromMap(response.body);

      return isar.writeTxn(() async {
        int id = await isar.pins.put(pin);
        return isar.pins.get(id);
      });
    }
    return null;
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    Business? business = await getBusiness();
    String itemPrefix = "flip-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);
    product.active = false;
    product.description = 'description';
    product.color = '#5A2328';
    product.hasPicture = false;
    product.businessId = ProxyService.box.getBusinessId()!;
    product.branchId = ProxyService.box.getBranchId()!;

    final int branchId = ProxyService.box.getBranchId()!;

    Product? kProduct = await isar.writeTxn(() async {
      int id = await isar.products.put(product);
      return isar.products.get(id);
    });
    // save variants in isar Db with the above productId
    await isar.writeTxn(() async {
      return isar.variants.put(
        Variant()
          ..name = 'Regular'
          ..productId = kProduct!.id
          ..unit = 'Per Item'
          ..table = 'variants'
          ..productName = product.name
          ..branchId = branchId
          ..taxName = 'N/A'
          ..isTaxExempted = false
          ..taxPercentage = 0
          ..retailPrice = 0
          // RRA fields
          ..bhfId = business?.bhfId
          ..prc = 0.0
          ..sku = 'sku'
          ..tin = business?.tinNumber
          ..itemCd = clip
          // TODOask about item clasification code, it seems to be static
          ..itemClsCd = "5020230602"
          ..itemTyCd = "1"
          ..itemNm = "Regular"
          ..itemStdNm = "Regular"
          ..orgnNatCd = "RW"
          ..pkgUnitCd = "NT"
          ..qtyUnitCd = "U"
          ..taxTyCd = "B"
          ..dftPrc = 0.0
          ..addInfo = "A"
          ..isrcAplcbYn = "N"
          ..useYn = "N"
          ..regrId = clip
          ..regrNm = "Regular"
          ..modrId = clip
          ..modrNm = "Regular"
          ..pkg = "1"
          ..itemSeq = "1"
          ..splyAmt = 0.0
          // RRA fields ends
          ..supplyPrice = 0.0,
      );
    });

    Variant? variant =
        await isar.variants.where().productIdEqualTo(kProduct!.id).findFirst();

    Stock stock = Stock()
      ..canTrackingStock = false
      ..showLowStockAlert = false
      ..currentStock = 0.0
      ..branchId = branchId
      ..variantId = variant!.id
      ..supplyPrice = 0.0
      ..retailPrice = 0.0
      ..lowStock = 10.0 // default static
      ..canTrackingStock = true
      ..showLowStockAlert = true
      // normaly this should be currentStock * retailPrice
      ..value = variant.retailPrice * 0.0
      ..active = false
      ..productId = kProduct.id
      ..rsdQty = 0.0;

    await isar.writeTxn(() async {
      return isar.stocks.put(stock);
    });

    return kProduct;
  }

  @override
  Future<bool> isTaxEnabled() async {
    Business? business = await getBusiness();
    bool isEbmEnabled = business?.tinNumber != null &&
        business?.bhfId != null &&
        business?.dvcSrlNo != null &&
        business?.taxEnabled == true;
    return Future.value(isEbmEnabled);
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required id, String? endPoint}) {
    switch (endPoint) {
      case 'color':
        isar.writeTxn(() async {
          await isar.pColors.delete(id);
          return true;
        });
        break;
      case 'category':
        isar.writeTxn(() async {
          await isar.categorys.delete(id);
          return true;
        });
        break;
      case 'product':
        isar.writeTxn(() async {
          await isar.products.delete(id);
          return true;
        });
        //TODOalso delete related variants
        break;
      case 'variant':
        isar.writeTxn(() async {
          await isar.variants.delete(id);
          return true;
        });
        break;
      case 'stock':
        isar.writeTxn(() async {
          await isar.stocks.delete(id);
          return true;
        });
        break;
      case 'setting':
        isar.writeTxn(() async {
          await isar.settings.delete(id);
          return true;
        });
        break;
      case 'pin':
        isar.writeTxn(() async {
          await isar.pins.delete(id);
          return true;
        });
        break;
      case 'business':
        isar.writeTxn(() async {
          await isar.business.delete(id);
          return true;
        });
        break;
      case 'branch':
        isar.writeTxn(() async {
          await isar.branchs.delete(id);
          return true;
        });
        break;

      case 'voucher':
        isar.writeTxn(() async {
          await isar.vouchers.delete(id);
          return true;
        });
        break;
      case 'orderItem':
        isar.writeTxn(() async {
          await isar.orderItems.delete(id);
          return true;
        });
        break;
      case 'customer':
        isar.writeTxn(() async {
          await isar.customers.delete(id);
          return true;
        });
        break;
      default:
        return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) async {
    /// call to create attendance document
    /// get business from store

    Business? business = await isar.writeTxn(() {
      return isar.business.get(businessId);
    });
    final http.Response response = await client.post(
        Uri.parse("$apihub/v2/api/createAttendanceDoc"),
        body: jsonEncode({
          "title": business!.name! + '-' + 'Attendance',
          "shareToEmail": email
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      log.d('created attendance document');
      // update settings with enableAttendance = true
      String userId = ProxyService.box.read(key: 'userId');
      Setting? setting = await getSetting(userId: int.parse(userId));
      setting!.attendnaceDocCreated = true;
      int id = setting.id;
      update(data: setting.toJson(), endPoint: "settings/$id");
      return true;
    }

    return false;
  }

  @override
  Future<Business?> getBusiness() {
    String? userId = ProxyService.box.getUserId();
    return isar.writeTxn(() {
      return isar.business.filter().userIdEqualTo(userId!).findFirst();
    });
  }

  @override
  Future<Business?> getBusinessById({required int id}) async {
    return await isar.business.get(id);
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = await isar.writeTxn(() {
      return isar.business.filter().idEqualTo(id).findFirst();
    });
    if (business != null) return business;
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      Business business = Business.fromJson(json.decode(response.body));
      return isar.writeTxn(() async {
        int id = await isar.business.put(business);
        return isar.business.get(id);
      });
    }
    return null;
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) async {
    return isar.writeTxn(() async {
      return isar.pColors.get(id);
    });
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant() async {
    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    Product? product =
        await isar.products.where().nameEqualTo('Custom Amount').findFirst();
    if (product == null) {
      Product newProduct = await createProduct(
          product: Product()
            ..branchId = branchId
            ..draft = true
            ..currentUpdate = true
            ..taxId = "XX"
            ..imageLocal = false
            ..businessId = businessId
            ..name = "Custom Amount"
            ..description = "L"
            ..active = true
            ..hasPicture = false
            ..table = "products"
            ..color = "#e74c3c"
            ..supplierId = "XXX"
            ..categoryId = "XXX"
            ..unit = "kg"
            ..synced = false
            ..createdAt = DateTime.now().toIso8601String());
      // add this newProduct's variant to the RRA DB
      Variant? variant = await isar.variants
          .where()
          .productIdEqualTo(newProduct.id)
          .findFirst();
      if (await ProxyService.isarApi.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant!);
      }
      return variant!;
    } else {
      return await isar.variants
          .where()
          .productIdEqualTo(product.id)
          .findFirst();
    }
  }

  @override
  Stream<Customer?> getCustomer({required String key}) {
    return isar.customers
        .filter()
        .nameEqualTo(key)
        .or()
        .emailEqualTo(key)
        .or()
        .phoneEqualTo(key)
        .build()
        .watch(initialReturn: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<Customer?> getCustomerByOrderId({required int id}) {
    return isar.customers
        .watchObject(id, initialReturn: true)
        .asyncMap((event) => event);
  }

  @override
  Future<Customer?> nGetCustomerByOrderId({required int id}) async {
    return isar.customers.filter().orderIdEqualTo(id).findFirst();
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) {
    return isar.discounts.filter().branchIdEqualTo(branchId).findAll();
  }

  // get list of Business from isar where userId = userId
  // if list is empty then get list from online
  @override
  Future<List<Business>> businesses({required String userId}) async {
    List<Business> businesses =
        await isar.business.filter().userIdEqualTo(userId).findAll();

    return businesses;
  }

  @override
  Future<Business> getOnlineBusiness({required String userId}) async {
    final response =
        await client.get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw NotFoundException(term: "Business not found");
    }

    Business? business = await isar.writeTxn(() {
      return isar.business.get(fromJson(response.body).id!);
    });

    if (business == null) {
      await isar.writeTxn(() async {
        return isar.business.put(fromJson(response.body));
      });
      business = await isar.writeTxn(() {
        return isar.business.filter().userIdEqualTo(userId).findFirst();
      });
    }
    ProxyService.box.write(key: 'businessId', value: business!.id);

    return business;
  }

  @override
  Future<Order?> getOrderById({required int id}) {
    return isar.orders.get(id);
  }

  @override
  Future<OrderItem?> getOrderItem({required int id}) {
    return isar.writeTxn(() {
      return isar.orderItems.get(id);
    });
  }

  @override
  Future<OrderItem?> getOrderItemByVariantId(
      {required int variantId, required int? orderId}) async {
    return isar.orderItems
        .where()
        .variantIdOrderIdEqualTo(variantId, orderId ?? 0)
        .findFirst();
  }

  @override
  Future<Pin?> getPin({required String pin}) async {
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/pin/$pin"));
    if (response.statusCode == 200) {
      return pinFromMap(response.body);
    }
    throw ErrorReadingFromYBServer(term: 'Failed to load pin');
  }

  @override
  Future<IPoint?> getPoints({required int userId}) {
    return isar.writeTxn(() {
      return isar.iPoints.where().userIdEqualTo(userId).findFirst();
    });
  }

  @override
  Future<Product?> getProduct({required int id}) async {
    return isar.writeTxn(() {
      return isar.products.get(id);
    });
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) {
    return isar.writeTxn(() {
      return isar.products.where().barCodeEqualTo(barCode).findFirst();
    });
  }

  @override
  Future<Setting?> getSetting({required int userId}) async {
    return isar.writeTxn(() {
      return isar.settings.where().userIdEqualTo(userId).findFirst();
    });
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required int variantId}) async {
    return await isar.writeTxn(() {
      return isar.stocks
          .where()
          .variantIdBranchIdEqualTo(variantId, branchId)
          .findFirst();
    });
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) async {
    Subscription? local = await isar.writeTxn(() {
      return isar.subscriptions.where().userIdEqualTo(userId).findFirst();
    });
    if (local == null) {
      final response =
          await client.get(Uri.parse("$apihub/v2/api/subscription/$userId"));
      if (response.statusCode == 200) {
        Subscription? sub = Subscription.fromJson(json.decode(response.body));

        await isar.writeTxn(() async {
          isar.subscriptions.put(sub);
        });
        return sub;
      } else {
        return null;
      }
    } else {
      return local;
    }
  }

  @override
  Future<List<Variant>> getVariantByProductId({required int productId}) async {
    return isar.writeTxn(() {
      return isar.variants.where().productIdEqualTo(productId).findAll();
    });
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<Product?> isTempProductExist({required int branchId}) {
    return isar.writeTxn(() {
      return isar.products
          .filter()
          .nameContains("temp")
          // .branchIdEqualTo(branchId)
          .findFirst();
    });
  }

  @override
  Future<Tenant?> isTenant({required String phoneNumber}) {
    // TODO: implement isTenant
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required int branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() async {
    log.i("logging out");
    // delete all business and branches from isar db for
    // potential next business that can log-in to not mix data.
    await isar.writeTxn(() async {
      await isar.business.clear();
      await isar.branchs.clear();
      await isar.iTenants.clear();
      await isar.permissions.clear();
    });
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    loginInfo.isLoggedIn = false;
    loginInfo.needSignUp = false;
    FirebaseAuth.instance.signOut();
    return await Future.value(true);
  }

  @override
  Future<JTenant> saveTenant(String phoneNumber, String name,
      {required Business business, required Branch branch}) async {
    final http.Response response =
        await client.post(Uri.parse("$apihub/v2/api/tenant"),
            body: jsonEncode({
              "phoneNumber": phoneNumber,
              "name": name,
              "businessId": business.id,
              "permissions": [
                {
                  "name": "cashier",
                }
              ],
              "businesses": [business.toJson()],
              "branches": [branch.toJson()]
            }),
            headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      JTenant jTenant = jTenantFromJson(response.body);
      ITenant iTenant = ITenant(
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          phoneNumber: jTenant.phoneNumber);

      isar.writeTxn(() async {
        await isar.business.putAll(jTenant.businesses);
        await isar.branchs.putAll(jTenant.branches);
        await isar.permissions.putAll(jTenant.permissions);
      });
      isar.writeTxn(() async {
        int id = await isar.iTenants.put(iTenant);
        return isar.iTenants.get(id);
      });

      return jTenantFromJson(response.body);
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<List<JTenant>> signup({required Map business}) async {
    final http.Response response = await client.post(
        Uri.parse("$apihub/v2/api/business"),
        body: jsonEncode(business),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        await isar.writeTxn(() async {
          return isar.business.putAll(jTenant.businesses);
        });
        await isar.writeTxn(() async {
          return await isar.branchs.putAll(jTenant.branches);
        });
        await isar.writeTxn(() async {
          return isar.permissions.putAll(jTenant.permissions);
        });
        await isar.writeTxn(() async {
          return isar.iTenants.put(iTenant);
        });
      }
      return jListTenantFromJson(response.body);
    } else {
      throw InternalServerError(term: "internal server error");
    }
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
        value: syncFFromJson(response.body).token,
      );
      ProxyService.box.write(
        key: 'userId',
        value: syncFFromJson(response.body).id.toString(),
      );
      ProxyService.box.write(
        key: 'userPhone',
        value: userPhone,
      );
      if (syncFFromJson(response.body).tenants.isEmpty) {
        throw NotFoundException(term: "Not found");
      }
      await isar.writeTxn(() async {
        return isar.business
            .putAll(syncFFromJson(response.body).tenants.first.businesses);
      });
      await isar.writeTxn(() async {
        return isar.branchs
            .putAll(syncFFromJson(response.body).tenants.first.branches);
      });

      return syncFFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }

  /// when adding a user call this endPoint to create a user first.
  /// then call add this user to tenants of specific business/branch.
  @override
  Future<SyncF> user({required String userPhone}) async {
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
      return syncFFromJson(response.body);
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Error from server");
    } else {
      throw Exception('403 Error');
    }
  }

  @override
  void migrateToSync() {
    // TODO: implement migrateToSync
  }

  @override
  Future<Order?> pendingOrder({required int branchId}) async {
    return isar.writeTxn(() async {
      return isar.orders
          .where()
          .statusBranchIdEqualTo(pendingStatus, branchId)
          .findFirst();
    });
  }

  @override
  Stream<List<Product>> productStreams({required int branchId}) {
    return isar.products
        .where()
        .draftBranchIdEqualTo(false, branchId)
        .build()
        .watch(initialReturn: true);
  }

  @override
  Future<List<Product>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<Profile?> profile({required int businessId}) async {
    return isar.writeTxn(() {
      return isar.profiles.where().businessIdEqualTo(businessId).findFirst();
    });
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    //save discount into isar db
    return isar.writeTxn(() async {
      Discount discount = Discount(
        amount: amount,
        branchId: branchId,
        name: name,
      );
      await isar.discounts.put(discount);
    });
  }

  @override
  Future<int> sendReport({required List<OrderItem> orderItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    String userId = ProxyService.box.read(key: 'userId');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Business? bu = await getBusiness();
    String businessName = bu!.name!;
    var request =
        http.Request('POST', Uri.parse('https://flipper.yegobox.com/pay'));
    request.bodyFields = {
      'amount': amount.toString(),
      'userId': userId,
      'RequestGuid': '00HK-KLJS',
      'paymentType': 'SPENN',
      'itemName': ' N/A',
      'note': ' N/A',
      'createdAt': DateTime.now().toIso8601String(),
      'phoneNumber': '+25' + phoneNumber,
      'message': 'Pay ' + businessName,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String body = await response.stream.bytesToString();

    return spennFromJson(body);
  }

  @override
  Future<Stock?> stockByVariantId({required int variantId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return await isar.stocks
        .where()
        .variantIdBranchIdEqualTo(variantId, branchId)
        .findFirst();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required int variantId}) {
    return isar.stocks
        .where()
        .variantIdBranchIdEqualTo(variantId, ProxyService.box.getBranchId()!)
        .watch(initialReturn: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<List<Stock?>> stocks({required int productId}) async {
    return isar.writeTxn(() {
      return isar.stocks.where().productIdEqualTo(productId).findAll();
    });
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
      {required Product product,
      required Variant variant,
      required Stock stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Order>> tickets() async {
    return isar.writeTxn(() {
      return isar.orders
          .where()
          .statusBranchIdEqualTo(parkedStatus, ProxyService.box.getBranchId()!)
          .build()
          .findAll();
    });
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return isar.writeTxn(() {
      return isar.iUnits.where().branchIdEqualTo(branchId).findAll();
    });
  }

  /// @Deprecated [endpoint] don't give the endpoint params
  @override
  Future<int> update<T>({required T data, String? endPoint}) async {
    if (data is Product) {
      final product = data;
      await isar.writeTxn(() async {
        return await isar.products.put(product);
      });
    }
    if (data is Variant) {
      final variant = data;
      await isar.writeTxn(() async {
        return await isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      final stock = data;
      await isar.writeTxn(() async {
        return await isar.stocks.put(stock);
      });
    }
    if (data is Order) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.orders.put(order);
      });
    }
    if (data is Category) {
      final order = data;
      await isar.writeTxn(() async {
        return await isar.categorys.put(order);
      });
    }
    if (data is IUnit) {
      final unit = data;
      await isar.writeTxn(() async {
        return await isar.iUnits.put(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      await isar.writeTxn(() async {
        return await isar.pColors.put(color);
      });
    }
    if (data is OrderItem) {
      await isar.writeTxn(() async {
        return await isar.orderItems.put(data);
      });
    }
    if (data is Ebm) {
      final ebm = data;
      await isar.writeTxn(() async {
        ProxyService.box.write(key: "serverUrl", value: ebm.taxServerUrl);
        Business? business =
            await isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        return await isar.business.put(business!);
      });
    }
    if (data is Token) {
      final token = data;
      await isar.writeTxn(() async {
        Token? ttoken =
            await isar.tokens.where().userIdEqualTo(token.userId).findFirst();
        if (ttoken == null) {
          ttoken = Token()
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        } else {
          ttoken
            ..token = token.token
            ..userId = token.userId
            ..type = token.type;
          return await isar.tokens.put(ttoken);
        }
      });
    }
    if (data is Business) {
      final business = data;
      await isar.writeTxn(() async {
        return await isar.business.put(business);
      });
      final response = await client.patch(
          Uri.parse("$apihub/v2/api/business/${business.id}"),
          body: jsonEncode(business.toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the business");
      }
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
      final response = await client.patch(
          Uri.parse("$apihub/v2/api/branch/${data.id}"),
          body: jsonEncode(data.toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the branch");
      }
    }
    if (data is Counter) {
      await isar.writeTxn(() async {
        return isar.counters.put(data..backed = false);
      });
      final response = await client.patch(
          Uri.parse("$apihub/v2/api/counter/${data.id}"),
          body: jsonEncode(data.toJson()),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        JCounter jCounter = jSingleCounterFromJson(response.body);
        await isar.writeTxn(() async {
          return isar.counters.put(data
            ..branchId = jCounter.branchId
            ..businessId = jCounter.businessId
            ..receiptType = jCounter.receiptType
            ..id = data.id
            ..backed = true
            ..totRcptNo = jCounter.totRcptNo
            ..curRcptNo = jCounter.curRcptNo);
        });
      } else {
        throw InternalServerError(term: "error patching the counter");
      }
    }
    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
      try {
        await client.patch(Uri.parse("$apihub/v2/api/branch/${data.id}"),
            body: jsonEncode(data.toJson()),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        log.e(e);
      }
    }
    if (data is Drawers) {
      final drawer = data;
      await isar.writeTxn(() async {
        return await isar.drawers.put(drawer);
      });
    }
    return 1;
  }

  @override
  Future<Profile?> updateProfile({required Profile profile}) async {
    //TODOcheck if the profile is propery updated.
    return isar.writeTxn(() async {
      int id = await isar.profiles.put(profile);
      return isar.profiles.get(id);
    });
  }

  @override
  Future<int> userNameAvailable({required String name}) async {
    log.d("$apihub/search?name=$name");
    final response = await client.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  Stream<List<Business>> users() {
    // TODO: implement users
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({required int variantId}) async {
    return await isar.variants.get(variantId);
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, required int productId}) async {
    return isar.variants.where().productIdEqualTo(productId).findAll();
  }

  List<DateTime> getWeeksForRange(DateTime start, DateTime end) {
    var result = [];
    var date = start;
    List<DateTime> week = [];

    while (date.difference(end).inDays <= 0) {
      // start new week on Monday
      if (date.weekday == 1 && week.isNotEmpty) {
        result.add(week);
      }

      week.add(date);
      date = date.add(const Duration(days: 1));
    }
    return week;
  }

  @override
  Future<List<Order>> weeklyOrdersReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) {
    // throw UnimplementedError();
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<Order> pastOrders = [];
    return isar.writeTxn(() {
      for (DateTime date in weekDates) {
        List<Order> orders = isar.orders
            .where()
            .branchIdEqualTo(branchId)
            .findAllSync()
            .where((order) =>
                DateTime.parse(order.createdAt).difference(date).inDays >= -7)
            .toList();
        if (orders.isNotEmpty) {
          for (var i = 0; i < orders.length; i++) {
            //is orders[i] does not exist in pastOrders then we add it in the list
            pastOrders.add(orders[i]);
          }
        }
      }
      Map<String, Order> mp = {};
      for (var item in pastOrders) {
        mp[item.orderNumber] = item;
      }
      return Future.value(mp.values.toList());
    });
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) {
    return isar.writeTxn(() async {
      return await isar.products.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    // get all categories from isar db
    return isar.writeTxn(() async {
      return isar.categorys.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Stream<List<Category>> categoriesStream({required int branchId}) {
    return isar.categorys
        .where()
        .branchIdEqualTo(branchId)
        .watch(initialReturn: true);
  }

  @override
  Future<List<OrderItem>> orderItems({required int orderId}) async {
    return isar.writeTxn(() async {
      return await isar.orderItems.where().orderIdEqualTo(orderId).findAll();
    });
  }

  @override
  Future<Variant?> getVariantById({required int id}) async {
    return isar.writeTxn(() async {
      return await isar.variants.get(id);
    });
  }

  @override
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required Order order,
      required String qrCode,
      required Counter counter,
      required String receiptType}) {
    return isar.writeTxn(() async {
      Receipt receipt = Receipt()
        ..resultCd = signature.resultCd
        ..resultMsg = signature.resultMsg
        ..rcptNo = signature.data.rcptNo
        ..intrlData = signature.data.intrlData
        ..rcptSign = signature.data.rcptSign
        ..qrCode = qrCode
        ..receiptType = receiptType
        ..vsdcRcptPbctDate = signature.data.vsdcRcptPbctDate
        ..sdcId = signature.data.sdcId
        ..totRcptNo = signature.data.totRcptNo
        ..mrcNo = signature.data.mrcNo
        ..orderId = order.id
        ..resultDt = signature.resultDt;
      int id = await isar.receipts.put(receipt);
      // get receipt from isar db
      return isar.receipts.get(id);
    });
  }

  @override
  Future<Receipt?> getReceipt({required int orderId}) {
    return isar.writeTxn(() async {
      return await isar.receipts.where().orderIdEqualTo(orderId).findFirst();
    });
  }

  @override
  Future<void> refund({required int itemId}) async {
    return isar.writeTxn(() async {
      OrderItem? item = await isar.orderItems.get(itemId);
      item!.isRefunded = true;
      await isar.orderItems.put(item);
    });
  }

  @override
  Future<Drawers?> isDrawerOpen({required int cashierId}) {
    return isar.writeTxn(() async {
      Drawers? drawer = await isar.drawers
          .where()
          .openCashierIdEqualTo(true, cashierId)
          .findFirst();
      return drawer;
    });
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) {
    // save drawer object in isar db
    return isar.writeTxn(() async {
      int id = await isar.drawers.put(drawer);
      return isar.drawers.get(id);
    });
  }

  @override
  Future<int> size<T>({required T object}) async {
    if (object is Product) {
      return isar.products.getSize(includeIndexes: true, includeLinks: true);
    }
    if (object is Counter) {
      return isar.counters.getSize(includeIndexes: true, includeLinks: true);
    }
    return 0;
  }

  @override
  Future<List<ITenant>> tenants({required int businessId}) async {
    return await isar.iTenants.filter().businessIdEqualTo(businessId).findAll();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            businessId: jTenant.businessId,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        isar.writeTxn(() async {
          await isar.business.putAll(jTenant.businesses);
          await isar.branchs.putAll(jTenant.branches);
          await isar.permissions.putAll(jTenant.permissions);
        });
        isar.writeTxn(() async {
          await isar.iTenants.put(iTenant);
        });
      }
      return await isar.iTenants
          .filter()
          .businessIdEqualTo(businessId)
          .findAll();
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Branch?> defaultBranch() async {
    return await isar.branchs.filter().isDefaultEqualTo(true).findFirst();
  }

  @override
  Future<Business?> defaultBusiness() async {
    return await isar.business.filter().isDefaultEqualTo(true).findFirst();
  }

  @override
  Future<Counter?> cSCounter({required int branchId}) async {
    return await isar.counters
        .filter()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.cs)
        .findFirst();
  }

  @override
  Future<Counter?> nRSCounter({required int branchId}) async {
    return await isar.counters
        .filter()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.nr)
        .findFirst();
  }

  @override
  Future<Counter?> nSCounter({required int branchId}) async {
    return await isar.counters
        .filter()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ns)
        .findFirst();
  }

  @override
  Future<Counter?> pSCounter({required int branchId}) async {
    return await isar.counters
        .filter()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ps)
        .findFirst();
  }

  @override
  Future<Counter?> tSCounter({required int branchId}) async {
    return await isar.counters
        .filter()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ts)
        .findFirst();
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/counter/$businessId"));
    if (response.statusCode == 200) {
      List<JCounter> counters = jCounterFromJson(response.body);
      for (JCounter jCounter in counters) {
        await isar.writeTxn(() async {
          return isar.counters.put(Counter()
            ..branchId = jCounter.branchId
            ..businessId = jCounter.businessId
            ..receiptType = jCounter.receiptType
            ..id = jCounter.id
            ..backed = true
            ..totRcptNo = jCounter.totRcptNo
            ..curRcptNo = jCounter.curRcptNo);
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  Future<List<Counter>> unSyncedCounters({required int branchId}) {
    return isar.writeTxn(() async {
      return isar.counters.filter().backedEqualTo(false).findAll();
    });
  }

  @override
  String dbPath() {
    return isar.path!;
  }

  @override
  Future<Token?> whatsAppToken() {
    return isar.tokens.filter().typeEqualTo('whatsapp').findFirst();
  }
}
