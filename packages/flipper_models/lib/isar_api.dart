import 'dart:async';
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
import 'flipper_http_client.dart';
import 'package:flipper_routing/receipt_types.dart';

class IsarAPI<M> implements IsarApiInterface {
  FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());
  SocialsHttpClient socialsHttpClient = SocialsHttpClient(http.Client());
  late String apihub;
  late String commApi;
  late Isar iisar;
  Future<IsarApiInterface> getInstance({Isar? db}) async {
    final appDocDir = await getApplicationDocumentsDirectory();
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
    if (db == null) {
      iisar = await Isar.open(
        // compactOnLaunch:
        // CompactCondition(minBytes: 100, minFileSize: 100, minRatio: 2.0),
        schemas: [
          TransactionSchema,
          BusinessSchema,
          BranchSchema,
          TransactionItemSchema,
          ProductSchema,
          VariantSchema,
          ProfileSchema,
          SubscriptionSchema,
          PointssSchema,
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
          FavoriteSchema,
          EBMSchema
        ],
        directory: foundation.kIsWeb ? Isar.sqliteInMemory : appDocDir.path,
        engine: foundation.kIsWeb ? IsarEngine.sqlite : IsarEngine.isar,
      );
    } else {
      iisar = db;
    }
    return this;
  }

  @override
  Future<Customer?> addCustomer(
      {required Map customer, required String transactionId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Customer kCustomer = Customer(
        name: customer['name'],
        id: randomString(),
        action: AppActions.create,
        tinNumber: customer['tinNumber'],
        email: customer['email'],
        phone: customer['phone'],
        address: customer['address'],
        updatedAt: DateTime.now(),
        branchId: branchId);
    iisar.write((isar) async {
      isar.customers.put(kCustomer);
    });

    Transaction transaction = iisar.transactions.get(transactionId)!;
    transaction.customerId = kCustomer.id;
    // update the transaction with the customerID
    await update(data: transaction);
    return kCustomer;
  }

  /// this method is one way i.e we get to know local unsynched changes
  /// then we send them but we are not working on the changes after this push.
  /// those change will stay on local, so I need to work on them as well.

  @override
  Stream<Transaction?> completedTransactionsStream(
      {required String status, required int branchId}) {
    return iisar.transactions
        .where()
        .statusEqualTo(postPonedStatus)
        .statusEqualTo(status)
        .branchIdEqualTo(branchId)
        .and()
        .lastTouchedIsNull()
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<List<Transaction>> pendingTransactionStreams() {
    // int? currentTransactionId = ProxyService.box.currentTransactionId();
    // return isar.transactions.watchObject(currentTransactionId ?? 0, fireImmediately: true);
    int branchId = ProxyService.box.getBranchId()!;
    return iisar.transactions
        .where()
        .statusEqualTo(pendingStatus)
        .and()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Stream<Transaction?> pendingTransactionStream() {
    int branchId = ProxyService.box.getBranchId()!;
    return iisar.transactions
        .where()
        .statusEqualTo(pendingStatus)
        .and()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.last);
  }

  @override
  Future<Transaction> manageTransaction({
    String transactionType = 'custom',
  }) async {
    int branchId = ProxyService.box.getBranchId()!;

    Transaction? existTransaction =
        await pendingTransaction(branchId: branchId);

    if (existTransaction == null) {
      final String id = randomString();
      final transaction = Transaction(
        lastTouched: DateTime.now(),
        id: id,
        reference: randomString(),
        action: AppActions.create,
        transactionNumber: randomString(),
        status: pendingStatus,
        transactionType: transactionType,
        subTotal: 0,
        cashReceived: 0,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0,
        paymentType: 'Cash',
        branchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );

      // save transaction to db
      iisar.write((isar) async {
        isar.transactions.put(transaction);
      });
      Transaction? createdTransaction = await iisar.transactions.get(id);
      ProxyService.box.write(key: 'currentTransactionId', value: id);
      return createdTransaction!;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<Transaction> manageCashInOutTransaction(
      {required String transactionType}) async {
    int branchId = ProxyService.box.getBranchId()!;

    Transaction? existTransaction =
        await pendingTransaction(branchId: branchId);

    if (existTransaction == null) {
      String id = randomString();
      final transaction = Transaction(
        lastTouched: DateTime.now(),
        id: id,
        reference: randomString(),
        action: AppActions.create,
        transactionNumber: randomString(),
        status: pendingStatus,
        transactionType: transactionType,
        subTotal: 0,
        cashReceived: 0,
        updatedAt: DateTime.now().toIso8601String(),
        customerChangeDue: 0.0,
        paymentType: 'Cash',
        branchId: branchId,
        createdAt: DateTime.now().toIso8601String(),
      );

      // save transaction to db
      iisar.write((isar) {
        isar.transactions.put(transaction);
      });
      Transaction? createdTransaction = iisar.transactions.get(id);
      ProxyService.box.write(key: 'currentTransactionId', value: id);
      return createdTransaction!;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<void> addTransactionItem(
      {required Transaction transaction, required TransactionItem item}) async {
    iisar.write((isar) async {
      isar.transactionItems.put(item);
    });
  }

  // get point where userId = userId from db
  @override
  Pointss addPoint({required int userId, required int point}) {
    return iisar.pointss.where().userIdEqualTo(userId).findFirst()!;
  }

  @override
  Future<Transaction?> getTransactionById({required String id}) async {
    return iisar.transactions.get(id);
  }

  //Delete a favorite
  @override
  Future<int> deleteTransactionByIndex(
      {required String transactionIndex}) async {
    iisar.write((isar) {
      isar.transactions.delete(transactionIndex);
    });
    return Future.value(200);
  }

  @override
  Stream<List<Transaction>> getTransactionsByCustomerId(
      {required String customerId}) async* {
    yield* iisar.transactions.where().customerIdEqualTo(customerId).watch();
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    Stream<List<Transaction>> transactions =
        iisar.transactions.where().build().watch(fireImmediately: true);

    return transactions;
  }

  @override
  Stream<List<Transaction>> getLocalTransactionsStream() {
    final branchId = ProxyService.box.getBranchId()!;
    Stream<List<Transaction>> transactions = iisar.transactions
        .where()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
    return transactions;
  }

  @override
  Stream<List<Transaction>> getCompletedTransactions() {
    Stream<List<Transaction>> completedTransactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true);
    return completedTransactions;
  }

  @override
  Stream<List<Transaction>> getLocalCashInTransactions() {
    final branchId = ProxyService.box.getBranchId()!;
    Stream<List<Transaction>> localCashInTransactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash In')
        .or()
        .transactionTypeEqualTo('Sale')
        .or()
        .transactionTypeEqualTo('custom')
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
    return localCashInTransactions;
  }

  @override
  Stream<List<Transaction>> getCashInTransactions() {
    Stream<List<Transaction>> cashInTransactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash In')
        .or()
        .transactionTypeEqualTo('Sale')
        .or()
        .transactionTypeEqualTo('custom')
        .build()
        .watch(fireImmediately: true);
    return cashInTransactions;
  }

  @override
  Stream<List<Transaction>> getLocalCashOutTransactions() {
    final branchId = ProxyService.box.getBranchId()!;
    Stream<List<Transaction>> localCashOutTransactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash Out')
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
    return localCashOutTransactions;
  }

  @override
  Stream<List<Transaction>> getCashOutTransactions() {
    Stream<List<Transaction>> cashOutTransactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash Out')
        .build()
        .watch(fireImmediately: true);
    return cashOutTransactions;
  }

  @override
  Future<List<double>> getTransactionsAmountsSum(
      {required String period}) async {
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<double> cashInOut = [];
    double In = 0;
    double Out = 0;
    List<Transaction> cashIn = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash In')
        .or()
        .transactionTypeEqualTo('Sale')
        .or()
        .transactionTypeEqualTo('custom')
        .findAll();

    for (final transaction in cashIn) {
      temporaryDate = DateTime.parse(transaction.createdAt);
      if (temporaryDate.isAfter(oldDate)) {
        In = In + transaction.subTotal.toDouble();
      }
    }
    cashInOut.add(In);

    List<Transaction> cashOut = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash Out')
        .findAll();
    for (final transaction in cashOut) {
      temporaryDate = DateTime.parse(transaction.createdAt);
      if (temporaryDate.isAfter(oldDate)) {
        Out = Out + transaction.subTotal.toDouble();
      }
    }
    cashInOut.add(Out);

    return cashInOut;
  }

  @override
  Future<List<double>> getLocalTransactionsAmountsSum(
      {required String period}) async {
    final branchId = ProxyService.box.getBranchId()!;
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<double> cashInOut = [];
    double In = 0;
    double Out = 0;
    List<Transaction> cashIn = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash In')
        .or()
        .transactionTypeEqualTo('Sale')
        .or()
        .transactionTypeEqualTo('custom')
        .branchIdEqualTo(branchId)
        .findAll();
    for (final transaction in cashIn) {
      temporaryDate = DateTime.parse(transaction.createdAt);
      if (temporaryDate.isAfter(oldDate)) {
        In = In + transaction.subTotal.toDouble();
      }
    }
    cashInOut.add(In);

    List<Transaction> cashOut = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash Out')
        .findAll();
    for (final transaction in cashOut) {
      temporaryDate = DateTime.parse(transaction.createdAt);
      if (temporaryDate.isAfter(oldDate)) {
        Out = Out + transaction.subTotal.toDouble();
      }
    }
    cashInOut.add(Out);

    return cashInOut;
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    Favorite? fav =
        iisar.favorites.where().favIndexEqualTo(data.favIndex!).findFirst();
    if (fav == null) {
      iisar.write((iisar) {
        iisar.favorites.put(data);
      });
      return Future.value(200);
    } else {
      fav.productId = data.productId;
      iisar.write((isar) {
        isar.favorites.put(fav);
      });
      return Future.value(200);
    }
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    List<Favorite> favorites = iisar.favorites.where().findAll();
    return favorites;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    //Get a favorite
    Favorite? favorite = iisar.favorites.where().idEqualTo(favId).findFirst();
    return favorite;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    //Get a favorite
    Favorite? favorite =
        iisar.favorites.where().favIndexEqualTo(favIndex).findFirst();
    return favorite;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    return iisar.favorites
        .where()
        .favIndexEqualTo(favIndex)
        .deletedAtIsNull()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<Product?> getProduct({required String id}) async {
    return iisar.products.get(id);
  }

  Stream<Product> getProductStream({required String prodIndex}) {
    return iisar.products
        .where()
        .idEqualTo(prodIndex)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    Favorite? favorite =
        iisar.favorites.where().productIdEqualTo(prodId).findFirst();
    return favorite;
  }

  //Delete a favorite
  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) async {
    iisar.write((isar) {
      isar.favorites.where().favIndexEqualTo(favIndex).deleteFirst();
    });
    return Future.value(200);
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    int branchId = ProxyService.box.getBranchId()!;
    iisar.write((isar) {
      for (Map map in units) {
        final unit = IUnit()
          ..active = map['active']
          ..value = map['value']
          ..name = map['name']
          ..branchId = branchId;
        // save unit to db
        isar.iUnits.put(unit);
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
        iisar.subscriptions.where().userIdEqualTo(userId).findFirst();
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
    String id = randomString();
    subscription ??= Subscription(
      id: id,
      userId: userId,
      lastBillingDate: subscription!.nextBillingDate,
      nextBillingDate: nextBillingDate.toIso8601String(),
      interval: interval,
      descriptor: descriptor,
      recurring: recurringAmount,
    );
    // save subscription to db and return subscription
    iisar.write((isar) {
      isar.subscriptions.put(subscription!);
    });
    Subscription? sub = iisar.subscriptions.get(id);
    // TODO: fix this as I used it when link were still supported
    // for (var feature in features) {
    //   sub!.features.value = feature;
    // }
    // update sub to db
    iisar.write((isar) {
      isar.subscriptions.put(sub!);
    });
    return iisar.subscriptions.get(id);
  }

  @override
  Future<int> addVariant(
      {required List<Variant> data,
      required double retailPrice,
      required double supplyPrice}) async {
    String id = randomString();
    iisar.write((isar) {
      for (Variant variation in data) {
        // save variation to db
        // FIXMEneed to know if all item will have same itemClsCd
        variation.itemClsCd = "5020230602";
        variation.pkg = "1";
        variation.id = id;
        isar.variants.put(variation);
        final stock = Stock(
            id: id,
            lastTouched: DateTime.now(),
            branchId: ProxyService.box.getBranchId()!,
            variantId: id,
            action: 'create',
            currentStock: 0.0,
            productId: variation.productId)
          ..id = id
          ..variantId = id
          ..lowStock = 0.0
          ..branchId = ProxyService.box.getBranchId()!
          ..currentStock = 0.0
          ..supplyPrice = supplyPrice
          ..retailPrice = retailPrice
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..productId = variation.productId
          ..active = false;
        isar.stocks.put(stock);
      }
    });
    return Future.value(200);
  }

  @override
  Future assingTransactionToCustomer(
      {required String customerId, required String transactionId}) async {
    // get transaction where id = transactionId from db
    Transaction? transaction =
        iisar.transactions.where().idEqualTo(transactionId).findFirst();

    transaction!.customerId = customerId;
    // update transaction to db
    iisar.write((isar) {
      isar.transactions.put(transaction);
    });
    // get customer where id = customerId from db
    //// and updat this customer with timestamp so it can trigger change!.
    Customer? customer = iisar.customers.get(customerId);
    customer!.updatedAt = DateTime.now();
    // save customer to db
    iisar.write((isar) {
      isar.customers.put(customer);
    });
  }

  @override
  Future<List<Branch>> branches({required int businessId}) async {
    // if in local db we have no branch fetch it from online
    return iisar.branchs.where().businessIdEqualTo(businessId).findAll();
  }

  @override
  Future<bool> checkIn({required String? checkInCode}) async {
    //  String? checkIn = ProxyService.box.read(key: 'checkIn');

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
  Future<void> collectPayment(
      {required double cashReceived,
      required Transaction transaction,
      required String paymentType}) async {
    transaction.status = completeStatus;

    List<TransactionItem> items = await transactionItems(
        transactionId: transaction.id, doneWithTransaction: false);

    transaction.customerChangeDue = (cashReceived - transaction.subTotal);
    transaction.paymentType = paymentType;
    transaction.cashReceived = cashReceived;
    transaction.updatedAt = DateTime.now().toIso8601String();

    await update(data: transaction);

    for (TransactionItem item in items) {
      Stock? stock = await stockByVariantId(variantId: item.variantId);
      stock?.currentStock = stock.currentStock - item.qty;
      stock?.action = AppActions.update;
      item.doneWithTransaction = true;
      item.updatedAt = DateTime.now().toIso8601String();
      await update(data: stock);
      await update(data: item);
    }
    // remove currentTransactionId from local storage to leave a room
    // for listening to new transaction that will be created
    ProxyService.box.remove(key: 'currentTransactionId');
    ProxyService.sync.push();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) async {
    return iisar.write((isar) async {
      return isar.pColors.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  void consumePoints({required int userId, required int points}) async {
    // get Points where userId = userId from db
    // and update this Points with new points
    Pointss? po = iisar.pointss.where().userIdEqualTo(userId).findFirst();
    //po ??= Points(userId: userId, points: 0, value: 0);
    // save po to db
    po!.value = po.value - points;
    iisar.write((isar) {
      isar.pointss.put(po);
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
    return Voucher(id: randomString())
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
    Pin? pin = iisar.pins.where().userIdEqualTo(id).findFirst();
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
      String id = randomString();
      Pin pin = Pin.fromJson(json.decode(response.body));
      pin.id = id;
      iisar.write((isar) {
        isar.pins.put(pin);
      });
      return iisar.pins.get(id);
    }
    return null;
  }

  Future<Product?> isCustomProductExist({required int businessId}) async {
    return iisar.products
        .where()
        .businessIdEqualTo(businessId)
        .and()
        .nameEqualTo('Custom Amount')
        .build()
        .findFirst();
  }

  @override
  Future<Product> createProduct({required Product product}) async {
    String id = randomString();
    Business? business = await getBusiness();
    String itemPrefix = "flip-";
    String clip = itemPrefix +
        DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

    product.description = 'description';
    product.color = '#5A2328';
    product.id = randomString();
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
    iisar.write((isar) {
      isar.products.put(product);
    });
    Product? kProduct = iisar.products.get(id);
    // save variants in isar Db with the above productId
    iisar.write((isar) {
      isar.variants.put(
        Variant(
            lastTouched: DateTime.now(),
            name: 'Regular',
            sku: 'sku',
            action: 'create',
            productId: kProduct!.id,
            unit: 'Per Item',
            productName: product.name,
            branchId: ProxyService.box.getBranchId()!,
            supplyPrice: 0.0,
            retailPrice: 0.0,
            id: randomString(),
            isTaxExempted: false)
          ..name = 'Regular'
          ..productId = kProduct.id
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
        iisar.variants.where().productIdEqualTo(kProduct!.id).findFirst();

    Stock stock = Stock(
        lastTouched: DateTime.now(),
        id: randomString(),
        action: 'create',
        branchId: branchId,
        variantId: variant!.id,
        currentStock: 0.0,
        productId: kProduct.id)
      ..canTrackingStock = false
      ..showLowStockAlert = false
      ..currentStock = 0.0
      ..branchId = branchId
      ..variantId = variant.id
      ..supplyPrice = 0.0
      ..retailPrice = 0.0
      ..lowStock = 10.0 // default static
      ..canTrackingStock = true
      ..showLowStockAlert = true
      ..active = false
      ..productId = kProduct.id
      ..rsdQty = 0.0;

    iisar.write((isar) {
      isar.stocks.put(stock);
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
  Future<bool> delete({required dynamic id, String? endPoint}) async {
    final DateTime deletionTime = DateTime.now();

    switch (endPoint) {
      case 'color':
        iisar.write((isar) async {
          PColor? color = await isar.pColors.get(id);
          if (color != null) {
            color.deletedAt = deletionTime;
            color.action = AppActions.deleted;
            isar.pColors.put(color);
            return true;
          }
          return false;
        });
        break;
      case 'device':
        iisar.write((isar) async {
          Device? device = await isar.devices.get(id);
          if (device != null) {
            device.deletedAt = deletionTime;
            device.action = AppActions.deleted;
            isar.devices.put(device);
            return true;
          }
          return false;
        });
        break;
      case 'category':
        iisar.write((isar) async {
          Category? category = await isar.categorys.get(id);
          if (category != null) {
            category.deletedAt = deletionTime;
            category.action = AppActions.deleted;
            isar.categorys.put(category);
            return true;
          }
          return false;
        });
        break;
      case 'product':
        iisar.write((isar) async {
          Product? product = await isar.products.get(id);
          if (product != null) {
            product.deletedAt = deletionTime;
            product.action = AppActions.deleted;
            isar.products.put(product);
            return true;
          }
          return false;
        });
        break;
      case 'variant':
        iisar.write((isar) async {
          Variant? variant = await isar.variants.get(id);
          if (variant != null) {
            variant.deletedAt = deletionTime;
            variant.action = AppActions.deleted;
            isar.variants.put(variant);
            return true;
          }
          return false;
        });
        break;
      case 'stock':
        iisar.write((isar) async {
          Stock? stocks = await isar.stocks.get(id);
          if (stocks != null) {
            stocks.deletedAt = deletionTime;
            stocks.action = AppActions.deleted;
            isar.stocks.put(stocks);
            return true;
          }
          return false;
        });
        break;
      case 'setting':
        iisar.write((isar) async {
          Setting? setting = await isar.settings.get(id);
          if (setting != null) {
            setting.deletedAt = deletionTime;
            setting.action = AppActions.deleted;
            isar.settings.put(setting);
            return true;
          }
          return false;
        });
        break;
      case 'pin':
        iisar.write((isar) async {
          Pin? pin = await isar.pins.get(id);
          if (pin != null) {
            pin.deletedAt = deletionTime;
            pin.action = AppActions.deleted;
            isar.pins.put(pin);
            return true;
          }
          return false;
        });
        break;
      case 'business':
        iisar.write((isar) async {
          isar.business.delete(id);
        });
        break;
      case 'branch':
        iisar.write((isar) async {
          isar.branchs.delete(id);
          return true;
        });
        break;

      case 'voucher':
        iisar.write((isar) async {
          await isar.vouchers.delete(id);
          return true;
        });
        break;
      case 'transactionItem':
        iisar.write((isar) async {
          await isar.transactionItems.delete(id);
          return true;
        });
        break;
      case 'customer':
        iisar.write((isar) async {
          Customer? customer = await isar.customers.get(id);
          if (customer != null) {
            customer.deletedAt = deletionTime;
            customer.action = AppActions.deleted;
            isar.customers.put(customer);
            return true;
          }
          return false;
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

    Business? business = iisar.write((isar) {
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
  Future<Business?> getBusiness() async {
    int? userId = ProxyService.box.getUserId();
    return iisar.business.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Future<Business?> getBusinessById({required int id}) async {
    return iisar.business.get(id);
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = iisar.write((isar) {
      return isar.business.where().idEqualTo(id).findFirst();
    });
    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      Business business = Business.fromJson(json.decode(response.body));
      // TODO: check if in incoming object we have an id
      business.id = id;
      iisar.write((isar) async {
        isar.business.put(business);
      });
      return iisar.business.get(id);
    }
    return null;
  }

  @override
  Future<PColor?> getColor({required String id, String? endPoint}) async {
    return iisar.write((isar) async {
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
        iisar.products.where().nameEqualTo('Custom Amount').findFirst();
    if (product == null) {
      String id = randomString();
      Product newProduct = await createProduct(
          product: Product(
              id: id,
              lastTouched: DateTime.now(),
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
      Variant? variant =
          iisar.variants.where().productIdEqualTo(newProduct.id).findFirst();
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant!);
      }
      return variant!;
    } else {
      Variant? variation =
          iisar.variants.where().productIdEqualTo(product.id).findFirst();
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
      String id = randomString();
      // add variant to this product
      Business? business = await getBusiness();
      String clip = 'flipper' +
          DateTime.now().microsecondsSinceEpoch.toString().substring(0, 5);

      iisar.write((isar) {
        isar.variants.put(
          Variant(
              id: id,
              lastTouched: DateTime.now(),
              name: 'Custom Amount',
              sku: 'sku',
              action: 'create',
              productId: product.id,
              unit: 'Per Item',
              productName: product.name,
              branchId: ProxyService.box.getBranchId()!,
              supplyPrice: 0.0,
              retailPrice: 0.0,
              isTaxExempted: false)
            ..name = 'Regular'
            ..productId = product.id
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
          lastTouched: DateTime.now(),
          id: randomString(),
          action: 'create',
          branchId: branchId,
          variantId: variation!.id,
          currentStock: 0.0,
          productId: product.id)
        ..canTrackingStock = false
        ..showLowStockAlert = false
        ..currentStock = 0.0
        ..branchId = branchId
        ..variantId = variation.id
        ..supplyPrice = 0.0
        ..retailPrice = 0.0
        ..lowStock = 10.0 // default static
        ..canTrackingStock = true
        ..showLowStockAlert = true
        ..active = false
        ..productId = product.id
        ..rsdQty = 0.0;

      iisar.write((isar) {
        isar.stocks.put(stock);
      });
    }
    return variation;
  }

  @override
  Stream<Customer?> getCustomer({required String key}) {
    return iisar.customers
        .where()
        .nameEqualTo(key)
        .or()
        .emailEqualTo(key)
        .or()
        .phoneEqualTo(key)
        .and()
        .deletedAtIsNull()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<Customer?> getCustomerByTransactionId({required String id}) {
    return iisar.customers
        .watchObject(id, fireImmediately: true)
        .asyncMap((event) => event);
  }

  @override
  Future<Customer?> nGetCustomerByTransactionId({required String id}) async {
    Transaction? transaction = iisar.transactions.get(id);
    if (transaction == null) {
      return null;
    }
    Customer? customer = iisar.customers.get(transaction.customerId!);
    return customer;
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return iisar.discounts.where().branchIdEqualTo(branchId).findAll();
  }

  // get list of Business from isar where userId = userId
  // if list is empty then get list from online
  @override
  Future<List<Business>> businesses({required int userId}) async {
    List<Business> businesses =
        iisar.business.where().userIdEqualTo(userId).findAll();

    return businesses;
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) async {
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw BusinessNotFoundException(term: "Business not found");
    }

    Business? business = iisar.write((isar) {
      return isar.business
          .get(Business.fromJson(json.decode(response.body)).id);
    });

    if (business == null) {
      iisar.write((isar) async {
        return isar.business.put(Business.fromJson(json.decode(response.body)));
      });
      business = iisar.write((isar) {
        return isar.business.where().userIdEqualTo(userId).findFirst();
      });
    }
    ProxyService.box.write(key: 'businessId', value: business!.id);

    return business;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required String id}) async {
    return iisar.transactionItems.get(id);
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, required String? transactionId}) async {
    return iisar.transactionItems
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .transactionIdEqualTo(transactionId!)
        .findFirst();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required String? transactionId}) async {
    return iisar.transactionItems
        .where()
        .transactionIdEqualTo(transactionId!)
        .findAll();
  }

  @override
  Future<Pin?> getPin({required String pin}) async {
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/pin/$pin"));
    if (response.statusCode == 200) {
      return Pin.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw ErrorReadingFromYBServer(term: 'Failed to load pin');
  }

  @override
  Future<Pointss?> getPoints({required int userId}) async {
    return iisar.pointss.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) async {
    return iisar.products.where().barCodeEqualTo(barCode).findFirst();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) async {
    return iisar.write((isar) {
      return isar.settings.where().businessIdEqualTo(businessId).findFirst();
    });
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required String variantId}) async {
    return iisar.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) async {
    Subscription? local = iisar.write((isar) {
      return isar.subscriptions.where().userIdEqualTo(userId).findFirst();
    });
    if (local == null) {
      final response = await flipperHttpClient
          .get(Uri.parse("$apihub/v2/api/subscription/$userId"));
      if (response.statusCode == 200) {
        Subscription? sub = Subscription.fromJson(json.decode(response.body));

        iisar.write((isar) async {
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
  Future<List<Variant>> getVariantByProductId(
      {required String productId}) async {
    return iisar.variants.where().productIdEqualTo(productId).findAll();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<Product?> isTempProductExist({required int branchId}) async {
    return iisar.products
        .where()
        .nameContains("temp")
        // .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    // delete all business and branches from isar db for
    // potential next business that can log-in to not mix data.
    iisar.write((isar) {
      isar.business.clear();
      isar.branchs.clear();
      isar.iTenants.clear();
      isar.permissions.clear();
      isar.pins.clear();
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
        'linkingCode': randomNumber().toString()
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
          {"id": 2, "name": "cashier"}
        ],
        "businesses": [business.toJson()],
        "branches": [branch.toJson()]
      }),
    );
    if (response.statusCode == 200) {
      JTenant jTenant = jTenantFromJson(response.body);
      ITenant iTenant = ITenant(
          id: randomNumber(),
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          userId: jTenant.userId,
          nfcEnabled: jTenant.nfcEnabled,
          phoneNumber: jTenant.phoneNumber);

      iisar.write((isar) {
        isar.business.putAll(jTenant.businesses);
        isar.branchs.putAll(jTenant.branches);
        isar.permissions.putAll(jTenant.permissions);
      });
      iisar.write((isar) {
        isar.iTenants.put(iTenant);
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

        iisar.write((isar) {
          isar.business.putAll(jTenant.businesses);
        });
        iisar.write((isar) {
          isar.branchs.putAll(jTenant.branches);
        });
        iisar.write((isar) {
          isar.permissions.putAll(jTenant.permissions);
        });
        iisar.write((isar) {
          isar.iTenants.put(iTenant);
        });
      }
      return jListTenantFromJson(response.body);
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup}) async {
    String phoneNumber = userPhone;
    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }

    final response = await flipperHttpClient.post(
      Uri.parse(apihub + '/v2/api/user'),
      body: jsonEncode(
        <String, String>{'phoneNumber': phoneNumber},
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

        iisar.write((isar) async {
          return isar.business.putAll(tenant.businesses);
        });
        iisar.write((isar) async {
          return isar.branchs.putAll(tenant.branches);
        });
        iisar.write((isar) async {
          return isar.permissions.putAll(tenant.permissions);
        });
        iisar.write((isar) async {
          return isar.iTenants.put(iTenant);
        });
      }
      return syncF;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      throw Exception(response);
    }
  }

  @override
  Future<Transaction?> pendingTransaction({required int branchId}) async {
    return iisar.transactions
        .where()
        .statusEqualTo(pendingStatus)
        .and()
        .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    return iisar.variants
        .where()
        .productIdEqualTo(productId)
        .deletedAtIsNull()
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Product>> productStreams({required int branchId}) {
    return iisar.products
        .where()
        .branchIdEqualTo(branchId)
        .deletedAtIsNull()
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Discount>> discountStreams({required int branchId}) {
    return iisar.discounts
        .where()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<Profile?> profile({required int businessId}) async {
    return iisar.write((isar) {
      return isar.profiles.where().businessIdEqualTo(businessId).findFirst();
    });
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) async {
    //save discount into isar db
    iisar.write((isar) {
      Discount discount = Discount(
        amount: amount,
        id: randomString(),
        branchId: branchId,
        name: name,
      );
      isar.discounts.put(discount);
    });
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
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
  Future<Stock?> stockByVariantId({required String variantId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return iisar.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required String variantId}) {
    return iisar.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<List<Stock?>> stocks({required String productId}) async {
    return iisar.write((isar) {
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
  Future<List<Transaction>> tickets() async {
    return iisar.write((isar) {
      return isar.transactions
          .where()
          .statusEqualTo(parkedStatus)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .build()
          .findAll();
    });
  }

  @override
  Stream<List<Transaction>> ticketsStreams() {
    log(ProxyService.box.getBranchId()!.toString(), name: "ticketsStreams()");
    return iisar.transactions
        .where()
        .statusEqualTo(parkedStatus)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return iisar.write((isar) {
      return isar.iUnits.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<T?> create<T>({required T data}) async {
    if (data is Conversation) {
      Conversation conversation = data;
      iisar.write((isar) {
        isar.conversations.put(conversation);
        // Return the created conversation
      }); // Cast the result to type T
      return iisar.conversations.get(conversation.id) as T;
    }

    if (data is PColor) {
      PColor color = data;
      iisar.write((isar) {
        for (String colorName in data.colors!) {
          isar.pColors.put(PColor(
              id: randomString(),
              lastTouched: DateTime.now(),
              action: AppActions.create,
              name: colorName,
              active: color.active,
              branchId: color.branchId));
        }
      });
    }
    if (data is Device) {
      Device device = data;
      iisar.write((isar) {
        isar.devices.put(device);
      });
      return Future.value(null);
    }
    if (data is Conversation) {
      Conversation conversation = data;
      iisar.write((isar) {
        isar.conversations.put(conversation);
      });
      return Future.value(null);
    }
    if (data is Category) {
      Category category = data;
      iisar.write((isar) {
        isar.categorys.put(category);
      });
      return Future.value(null);
    }
    if (data is Product) {
      iisar.write((isar) {
        return isar.products.put(data);
      });
    }
    if (data is Variant) {
      iisar.write((isar) {
        isar.variants.put(data);
      });
      return Future.value(null);
    }
    if (data is Favorite) {
      iisar.write((isar) {
        isar.favorites.put(data);
      });
      return Future.value(null);
    }
    if (data is Stock) {
      iisar.write((isar) {
        isar.stocks.put(data);
      });
      return Future.value(null);
    }
    if (data is Social) {
      iisar.write((isar) {
        isar.socials.put(data);
      });
      return Future.value(null);
    }
    if (data is Token) {
      iisar.write((isar) {
        isar.tokens.put(data);
      });
      return Future.value(null);
    }
    if (data is Setting) {
      iisar.write((isar) {
        isar.settings.put(data);
      });
      return Future.value(null);
    }
    if (data is EBM) {
      iisar.write((isar) {
        isar.eBMs.put(data);
      });
      return Future.value(null);
    }
    if (data is Transaction) {
      iisar.write((isar) {
        isar.transactions.put(data);
      });
      return Future.value(null);
    }
    if (data is TransactionItem) {
      iisar.write((isar) {
        isar.transactionItems.put(data);
      });
      return Future.value(null);
    }
    return Future.value(null);
  }

  /// @Deprecated [endpoint] don't give the endpoint params
  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Device) {
      Device device = data;

      iisar.write((isar) {
        isar.devices.put(device);
      });
    }
    if (data is Social) {
      Social social = data;

      iisar.write((isar) {
        isar.socials.put(social);
      });
    }
    if (data is Product) {
      Product product = data;

      iisar.write((isar) {
        isar.products.put(product);
      });
    }
    if (data is Favorite) {
      Favorite fav = data;
      iisar.write((isar) {
        isar.favorites.put(fav);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      iisar.write((isar) {
        isar.variants.put(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
      iisar.write((isar) {
        isar.stocks.put(stock);
      });
    }
    if (data is Transaction) {
      final transaction = data;
      iisar.write((isar) {
        isar.transactions.put(transaction);
      });
    }
    if (data is Category) {
      final transaction = data;
      iisar.write((isar) {
        isar.categorys.put(transaction);
      });
    }
    if (data is IUnit) {
      final unit = data;
      iisar.write((isar) {
        isar.iUnits.put(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      iisar.write((isar) {
        isar.pColors.put(color);
      });
    }
    if (data is TransactionItem) {
      iisar.write((isar) {
        isar.transactionItems.put(data);
      });
    }
    if (data is EBM) {
      final ebm = data;
      iisar.write((isar) async {
        ProxyService.box.write(key: "serverUrl", value: ebm.taxServerUrl);
        Business? business =
            await isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        isar.business.put(business!);
      });
    }
    if (data is Token) {
      final token = data;
      token
        ..token = token.token
        ..businessId = token.businessId
        ..type = token.type;
      iisar.tokens.put(token);
    }
    if (data is Business) {
      final business = data;
      iisar.write((isar) async {
        isar.business.put(business);
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
      iisar.write((isar) async {
        isar.branchs.put(data);
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
      iisar.write((isar) async {
        return isar.counters.put(data..backed = false);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/counter/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode == 200) {
        JCounter jCounter = jSingleCounterFromJson(response.body);
        iisar.write((isar) async {
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
      iisar.write((isar) async {
        isar.branchs.put(data);
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
      iisar.write((isar) async {
        isar.drawers.put(drawer);
      });
    }
    if (data is ITenant) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/tenant/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode == 200) {
        iisar.write((isar) async {
          isar.iTenants.put(data);
        });
      }
      return null;
    }
    return null;
  }

  @override
  Future<Profile?> updateProfile({required Profile profile}) async {
    //TODOcheck if the profile is propery updated.
    iisar.write((isar) async {
      isar.profiles.put(profile);
    });
    return iisar.profiles.get(profile.id);
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
  Future<Variant?> variant({required String variantId}) async {
    return iisar.variants.get(variantId);
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, required String productId}) async {
    return iisar.variants.where().productIdEqualTo(productId).findAll();
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
  Future<List<Transaction>> weeklyTransactionsReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) async {
    // throw UnimplementedError();
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<Transaction> pastTransactions = [];
    return iisar.write((isar) async {
      for (DateTime date in weekDates) {
        List<Transaction> transactions = isar.transactions
            .where()
            .branchIdEqualTo(branchId)
            .findAll()
            .where((transaction) =>
                DateTime.parse(transaction.createdAt).difference(date).inDays >=
                -7)
            .toList();
        if (transactions.isNotEmpty) {
          for (var i = 0; i < transactions.length; i++) {
            //is transactions[i] does not exist in pastTransactions then we add it in the list
            pastTransactions.add(transactions[i]);
          }
        }
      }
      Map<String, Transaction> mp = {};
      for (var item in pastTransactions) {
        mp[item.transactionNumber] = item;
      }
      return Future.value(mp.values.toList());
    });
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) {
    return iisar.write((isar) async {
      return await isar.products.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    // get all categories from isar db
    return iisar.write((isar) async {
      return isar.categorys.where().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  Stream<List<Category>> categoriesStream({required int branchId}) {
    log(branchId.toString(), name: "load stream of categoris");
    return iisar.categorys
        .where()
        .branchIdEqualTo(branchId)
        .watch(fireImmediately: true);
  }

  @override
  Future<Variant?> getVariantById({required String id}) async {
    return iisar.variants.get(id);
  }

  @override
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required Transaction transaction,
      required String qrCode,
      required Counter counter,
      required String receiptType}) {
    return iisar.write((isar) async {
      Receipt receipt = Receipt()
        ..resultCd = signature.resultCd
        ..id = randomString()
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
        ..transactionId = transaction.id
        ..resultDt = signature.resultDt;
      isar.receipts.put(receipt);
      // get receipt from isar db
      return isar.receipts.get(receipt.id);
    });
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) {
    return iisar.write((isar) async {
      return await isar.receipts
          .where()
          .transactionIdEqualTo(transactionId)
          .findFirst();
    });
  }

  @override
  Future<void> refund({required String itemId}) async {
    return iisar.write((isar) async {
      TransactionItem? item = await isar.transactionItems.get(itemId);
      item!.isRefunded = true;
      isar.transactionItems.put(item);
    });
  }

  @override
  Future<bool> isDrawerOpen({required int cashierId}) async {
    Drawers? drawer = iisar.drawers
        .where()
        .openEqualTo(true)
        .and()
        .cashierIdEqualTo(cashierId)
        .findFirst();
    return drawer != null;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    Drawers? drawer = iisar.drawers
        .where()
        .openEqualTo(true)
        .and()
        .cashierIdEqualTo(cashierId)
        .findFirst();
    return drawer;
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) async {
    // save drawer object in isar db
    iisar.write((isar) async {
      isar.drawers.put(drawer);
    });
    return iisar.drawers.get(drawer.id);
  }

  @override
  Future<int> size<T>({required T object}) async {
    if (object is Product) {
      return iisar.products.getSize(includeIndexes: true);
    }
    if (object is Variant) {
      return iisar.variants.getSize(includeIndexes: true);
    }
    if (object is Stock) {
      return iisar.stocks.getSize(includeIndexes: true);
    }
    if (object is Counter) {
      return iisar.counters.getSize(includeIndexes: true);
    }
    return 0;
  }

  @override
  Future<List<ITenant>> tenants({required int businessId}) async {
    return iisar.iTenants.where().businessIdEqualTo(businessId).findAll();
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

        iisar.write((isar) async {
          isar.business.putAll(jTenant.businesses);
          isar.branchs.putAll(jTenant.branches);
          isar.permissions.putAll(jTenant.permissions);
        });
        iisar.write((isar) async {
          isar.iTenants.put(iTenant);
        });
      }
      return iisar.iTenants.where().businessIdEqualTo(businessId).findAll();
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Branch?> defaultBranch() async {
    return iisar.branchs.where().isDefaultEqualTo(true).findFirst();
  }

  @override
  Future<Business?> defaultBusiness() async {
    return iisar.business.where().isDefaultEqualTo(true).findFirst();
  }

  @override
  Future<Counter?> cSCounter({required int branchId}) async {
    return iisar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.cs)
        .findFirst();
  }

  @override
  Future<Counter?> nRSCounter({required int branchId}) async {
    return iisar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.nr)
        .findFirst();
  }

  @override
  Future<Counter?> nSCounter({required int branchId}) async {
    return iisar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo("ns")
        .findFirst();
  }

  @override
  Future<Counter?> pSCounter({required int branchId}) async {
    return iisar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ps)
        .findFirst();
  }

  @override
  Future<Counter?> tSCounter({required int branchId}) async {
    return iisar.counters
        .where()
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
        iisar.write((isar) async {
          return isar.counters.put(Counter(id: randomString())
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
    return iisar.write((isar) async {
      return isar.counters.where().backedEqualTo(false).findAll();
    });
  }

  @override
  String dbPath() {
    return iisar.directory;
  }
  // You can either directly export the entire database file with the isar.copyToFile() method, or you can use collection.where().exportJson() to export a query result to json
  // @override
  // String public() {
  //   // return isar.j
  // }

  @override
  Future<bool> bindProduct(
      {required String productId, required int tenantId}) async {
    return iisar.write((isar) async {
      final product = await isar.products.get(productId);
      product!.nfcEnabled = true;
      product.bindedToTenantId = tenantId;
      isar.products.put(product);
      return true;
    });
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    return iisar.products.where().bindedToTenantIdEqualTo(tenantId).findFirst();
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return iisar.write((isar) async {
      return await isar.products.where().branchIdEqualTo(branchId).findAll();
    });
  }

// https://pub.dev/packages/excel
  @override
  Future<List<Transaction>> completedTransactions(
      {required int branchId, String? status = completeStatus}) async {
    return iisar.transactions
        .where()
        // .statusBranchIdEqualTo(status!, branchId)
        .statusEqualTo(status!)
        .and()
        .branchIdEqualTo(branchId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Stream<List<Transaction>> localCompletedTransactions() {
    String status = completeStatus;
    int branchId = ProxyService.box.getBranchId()!;
    return iisar.transactions
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .statusEqualTo(status)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true);
  }

  /// Do not call this function in production
  @override
  Future<void> deleteAllProducts() async {
    List<Product> products =
        await productsFuture(branchId: ProxyService.box.getBranchId()!);
    List<String> productIds = products.map((product) => product.id).toList();
    iisar.write((isar) async {
      isar.products.deleteAll(productIds);
    });
  }

  @override
  Future<Stock?> getStockById({required String id}) async {
    return iisar.stocks.get(id);
  }

  @override
  Stream<Social> socialsStream({required int branchId}) {
    log("socialsStream called", name: "${branchId}");
    return iisar.socials
        .where()
        .branchIdEqualTo(branchId)
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
  Future<Social?> getSocialById({required String id}) async {
    return iisar.socials.get(id);
  }

  /// Given businessId return if there is any social account set for this business
  /// this will give us enough confidence that we can authenticate social api as there is
  /// probably one account set which means we can get bearer token if we authenticate with service
  @override
  Future<List<Social>> activesocialAccounts({required int branchId}) async {
    return iisar.socials
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .isAccountSetEqualTo(true)
        .findAll();
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    if (ProxyService.box.getUserPhone() == null) return Stream.empty();
    final phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
    log(phone, name: "top5Conversations");
    return iisar.conversations
        .where()
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

      // Sort conversations by creation date in descending transaction
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
      return iisar.conversations
          .where()
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
      return iisar.conversations
          .where()
          .conversationIdEqualTo(conversationId)
          .build()
          .watch(fireImmediately: true);
    }
  }

  final appService = loc.locator<AppService>();
  @override
  Future<List<Conversation>> getScheduleMessages() async {
    return iisar.conversations
        .where()
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
        message.businessPhoneNumber =
            ProxyService.box.getUserPhone()!.replaceAll("+", "");
        iisar.write((isar) async {
          isar.conversations.put(message);
        });
      } else {
        // this means there is no credit
        throw Exception(
            'Error sending scheduled message${response.body}${response.statusCode}');
      }
    }
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) async {
    return iisar.conversations.where().messageIdEqualTo(messageId).findFirst();
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
    final token = iisar.tokens
        .where()
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
      iisar.write((isar) => isar.tokens.delete(token.id));
      return false;
    }
    String? localToken = ProxyService.box.whatsAppToken();
    if (localToken == null) {
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

  /// Retrieves the social setting asynchronously.
  ///
  /// This function retrieves the social setting based on the user's phone number.
  /// If the user's phone number is not available, it returns `null`.
  /// It first checks if the setting is available in the `isar.settings` database using the user's phone number.
  /// If the setting is found, it returns the setting.
  /// If the setting is not found in the database, it makes an HTTP GET request to the socialsHttpClient
  /// to fetch the setting from the specified API endpoint.
  /// If the HTTP response status code is 200, it converts the response body to a `Setting` object
  /// using `Setting.fromJson()` and then saves it using the `create()` function.
  /// Finally, it returns the fetched or created setting.
  /// If the HTTP response status code is not 200, it throws an exception with a descriptive error message.
  ///
  /// Returns:
  ///   - A `Future` of type `Setting?` representing the retrieved social setting.
  ///     If the user's phone number is not available, it returns `null`.
  ///
  /// Throws:
  ///   - An `Exception` with an error message if the HTTP response status code is not 200.
  ///     The error message includes the response body and the user's phone number.

  @override
  Future<Setting?> getSocialSetting() async {
    String? phoneNumber = ProxyService.box.getUserPhone();
    if (phoneNumber == null) {
      return null;
    }

    final number = phoneNumber.replaceAll("+", "");

    Setting? setting =
        iisar.settings.where().businessPhoneNumberEqualTo(number).findFirst();

    if (setting != null) {
      return setting;
    }
    Future.delayed(Duration(seconds: 20));
    final Uri uri = Uri.parse("$commApi/settings/$number");
    final http.Response response = await socialsHttpClient.get(uri);

    if (response.statusCode == 200) {
      Setting setting = Setting.fromJson(jsonDecode(response.body));
      create(data: setting);
      return setting;
    } else {
      throw Exception("Can't get social setting ${response.body}${number}");
    }
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) async {
    /// a hack to delay 20 seconds for theserver to not return forbidden as we have called the aws api before
    /// so we need to wait 20 seconds to make another call, I will need to investigate on server later
    // await Future.delayed(Duration(seconds: 20));
    int businessId = ProxyService.box.getBusinessId()!;
    final http.Response response = await socialsHttpClient.patch(
        Uri.parse("$commApi/settings"),
        body: json.encode(
            {"businessId": businessId, "deviceToken": setting.deviceToken}));
    // convert response to Setting
    if (response.statusCode != 200 && response.statusCode != 403) {
      throw Exception(
          "Can't  patch  settings patch ${response.body}${setting.toJson()}");
    }
  }

  @override
  Future<Device?> getDevice({required String phone}) async {
    // get device from isar with linking code and return it
    return iisar.devices.where().phoneEqualTo(phone).build().findFirst();
  }

  @override
  Future<Device?> getDeviceById({required String id}) async {
    // get device from isar with linking code and return it
    return iisar.devices.where().idEqualTo(id).build().findFirst();
  }

  @override
  Stream<List<Device>> getDevices({required int businessId}) {
    // get device from isar with linking code and return it
    return iisar.devices
        .where()
        .businessIdEqualTo(businessId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) async {
    return iisar.devices
        .where()
        .businessIdEqualTo(businessId)
        .and()
        .pubNubPublishedEqualTo(false)
        .build()
        .findAll();
  }

  @override
  Stream<Business> businessStream({required int businessId}) {
    return iisar.business
        .where()
        .idEqualTo(businessId)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<ITenant?> getTenantBYUserId({required int userId}) async {
    return iisar.iTenants.where().userIdEqualTo(userId).build().findFirst();
  }

  /// Loads conversations from the server for a given business ID.
  ///
  /// The [businessId] parameter is required and specifies the ID of the business
  /// for which conversations should be loaded.
  ///
  /// The [pageSize] parameter determines the number of conversations to retrieve
  /// per page. If not provided, a default value of 10 is used.
  ///
  /// The [pk] and [sk] parameters allow for pagination and retrieving conversations
  /// starting from a specific point in the conversation history.
  ///
  /// This function makes an HTTP request to the server, retrieves the conversations,
  /// and stores them in a local database for future reference.
  ///
  /// Note: This function assumes a successful HTTP response with a status code of 200.
  /// Errors during the request or JSON parsing are not handled in this implementation.
  ///
  /// Example usage:
  /// ```
  /// await loadConversations(businessId: 123, pageSize: 20);
  /// ```
  @override
  Future<void> loadConversations(
      {required int businessId,
      int? pageSize = 1000,
      String? pk,
      String? sk}) async {
    String? paginationCreatedAt = ProxyService.box.paginationCreatedAt();
    int? paginationId = ProxyService.box.paginationId();

    final response = await socialsHttpClient.get(Uri.parse(
        '${commApi}/messages/${businessId}?pageSize=${pageSize}&createdAt=${paginationCreatedAt}&id=${paginationId}'));

    if (response.statusCode == 200) {
      final messagesJson = jsonDecode(response.body)['messages'];
      if (messagesJson == null) return;
      List<Conversation> messages = (messagesJson as List<dynamic>)
          .map((e) => Conversation.fromJson(e))
          .toList();

      for (Conversation conversation in messages) {
        Conversation? localConversation =
            await getConversation(messageId: conversation.messageId!);
        // if date is improperly formatted then format it right
        // the bellow date format will be like 5th May converter
        DateTime createdAt;
        try {
          createdAt = DateTime.parse(conversation.createdAt!);
        } on FormatException {
          /// in case it fail to format set fake date
          createdAt = DateTime.now();
        }
        conversation.createdAt = createdAt.toIso8601String();
        conversation.avatar = HtmlUnescape().convert(conversation.avatar);
        if (localConversation == null) {
          conversation.businessPhoneNumber =
              conversation.businessPhoneNumber == null
                  ? ProxyService.box.getUserPhone()!.replaceAll("+", "")
                  : conversation.businessPhoneNumber;
          await create(data: conversation);
        }
      }

      if (jsonDecode(response.body)['lastEvaluatedKey'] != null) {
        // Set lastKey to the value returned by the API
        String createdAt = jsonDecode(response.body)['lastEvaluatedKey']
            ['createdAt'] as String;
        int id = jsonDecode(response.body)['lastEvaluatedKey']['id'] as int;
        ProxyService.box.write(key: 'createdAt', value: createdAt);
        ProxyService.box.write(key: 'id', value: id);
      } else {
        log(jsonDecode(response.body).toString());
        log("there is no last key to use in query and that is fine!");
      }
    } else {
      print(response.statusCode);
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
  Future<List<TransactionItem>> transactionItems(
      {required String transactionId,
      required bool doneWithTransaction}) async {
    return iisar.transactionItems
        .where()
        .transactionIdEqualTo(transactionId)
        .and()
        .doneWithTransactionEqualTo(doneWithTransaction)
        .findAll();
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStream() {
    return pendingTransactionStream().asyncMap((transaction) async {
      if (transaction != null) {
        final items = iisar.transactionItems
            .where()
            .transactionIdEqualTo(transaction.id)
            .findAll();
        return items;
      } else {
        return <TransactionItem>[];
      }
    });
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Stock stock = Stock(
        lastTouched: DateTime.now(),
        id: randomString(),
        action: 'create',
        branchId: branchId,
        variantId: variant.id,
        currentStock: 0.0,
        productId: variant.productId)
      ..canTrackingStock = false
      ..showLowStockAlert = false
      ..currentStock = 0.0
      ..branchId = branchId
      ..variantId = variant.id
      ..supplyPrice = 0.0
      ..retailPrice = 0.0
      ..lowStock = 10.0 // default static
      ..canTrackingStock = true
      ..showLowStockAlert = true
      ..active = false
      ..productId = variant.productId
      ..rsdQty = 0.0;

    return iisar.write((isar) async {
      isar.stocks.put(stock);
      return await isar.stocks.get(stock.id);
    });
  }

  @override
  Future<Conversation> sendMessage(
      {required String message,
      required Conversation latestConversation}) async {
    final reply = Conversation(
      avatar: "https://yegobox-flipper.s3.eu-west-2.amazonaws.com/lRsBL.png",
      body: message,
      channelType: "whatsapp",

      /// always from number is the user phone number i.e the business phone number
      /// this number need to be enabled on whatsapp business to use whatsapp api
      fromNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),

      /// the phone number of a user who sent the message to the business, this is the number
      /// and this does not have to be registered on flipper but check to see if this from is not us
      toNumber: latestConversation.fromNumber,
      userName: latestConversation.userName,
      messageId: latestConversation.messageId,
      conversationId: latestConversation.conversationId,
      phoneNumberId: latestConversation.phoneNumberId,
      delivered: false,
      createdAt: DateTime.now().toString(),
      // now add 5 seconds to the current time
      scheduledAt: DateTime.now().add(const Duration(seconds: 5)),
      businessPhoneNumber: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
      messageType: "text",
      businessId: ProxyService.box.getBusinessId()!,
    );
    return await create(data: reply) as Conversation;
  }

  @override
  Future<EBM?> getEbmByBranchId({required int branchId}) async {
    return iisar.eBMs.where().branchIdEqualTo(branchId).findFirst();
  }

  @override
  Future<
      ({
        List<Stock> stocks,
        List<Variant> variants,
        List<Product> products,
        List<Favorite> favorites,
        List<Device> devices,
        List<Transaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData() async {
    List<Stock> stocks = iisar.stocks
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .actionIsNotEmpty()
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<Variant> variants = iisar.variants
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<Product> products = iisar.products
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<Favorite> favorites = iisar.favorites
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<Device> devices = iisar.devices
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<Transaction> transactions = iisar.transactions
        .where()
        .statusEqualTo(completeStatus)
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll();
    List<TransactionItem> transactionItems = iisar.transactionItems
        .where()
        .lastTouchedIsNull()
        .or()
        .actionEqualTo(AppActions.update)
        .or()
        .actionEqualTo(AppActions.create)
        .or()
        .actionEqualTo(AppActions.deleted)
        .findAll();
    return (
      stocks: stocks,
      variants: variants,
      products: products,
      favorites: favorites,
      devices: devices,
      transactions: transactions,
      transactionItems: transactionItems
    );
  }
}
