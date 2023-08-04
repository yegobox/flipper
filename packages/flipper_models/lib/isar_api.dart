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
  late Isar isar;
  Future<IsarApiInterface> getInstance({Isar? iisar}) async {
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
    if (iisar == null) {
      isar = await Isar.open(
        // compactOnLaunch:
        // CompactCondition(minBytes: 100, minFileSize: 100, minRatio: 2.0),
        [
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
        directory: appDocDir.path,
      );
    } else {
      isar = iisar;
    }
    return this;
  }

  @override
  Future<Customer?> addCustomer(
      {required Map customer, required int transactionId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    Customer kCustomer = Customer(
        name: customer['name'],
        action: AppActions.create,
        tinNumber: customer['tinNumber'],
        email: customer['email'],
        phone: customer['phone'],
        address: customer['address'],
        updatedAt: DateTime.now(),
        branchId: branchId);
    Customer? kcustomer = await isar.writeTxn(() async {
      int id = await isar.customers.put(kCustomer);
      return await isar.customers.get(id);
    });
    Transaction? transaction = await isar.writeTxn(() async {
      return await isar.transactions.get(transactionId);
    });
    transaction!.customerId = kcustomer!.id;
    // update the transaction with the customerID
    await update(data: transaction);
    return kcustomer;
  }

  /// this method is one way i.e we get to know local unsynched changes
  /// then we send them but we are not working on the changes after this push.
  /// those change will stay on local, so I need to work on them as well.

  @override
  Stream<Transaction?> completedTransactionsStream(
      {required String status, required int branchId}) {
    return isar.transactions
        .filter()
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
    return isar.transactions
        .where()
        .statusBranchIdEqualTo(pendingStatus, branchId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Stream<Transaction?> pendingTransactionStream() {
    int branchId = ProxyService.box.getBranchId()!;
    return isar.transactions
        .filter()
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
      final transaction = Transaction(
        id: syncIdInt(),
        reference: syncId(),
        action: AppActions.create,
        transactionNumber: syncId(),
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
      Transaction? createdTransaction = await isar.writeTxn(() async {
        int id = await isar.transactions.put(transaction);
        ProxyService.box.write(key: 'currentTransactionId', value: id);
        return await isar.transactions.get(id);
      });
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
      final transaction = Transaction(
        id: syncIdInt(),
        reference: syncId(),
        action: AppActions.create,
        transactionNumber: syncId(),
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
      Transaction? createdTransaction = await isar.writeTxn(() async {
        int id = await isar.transactions.put(transaction);
        ProxyService.box.write(key: 'currentTransactionId', value: id);
        return await isar.transactions.get(id);
      });
      return createdTransaction!;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<void> addTransactionItem(
      {required Transaction transaction, required TransactionItem item}) async {
    return isar.writeTxn(() async {
      await isar.transactionItems.put(item);
    });
  }

  // get point where userId = userId from db
  @override
  Pointss addPoint({required int userId, required int point}) {
    return isar.pointss.filter().userIdEqualTo(userId).findFirstSync()!;
  }

  @override
  Future<Transaction?> getTransactionById({required int id}) async {
    return await isar.transactions.get(id);
  }

  //Delete a favorite
  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(transactionIndex);
      return Future.value(200);
    });
    return Future.value(403);
  }

  @override
  Stream<List<Transaction>> getTransactionsByCustomerId(
      {required int customerId}) async* {
    yield* await isar.transactions
        .where()
        .filter()
        .customerIdEqualTo(customerId)
        .watch();
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    Stream<List<Transaction>> transactions =
        isar.transactions.where().build().watch(fireImmediately: true);

    return transactions;
  }

  @override
  Stream<List<Transaction>> getLocalTransactionsStream() {
    final branchId = ProxyService.box.getBranchId()!;
    Stream<List<Transaction>> transactions = isar.transactions
        .where()
        .filter()
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
    return transactions;
  }

  @override
  Stream<List<Transaction>> getCompletedTransactions() {
    Stream<List<Transaction>> completedTransactions = isar.transactions
        .where()
        .filter()
        .statusEqualTo(completeStatus)
        .sortByCreatedAtDesc()
        .build()
        .watch(fireImmediately: true);
    return completedTransactions;
  }

  @override
  Stream<List<Transaction>> getLocalCashInTransactions() {
    final branchId = ProxyService.box.getBranchId()!;
    Stream<List<Transaction>> localCashInTransactions = isar.transactions
        .where()
        .filter()
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
    Stream<List<Transaction>> cashInTransactions = isar.transactions
        .filter()
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
    Stream<List<Transaction>> localCashOutTransactions = isar.transactions
        .filter()
        .statusEqualTo(completeStatus)
        .transactionTypeEqualTo('Cash Out')
        .branchIdEqualTo(branchId)
        .build()
        .watch(fireImmediately: true);
    return localCashOutTransactions;
  }

  @override
  Stream<List<Transaction>> getCashOutTransactions() {
    Stream<List<Transaction>> cashOutTransactions = isar.transactions
        .filter()
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
    List<Transaction> cashIn = await isar.transactions
        .where()
        .filter()
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

    List<Transaction> cashOut = await isar.transactions
        .where()
        .filter()
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
    List<Transaction> cashIn = await isar.transactions
        .where()
        .filter()
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

    List<Transaction> cashOut = await isar.transactions
        .where()
        .filter()
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
    Favorite? fav = await isar.favorites.getByFavIndex(data.favIndex!);
    if (fav == null) {
      await isar.writeTxn(() async {
        await isar.favorites.put(data);
      });
      return Future.value(200);
    } else {
      fav.productId = data.productId;
      await isar.writeTxn(() async {
        await isar.favorites.put(fav);
      });
      return Future.value(200);
    }
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

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    return isar.favorites
        .filter()
        .favIndexEqualTo(favIndex)
        .deletedAtIsNull()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<Product?> getProduct({required int id}) async {
    return await isar.products.get(id);
  }

  Stream<Product> getProductStream({required int prodIndex}) {
    return isar.products
        .filter()
        .idEqualTo(prodIndex)
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
    Favorite? favorite =
        await isar.favorites.filter().productIdEqualTo(prodId).findFirst();
    return favorite;
  }

  //Delete a favorite
  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) async {
    await isar.writeTxn(() async {
      await isar.favorites.deleteByFavIndex(favIndex);
      return Future.value(200);
    });
    return Future.value(403);
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
  Future assingTransactionToCustomer(
      {required int customerId, required int transactionId}) async {
    // get transaction where id = transactionId from db
    Transaction? transaction =
        await isar.transactions.filter().idEqualTo(transactionId).findFirst();

    transaction!.customerId = customerId;
    // update transaction to db
    await isar.writeTxn(() async {
      int id = await isar.transactions.put(transaction);
      return isar.transactions.get(id);
    });
    // get customer where id = customerId from db
    //// and updat this customer with timestamp so it can trigger change!.
    Customer? customer = await isar.customers.get(customerId);
    customer!.updatedAt = DateTime.now();
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
        transactionId: transaction.id!, doneWithTransaction: false);

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
    return isar.writeTxn(() async {
      return isar.pColors.filter().branchIdEqualTo(branchId).findAll();
    });
  }

  @override
  void consumePoints({required int userId, required int points}) async {
    // get Points where userId = userId from db
    // and update this Points with new points
    Pointss? po = await isar.pointss.filter().userIdEqualTo(userId).findFirst();
    //po ??= Points(userId: userId, points: 0, value: 0);
    // save po to db
    po!.value = po.value - points;
    await isar.writeTxn(() async {
      int id = await isar.pointss.put(po);
      return isar.pointss.getSync(id)!;
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
      Pin pin = Pin.fromJson(json.decode(response.body));

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
  Future<bool> delete({required int id, String? endPoint}) async {
    final DateTime deletionTime = DateTime.now();

    switch (endPoint) {
      case 'color':
        await isar.writeTxn(() async {
          PColor? color = await isar.pColors.get(id);
          if (color != null) {
            color.deletedAt = deletionTime;
            color.action = AppActions.deleted;
            await isar.pColors.put(color);
            return true;
          }
          return false;
        });
        break;
      case 'device':
        await isar.writeTxn(() async {
          Device? device = await isar.devices.get(id);
          if (device != null) {
            device.deletedAt = deletionTime;
            device.action = AppActions.deleted;
            await isar.devices.put(device);
            return true;
          }
          return false;
        });
        break;
      case 'category':
        await isar.writeTxn(() async {
          Category? category = await isar.categorys.get(id);
          if (category != null) {
            category.deletedAt = deletionTime;
            category.action = AppActions.deleted;
            await isar.categorys.put(category);
            return true;
          }
          return false;
        });
        break;
      case 'product':
        await isar.writeTxn(() async {
          Product? product = await isar.products.get(id);
          if (product != null) {
            product.deletedAt = deletionTime;
            product.action = AppActions.deleted;
            await isar.products.put(product);
            return true;
          }
          return false;
        });
        break;
      case 'variant':
        await isar.writeTxn(() async {
          Variant? variant = await isar.variants.get(id);
          if (variant != null) {
            variant.deletedAt = deletionTime;
            variant.action = AppActions.deleted;
            await isar.variants.put(variant);
            return true;
          }
          return false;
        });
        break;
      case 'stock':
        await isar.writeTxn(() async {
          Stock? stocks = await isar.stocks.get(id);
          if (stocks != null) {
            stocks.deletedAt = deletionTime;
            stocks.action = AppActions.deleted;
            await isar.stocks.put(stocks);
            return true;
          }
          return false;
        });
        break;
      case 'setting':
        await isar.writeTxn(() async {
          Setting? setting = await isar.settings.get(id);
          if (setting != null) {
            setting.deletedAt = deletionTime;
            setting.action = AppActions.deleted;
            await isar.settings.put(setting);
            return true;
          }
          return false;
        });
        break;
      case 'pin':
        await isar.writeTxn(() async {
          Pin? pin = await isar.pins.get(id);
          if (pin != null) {
            pin.deletedAt = deletionTime;
            pin.action = AppActions.deleted;
            await isar.pins.put(pin);
            return true;
          }
          return false;
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
      case 'transactionItem':
        isar.writeTxn(() async {
          await isar.transactionItems.delete(id);
          return true;
        });
        break;
      case 'customer':
        await isar.writeTxn(() async {
          Customer? customer = await isar.customers.get(id);
          if (customer != null) {
            customer.deletedAt = deletionTime;
            customer.action = AppActions.deleted;
            await isar.customers.put(customer);
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
      if (await ProxyService.isar.isTaxEnabled()) {
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
        .and()
        .deletedAtIsNull()
        .build()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<Customer?> getCustomerByTransactionId({required int id}) {
    return isar.customers
        .watchObject(id, fireImmediately: true)
        .asyncMap((event) => event);
  }

  @override
  Future<Customer?> nGetCustomerByTransactionId({required int id}) async {
    Transaction? transaction = await isar.transactions.get(id);
    if (transaction == null) {
      return null;
    }
    Customer? customer = await isar.customers.get(transaction.customerId!);
    return customer;
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
      return isar.business
          .get(Business.fromJson(json.decode(response.body)).id!);
    });

    if (business == null) {
      await isar.writeTxn(() async {
        return isar.business.put(Business.fromJson(json.decode(response.body)));
      });
      business = await isar.writeTxn(() {
        return isar.business.filter().userIdEqualTo(userId).findFirst();
      });
    }
    ProxyService.box.write(key: 'businessId', value: business!.id);

    return business;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) async {
    return await isar.transactionItems.get(id);
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId}) async {
    return isar.transactionItems
        .where()
        .variantIdTransactionIdEqualTo(variantId, transactionId ?? 0)
        .findFirst();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) async {
    return isar.transactionItems
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
  Future<Pointss?> getPoints({required int userId}) {
    return isar.writeTxn(() {
      return isar.pointss.where().userIdEqualTo(userId).findFirst();
    });
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
          {"id": 2, "name": "cashier"}
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
      throw Exception(response);
    }
  }

  @override
  Future<Transaction?> pendingTransaction({required int branchId}) async {
    return await isar.transactions
        .where()
        .statusBranchIdEqualTo(pendingStatus, branchId)
        .findFirst();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    return isar.variants
        .filter()
        .productIdEqualTo(productId)
        .deletedAtIsNull()
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Product>> productStreams({required int branchId}) {
    return isar.products
        .filter()
        .branchIdEqualTo(branchId)
        .deletedAtIsNull()
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
  Future<List<Transaction>> tickets() async {
    return isar.writeTxn(() {
      return isar.transactions
          .where()
          .statusBranchIdEqualTo(parkedStatus, ProxyService.box.getBranchId()!)
          .build()
          .findAll();
    });
  }

  @override
  Stream<List<Transaction>> ticketsStreams() {
    log(ProxyService.box.getBranchId()!.toString(), name: "ticketsStreams()");
    return isar.transactions
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
    if (data is Conversation) {
      Conversation conversation = data;
      return await isar.writeTxn(() async {
        int id = await isar.conversations.put(conversation);
        return isar.conversations.get(id); // Return the created conversation
      }) as T; // Cast the result to type T
    }

    if (data is PColor) {
      PColor color = data;
      isar.writeTxn(() async {
        for (String colorName in data.colors!) {
          await isar.pColors.put(PColor(
              action: AppActions.create,
              name: colorName,
              active: color.active,
              branchId: color.branchId));
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
    if (data is Setting) {
      await isar.writeTxn(() async {
        await isar.settings.put(data);
        return Future.value(null);
      });
    }
    if (data is EBM) {
      await isar.writeTxn(() async {
        await isar.eBMs.put(data);
        return Future.value(null);
      });
    }
    return Future.value(null);
  }

  /// @Deprecated [endpoint] don't give the endpoint params
  @override
  Future<T?> update<T>({required T data}) async {
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Device) {
      Device device = data;

      await isar.writeTxn(() async {
        return await isar.devices.put(device);
      });
    }
    if (data is Social) {
      Social social = data;

      await isar.writeTxn(() async {
        return await isar.socials.put(social);
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
    if (data is Transaction) {
      final transaction = data;
      await isar.writeTxn(() async {
        return await isar.transactions.put(transaction);
      });
    }
    if (data is Category) {
      final transaction = data;
      await isar.writeTxn(() async {
        return await isar.categorys.put(transaction);
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
    if (data is TransactionItem) {
      await isar.writeTxn(() async {
        return await isar.transactionItems.put(data);
      });
    }
    if (data is EBM) {
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
  Future<List<Transaction>> weeklyTransactionsReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) {
    // throw UnimplementedError();
    List<DateTime> weekDates = getWeeksForRange(weekStartDate, weekEndDate);
    List<Transaction> pastTransactions = [];
    return isar.writeTxn(() {
      for (DateTime date in weekDates) {
        List<Transaction> transactions = isar.transactions
            .where()
            .branchIdEqualTo(branchId)
            .findAllSync()
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
    log(branchId.toString(), name: "load stream of categoris");
    return isar.categorys
        .where()
        .branchIdEqualTo(branchId)
        .watch(fireImmediately: true);
  }

  @override
  Future<Variant?> getVariantById({required int id}) async {
    return await isar.variants.get(id);
  }

  @override
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required Transaction transaction,
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
        ..transactionId = transaction.id!
        ..resultDt = signature.resultDt;
      int id = await isar.receipts.put(receipt);
      // get receipt from isar db
      return isar.receipts.get(id);
    });
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
    return isar.writeTxn(() async {
      return await isar.receipts
          .where()
          .transactionIdEqualTo(transactionId)
          .findFirst();
    });
  }

  @override
  Future<void> refund({required int itemId}) async {
    return isar.writeTxn(() async {
      TransactionItem? item = await isar.transactionItems.get(itemId);
      item!.isRefunded = true;
      await isar.transactionItems.put(item);
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

// https://pub.dev/packages/excel
  @override
  Future<List<Transaction>> completedTransactions(
      {required int branchId, String? status = completeStatus}) async {
    return await isar.transactions
        .where()
        .statusBranchIdEqualTo(status!, branchId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Stream<List<Transaction>> localCompletedTransactions() {
    String status = completeStatus;
    int branchId = ProxyService.box.getBranchId()!;
    return isar.transactions
        .where()
        .filter()
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
    List<int> productIds = products.map((product) => product.id ?? 0).toList();
    isar.writeTxn(() async {
      isar.products.deleteAll(productIds);
    });
  }

  @override
  Future<Stock?> getStockById({required int id}) async {
    return await isar.stocks.get(id);
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

  /// Given businessId return if there is any social account set for this business
  /// this will give us enough confidence that we can authenticate social api as there is
  /// probably one account set which means we can get bearer token if we authenticate with service
  @override
  Future<List<Social>> activesocialAccounts({required int businessId}) async {
    return await isar.socials
        .filter()
        .businessIdEqualTo(businessId)
        .and()
        .isAccountSetEqualTo(true)
        .findAll();
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
        message.businessPhoneNumber =
            ProxyService.box.getUserPhone()!.replaceAll("+", "");
        isar.writeTxn(() async {
          await isar.conversations.put(message);
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

    Setting? setting = await isar.settings
        .filter()
        .businessPhoneNumberEqualTo(number)
        .findFirst();

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
  Future<Device?> getDevice({required String phone}) {
    // get device from isar with linking code and return it
    return isar.devices.filter().phoneEqualTo(phone).build().findFirst();
  }

  @override
  Future<Device?> getDeviceById({required int id}) {
    // get device from isar with linking code and return it
    return isar.devices.filter().idEqualTo(id).build().findFirst();
  }

  @override
  Stream<List<Device>> getDevices({required int businessId}) {
    // get device from isar with linking code and return it
    return isar.devices
        .filter()
        .businessIdEqualTo(businessId)
        .build()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) async {
    return await isar.devices
        .filter()
        .businessIdEqualTo(businessId)
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
      {required int transactionId, required bool doneWithTransaction}) async {
    return await isar.transactionItems
        .filter()
        .transactionIdEqualTo(transactionId)
        .and()
        .doneWithTransactionEqualTo(doneWithTransaction)
        .findAll();
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStream() {
    return pendingTransactionStream().asyncMap((transaction) async {
      if (transaction != null) {
        final items = await isar.transactionItems
            .where()
            .transactionIdEqualTo(transaction.id!)
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
        id: syncIdInt(),
        action: 'create',
        branchId: branchId,
        variantId: variant.id!,
        currentStock: 0.0,
        productId: variant.productId)
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
      ..productId = variant.productId
      ..rsdQty = 0.0;

    return await isar.writeTxn(() async {
      int id = await isar.stocks.put(stock);
      return await isar.stocks.get(id);
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
    return await isar.eBMs.filter().branchIdEqualTo(branchId).findFirst();
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
    List<Stock> stocks = await isar.stocks
        .filter()
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
    List<Variant> variants = await isar.variants
        .filter()
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
    List<Product> products = await isar.products
        .filter()
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
    List<Favorite> favorites = await isar.favorites
        .filter()
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
    List<Device> devices = await isar.devices
        .filter()
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
    List<Transaction> transactions = await isar.transactions
        .filter()
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
    List<TransactionItem> transactionItems = await isar.transactionItems
        .filter()
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
