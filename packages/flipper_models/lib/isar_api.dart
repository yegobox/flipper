import 'dart:async';
import 'package:intl/intl.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/data.loads/jcounter.dart';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/socials_http_client.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/foundation.dart' as foundation;

import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'flipper_http_client.dart';
import 'package:flipper_routing/receipt_types.dart';

final isAndroid = UniversalPlatform.isAndroid;

class IsarAPI<M> implements IsarApiInterface {
  FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());
  SocialsHttpClient socialsHttpClient = SocialsHttpClient(http.Client());
  late String apihub;
  late String commApi;
  late Isar isar;
  Future<IsarApiInterface> getInstance({Isar? iisar}) async {
    final dir = await getApplicationDocumentsDirectory();
    if (foundation.kDebugMode && !isAndroid) {
      apihub = "https://uat-apihub.yegobox.com";
      commApi = "https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api";
    } else if (foundation.kDebugMode && isAndroid) {
      // apihub = "http://10.0.2.2:8083";
      apihub = "https://uat-apihub.yegobox.com";
      commApi = "https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api";
    } else if (!foundation.kDebugMode) {
      apihub = "https://apihub.yegobox.com";
      commApi = "https://ers84w6ehl.execute-api.us-east-1.amazonaws.com/api";
    }
    if (iisar == null) {
      isar = await Isar.open(
        // compactOnLaunch:
        // CompactCondition(minBytes: 100, minFileSize: 100, minRatio: 2.0),
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
          TokenSchema,
          SocialSchema,
          ConversationSchema,
          DeviceSchema,
          FavoriteSchema
        ],
        directory: dir.path,
      );
    } else {
      isar = iisar;
    }
    return this;
  }

  @override
  Future<Customer?> addCustomer(
      {required Map customer, required int orderId}) async {
    int branchId = ProxyService.box.getBranchId()!;
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
  Stream<Order?> pendingOrderStream() {
    int? currentOrderId = ProxyService.box.currentOrderId();
    return isar.orders.watchObject(currentOrderId ?? 0, fireImmediately: true);
  }

  @override
  Future<Order> manageOrder({
    String orderType = 'custom',
  }) async {
    int branchId = ProxyService.box.getBranchId()!;

    Order? existOrder = await pendingOrder(branchId: branchId);

    if (existOrder == null) {
      final order = Order(
        id: syncIdInt(),
        reference: syncId(),
        orderNumber: syncId(),
        draft: true,
        status: pendingStatus,
        orderType: orderType,
        active: true,
        reported: false,
        subTotal: 0,
        cashReceived: 0,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0,
        paymentType: 'Cash',
        branchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );

      // save order to db
      Order? createdOrder = await isar.writeTxn(() async {
        int id = await isar.orders.put(order);
        ProxyService.box.write(key: 'currentOrderId', value: id);
        return await isar.orders.get(id);
      });
      return createdOrder!;
    } else {
      return existOrder;
    }
  }

  @override
  Future<void> addOrderItem(
      {required Order order, required OrderItem item}) async {
    return isar.writeTxn(() async {
      await isar.orderItems.put(item);
    });
  }

  // get point where userId = userId from db
  @override
  IPoint addPoint({required int userId, required int point}) {
    return isar.iPoints.filter().userIdEqualTo(userId).findFirstSync()!;
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    if (data != Null) {
      await isar.writeTxn(() async {
        await isar.favorites.put(data);
      });
      return Future.value(200);
    }
    return Future.value(404);
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    List<Favorite> favorites = await isar.favorites.where().findAll();
    return favorites;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    //Get a favorite
    Favorite? favorite =
        await isar.favorites.filter().idEqualTo(favId).findFirst();
    return favorite;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    //Get a favorite
    Favorite? favorite =
        await isar.favorites.filter().favIndexEqualTo(favIndex).findFirst();
    return favorite;
  }

  //Delete a favorite
  @override
  Future<int> deleteFavorite({required int favId}) async {
    await isar.favorites.delete(favId);
    return Future.value(200);
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
        final stock = Stock(
            branchId: ProxyService.box.getBranchId()!,
            variantId: variantId,
            action: 'create',
            currentStock: 0.0,
            productId: variation.productId)
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
    // if in local db we have no branch fetch it from online
    return await isar.branchs.filter().businessIdEqualTo(businessId).findAll();
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
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/attendance"),
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
    );
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

    List<OrderItem> items = await orderItems(orderId: order.id!);

    double? totalPayable = items.fold(0, (a, b) => a! + (b.price * b.qty));

    order.customerChangeDue = (cashReceived - totalPayable!);

    order.cashReceived = cashReceived;

    await update(data: order);

    for (OrderItem item in items) {
      Stock? stock = await stockByVariantId(variantId: item.variantId);
      stock?.currentStock = stock.currentStock - item.qty;
      stock?.action = actions["update"];
      update(data: stock);
    }
    // remove currentOrderId from local storage to leave a room
    // for listening to new order that will be created
    ProxyService.box.remove(key: 'currentOrderId');
    ProxyService.appService.pushDataToServer();
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
    final http.Response response = await flipperHttpClient.patch(
      Uri.parse("$apihub/v2/api/voucher"),
      body: jsonEncode(
        <String, int>{'id': voucherCode},
      ),
    );
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
  Future<void> createGoogleSheetDoc({required String email}) async {
    // TODOre-work on this until it work 100%;
    Business? business = await getBusiness();
    String docName = business!.name! + '- Report';

    await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/createSheetDocument"),
      body: jsonEncode({"title": docName, "shareToEmail": email}),
    );
  }

  @override
  Future<Pin?> createPin() async {
    String id = ProxyService.box.getUserId()!.toString();
    //get existing pin where userId =1
    // if pin is null then create new pin
    Pin? pin = await isar.pins.filter().userIdEqualTo(id).findFirst();
    if (pin != null) {
      return pin;
    }

    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    String phoneNumber = ProxyService.box.getUserPhone()!;
    int defaultApp = ProxyService.box.getDefaultApp();
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/pin"),
      body: jsonEncode(
        <String, dynamic>{
          'userId': id,
          'branchId': branchId.toString(),
          'businessId': businessId.toString(),
          'phoneNumber': phoneNumber,
          'pin': id,
          'defaultApp': defaultApp
        },
      ),
    );
    if (response.statusCode == 200) {
      Pin pin = pinFromMap(response.body);

      return isar.writeTxn(() async {
        int id = await isar.pins.put(pin);
        return isar.pins.get(id);
      });
    }
    return null;
  }

  Future<Product?> isCustomProductExist({required int businessId}) async {
    return isar.products
        .filter()
        .businessIdEqualTo(businessId)
        .and()
        .nameEqualTo('Custom Amount')
        .build()
        .findFirst();
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    Business? business = await getBusiness();
    String itemPrefix = "flip-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

    product.description = 'description';
    product.color = '#5A2328';
    product.id = syncIdInt();
    product.businessId = ProxyService.box.getBusinessId()!;
    product.branchId = ProxyService.box.getBranchId()!;

    final int branchId = ProxyService.box.getBranchId()!;
    // check if the product created custom amount exist and do not re-create
    if (product.name == "Custom Amount") {
      Product? existingProduct = await isCustomProductExist(
          businessId: ProxyService.box.getBusinessId()!);
      if (existingProduct != null) {
        return existingProduct;
      }
    }
    Product? kProduct = await isar.writeTxn(() async {
      int id = await isar.products.put(product);
      return isar.products.get(id);
    });
    // save variants in isar Db with the above productId
    await isar.writeTxn(() async {
      return await isar.variants.put(
        Variant(
            name: 'Regular',
            sku: 'sku',
            action: 'create',
            productId: kProduct!.id!,
            unit: 'Per Item',
            productName: product.name,
            branchId: ProxyService.box.getBranchId()!,
            supplyPrice: 0.0,
            retailPrice: 0.0,
            id: syncIdInt(),
            isTaxExempted: false)
          ..name = 'Regular'
          ..productId = kProduct.id!
          ..unit = 'Per Item'
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
        await isar.variants.where().productIdEqualTo(kProduct!.id!).findFirst();

    Stock stock = Stock(
        id: syncIdInt(),
        action: 'create',
        branchId: branchId,
        variantId: variant!.id!,
        currentStock: 0.0,
        productId: kProduct.id!)
      ..canTrackingStock = false
      ..showLowStockAlert = false
      ..currentStock = 0.0
      ..branchId = branchId
      ..variantId = variant.id!
      ..supplyPrice = 0.0
      ..retailPrice = 0.0
      ..lowStock = 10.0 // default static
      ..canTrackingStock = true
      ..showLowStockAlert = true
      ..active = false
      ..productId = kProduct.id!
      ..rsdQty = 0.0;

    await isar.writeTxn(() async {
      return await isar.stocks.put(stock);
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
  Future<bool> delete({required int id, String? endPoint}) {
    switch (endPoint) {
      case 'color':
        isar.writeTxn(() async {
          await isar.pColors.delete(id);
          return true;
        });
        break;
      case 'device':
        isar.writeTxn(() async {
          await isar.devices.delete(id);
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
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/createAttendanceDoc"),
      body: jsonEncode({
        "title": business!.name! + '-' + 'Attendance',
        "shareToEmail": email
      }),
    );
    if (response.statusCode == 200) {
      // update settings with enableAttendance = true
      int businessId = ProxyService.box.getBusinessId()!;
      Setting? setting = await getSetting(businessId: businessId);
      setting!.attendnaceDocCreated = true;
      update(data: setting);
      return true;
    }

    return false;
  }

  @override
  Future<Business?> getBusiness() {
    int? userId = ProxyService.box.getUserId();
    return isar.writeTxn(() {
      return isar.business
          .filter()
          .userIdEqualTo(userId?.toString())
          .findFirst();
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
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
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
          product: Product(
              name: "Custom Amount",
              action: 'create',
              businessId: businessId,
              color: "#e74c3c",
              branchId: businessId)
            ..branchId = branchId
            ..taxId = "XX"
            ..businessId = businessId
            ..name = "Custom Amount"
            ..description = "L"
            ..color = "#e74c3c"
            ..supplierId = "XXX"
            ..categoryId = "XXX"
            ..unit = "kg"
            ..createdAt = DateTime.now().toIso8601String());
      // add this newProduct's variant to the RRA DB
      Variant? variant = await isar.variants
          .where()
          .productIdEqualTo(newProduct.id!)
          .findFirst();
      if (await ProxyService.isarApi.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant!);
      }
      return variant!;
    } else {
      Variant? variation =
          await isar.variants.where().productIdEqualTo(product.id!).findFirst();
      // if it happen that this product does not have a custom variant add it
      variation =
          await ifPreConditionOfSellingACustomProductDoesNotMeetAddMissings(
              variation, product, branchId);
      return variation;
    }
  }

  Future<Variant?> ifPreConditionOfSellingACustomProductDoesNotMeetAddMissings(
      Variant? variation, Product product, int branchId) async {
    if (variation == null) {
      // add variant to this product
      Business? business = await getBusiness();
      String clip = 'flipper' +
          DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

      variation = await isar.writeTxn(() async {
        int id = await isar.variants.put(
          Variant(
              name: 'Custom Amount',
              sku: 'sku',
              action: 'create',
              productId: product.id!,
              unit: 'Per Item',
              productName: product.name,
              branchId: ProxyService.box.getBranchId()!,
              supplyPrice: 0.0,
              retailPrice: 0.0,
              id: syncIdInt(),
              isTaxExempted: false)
            ..name = 'Regular'
            ..productId = product.id!
            ..unit = 'Per Item'
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
        return isar.variants.get(id);
      });
      // add its stock
      Stock stock = Stock(
          id: syncIdInt(),
          action: 'create',
          branchId: branchId,
          variantId: variation!.id!,
          currentStock: 0.0,
          productId: product.id!)
        ..canTrackingStock = false
        ..showLowStockAlert = false
        ..currentStock = 0.0
        ..branchId = branchId
        ..variantId = variation.id!
        ..supplyPrice = 0.0
        ..retailPrice = 0.0
        ..lowStock = 10.0 // default static
        ..canTrackingStock = true
        ..showLowStockAlert = true
        ..active = false
        ..productId = product.id!
        ..rsdQty = 0.0;

      await isar.writeTxn(() async {
        return await isar.stocks.put(stock);
      });
    }
    return variation;
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
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<Customer?> getCustomerByOrderId({required int id}) {
    return isar.customers
        .watchObject(id, fireImmediately: true)
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
  Future<List<Business>> businesses({required int userId}) async {
    List<Business> businesses =
        await isar.business.filter().userIdEqualTo(userId.toString()).findAll();

    return businesses;
  }

  @override
  Future<Business> getOnlineBusiness({required String userId}) async {
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw BusinessNotFoundException(term: "Business not found");
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
  Future<Order?> getOrderById({required int id}) async {
    return await isar.orders.get(id);
  }

  @override
  Future<OrderItem?> getOrderItem({required int id}) async {
    return await isar.orderItems.get(id);
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
  Future<List<OrderItem>> getOrderItemsByOrderId(
      {required int? orderId}) async {
    return isar.orderItems.where().orderIdEqualTo(orderId!).findAll();
  }

  @override
  Future<Pin?> getPin({required String pin}) async {
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/pin/$pin"));
    if (response.statusCode == 200) {
      return pinFromMap(response.body);
    }
    if (response.statusCode == 404) {
      return null;
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
    return await isar.products.get(id);
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) {
    return isar.writeTxn(() {
      return isar.products.where().barCodeEqualTo(barCode).findFirst();
    });
  }

  @override
  Future<Setting?> getSetting({required int businessId}) async {
    return isar.writeTxn(() {
      return isar.settings.where().businessIdEqualTo(businessId).findFirst();
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
      final response = await flipperHttpClient
          .get(Uri.parse("$apihub/v2/api/subscription/$userId"));
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
  int lifeTimeCustomersForbranch({required int branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    // delete all business and branches from isar db for
    // potential next business that can log-in to not mix data.
    await isar.writeTxn(() async {
      await isar.business.clear();
      await isar.branchs.clear();
      await isar.iTenants.clear();
      await isar.permissions.clear();
      await isar.pins.clear();
    });
    if (ProxyService.box.getUserId() != null &&
        ProxyService.box.getBusinessId() != null) {
      ProxyService.event.publish(loginDetails: {
        'channel': "${ProxyService.box.getUserId()!}-logout",
        'userId': ProxyService.box.getUserId()!,
        'businessId': ProxyService.box.getBusinessId()!,
        'branchId': ProxyService.box.getBranchId()!,
        'phone': ProxyService.box.getUserPhone(),
        'defaultApp': ProxyService.box.getDefaultApp(),
        'deviceName': Platform.operatingSystem,
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': syncIdInt().toString()
      });
    }

    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'getIsTokenRegistered');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'defaultApp');
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<JTenant> saveTenant(String phoneNumber, String name,
      {required Business business, required Branch branch}) async {
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/tenant"),
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
    );
    if (response.statusCode == 200) {
      JTenant jTenant = jTenantFromJson(response.body);
      ITenant iTenant = ITenant(
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          userId: jTenant.userId,
          nfcEnabled: jTenant.nfcEnabled,
          phoneNumber: jTenant.phoneNumber);

      isar.writeTxn(() async {
        await isar.business.putAll(jTenant.businesses);
        await isar.branchs.putAll(jTenant.branches);
        await isar.permissions.putAll(jTenant.permissions);
      });
      isar.writeTxn(() async {
        await isar.iTenants.put(iTenant);
      });

      return jTenantFromJson(response.body);
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<List<JTenant>> signup({required Map business}) async {
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/business"),
      body: jsonEncode(business),
    );
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
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
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup}) async {
    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body: jsonEncode(
        <String, String>{'phoneNumber': userPhone},
      ),
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      IUser syncF = IUser.fromRawJson(response.body);
      await ProxyService.box.write(
        key: 'userPhone',
        value: userPhone,
      );
      await ProxyService.box.write(
        key: 'bearerToken',
        value: syncF.token,
      );
      await ProxyService.box.write(
        key: 'userId',
        value: syncF.id,
      );
      await ProxyService.box.write(
        key: 'branchId',
        // check if branches is empty
        value: syncF.tenants.isEmpty
            ? null
            : syncF.tenants.first.branches.first.id,
      );
      await ProxyService.box.write(
        key: 'businessId',
        // check if businesses is empty
        value: syncF.tenants.isEmpty
            ? null
            : syncF.tenants.first.businesses.first.id,
      );
      if (skipDefaultAppSetup == false) {
        await ProxyService.box.write(
          key: 'defaultApp',

          /// because we don update default app from server
          /// because we want the ability of switching apps to be entirely offline
          /// then if we have a default app in the box we use it if it only different from 1
          value: syncF.tenants.isEmpty
              ? null
              : ProxyService.box.getDefaultApp() != 1
                  ? ProxyService.box.getDefaultApp()
                  : syncF.tenants.first.businesses.first.businessTypeId,
        );
      }

      if (syncF.tenants.isEmpty) {
        throw BusinessNotFoundException(
            term:
                "No tenant added to the user, if a business is added it should have one tenant");
      }
      for (Tenant tenant in syncF.tenants) {
        ITenant iTenant = ITenant(
            id: tenant.id,
            name: tenant.name,
            businessId: tenant.businessId,
            nfcEnabled: tenant.nfcEnabled,
            email: tenant.email ?? '',
            userId: syncF.id,
            phoneNumber: tenant.phoneNumber);

        await isar.writeTxn(() async {
          return isar.business.putAll(tenant.businesses);
        });
        await isar.writeTxn(() async {
          return isar.branchs.putAll(tenant.branches);
        });
        await isar.writeTxn(() async {
          return isar.permissions.putAll(tenant.permissions);
        });
        await isar.writeTxn(() async {
          return isar.iTenants.put(iTenant);
        });
      }
      return syncF;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception('403 Error');
    }
  }

  @override
  Future<Order?> pendingOrder({required int branchId}) async {
    return await isar.orders
        .where()
        .statusBranchIdEqualTo(pendingStatus, branchId)
        .findFirst();
  }

  @override
  Stream<List<Product>> productStreams({required int branchId}) {
    return isar.products
        .where()
        .branchIdEqualTo(branchId)
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Discount>> discountStreams({required int branchId}) {
    return isar.discounts
        .where()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
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
    return Future.value(200);
  }

  @override
  Future<Spenn> spennPayment(
      {required double amount, required phoneNumber}) async {
    int userId = ProxyService.box.getUserId()!;
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    Business? bu = await getBusiness();
    // ignore: fixme
    // FIXME: this endpoint is no longer working
    String businessName = bu!.name!;
    var request =
        http.Request('POST', Uri.parse('https://flipper.yegobox.com/pay'));
    request.bodyFields = {
      'amount': amount.toString(),
      'userId': userId.toString(),
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
        .watch(fireImmediately: true)
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
  Stream<List<Order>> ticketsStreams() {
    log(ProxyService.box.getBranchId()!.toString(),
        name: "BranchId when stream ticket");
    return isar.orders
        .where()
        .statusBranchIdEqualTo(parkedStatus, ProxyService.box.getBranchId()!)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return isar.writeTxn(() {
      return isar.iUnits.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<T?> create<T>({required T data}) async {
    if (data is PColor) {
      PColor color = data;
      isar.writeTxn(() async {
        for (String colorName in data.colors!) {
          await isar.pColors.put(PColor()
            ..name = colorName
            ..active = color.active
            ..branchId = color.branchId);
        }
      });
    }
    if (data is Device) {
      Device device = data;
      return await isar.writeTxn(() async {
        await isar.devices.put(device);
        return Future.value(null);
      });
    }
    if (data is Conversation) {
      Conversation conversation = data;
      return await isar.writeTxn(() async {
        await isar.conversations.put(conversation);
        return Future.value(null);
      });
    }
    if (data is Category) {
      Category category = data;
      return await isar.writeTxn(() async {
        await isar.categorys.put(category);
        return Future.value(null);
      });
    }
    if (data is Product) {
      isar.writeTxn(() {
        return isar.products.put(data);
      });
    }
    if (data is Variant) {
      await isar.writeTxn(() async {
        await isar.variants.put(data);
        return Future.value(null);
      });
    }
    if (data is Favorite) {
      await isar.writeTxn(() async {
        await isar.favorites.put(data);
        return Future.value(null);
      });
    }
    if (data is Stock) {
      await isar.writeTxn(() async {
        await isar.stocks.put(data);
        return Future.value(null);
      });
    }
    if (data is Social) {
      await isar.writeTxn(() async {
        await isar.socials.put(data);
        return Future.value(null);
      });
    }
    if (data is Token) {
      await isar.writeTxn(() async {
        await isar.tokens.put(data);
        return Future.value(null);
      });
    }
    return Future.value(null);
  }

  /// @Deprecated [endpoint] don't give the endpoint params
  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;

    if (data is Social) {
      Social product = data;

      await isar.writeTxn(() async {
        return await isar.socials.put(product);
      });
    }
    if (data is Product) {
      Product product = data;

      await isar.writeTxn(() async {
        return await isar.products.put(product);
      });
    }
    if (data is Favorite) {
      Favorite fav = data;
      await isar.writeTxn(() async {
        return await isar.favorites.put(fav);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      await isar.writeTxn(() async {
        return await isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
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
      token
        ..token = token.token
        ..businessId = token.businessId
        ..type = token.type;
      await isar.tokens.put(token);
    }
    if (data is Business) {
      final business = data;
      await isar.writeTxn(() async {
        return await isar.business.put(business);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/business/${business.id}"),
        body: jsonEncode(business.toJson()),
      );
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the business");
      }
    }

    if (data is Branch) {
      isar.writeTxn(() async {
        return await isar.branchs.put(data);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/branch/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode != 200) {
        throw InternalServerError(term: "error patching the branch");
      }
    }
    if (data is Counter) {
      await isar.writeTxn(() async {
        return isar.counters.put(data..backed = false);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/counter/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
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
        await flipperHttpClient.patch(
          Uri.parse("$apihub/v2/api/branch/${data.id}"),
          body: jsonEncode(data.toJson()),
        );
      } catch (e) {}
    }
    if (data is Drawers) {
      final drawer = data;
      await isar.writeTxn(() async {
        return await isar.drawers.put(drawer);
      });
    }
    if (data is ITenant) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/tenant/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode == 200) {
        await isar.writeTxn(() async {
          return await isar.iTenants.put(data);
        });
      }
      return null;
    }
    return null;
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
    final response =
        await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
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
        .watch(fireImmediately: true);
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
        ..orderId = order.id!
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
  Future<bool> isDrawerOpen({required int cashierId}) async {
    Drawers? drawer = await isar.drawers
        .where()
        .openCashierIdEqualTo(true, cashierId)
        .findFirst();
    return drawer != null;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    Drawers? drawer = await isar.drawers
        .where()
        .openCashierIdEqualTo(true, cashierId)
        .findFirst();
    return drawer;
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) {
    // save drawer object in isar db
    return isar.writeTxn(() async {
      int id = await isar.drawers.put(drawer);
      return await isar.drawers.get(id);
    });
  }

  @override
  Future<int> size<T>({required T object}) async {
    if (object is Product) {
      return await isar.products
          .getSize(includeIndexes: true, includeLinks: true);
    }
    if (object is Variant) {
      return await isar.variants
          .getSize(includeIndexes: true, includeLinks: true);
    }
    if (object is Stock) {
      return await isar.stocks
          .getSize(includeIndexes: true, includeLinks: true);
    }
    if (object is Counter) {
      return await isar.counters
          .getSize(includeIndexes: true, includeLinks: true);
    }
    return 0;
  }

  @override
  Future<List<ITenant>> tenants({required int businessId}) async {
    return await isar.iTenants.filter().businessIdEqualTo(businessId).findAll();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    String id = businessId.toString();
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/tenant/$id"));
    if (response.statusCode == 200) {
      for (JTenant tenant in jListTenantFromJson(response.body)) {
        JTenant jTenant = tenant;
        ITenant iTenant = ITenant(
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
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
        .receiptTypeEqualTo("ns")
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
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/counter/$businessId"));
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
  // You can either directly export the entire database file with the isar.copyToFile() method, or you can use collection.where().exportJson() to export a query result to json
  // @override
  // String public() {
  //   // return isar.j
  // }

  @override
  Future<bool> bindProduct(
      {required int productId, required int tenantId}) async {
    return await isar.writeTxn(() async {
      final product = await isar.products.get(productId);
      product!.nfcEnabled = true;
      product.bindedToTenantId = tenantId;
      await isar.products.put(product);
      return true;
    });
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    return await isar.products
        .where()
        .bindedToTenantIdEqualTo(tenantId)
        .findFirst();
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return isar.writeTxn(() async {
      return await isar.products.where().branchIdEqualTo(branchId).findAll();
    });
  }

  /// this method is one way i.e we get to know local unsynched changes
  /// then we send them but we are not working on the changes after this push.
  /// those change will stay on local, so I need to work on them as well.

  @override
  Stream<Order?> completedOrdersStream(
      {required String status, required int branchId}) {
    return isar.orders
        .filter()
        .statusEqualTo(postPonedStatus)
        .reportedEqualTo(false)
        .or()
        .statusEqualTo(status)
        .branchIdEqualTo(branchId)
        .and()
        .lastTouchedIsNull()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

// https://pub.dev/packages/excel
  @override
  Future<List<Order>> completedOrders(
      {required int branchId, String? status = completeStatus}) async {
    return await isar.orders
        .where()
        .statusBranchIdEqualTo(status!, branchId)
        .findAll();
  }

  /// Do not call this function in production
  @override
  Future<void> deleteAllProducts() async {
    List<Product> products =
        await productsFuture(branchId: ProxyService.box.getBranchId()!);
    List<int> productIds = products.map((product) => product.id ?? 0).toList();
    isar.writeTxn(() async {
      isar.products.deleteAll(productIds);
    });
  }

  @override
  Future<Stock?> getStockById({required int id}) async {
    return isar.writeTxn(() async {
      return await isar.stocks.get(id);
    });
  }

  @override
  Future<List<Stock>> getLocalStocks() async {
    log(ProxyService.box.getBranchId().toString(), name: 'getLocalStocks');
    if (ProxyService.box.getBranchId() == null) return [];
    return await isar.stocks
        .filter()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo('update')
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
  }

  @override
  Future<List<Variant>> getLocalVariants() async {
    log(ProxyService.box.getBranchId().toString(), name: 'getLocalVariants');
    if (ProxyService.box.getBranchId() == null) return [];
    return await isar.variants
        .filter()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo('update')
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
  }

  @override
  Future<List<Product>> getLocalProducts() async {
    if (ProxyService.box.getBranchId() == null) return [];
    return await isar.products
        .filter()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo('update')
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
  }

  @override
  Future<List<Order>> getLocalOrders() async {
    if (ProxyService.box.getBranchId() == null) return [];
    return await isar.orders
        .filter()
        .statusEqualTo(completeStatus)
        .lastTouchedIsNull()
        .or()
        .actionEqualTo('update')
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
  }

  @override
  Stream<Social> socialsStream({required int businessId}) {
    log("socialsStream called", name: "${businessId}");
    return isar.socials
        .filter()
        .businessIdEqualTo(businessId)
        .and()
        .isAccountSetEqualTo(true)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  /// sincd this type does not change no point of getting it from the server
  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": 1, "typeName": "Flipper Retailer"},
      {"id": 2, "typeName": "Flipper Connecta"},
      // {"id": 3, "typeName": "Retailer"},
      // {"id": 4, "typeName": "Agent"}
    ];
    Future.delayed(Duration(seconds: 5));
    final response = http.Response(jsonEncode(responseJson), 200);
    if (response.statusCode == 200) {
      return BusinessType.fromJsonList(jsonEncode(responseJson));
    }
    return BusinessType.fromJsonList(jsonEncode(responseJson));
  }

  @override
  Future<Social?> getSocialById({required int id}) async {
    return await isar.socials.get(id);
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    if (ProxyService.box.getUserPhone() == null) return Stream.empty();
    final phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
    log(phone, name: "top5Conversations");
    return isar.conversations
        .filter()
        .toNumberEqualTo(phone)
        .or()
        .fromNumberEqualTo(phone)
        .and()
        .deliveredEqualTo(true)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true)
        .map((event) {
      final uniqueUserNames = <String>{};
      final uniqueConversations = <Conversation>[];

      for (final message in event) {
        if (!uniqueUserNames.contains(message.userName)) {
          uniqueUserNames.add(message.userName);
          uniqueConversations.add(message);
        }
      }

      // Sort conversations by creation date in descending order
      uniqueConversations.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Return the top 5 recent conversations
      return uniqueConversations.take(5).toList();
    });
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) {
    if (conversationId == null && ProxyService.box.getUserPhone() != null) {
      // get all conversations addressed to me or from me
      String phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
      log(phone, name: "LoadInitialList of conversations");
      return isar.conversations
          .filter()
          .toNumberEqualTo(phone)
          .or()
          .fromNumberEqualTo(phone)
          .and()
          .deliveredEqualTo(true)
          .build()
          .watch(fireImmediately: true)
          .asyncMap((event) {
        final uniqueUserNames = <String>{};

        // Create a list to store the unique conversations
        final uniqueConversations = <Conversation>[];

        // Loop through each message in the responseJson
        for (final message in event) {
          // Check if the username of the message is already in the set
          if (!uniqueUserNames.contains(message.userName)) {
            // If not, add the username to the set and add the message to the uniqueConversations list
            uniqueUserNames.add(message.userName);
            uniqueConversations.add(message);
          }
        }
        // Return the list of unique conversations
        return uniqueConversations;
      });
    } else {
      return isar.conversations
          .filter()
          .conversationIdEqualTo(conversationId)
          .build()
          .watch(fireImmediately: true);
    }
  }

  final appService = loc.locator<AppService>();
  @override
  Future<List<Conversation>> getScheduleMessages() async {
    return isar.conversations
        .filter()
        .deliveredEqualTo(false)
        .build()
        .findAll();
  }

  @override
  Future<void> sendScheduleMessages() async {
    await appService.isLoggedIn();
    List<Conversation> scheduledMessages = await getScheduleMessages();
    for (Conversation message in scheduledMessages) {
      final http.Response response = await socialsHttpClient.post(
        Uri.parse("$commApi/reply"),
        body: json.encode(message.toJson()),
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final conversation = Conversation.fromJson(responseJson);
        message.delivered = true;
        message.messageId = conversation.messageId;

        /// can not rely on remote server time using local, will fix remote later
        /// to have same date format as here and use it
        message.createdAt = DateTime.now().toString();
        message.conversationId = conversation.conversationId;
        message.userName = conversation.userName;
        message.phoneNumberId = conversation.phoneNumberId;
        message.businessId = conversation.businessId;
        message.businessPhoneNumber =
            ProxyService.box.getUserPhone()!.replaceAll("+", "");
        isar.writeTxn(() async {
          await isar.conversations.put(message);
        });
      } else if (response.statusCode == 402) {
        // this means there is no credit
        throw Exception('There is no available credit,can not send message');
      }
    }
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) async {
    return await isar.conversations
        .where()
        .messageIdEqualTo(messageId)
        .findFirst();
  }

  @override
  Future<int> registerOnSocial(
      {String? phoneNumberOrEmail, String? password}) async {
    final http.Response response = await socialsHttpClient.post(
      Uri.parse("$commApi/register"),
      body: json.encode({"email": phoneNumberOrEmail, "password": password}),
    );
    if (response.statusCode == 200) {
      return Future.value(200);
    }

    // var headers = {'Content-Type': 'application/json'};
    // var request = http.Request('POST', Uri.parse("$commApi/register"));
    // request.body =
    //     json.encode({"email": phoneNumberOrEmail, "password": password});
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    throw Exception();
  }

  @override
  Future<bool> isTokenValid({
    required String tokenType,
    required int businessId,
  }) async {
    final token = await isar.tokens
        .filter()
        .typeEqualTo(tokenType)
        .and()
        .businessIdEqualTo(businessId)
        .build()
        .findFirst();

    if (token == null) {
      return false;
    }

    final now = DateTime.now();

    if (now.isBefore(token.validFrom) || now.isAfter(token.validUntil)) {
      isar.writeTxn(() => isar.tokens.delete(token.id));
      return false;
    }

    return true;
  }

  @override
  Future<SocialToken> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) async {
    final http.Response response = await socialsHttpClient.post(
      Uri.parse("$commApi/login"),
      body: json.encode({"email": phoneNumberOrEmail, "password": password}),
    );

    if (response.statusCode == 200) {
      SocialToken responseBody = SocialToken.fromRawJson(response.body);
      return responseBody;
    } else {
      throw Exception("Failed to get token");
    }
  }

  @override
  Future<Setting?> getSocialSetting() async {
    String? phoneNumber = ProxyService.box.getUserPhone();
    if (phoneNumber == null) {
      return null;
    }
    await Future.delayed(Duration(seconds: 20));
    final number = phoneNumber.replaceAll("+", "");
    final http.Response response =
        await socialsHttpClient.get(Uri.parse("$commApi/settings/$number"));
    // convert response to Setting
    if (response.statusCode == 200) {
      Setting setting = Setting.fromJson(jsonDecode(response.body));
      return setting;
    }
    throw Exception("Can't get social setting ${response.body}${number}");
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) async {
    /// a hack to delay 20 seconds for theserver to not return forbidden as we have called the aws api before
    /// so we need to wait 20 seconds to make another call, I will need to investigate on server later
    // await Future.delayed(Duration(seconds: 20));
    int businessId = ProxyService.box.getBusinessId()!;
    final http.Response response =
        await socialsHttpClient.patch(Uri.parse("$commApi/settings"),
            body: json.encode({
              "token": setting.token,
              "businessPhoneNumber": setting.businessPhoneNumber,
              "enrolledInBot": setting.enrolledInBot,
              "autoRespond": setting.autoRespond,
              "businessId": businessId,
              "deviceToken": setting.deviceToken
            }));
    // convert response to Setting
    if (response.statusCode != 200) {
      throw Exception(
          "Can't  patch  settings patch ${response.body}${setting.toJson()}");
    }
  }

  @override
  Future<Device?> getDevice({required String linkingCode}) {
    // get device from isar with linking code and return it
    return isar.devices
        .filter()
        .linkingCodeEqualTo(linkingCode)
        .build()
        .findFirst();
  }

  @override
  Stream<List<Device>> getDevices({required int businessId}) {
    // get device from isar with linking code and return it
    return isar.devices
        .filter()
        .busienssIdEqualTo(businessId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) async {
    return await isar.devices
        .filter()
        .busienssIdEqualTo(businessId)
        .and()
        .pubNubPublishedEqualTo(false)
        .build()
        .findAll();
  }

  @override
  Stream<Business> businessStream({required int businessId}) {
    return isar.business
        .filter()
        .idEqualTo(businessId)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<ITenant?> getTenantBYUserId({required int userId}) async {
    return isar.iTenants.filter().userIdEqualTo(userId).build().findFirst();
  }

  @override
  Future<void> loadConversations(
      {required int businessId,
      int? pageSize = 10,
      String? pk,
      String? sk}) async {
    String? lastPk = ProxyService.box.getPk();
    String? lastSk = ProxyService.box.getSk();

    final response = await socialsHttpClient.get(Uri.parse(
        '${commApi}/messages/${businessId}?pageSize=${pageSize}&pk=${lastPk}&sk=${lastSk}'));

    if (response.statusCode == 200) {
      final messagesJson = jsonDecode(response.body)['messages'];
      if (messagesJson == null) return;
      List<Conversation> messages = (messagesJson as List<dynamic>)
          .map((e) => Conversation.fromJson(e))
          .toList();

      for (Conversation conversation in messages) {
        Conversation? localConversation = await ProxyService.isarApi
            .getConversation(messageId: conversation.messageId!);
        // if date is improperly formatted then format it right
        // the bellow date format will be like 5th May converter
        final DateFormat formatter = DateFormat('EEE MMM dd yyyy');
        DateTime createdAt;
        try {
          createdAt = formatter.parse(conversation.createdAt!);
        } on FormatException {
          /// in case it fail to format set fake date
          createdAt = DateTime.now();
        }
        conversation.createdAt = createdAt.toIso8601String();
        conversation.avatar = HtmlUnescape().convert(conversation.avatar);
        log(conversation.avatar, name: "converted URL");
        if (localConversation == null) {
          await ProxyService.isarApi.create(data: conversation);
        }
      }

      if (jsonDecode(response.body)['lastKey'] != null) {
        // Set lastKey to the value returned by the API
        String pk = jsonDecode(response.body)['lastKey']['PK'] as String;
        String sk = jsonDecode(response.body)['lastKey']['SK'] as String;
        ProxyService.box
            .write(key: 'pk', value: pk.replaceAll("messages#", ""));
        ProxyService.box
            .write(key: 'sk', value: sk.replaceAll("messages#", ""));
      }
    }
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) async {
    final response = await socialsHttpClient.patch(
      Uri.parse("$commApi/contacts/${businessId}"),
      body: jsonEncode(contact),
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  @override
  Future<List<OrderItem>> orderItems({required int orderId}) async {
    return await isar.orderItems.where().orderIdEqualTo(orderId).findAll();
  }

  @override
  Stream<List<OrderItem>> orderItemsStream({required int orderId}) {
    return isar.orderItems
        .where()
        .orderIdEqualTo(orderId)
        .watch()
        .map((event) => event.toList());
  }
}