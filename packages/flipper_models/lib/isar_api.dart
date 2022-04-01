import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/isar/product.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:http/http.dart' as http;

late Isar isar;

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
  String apihub = "https://apihub.yegobox.com";
  static getDir({required String dbName}) async {
    isar = isar = await Isar.open(
      directory: dbName,
      schemas: [
        OrderFSyncSchema,
        BusinessSyncSchema,
        BranchSyncSchema,
        BusinessSchema,
        OrderItemSyncSchema,
        ProductSchema,
        ProductSyncSchema,
        VariantSyncSchema,
        ProfileSchema,
        SubscriptionSchema,
        PointsSchema,
        StockSyncSchema,
        FeatureSchema,
        VoucherSchema,
        PColorSchema,
        CategorySchema,
        UnitSchema,
        SettingSchema,
        DiscountSyncSchema,
      ],
      inspector: false,
    );
  }

  IsarAPI({String? dbName, Directory? dir}) {
    if (dbName != null) {
      getDir(dbName: dbName);
      log.d('dbName: $dbName');
    }
  }

  @override
  Future<CustomerSync?> addCustomer(
      {required Map customer, required int orderId}) async {
    int branchId = ProxyService.box.read(key: 'branchId');
    CustomerSync kCustomer = CustomerSync(
      name: customer['name'],
      branchId: branchId,
      email: customer['email'],
      phone: customer['phone'],
      address: customer['address'] ?? '',
      orderId: orderId,
    );
    return await isar.writeTxn((isar) async {
      int id = await isar.customerSyncs.put(kCustomer);
      return await isar.customerSyncs.get(id);
    });
  }

  Future<OrderFSync?> pendingOrderExist({required int branchId}) async {
    return isar.writeTxn((isar) async {
      return isar.orderFSyncs
          .filter()
          .branchIdEqualTo(branchId)
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
    final ref = const Uuid().v1().substring(0, 8);

    final String orderNumber = const Uuid().v1().substring(0, 8);

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
      final order = OrderFSync()
        ..reference = ref
        ..orderNumber = orderNumber
        ..status = 'pending'
        ..orderType = orderType
        ..active = true
        ..draft = true
        ..subTotal = customAmount
        ..cashReceived = customAmount
        ..updatedAt = DateTime.now().toIso8601String()
        ..customerChangeDue = 0.0
        ..paymentType = 'Cash'
        ..branchId = branchId
        ..createdAt = DateTime.now().toIso8601String();
      // save order to db
      OrderFSync? createdOrder = await isar.writeTxn((isar) async {
        int id = await isar.orderFSyncs.put(order, saveLinks: true);
        return isar.orderFSyncs.get(id);
      });
      // get stock by variation.id
      StockSync stock = isar.stockSyncs
          .filter()
          .variantIdEqualTo(variation.id)
          .findFirstSync()!;

      createdOrder!.orderItems.add(OrderItemSync()
        ..count = price
        ..count = quantity
        ..name = name
        ..discount = 0.0
        ..reported = false
        ..variantId = variation.id
        ..price = price
        ..orderId = createdOrder.id
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String()
        ..remainingStock = stock.currentStock - quantity.toInt());
      await isar.writeTxn((isar) async {
        return createdOrder.orderItems.save();
      });
      return createdOrder;
    } else {
      // get StockSync by variation.id
      StockSync? stock = await isar.writeTxn((isar) async {
        return isar.stockSyncs
            .filter()
            .variantIdEqualTo(variation.id)
            .findFirst();
      });

      existOrder.orderItems.add(OrderItemSync()
        ..count = quantity
        ..name = name
        ..variantId = variation.id
        ..price = price
        ..orderId = existOrder.id
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String()
        ..remainingStock = stock!.currentStock - quantity.toInt());
      // update order
      await isar.writeTxn((isar) async {
        return existOrder.orderItems.save();
      });
      return existOrder;
    }
  }

  @override
  Future<void> addOrderItem(
      {required OrderFSync order, required OrderItemSync item}) async {
    order.orderItems.add(item);
    return isar.writeTxn((isar) async {
      return order.orderItems.save();
    });
  }

  // get point where userId = userId from db
  @override
  Points addPoint({required int userId, required int point}) {
    return isar.pointss.filter().userIdEqualTo(userId).findFirstSync()!;
  }

  @override
  Future<int> addUnits<T>({required T data}) async {
    await isar.writeTxn((isar) async {
      Unit units = data as Unit;
      for (Map map in units.units!) {
        final unit = Unit()
          ..active = false
          ..value = units.value
          ..name = map['name']
          ..branchId = units.branchId;
        // save unit to db
        await isar.units.put(unit);
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
    Subscription? sub = await isar.writeTxn((isar) async {
      int id = await isar.subscriptions.put(subscription!);
      return isar.subscriptions.get(id);
    });
    for (var feature in features) {
      sub!.features.value = feature;
    }
    // update sub to db
    return isar.writeTxn((isar) async {
      int id = await isar.subscriptions.put(sub!);
      return isar.subscriptions.get(id);
    });
  }

  @override
  Future<int> addVariant(
      {required List<VariantSync> data,
      required double retailPrice,
      required double supplyPrice}) async {
    await isar.writeTxn((isar) async {
      for (VariantSync variation in data) {
        // save variation to db
        int variantId = await isar.variantSyncs.put(variation);
        final stockId = DateTime.now().millisecondsSinceEpoch;
        final stock = StockSync()
          ..id = stockId
          ..variantId = variantId
          ..lowStock = 0.0
          ..currentStock = 0.0
          ..supplyPrice = supplyPrice
          ..retailPrice = retailPrice
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..productId = variation.productId
          ..value = 0
          ..active = false;
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
          final b = BranchSync()
            ..active = branch.active
            ..id = branch.id
            ..description = branch.description
            ..latitude = branch.latitude.toString()
            ..name = branch.name
            ..table = 'banches'
            ..longitude = branch.longitude.toString()
            ..description = branch.description
            ..fbusinessId = branch.fbusinessId;

          await isar.branchSyncs.put(b);
        }
      });
      // return all branches from db
      /// right now the the branch business Id is empty return here id is in this range
      /// instead, will fix later.
      List<BranchSync> bb =
          await isar.branchSyncs.filter().tableEqualTo('banches').findAll();

      return bb;
    }
    throw Exception('Failed to load branch');
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
    return isar.pColors.filter().branchIdEqualTo(branchId).findAll();
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
      isar.writeTxn((isar) async {
        for (String co in data.colors!) {
          int id = await isar.pColors.put(PColor()
            ..name = co
            ..active = color.active
            ..branchId = color.branchId);

          return await isar.pColors.get(id);
        }
      });
    }
    if (endPoint == 'category') {
      Category category = data as Category;
      isar.writeTxn((isar) {
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
  Future<ProductSync> createProduct({required ProductSync product}) async {
    product.active = false;
    product.id = DateTime.now().microsecondsSinceEpoch;
    product.description = 'description';
    product.color = '#5A2328';
    product.hasPicture = false;
    product.businessId = ProxyService.box.getBusinessId()!;
    product.branchId = ProxyService.box.getBranchId()!;

    final int branchId = ProxyService.box.getBranchId()!;

    ProductSync? kProduct = await isar.writeTxn((isar) async {
      int id = await isar.productSyncs.put(product, saveLinks: true);
      return isar.productSyncs.get(id);
    });
    int idd = kProduct!.id;
    log.i("product:$idd");
    // save variants in isar Db with the above productId
    kProduct.variants.add(VariantSync()
      ..name = 'Regular'
      ..sku = 'sku'
      ..productId = kProduct.id
      ..unit = 'Per Item'
      ..table = 'variants'
      ..productName = product.name
      ..branchId = branchId
      ..taxName = 'N/A'
      ..taxPercentage = 0
      ..retailPrice = 0
      ..supplyPrice = 0.0);
    await isar.writeTxn((isar) async {
      return await kProduct.variants.save();
    });
    VariantSync? variant = await isar.writeTxn((isar) async {
      return isar.variantSyncs
          .filter()
          .productIdEqualTo(kProduct.id)
          .findFirst();
    });
    int vaa = variant!.id;
    log.i("variantID:$vaa");
    StockSync stock = StockSync()
      ..canTrackingStock = false
      ..showLowStockAlert = false
      ..currentStock = 0.0
      ..branchId = branchId
      ..variantId = variant.id
      ..supplyPrice = 0.0
      ..retailPrice = 0.0
      ..lowStock = 10.0
      ..canTrackingStock = true
      ..showLowStockAlert = true
      ..value = 300.0
      ..active = false
      ..productId = kProduct.id;

    await isar.writeTxn((isar) async {
      return isar.stockSyncs.put(stock);
    });
    return kProduct;
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
        isar.writeTxn((isar) async {
          await isar.pColors.delete(id);
          return true;
        });
        break;
      case 'category':
        isar.writeTxn((isar) async {
          await isar.categorys.delete(id);
          return true;
        });
        break;
      case 'product':
        isar.writeTxn((isar) async {
          await isar.productSyncs.delete(id);
          return true;
        });
        break;
      case 'variant':
        isar.writeTxn((isar) async {
          await isar.variantSyncs.delete(id);
          return true;
        });
        break;
      case 'stock':
        isar.writeTxn((isar) async {
          await isar.stockSyncs.delete(id);
          return true;
        });
        break;
      case 'setting':
        isar.writeTxn((isar) async {
          await isar.settings.delete(id);
          return true;
        });
        break;
      case 'pin':
        isar.writeTxn((isar) async {
          await isar.pins.delete(id);
          return true;
        });
        break;
      case 'business':
        isar.writeTxn((isar) async {
          await isar.businessSyncs.delete(id);
          return true;
        });
        break;
      case 'branch':
        isar.writeTxn((isar) async {
          await isar.branchSyncs.delete(id);
          return true;
        });
        break;

      case 'voucher':
        isar.writeTxn((isar) async {
          await isar.vouchers.delete(id);
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

    BusinessSync? business = await isar.writeTxn((isar) {
      return isar.businessSyncs.get(businessId);
    });
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
    return isar.writeTxn((isar) {
      return isar.businesss.filter().userIdEqualTo(userId!).findFirst();
    });
  }

  @override
  Business getBusinessById({required int id}) {
    // TODO: implement getBusinessById
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = await isar.writeTxn((isar) {
      return isar.businesss.filter().idEqualTo(id).findFirst();
    });
    if (business != null) return business;
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      Business business = Business.fromJson(json.decode(response.body));
      return isar.writeTxn((isar) async {
        int id = await isar.businesss.put(business);
        return isar.businesss.get(id);
      });
    }
    return null;
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) async {
    return isar.writeTxn((isar) async {
      return isar.pColors.getSync(id);
    });
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<VariantSync?> getCustomProductVariant() async {
    // throw UnimplementedError();
    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    ProductSync? product = await isar.writeTxn((isar) {
      return isar.productSyncs
          .filter()
          .nameEqualTo('Custom Amount')
          .findFirst();
    });
    if (product == null) {
      ProductSync p = await buildProductObject(branchId, businessId);
      return isar.writeTxn((isar) async {
        return isar.variantSyncs.filter().productIdEqualTo(p.id).findFirst();
      });
    } else {
      return isar.writeTxn((isar) async {
        return isar.variantSyncs
            .filter()
            .productIdEqualTo(product.id)
            .findFirst();
      });
    }
  }

  Future<ProductSync> buildProductObject(int branchId, int businessId) async {
    return await createProduct(
        product: ProductSync()
          ..branchId = branchId
          ..draft = true
          ..currentUpdate = true
          ..taxId = "XX"
          ..imageLocal = false
          ..businessId = businessId
          ..name = "temp"
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
  }

  @override
  Stream<CustomerSync?> getCustomer({required String key}) {
    return isar.customerSyncs
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
  Stream<CustomerSync?> getCustomerByOrderId({required int id}) {
    return isar.customerSyncs
        .filter()
        .idEqualTo(id)
        .build()
        .watch(initialReturn: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<List<DiscountSync>> getDiscounts({required int branchId}) {
    return isar.writeTxn((isar) async {
      return isar.discountSyncs.filter().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<List<BranchSync>> getLocalBranches({required int businessId}) async {
    // clean all branches from db
    // get all branch from isar db
    List<BranchSync> kBranches =
        await isar.branchSyncs.filter().tableEqualTo('banches').findAll();
    if (kBranches.isEmpty) {
      return await branches(businessId: businessId);
    }
    return kBranches;
  }

  // get list of Business from isar where userId = userId
  // if list is empty then get list from online
  @override
  Future<Business> getLocalOrOnlineBusiness({required String userId}) async {
    Business? kBusiness =
        await isar.businesss.filter().userIdEqualTo(userId).findFirst();
    if (kBusiness == null) {
      log.e("fetching business from server");
      return await getOnlineBusiness(userId: userId);
    }
    return kBusiness;
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

    Business? business = await isar.writeTxn((isar) {
      return isar.businesss.get(fromJson(response.body).id);
    });
    if (business == null) {
      await isar.writeTxn((isar) async {
        return isar.businesss.put(fromJson(response.body));
      });
      business = await isar.writeTxn((isar) {
        return isar.businesss.filter().userIdEqualTo(userId).findFirst();
      });
      return business!;
    } else {
      return business;
    }
  }

  @override
  Future<OrderFSync?> getOrderById({required int id}) {
    return isar.writeTxn((isar) async {
      return isar.orderFSyncs.get(id);
    });
  }

  @override
  Future<List<OrderFSync>> getOrderByStatus({required String status}) {
    return isar.writeTxn((isar) async {
      return isar.orderFSyncs.filter().statusEqualTo(status).findAll();
    });
  }

  @override
  Future<OrderItemSync?> getOrderItem({required int id}) {
    return isar.writeTxn((isar) {
      return isar.orderItemSyncs.get(id);
    });
  }

  @override
  Future<OrderItemSync?> getOrderItemByVariantId(
      {required int variantId, required int orderId}) async {
    return await isar.writeTxn((isar) {
      return isar.orderItemSyncs
          .filter()
          .variantIdEqualTo(variantId)
          .orderIdEqualTo(orderId)
          .findFirst();
    });
  }

  @override
  Future<Pin?> getPin({required String pin}) async {
    final http.Response response =
        await client.get(Uri.parse("$apihub/v2/api/pin/$pin"));
    if (response.statusCode == 200) {
      return pinFromMap(response.body);
    }
    throw Exception('Failed to load pin');
  }

  @override
  Future<Points?> getPoints({required int userId}) {
    return isar.writeTxn((isar) {
      return isar.pointss.filter().userIdEqualTo(userId).findFirst();
    });
  }

  @override
  Future<ProductSync?> getProduct({required int id}) async {
    return isar.writeTxn((isar) {
      return isar.productSyncs.get(id);
    });
  }

  @override
  Future<ProductSync?> getProductByBarCode({required String barCode}) {
    return isar.writeTxn((isar) {
      return isar.productSyncs.filter().barCodeEqualTo(barCode).findFirst();
    });
  }

  @override
  Future<Setting?> getSetting({required int userId}) async {
    return isar.writeTxn((isar) {
      return isar.settings.filter().userIdEqualTo(userId).findFirst();
    });
  }

  @override
  Future<StockSync?> getStock(
      {required int branchId, required int variantId}) async {
    return await isar.writeTxn((isar) {
      return isar.stockSyncs
          .filter()
          .branchIdEqualTo(branchId)
          .variantIdEqualTo(variantId)
          .findFirst();
    });
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) async {
    Subscription? local = await isar.writeTxn((isar) {
      return isar.subscriptions.filter().userIdEqualTo(userId).findFirst();
    });
    if (local == null) {
      final response =
          await client.get(Uri.parse("$apihub/v2/api/subscription/$userId"));
      if (response.statusCode == 200) {
        Subscription? sub = Subscription.fromJson(json.decode(response.body));

        await isar.writeTxn((isar) async {
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
  Future<List<VariantSync>> getVariantByProductId(
      {required int productId}) async {
    return isar.writeTxn((isar) {
      return isar.variantSyncs.filter().productIdEqualTo(productId).findAll();
    });
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<ProductSync?> isTempProductExist({required int branchId}) {
    return isar.writeTxn((isar) {
      return isar.productSyncs.filter().branchIdEqualTo(branchId).findFirst();
    });
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
  Future<bool> logOut() async {
    log.i("logging out");

    /// delete all business and branches from isar db for
    /// potential next business that can log-in to not mix data.
    await isar.writeTxn((isar) async {
      // delete all business
      await isar.businessSyncs.clear();
      await isar.businesss.clear();
      // delete all branches.
      await isar.branchSyncs.clear();
    });
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    loginInfo.isLoggedIn = false;
    FirebaseAuth.instance.signOut();
    return await Future.value(true);
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
  Future<OrderFSync?> order({required int branchId}) async {
    return isar.writeTxn((isar) async {
      return isar.orderFSyncs
          .filter()
          .statusEqualTo('pending')
          .branchIdEqualTo(branchId)
          .findFirst();
    });
  }

  @override
  Future<List<OrderFSync>> orders({required int branchId}) {
    return isar.orderFSyncs
        .filter()
        .branchIdEqualTo(branchId)
        .statusEqualTo('pending')
        .findAll();
  }

  @override
  Stream<List<ProductSync>> productStreams({required int branchId}) {
    return isar.productSyncs
        .filter()
        .branchIdEqualTo(branchId)
        .draftEqualTo(false)
        .build()
        .watch(initialReturn: true);
  }

  @override
  Future<List<ProductSync>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<Profile?> profile({required int businessId}) async {
    return isar.writeTxn((isar) {
      return isar.profiles.filter().businessIdEqualTo(businessId).findFirst();
    });
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
  Future<StockSync?> stockByVariantId({required int variantId}) async {
    // get stock where variantId = variantId from isar db
    return isar.writeTxn((isar) async {
      return isar.stockSyncs
          .filter()
          .variantIdEqualTo(variantId)
          .build()
          .findFirst();
    });
  }

  @override
  Stream<StockSync> stockByVariantIdStream({required int variantId}) {
    return isar.stockSyncs
        .filter()
        .variantIdEqualTo(variantId)
        .build()
        .watch(initialReturn: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<List<StockSync?>> stocks({required int productId}) async {
    return isar.writeTxn((isar) {
      return isar.stockSyncs
          .filter()
          .productIdEqualTo(productId)
          .build()
          .findAll();
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
      {required ProductSync product,
      required VariantSync variant,
      required StockSync stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<OrderFSync>> tickets() async {
    return isar.writeTxn((isar) {
      return isar.orderFSyncs
          .filter()
          .statusEqualTo(pendingStatus)
          .build()
          .findAll();
    });
  }

  @override
  Future<List<Unit>> units({required int branchId}) async {
    return isar.writeTxn((isar) {
      return isar.units.filter().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<int> update<T>({required T data, String? endPoint}) async {
    if (data is ProductSync) {
      final product = data;
      await isar.writeTxn((isar) async {
        return await isar.productSyncs.put(product, saveLinks: true);
      });
    }
    if (data is VariantSync) {
      final variant = data;
      await isar.writeTxn((isar) async {
        return await isar.variantSyncs.put(variant, saveLinks: true);
      });
    }
    if (data is StockSync) {
      final stock = data;
      await isar.writeTxn((isar) async {
        return await isar.stockSyncs.put(stock, saveLinks: true);
      });
    }
    if (data is OrderFSync) {
      final order = data;
      await isar.writeTxn((isar) async {
        return await isar.orderFSyncs.put(order, saveLinks: true);
      });
    }
    if (data is Category) {
      final order = data;
      await isar.writeTxn((isar) async {
        return await isar.categorys.put(order, saveLinks: true);
      });
    }
    if (data is Unit) {
      final unit = data;
      await isar.writeTxn((isar) async {
        return await isar.units.put(unit, saveLinks: true);
      });
    }
    if (data is OrderItemSync) {
      final orderItem = data;
      // find this related order
      OrderFSync? order = await isar.writeTxn((isar) async {
        return await isar.orderFSyncs
            .filter()
            .idEqualTo(orderItem.orderId)
            .build()
            .findFirst();
      });
      order!.orderItems.add(data);
      await isar.writeTxn((isar) async {
        return order.orderItems.save();
      });
    }
    return 1;
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
  Future<Profile?> updateProfile({required Profile profile}) async {
    //TODOcheck if the profile is propery updated.
    return isar.writeTxn((isar) async {
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
  Future<VariantSync?> variant({required int variantId}) async {
    return await isar.writeTxn((isar) async {
      return await isar.variantSyncs
          .filter()
          .idEqualTo(variantId)
          .build()
          .findFirst();
    });
  }

  @override
  Future<List<VariantSync>> variants(
      {required int branchId, required int productId}) async {
    // get variants where branchId and productId from isar db
    return await isar.writeTxn((isar) async {
      // get variants where branchId and productId from isar db
      return await isar.variantSyncs
          .filter()
          .branchIdEqualTo(branchId)
          .productIdEqualTo(productId)
          .build()
          .findAll();
    });
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
  Future<List<OrderFSync>> weeklyOrdersReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) {
    // throw UnimplementedError();
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<OrderFSync> pastOrders = [];
    return isar.writeTxn((isar) {
      for (DateTime date in weekDates) {
        List<OrderFSync> orders = isar.orderFSyncs
            .filter()
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
      Map<String, OrderFSync> mp = {};
      for (var item in pastOrders) {
        mp[item.orderNumber] = item;
      }
      return Future.value(mp.values.toList());
    });
  }

  @override
  Future<List<ProductSync>> productsFuture({required int branchId}) {
    return isar.writeTxn((isar) async {
      return await isar.productSyncs
          .filter()
          .branchIdEqualTo(branchId)
          .build()
          .findAll();
    });
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    // get all categories from isar db
    return isar.categorys.filter().branchIdEqualTo(branchId).findAll();
  }

  @override
  Stream<List<Category>> categoriesStream({required int branchId}) {
    return isar.categorys
        .filter()
        .branchIdEqualTo(branchId)
        .build()
        .watch(initialReturn: true);
  }
}
