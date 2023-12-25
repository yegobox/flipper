import 'dart:async';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/secrets.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/foundation.dart' as foundation;

import 'package:path_provider/path_provider.dart';
import 'package:flipper_routing/receipt_types.dart';

class IsarAPI<M> implements IsarApiInterface {
  FlipperHttpClient flipperHttpClient = FlipperHttpClient(http.Client());
  late String apihub;
  late String commApi;
  late Isar db;
  Future<IsarApiInterface> getInstance({Isar? isa}) async {
    String? appDocDir = '';

    if (foundation.kDebugMode && !isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (foundation.kDebugMode && isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (!foundation.kDebugMode) {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }
    if (isa == null) {
      if (foundation.kIsWeb) {
        Isar.initialize();
      } else {
        appDocDir = (await getApplicationDocumentsDirectory()).path;
      }
      db = await Isar.open(
        // compactOnLaunch:
        //     CompactCondition(minBytes: 100, minFileSize: 100, minRatio: 2.0),
        schemas: [
          ITransactionSchema,
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
          EBMSchema,
          UserActivitySchema,
          SyncRecordSchema
        ],
        directory: foundation.kIsWeb ? Isar.sqliteInMemory : appDocDir,
        engine: foundation.kIsWeb || Platform.isLinux
            ? IsarEngine.sqlite
            : IsarEngine.isar,
        // name: 'flipper-db',
      );
    } else {
      db = isa;
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
        action: AppActions.created,
        tinNumber: customer['tinNumber'],
        email: customer['email'],
        phone: customer['phone'],
        address: customer['address'],
        updatedAt: DateTime.now(),
        branchId: branchId);
    db.write((isar) {
      isar.customers.put(kCustomer);
    });

    ITransaction? transaction =
        db.read((isar) => isar.iTransactions.get(transactionId));
    transaction?.customerId = kCustomer.id;
    // update the transaction with the customerID
    await update(data: transaction);
    return kCustomer;
  }

  /// this method is one way i.e we get to know local unsynched changes
  /// then we send them but we are not working on the changes after this push.
  /// those change will stay on local, so I need to work on them as well.

  @override
  Future<ITransaction> manageTransaction(
      {required String transactionType}) async {
    int branchId = ProxyService.box.getBranchId()!;
    // ITransaction? existTransaction = retailId != null
    //     ? await pendingTransaction(retailId: retailId,transactionType:transactionType)
    //     : await pendingTransaction(branchId: branchId,transactionType:transactionType);
    ITransaction? existTransaction = await pendingTransaction(
        branchId: branchId, transactionType: transactionType);
    if (existTransaction == null) {
      final String id = randomString();
      final transaction = ITransaction(
        lastTouched: DateTime.now(),
        id: id,
        supplierId: branchId,
        reference: randomString(),
        action: AppActions.created,
        transactionNumber: randomString(),
        status: PENDING,
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
      db.write((isar) {
        isar.iTransactions.onPut(transaction);
      });
      ITransaction? createdTransaction = await db.iTransactions.get(id);
      ProxyService.box.writeString(key: 'currentTransactionId', value: id);
      return createdTransaction!;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType}) async {
    int branchId = ProxyService.box.getBranchId()!;

    ITransaction? existTransaction = await pendingTransaction(
        branchId: branchId, transactionType: transactionType);

    int businessId = ProxyService.box.getBusinessId()!;
    if (existTransaction == null) {
      String id = randomString();
      final transaction = ITransaction(
        lastTouched: DateTime.now(),
        id: id,
        supplierId: businessId,
        reference: randomString(),
        action: AppActions.created,
        transactionNumber: randomString(),
        status: PENDING,
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
      db.write((isar) {
        isar.iTransactions.onPut(transaction);
      });
      ITransaction? createdTransaction = db.iTransactions.get(id);
      ProxyService.box.writeString(key: 'currentTransactionId', value: id);
      return createdTransaction!;
    } else {
      return existTransaction;
    }
  }

  @override
  Future<void> addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item}) async {
    db.write((isar) {
      isar.transactionItems.onPut(item);
    });
  }

  // get point where userId = userId from db
  @override
  Pointss addPoint({required int userId, required int point}) {
    return db.read(
        (isar) => isar.pointss.where().userIdEqualTo(userId).findFirst()!);
  }

  @override
  Future<ITransaction?> getTransactionById({required String id}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return db
        .read((isar) => isar.iTransactions
            .where()
            .idEqualTo(id)
            .and()
            .branchIdEqualTo(branchId))
        .findFirst();
  }

  //Delete a favorite
  @override
  Future<int> deleteTransactionByIndex(
      {required String transactionIndex}) async {
    db.write((isar) {
      isar.iTransactions.delete(transactionIndex);
    });
    return Future.value(200);
  }

  /// Sums the total income and expense amounts from transactions within a given time period.
  ///
  /// The `period` parameter specifies the time period to filter transactions by. Valid values are:
  /// - 'Today' - Transactions from today
  /// - 'This Week' - Transactions from the last 7 days
  /// - 'This Month' - Transactions from the last 30 days
  /// - 'This Year' - Transactions from the last 365 days
  ///
  /// Returns a map with the total `income` and `expense` amounts.
  @override
  Future<({double income, double expense})> getTransactionsAmountsSum(
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

    List<ITransaction> transactions = await transactionsFuture();

    List<ITransaction> filteredTransactions = [];
    for (final transaction in transactions) {
      temporaryDate = DateTime.parse(transaction.createdAt);
      if (temporaryDate.isAfter(oldDate)) {
        filteredTransactions.add(transaction);
      }
    }

    double sum_cash_in = 0;
    double sum_cash_out = 0;
    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sum_cash_out = transaction.subTotal + sum_cash_out;
      } else {
        sum_cash_in = transaction.subTotal + sum_cash_in;
      }
    }

    return (income: sum_cash_in, expense: sum_cash_out);
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    Favorite? fav = db.read((isar) =>
        isar.favorites.where().favIndexEqualTo(data.favIndex!).findFirst());
    if (fav == null) {
      data.id = db.favorites.autoIncrement();
      db.write((db) {
        db.favorites.put(data);
      });
      return Future.value(200);
    } else {
      fav.productId = data.productId;
      db.write((isar) {
        isar.favorites.onPut(fav);
      });
      return Future.value(200);
    }
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    List<Favorite> favorites =
        db.read((isar) => isar.favorites.where().findAll());
    return favorites;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    //Get a favorite
    Favorite? favorite =
        db.read((isar) => isar.favorites.where().idEqualTo(favId).findFirst());
    return favorite;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    //Get a favorite
    Favorite? favorite = db.read(
        (isar) => isar.favorites.where().favIndexEqualTo(favIndex).findFirst());
    return favorite;
  }

  @override
  Future<Product?> getProduct({required String id}) async {
    return db.read((isar) => isar.products.where().idEqualTo(id).findFirst());
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    Favorite? favorite = db.read(
        (isar) => isar.favorites.where().productIdEqualTo(prodId).findFirst());
    return favorite;
  }

  //Delete a favorite
  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) async {
    db.write((isar) {
      isar.favorites.where().favIndexEqualTo(favIndex).deleteFirst();
    });
    return Future.value(200);
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    int branchId = ProxyService.box.getBranchId()!;
    db.write((isar) {
      for (Map map in units) {
        final unit = IUnit()
          ..active = map['active']
          ..value = map['value']
          ..id = randomString()
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
        db.subscriptions.where().userIdEqualTo(userId).findFirst();
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
    db.write((isar) {
      isar.subscriptions.put(subscription!);
    });
    Subscription? sub = db.subscriptions.get(id);
    // TODO: fix this as I used it when link were still supported
    // for (var feature in features) {
    //   sub!.features.value = feature;
    // }
    // update sub to db
    db.write((isar) {
      isar.subscriptions.put(sub!);
    });
    return db.subscriptions.get(id);
  }

  @override
  Future<int> addVariant({required List<Variant> variations}) async {
    db.write((isar) {
      for (Variant variation in variations) {
        String id = randomString();
        // save variation to db
        // FIXMEneed to know if all item will have same itemClsCd
        variation.itemClsCd = "5020230602";
        variation.pkg = "1";
        variation.id = id;
        isar.variants.onPut(variation);
        final stock = Stock(
            id: id,
            lastTouched: DateTime.now(),
            branchId: ProxyService.box.getBranchId()!,
            variantId: id,
            action: AppActions.created,
            retailPrice: variation.retailPrice,
            currentStock: variation.qty!,
            productId: variation.productId)
          ..active = false;
        isar.stocks.onPut(stock);
      }
    });
    return Future.value(200);
  }

  @override
  Future assingTransactionToCustomer(
      {required String customerId, String? transactionId}) async {
    // get transaction where id = transactionId from db
    ITransaction? transaction =
        db.iTransactions.where().idEqualTo(transactionId ?? "").findFirst();

    transaction?.customerId = customerId;
    // update transaction to db
    if (transaction != null) {
      db.write((isar) {
        isar.iTransactions.onPut(transaction);
      });
    }

    // get customer where id = customerId from db
    //// and updat this customer with timestamp so it can trigger change!.
    Customer? customer = db.customers.get(customerId);
    customer!.updatedAt = DateTime.now();
    // save customer to db
    db.write((isar) {
      isar.customers.onPut(customer);
    });
  }

  @override
  Future<List<Branch>> branches({required int businessId}) async {
    // if in local db we have no branch fetch it from online
    return db.read(
        (isar) => isar.branchs.where().businessIdEqualTo(businessId).findAll());
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
      required ITransaction transaction,
      required String paymentType}) async {
    transaction.status = COMPLETE;

    List<TransactionItem> items = await transactionItems(
        transactionId: transaction.id,
        doneWithTransaction: false,
        active: true);
    double subTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
    transaction.customerChangeDue = (cashReceived - subTotal);
    transaction.paymentType = paymentType;
    transaction.cashReceived = cashReceived;
    transaction.subTotal = subTotal;

    /// refresh created as well to reflect when this transaction was created and completed

    transaction.updatedAt = DateTime.now().toIso8601String();

    await update(data: transaction);

    for (TransactionItem item in items) {
      Stock? stock = await stockByVariantId(variantId: item.variantId);
      stock.currentStock = stock.currentStock - item.qty;
      stock.action = AppActions.updated;
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
    return db.read(
        (isar) => isar.pColors.where().branchIdEqualTo(branchId).findAll());
  }

  @override
  void consumePoints({required int userId, required int points}) async {
    // Retrieve user's points from the database
    Pointss? userPoints = db.read(
      (isar) => isar.pointss.where().userIdEqualTo(userId).findFirst(),
    );

    // Deduct the consumed points from the user's total points
    userPoints!.value -= points;

    // Update the modified points back to the database
    db.write((isar) {
      isar.pointss.put(userPoints);
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
    Pin? pin =
        db.read((isar) => isar.pins.where().userIdEqualTo(id).findFirst());
    if (pin != null) {
      return pin;
    }

    int branchId = ProxyService.box.getBranchId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    String phoneNumber = ProxyService.box.getUserPhone()!;
    String defaultApp = ProxyService.box.getDefaultApp();
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
      int id = randomNumber();
      Pin pin = Pin.fromJson(json.decode(response.body));
      pin.id = id;
      db.write((isar) {
        isar.pins.put(pin);
      });
      return db.pins.get(id);
    }
    return null;
  }

  @override
  Future<Product> createProduct(
      {required Product product, bool skipRegularVariant = false}) async {
    final Business? business = await getBusiness();
    final int branchId = ProxyService.box.getBranchId()!;

    // Check if the product created (custom or temp) already exists and return it
    final String productName = product.name;
    if (productName == CUSTOM_PRODUCT || productName == TEMP_PRODUCT) {
      final Product? existingProduct = await _findProductByNameAndBusinessId(
        name: productName,
        businessId: ProxyService.box.getBusinessId()!,
      );
      if (existingProduct != null) {
        return existingProduct;
      }
    }

    db.write((isar) {
      isar.products.onPut(product);

      if (!skipRegularVariant) {
        final Product? kProduct = isar.products.get(product.id);

        // Create a Regular Variant
        final Variant newVariant =
            _createRegularVariant(product, branchId, business);
        isar.variants.onPut(newVariant);

        // Create a Stock for the Regular Variant
        final Stock stock = Stock(
          lastTouched: DateTime.now(),
          id: randomString(),
          action: 'create',
          branchId: branchId,
          variantId: newVariant.id,
          currentStock: 0.0,
          productId: kProduct!.id,
        );
        isar.stocks.onPut(stock);
      }
    });

    return db.read((isar) => isar.products.get(product.id))!;
  }

  Variant _createRegularVariant(
      Product product, int branchId, Business? business) {
    final String variantId = randomString();
    return Variant(
      lastTouched: DateTime.now(),
      name: 'Regular',
      sku: 'sku',
      action: 'create',
      productId: product.id,
      color: product.color,
      unit: 'Per Item',
      productName: product.name,
      branchId: branchId,
      supplyPrice: 0.0,
      retailPrice: 0.0,
      id: variantId,
      isTaxExempted: false,
      bhfId: business?.bhfId ?? '',
      itemCd: randomString(),
      itemClsCd: "5020230602", // TODO: Ask about item classification code
      itemTyCd: "1",
      itemNm: "Regular",
      itemStdNm: "Regular",
      orgnNatCd: "RW",
      pkgUnitCd: "NT",
      qtyUnitCd: "U",
      taxTyCd: "B",
      dftPrc: 0.0,
      addInfo: "A",
      isrcAplcbYn: "N",
      useYn: "N",
      regrId: randomString(),
      regrNm: "Regular",
      modrId: randomString(),
      modrNm: "Regular",
      pkg: "1",
      itemSeq: "1",
      splyAmt: 0.0,
    );
  }

  Future<Product?> _findProductByNameAndBusinessId({
    required String name,
    required int businessId,
  }) async {
    return db.read((isar) => isar.products
        .where()
        .nameEqualTo(name)
        .businessIdEqualTo(businessId)
        .findFirst());
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
  Future<bool> delete({required String id, String? endPoint}) async {
    final DateTime deletionTime = DateTime.now();

    switch (endPoint) {
      case 'color':
        db.write((isar) {
          PColor? color = isar.pColors.get(id);
          if (color != null) {
            color.deletedAt = deletionTime;
            color.action = AppActions.deleted;
            isar.pColors.onPut(color);
            return true;
          }
          return false;
        });
        break;
      case 'device':
        db.write((isar) {
          Device? device = isar.devices.get(id);
          if (device != null) {
            device.deletedAt = deletionTime;
            device.action = AppActions.deleted;
            isar.devices.onPut(device);
            return true;
          }
          return false;
        });
        break;
      case 'category':
        db.write((isar) {
          Category? category = isar.categorys.get(id);
          if (category != null) {
            category.deletedAt = deletionTime;
            category.action = AppActions.deleted;
            isar.categorys.onPut(category);
            return true;
          }
          return false;
        });
        break;
      case 'product':
        db.write((isar) {
          Product? product = isar.products.get(id);
          if (product != null) {
            product.deletedAt = deletionTime;
            product.action = AppActions.deleted;
            isar.products.onPut(product);
            return true;
          }
          return false;
        });
        break;
      case 'variant':
        db.write((isar) {
          Variant? variant = isar.variants.get(id);
          if (variant != null) {
            variant.deletedAt = deletionTime;
            variant.action = AppActions.deleted;
            isar.variants.onPut(variant);
            return true;
          }
          return false;
        });
        break;
      case 'stock':
        db.write((isar) {
          Stock? stocks = isar.stocks.get(id);
          if (stocks != null) {
            stocks.deletedAt = deletionTime;
            stocks.action = AppActions.deleted;
            isar.stocks.onPut(stocks);
            return true;
          }
          return false;
        });
        break;
      case 'setting':
        db.write((isar) {
          Setting? setting = isar.settings.get(id);
          if (setting != null) {
            setting.deletedAt = deletionTime;
            setting.action = AppActions.deleted;
            isar.settings.onPut(setting);
            return true;
          }
          return false;
        });
        break;
      case 'pin':
        db.write((isar) {
          Pin? pin = isar.pins.get(int.parse(id));
          if (pin != null) {
            isar.pins.delete(pin.id);
            return true;
          }
          return false;
        });
        break;
      case 'business':
        db.write((isar) {
          isar.business.delete(int.tryParse(id) ?? 0);
        });
        break;
      case 'branch':
        db.write((isar) {
          isar.branchs.delete(int.tryParse(id) ?? 0);
          return true;
        });
        break;

      case 'voucher':
        db.write((isar) {
          isar.vouchers.delete(id);
          return true;
        });
        break;
      case 'transactionItem':
        db.write((isar) {
          TransactionItem? transactionItems = isar.transactionItems.get(id);
          if (transactionItems != null) {
            transactionItems.deletedAt = deletionTime;
            transactionItems.action = AppActions.deleted;
            isar.transactionItems.onPut(transactionItems);
            return true;
          }
          return false;
        });
        break;
      case 'customer':
        db.write((isar) {
          Customer? customer = isar.customers.get(id);
          if (customer != null) {
            customer.deletedAt = deletionTime;
            customer.action = AppActions.deleted;
            isar.customers.onPut(customer);
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

    Business? business = db.write((isar) {
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
  Future<Business?> getBusiness({int? businessId}) async {
    if (businessId != null) {
      return db.read((isar) => isar.business.get(businessId));
    } else {
      int? userId = ProxyService.box.getUserId();
      return db.business.where().userIdEqualTo(userId).findFirst();
    }
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business = db.write((isar) {
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
      db.write((isar) {
        isar.business.put(business);
      });
      return db.business.get(id);
    }
    return null;
  }

  @override
  Future<PColor?> getColor({required String id, String? endPoint}) async {
    return db.write((isar) {
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
        db.products.where().nameEqualTo('Custom Amount').findFirst();
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
              createdAt: DateTime.now().toIso8601String(),
              branchId: businessId));
      // add this newProduct's variant to the RRA DB
      Variant? variant =
          db.variants.where().productIdEqualTo(newProduct.id).findFirst();
      if (await ProxyService.isar.isTaxEnabled()) {
        ProxyService.tax.saveItem(variation: variant!);
      }
      return variant!;
    } else {
      Variant? variation =
          db.variants.where().productIdEqualTo(product.id).findFirst();
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

      variation = db.write((isar) {
        isar.variants.onPut(
          Variant(
              id: id,
              lastTouched: DateTime.now(),
              name: 'Custom Amount',
              color: product.color,
              sku: 'sku',
              action: 'create',
              productId: product.id,
              unit: 'Per Item',
              productName: product.name,
              branchId: ProxyService.box.getBranchId()!,
              supplyPrice: 0.0,
              retailPrice: 0.0,
              itemCd: clip,
              bhfId: business?.bhfId ?? '',
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

      db.write((isar) {
        isar.stocks.onPut(stock);
      });
    }
    return variation;
  }

  @override
  Future<Customer?> nGetCustomerByTransactionId({required String id}) async {
    ITransaction? transaction = db.iTransactions.get(id);
    if (transaction == null) {
      return null;
    }
    Customer? customer = db.customers.get(transaction.customerId ?? '0');
    return customer;
  }

  @override
  Future<List<Discount>> getDiscounts({required int branchId}) async {
    return db.read(
        (isar) => isar.discounts.where().branchIdEqualTo(branchId).findAll());
  }

  // get list of Business from isar where userId = userId
  // if list is empty then get list from online
  @override
  Future<List<Business>> businesses({required int userId}) async {
    List<Business> businesses =
        db.business.where().userIdEqualTo(userId).findAll();

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

    Business? business = db.write((isar) {
      return isar.business
          .get(Business.fromJson(json.decode(response.body)).id);
    });

    if (business == null) {
      db.write((isar) {
        isar.business.put(Business.fromJson(json.decode(response.body)));
      });
      business = db.read((isar) {
        return isar.business.where().userIdEqualTo(userId).findFirst();
      });
    }
    ProxyService.box.writeInt(key: 'businessId', value: business!.id);

    return business;
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required String id}) async {
    return db.transactionItems
        .where()
        .idEqualTo(id)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findFirst();
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, required String? transactionId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return db.transactionItems
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .transactionIdEqualTo(transactionId!)
        .and()
        .deletedAtIsNull()
        .and()
        .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required String? transactionId}) async {
    return db.transactionItems
        .where()
        .transactionIdEqualTo(transactionId!)
        .findAll();
  }

  /// since tennat has userId which is a pin, we need to think if
  /// we still need to create & get pin
  @override
  Future<Pin?> getPin({required String pin}) async {
    final Uri uri = Uri.parse("$apihub/v2/api/pin/$pin");

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        return Pin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw ErrorReadingFromYBServer(term: response.body);
      } else {
        throw ErrorReadingFromYBServer(term: response.body);
      }
    } catch (error) {
      throw ErrorReadingFromYBServer(term: error.toString());
    }
  }

  @override
  Future<Pointss?> getPoints({required int userId}) async {
    return db.pointss.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) async {
    return db.products.where().barCodeEqualTo(barCode).findFirst();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) async {
    return db.write((isar) {
      return isar.settings.where().businessIdEqualTo(businessId).findFirst();
    });
  }

  @override
  Future<Stock?> getStock(
      {required int branchId, required String variantId}) async {
    return db.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(branchId)
        .findFirst();
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) async {
    Subscription? local = db.write((isar) {
      return isar.subscriptions.where().userIdEqualTo(userId).findFirst();
    });
    if (local == null) {
      final response = await flipperHttpClient
          .get(Uri.parse("$apihub/v2/api/subscription/$userId"));
      if (response.statusCode == 200) {
        Subscription? sub = Subscription.fromJson(json.decode(response.body));

        db.write((isar) {
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
    return db.variants.where().productIdEqualTo(productId).findAll();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  void clear() {
    db.write((isar) {
      isar.products.clear();
      isar.variants.clear();
      isar.stocks.clear();
      isar.iTransactions.clear();
      isar.transactionItems.clear();
    });
  }

  @override
  Future<void> logOut() async {
    // delete all business and branches from isar db for
    // potential next business that can log-in to not mix data.

    db.write((isar) {
      isar.business.clear();
      isar.branchs.clear();
      isar.iTenants.clear();
      isar.permissions.clear();
      isar.userActivitys.clear();
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
    // for box clearing if we are using box then we need to be explicit
    // of the keys
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'getIsTokenRegistered');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'defaultApp');
    // but for shared preference we can just clear them all
    ProxyService.box.clear();
    await firebase.FirebaseAuth.instance.signOut();
  }

  @override
  Future<Tenant> saveTenant(String phoneNumber, String name,
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
      Tenant jTenant = Tenant.fromRawJson(response.body);
      ITenant iTenant = ITenant(
          isDefault: jTenant.isDefault,
          id: randomNumber(),
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          userId: jTenant.userId,
          nfcEnabled: jTenant.nfcEnabled,
          phoneNumber: jTenant.phoneNumber);

      db.write((isar) {
        isar.business.putAll(jTenant.businesses);
        isar.branchs.putAll(jTenant.branches);
        isar.permissions.putAll(jTenant.permissions);
      });
      db.write((isar) {
        isar.iTenants.put(iTenant);
      });

      return Tenant.fromRawJson(response.body);
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<List<Tenant>> signup({required Map business}) async {
    log(jsonEncode(business));
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/business"),
      body: jsonEncode(business),
    );
    if (response.statusCode == 200) {
      for (Tenant tenant in Tenant.fromJsonList(response.body)) {
        Tenant jTenant = tenant;
        ITenant iTenant = ITenant(
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        db.write((isar) {
          isar.business.putAll(jTenant.businesses);
        });
        db.write((isar) {
          isar.branchs.putAll(jTenant.branches);
        });
        db.write((isar) {
          isar.permissions.putAll(jTenant.permissions);
        });
        db.write((isar) {
          isar.iTenants.put(iTenant);
        });
      }
      return Tenant.fromJsonList(response.body);
    } else {
      throw InternalServerError(term: response.body.toString());
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
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Create an IUser object using the fromJson constructor
      IUser user = IUser.fromJson(jsonResponse);
      await ProxyService.box.writeString(
        key: 'userPhone',
        value: userPhone,
      );
      await ProxyService.box.writeString(
        key: 'bearerToken',
        value: user.token,
      );
      await ProxyService.box.writeInt(
        key: 'userId',
        value: user.id,
      );
      recordUserActivity(userId: user.id, activity: 'login');
      if (user.tenants.isEmpty) {
        throw BusinessNotFoundException(
            term:
                "No tenant added to the user, if a business is added it should have one tenant");
      }
      if (user.tenants.first.businesses.isEmpty ||
          user.tenants.first.branches.isEmpty) {
        throw BusinessNotFoundException(
            term:
                "No tenant added to the user, if a business is added it should have one tenant");
      }
      await ProxyService.box.writeInt(
        key: 'branchId',
        // check if branches is empty
        value: user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id,
      );

      log(user.id.toString(), name: 'login');
      await ProxyService.box.writeInt(
        key: 'businessId',
        // check if businesses is empty
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id,
      );
      if (skipDefaultAppSetup == false) {
        await ProxyService.box.writeString(
          key: 'defaultApp',

          /// because we don update default app from server
          /// because we want the ability of switching apps to be entirely offline
          /// then if we have a default app in the box we use it if it only different from "1"
          value: user.tenants.isEmpty
              ? 'null'
              : ProxyService.box.getDefaultApp() != "1"
                  ? ProxyService.box.getDefaultApp()
                  : user.tenants.first.businesses.first.businessTypeId
                      .toString(),
        );
      }

      for (Tenant tenant in user.tenants) {
        ITenant iTenant = ITenant(
            isDefault: tenant.isDefault,
            id: tenant.id,
            name: tenant.name,
            businessId: tenant.businessId,
            nfcEnabled: tenant.nfcEnabled,
            email: tenant.email,
            userId: user.id,
            phoneNumber: tenant.phoneNumber,
            pin: tenant.pin);

        db.write((isar) {
          isar.business.putAll(tenant.businesses);
        });
        db.write((isar) {
          isar.branchs.putAll(tenant.branches);
        });
        db.write((isar) {
          isar.permissions.putAll(tenant.permissions);
        });

        db.write((isar) {
          if (user.id == iTenant.userId) {
            iTenant.sessionActive = true;
            isar.iTenants.put(iTenant);
          } else {
            isar.iTenants.put(iTenant);
          }
        });
      }
      return user;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      log(response.body.toString(), name: "login error");
      throw Exception(response.body.toString());
    }
  }

  @override
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType}) async {
    return db.read((isar) => isar.iTransactions
        .where()
        .statusEqualTo(PENDING)
        .and()
        .branchIdEqualTo(branchId)
        .and()
        .transactionTypeEqualTo(transactionType)
        .findFirst());
  }

  @override
  Future<Profile?> profile({required int businessId}) async {
    return db.write((isar) =>
        isar.profiles.where().businessIdEqualTo(businessId).findFirst());
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) async {
    //save discount into isar db
    db.write((isar) {
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
  Future<Stock> stockByVariantId({required String variantId}) async {
    int branchId = ProxyService.box.getBranchId()!;
    await assignStockToVariant(variantId: variantId);
    return db.read((isar) => isar.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(branchId)
        .findFirst())!;
  }

  @override
  Future<double> stocks({String? productId, String? variantId}) async {
    double totalStock = 0.0;

    // If productId is given, compute the total stock for all variants and return it
    // Otherwise, get the stock for a single variant based on variantId
    if (productId != null) {
      // Query Isar database to find all stocks with a matching productId
      final stocks = await db.read(
        (isar) => isar.stocks.where().productIdEqualTo(productId).findAll(),
      );

      // Sum up the stock quantities for all variants with the given productId
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    } else if (variantId != null) {
      // Query Isar database to find all stocks with a matching variantId
      final stocks = await db.read(
        (isar) => isar.stocks.where().variantIdEqualTo(variantId).findAll(),
      );

      // Sum up the stock quantities for the variant with the given variantId
      totalStock = stocks.fold(0.0, (sum, stock) => sum + (stock.currentStock));
    }
    return totalStock;
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
  Future<List<ITransaction>> tickets() async {
    return db.read((isar) => isar.iTransactions
        .where()
        .statusEqualTo(PARKED)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findAll());
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return db.read(
        (isar) => isar.iUnits.where().branchIdEqualTo(branchId).findAll());
  }

  @override
  Future<T?> create<T>({required T data}) async {
    /// update user activity model
    int userId = ProxyService.box.getUserId()!;
    recordUserActivity(userId: userId, activity: 'create');

    /// end with updating user activity
    if (data is Conversation) {
      Conversation conversation = data;
      db.write((isar) {
        isar.conversations.put(conversation);
        // Return the created conversation
      }); // Cast the result to type T
      return db.conversations.get(conversation.id) as T;
    }

    if (data is PColor) {
      PColor color = data;
      db.write((isar) {
        for (String colorName in data.colors!) {
          isar.pColors.put(PColor(
              id: randomString(),
              lastTouched: DateTime.now(),
              action: AppActions.created,
              name: colorName,
              active: color.active,
              branchId: color.branchId));
        }
      });
    }
    if (data is Device) {
      Device device = data;
      db.write((isar) {
        isar.devices.onPut(device);
      });
      return Future.value(null);
    }
    if (data is Conversation) {
      Conversation conversation = data;
      db.write((isar) {
        isar.conversations.put(conversation);
      });
      return Future.value(null);
    }
    if (data is Category) {
      Category category = data;
      db.write((isar) {
        isar.categorys.put(category);
      });
      return Future.value(null);
    }
    if (data is Product) {
      db.write((isar) {
        return isar.products.onPut(data);
      });
    }
    if (data is Variant) {
      db.write((isar) {
        isar.variants.onPut(data);
      });
      return Future.value(null);
    }
    if (data is Favorite) {
      db.write((isar) {
        isar.favorites.onPut(data);
      });
      return Future.value(null);
    }
    if (data is Stock) {
      db.write((isar) {
        isar.stocks.onPut(data);
      });
      return Future.value(null);
    }
    if (data is Social) {
      db.write((isar) {
        isar.socials.put(data);
      });
      return Future.value(null);
    }
    if (data is Token) {
      db.write((isar) {
        isar.tokens.put(data);
      });
      return Future.value(null);
    }
    if (data is Setting) {
      db.write((isar) {
        isar.settings.put(data);
      });
      return Future.value(null);
    }
    if (data is EBM) {
      db.write((isar) {
        isar.eBMs.put(data);
      });
      return Future.value(null);
    }
    if (data is ITransaction) {
      db.write((isar) {
        isar.iTransactions.onPut(data);
      });
      return Future.value(null);
    }
    if (data is TransactionItem) {
      db.write((isar) {
        isar.transactionItems.onPut(data);
      });
      return Future.value(null);
    }
    return Future.value(null);
  }

  /// @Deprecated [endpoint] don't give the endpoint params
  @override
  Future<int> update<T>({required T data}) async {
    /// update user activity
    int userId = ProxyService.box.getUserId() ?? 0;
    if (userId == 0) return 0;
    recordUserActivity(userId: userId, activity: 'create');

    /// end updating user activity
    // int branchId = ProxyService.box.getBranchId()!;
    if (data is Device) {
      Device device = data;

      db.write((isar) {
        isar.devices.onPut(device);
      });
    }
    if (data is Social) {
      Social social = data;

      db.write((isar) {
        isar.socials.put(social);
      });
    }
    if (data is Product) {
      Product product = data;

      db.write((isar) {
        isar.products.onPut(product);
      });
    }
    if (data is Favorite) {
      Favorite fav = data;
      db.write((isar) {
        isar.favorites.onPut(fav);
      });
    }
    if (data is Variant) {
      Variant variant = data;
      db.write((isar) {
        isar.variants.onPut(variant);
      });
    }
    if (data is Stock) {
      Stock stock = data;
      db.write((isar) {
        isar.stocks.onPut(stock);
      });
    }
    if (data is ITransaction) {
      log(data.toJson().toString(), name: 'UpdatingTransaction');
      final transaction = data;
      db.write((isar) {
        isar.iTransactions.onPut(transaction);
      });
    }
    if (data is Category) {
      final transaction = data;
      db.write((isar) {
        isar.categorys.onPut(transaction);
      });
    }
    if (data is IUnit) {
      final unit = data;
      db.write((isar) {
        isar.iUnits.onPut(unit);
      });
    }
    if (data is PColor) {
      final color = data;
      db.write((isar) {
        isar.pColors.onPut(color);
      });
    }
    if (data is TransactionItem) {
      db.write((isar) {
        isar.transactionItems.onPut(data);
      });
    }
    if (data is EBM) {
      final ebm = data;
      db.write((isar) {
        ProxyService.box
            .writeString(key: "serverUrl", value: ebm.taxServerUrl ?? 'null');
        Business? business =
            isar.business.where().userIdEqualTo(ebm.userId).findFirst();
        business
          ?..dvcSrlNo = ebm.dvcSrlNo
          ..tinNumber = ebm.tinNumber
          ..bhfId = ebm.bhfId
          ..taxServerUrl = ebm.taxServerUrl
          ..taxEnabled = true;
        isar.business.onPut(business!);
      });
    }
    if (data is Token) {
      final token = data;
      token
        ..token = token.token
        ..businessId = token.businessId
        ..type = token.type;
      db.write((isar) {
        db.tokens.onPut(token);
      });
    }
    if (data is Business) {
      final business = data;
      db.write((isar) {
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
      db.write((isar) {
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
      db.write((isar) {
        isar.counters.onPut(data);
      });
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/counter/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode == 200) {
        log(response.body, name: 'response.body');
        Counter counter = Counter.fromRawJson(response.body);
        db.write((isar) {
          isar.counters.onPut(data
            ..branchId = counter.branchId
            ..businessId = counter.businessId
            ..receiptType = counter.receiptType
            ..id = data.id
            ..totRcptNo = counter.totRcptNo
            ..curRcptNo = counter.curRcptNo);
        });
      } else {
        throw InternalServerError(term: "error patching the counter");
      }
    }
    if (data is Branch) {
      db.write((isar) {
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
      db.write((isar) {
        isar.drawers.onPut(drawer);
      });
    }
    if (data is User) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/user"),
        body: jsonEncode(data.toJson()),
      );
      return response.statusCode;
    }
    if (data is ITenant) {
      final response = await flipperHttpClient.patch(
        Uri.parse("$apihub/v2/api/tenant/${data.id}"),
        body: jsonEncode(data.toJson()),
      );
      if (response.statusCode == 200) {
        db.write((isar) {
          isar.iTenants.onPut(data);
        });
      }
      return response.statusCode;
    }
    return 0;
  }

  @override
  Future<Profile?> updateProfile({required Profile profile}) async {
    //TODOcheck if the profile is propery updated.
    db.write((isar) {
      isar.profiles.put(profile);
    });
    return db.profiles.get(profile.id);
  }

  @override
  Future<int> userNameAvailable({required String name}) async {
    final response =
        await flipperHttpClient.get(Uri.parse("$apihub/search?name=$name"));
    return response.statusCode;
  }

  @override
  Future<Variant?> variant({String? variantId, String? name}) async {
    if (variantId != null) {
      return db.read((isar) => isar.variants.get(variantId));
    }
    if (name != null) {
      return db.read((isar) => isar.variants
          .where()
          .nameEqualTo(name)
          .and()
          .deletedAtIsNull()
          .findFirst());
    }
    return null;
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, String? productId}) async {
    if (productId != null) {
      return db.read((isar) => isar.variants
          .where()
          .productIdEqualTo(productId)
          .and()
          .branchIdEqualTo(branchId)
          .and()
          .deletedAtIsNull()
          .findAll());
    } else {
      return db.read((isar) => isar.variants
          .where()
          .branchIdEqualTo(branchId)
          .and()
          .deletedAtIsNull()
          .and()
          .retailPriceGreaterThan(0)
          .and()
          .supplyPriceGreaterThan(0)
          .findAll());
    }
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
  Future<List<Product>> productsFuture({required int branchId}) async {
    final allProducts = await db.read((isar) => isar.products
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .deletedAtIsNull()
        .findAll());

    // Filter out products with the name 'temp' or 'custom'
    final filteredProducts = allProducts
        .where((product) =>
            product.name != TEMP_PRODUCT && product.name != CUSTOM_PRODUCT)
        .toList();

    return filteredProducts;
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    // get all categories from isar db
    return db.read(
        (isar) => isar.categorys.where().branchIdEqualTo(branchId).findAll());
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    // get all categories from isar db
    return db.read((isar) => isar.categorys
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .activeEqualTo(true)
        .and()
        .focusedEqualTo(true)
        .findFirst());
  }

  @override
  Future<Variant?> getVariantById({required String id}) async {
    return db.read((isar) => isar.variants.get(id));
  }

  @override
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required ITransaction transaction,
      required String qrCode,
      required Counter counter,
      required String receiptType}) async {
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

    db.write((isar) {
      isar.receipts.put(receipt);
    });
    return db.read((isar) => isar.receipts.get(receipt.id));
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) async {
    return db.read((isar) =>
        isar.receipts.where().transactionIdEqualTo(transactionId).findFirst());
  }

  @override
  Future<void> refund({required String itemId}) async {
    return db.write((isar) {
      TransactionItem? item = isar.transactionItems.get(itemId);
      item!.isRefunded = true;
      isar.transactionItems.onPut(item);
    });
  }

  @override
  Future<bool> isDrawerOpen({required int cashierId}) async {
    Drawers? drawer = db.read((isar) => isar.drawers
        .where()
        .openEqualTo(true)
        .and()
        .cashierIdEqualTo(cashierId)
        .findFirst());
    return drawer != null;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    return db.read((isar) => isar.drawers
        .where()
        .openEqualTo(true)
        .and()
        .cashierIdEqualTo(cashierId)
        .findFirst());
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) async {
    // save drawer object in isar db
    String id = randomString();
    await db.writeAsync((isar) {
      isar.drawers.put(drawer..id = id);
    });
    return db.read((isar) => isar.drawers.get(id));
  }

  @override
  Future<int> size<T>({required T object}) async {
    if (object is Product) {
      return db.read((isar) => isar.products.getSize(includeIndexes: true));
    }
    if (object is Variant) {
      return db.read((isar) => isar.variants.getSize(includeIndexes: true));
    }
    if (object is Stock) {
      return db.read((isar) => isar.stocks.getSize(includeIndexes: true));
    }
    if (object is Counter) {
      return db.read((isar) => isar.counters.getSize(includeIndexes: true));
    }
    return 0;
  }

  @override
  Future<List<ITenant>> tenants({required int businessId}) async {
    return db.read((isar) =>
        isar.iTenants.where().businessIdEqualTo(businessId).findAll());
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    String id = businessId.toString();
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/tenant/$id"));
    if (response.statusCode == 200) {
      for (Tenant tenant in Tenant.fromJsonList(response.body)) {
        Tenant jTenant = tenant;
        ITenant iTenant = ITenant(
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        db.write((isar) {
          isar.business.putAll(jTenant.businesses);
          isar.branchs.putAll(jTenant.branches);
          isar.permissions.putAll(jTenant.permissions);
        });
        db.write((isar) {
          isar.iTenants.put(iTenant);
        });
      }
      return db.read((isar) =>
          isar.iTenants.where().businessIdEqualTo(businessId).findAll());
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Branch?> defaultBranch() async {
    return db.read(
        (isar) => isar.branchs.where().isDefaultEqualTo(true).findFirst());
  }

  @override
  Future<Business?> defaultBusiness() async {
    return db.read(
        (isar) => isar.business.where().isDefaultEqualTo(true).findFirst());
  }

  @override
  Future<Counter?> cSCounter({required int branchId}) async {
    return db.read((isar) => isar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.cs)
        .findFirst());
  }

  @override
  Future<Counter?> nRSCounter({required int branchId}) async {
    return db.read((isar) => isar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.nr)
        .findFirst());
  }

  @override
  Future<Counter?> nSCounter({required int branchId}) async {
    return db.read((isar) => isar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo("ns")
        .findFirst());
  }

  @override
  Future<Counter?> pSCounter({required int branchId}) async {
    return db.read((isar) => isar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ps)
        .findFirst());
  }

  @override
  Future<Counter?> tSCounter({required int branchId}) async {
    return db.read((isar) => isar.counters
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .receiptTypeEqualTo(ReceiptType.ts)
        .findFirst());
  }

  @override
  Future<void> loadCounterFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/counter/$businessId"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      List<Counter> counters = Counter.fromJsonList(jsonResponse);

      for (Counter counter in counters) {
        db.write((isar) {
          isar.counters.put(Counter(
            id: counter.id,
            branchId: counter.branchId,
            businessId: counter.businessId,
            totRcptNo: counter.totRcptNo,
            curRcptNo: counter.curRcptNo,
            receiptType: counter.receiptType,
          ));
        });
      }
    } else {
      throw InternalServerError(term: "Error loading the counters");
    }
  }

  @override
  String dbPath() {
    return db.read((isar) => isar.directory);
  }
  // You can either directly export the entire database file with the isar.copyToFile() method, or you can use collection.where().exportJson() to export a query result to json
  // @override
  // String public() {
  //   // return isar.j
  // }

  @override
  Future<bool> bindProduct(
      {required String productId, required int tenantId}) async {
    final product = await db.read((isar) => db.products.get(productId));
    product!.nfcEnabled = true;
    product.bindedToTenantId = tenantId;
    db.write((isar) {
      isar.products.onPut(product);
    });
    return true;
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    return db.products.where().bindedToTenantIdEqualTo(tenantId).findFirst();
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    return db.read(
        (isar) => isar.products.where().branchIdEqualTo(branchId).findAll());
  }

// https://pub.dev/packages/excel
  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) async {
    return db.iTransactions
        .where()
        .statusEqualTo(status!)
        .and()
        .branchIdEqualTo(branchId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Do not call this function in production
  @override
  Future<void> deleteAllProducts() async {
    List<Product> products =
        await productsFuture(branchId: ProxyService.box.getBranchId()!);
    List<String> productIds = products.map((product) => product.id).toList();
    db.write((isar) {
      isar.products.deleteAll(productIds);
    });
  }

  @override
  Future<Stock?> getStockById({required String id}) async {
    return db.read((isar) => isar.stocks.get(id));
  }

  /// sincd this type does not change no point of getting it from the server
  @override
  Future<List<BusinessType>> businessTypes() async {
    final responseJson = [
      {"id": "1", "typeName": "Flipper Retailer"},
      {"id": "2", "typeName": "Flipper Connecta"},
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
    return db.read((isar) => isar.socials.get(id));
  }

  /// Given businessId return if there is any social account set for this business
  /// this will give us enough confidence that we can authenticate social api as there is
  /// probably one account set which means we can get bearer token if we authenticate with service
  @override
  Future<List<Social>> activesocialAccounts({required int branchId}) async {
    return db.read((isar) => isar.socials
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .isAccountSetEqualTo(true)
        .findAll());
  }

  final appService = loc.getIt<AppService>();
  @override
  Future<List<Conversation>> getScheduleMessages() async {
    return db.read(
        (isar) => isar.conversations.where().deliveredEqualTo(false).findAll());
  }

  @override
  Future<void> sendScheduleMessages() async {
    try {
      await appService.isLoggedIn();
      List<Conversation> scheduledMessages = await getScheduleMessages();
      for (Conversation message in scheduledMessages) {
        final http.Response response = await flipperHttpClient.post(
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
          await db.writeAsync((isar) {
            isar.conversations.put(message);
          });
        } else {
          // this means there is no credit
          throw Exception(
              'Error sending scheduled message${response.body}${response.statusCode}');
        }
      }

      /// silently avoid the app to hand in debug mode
      /// because of the error found in   await appService.isLoggedIn(); firebase auth object
    } catch (e) {}
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) async {
    return db.read((isar) =>
        isar.conversations.where().messageIdEqualTo(messageId).findFirst());
  }

  @override
  Future<int> registerOnSocial(
      {String? phoneNumberOrEmail, String? password}) async {
    final http.Response response = await flipperHttpClient.post(
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
    final token = db.read((isar) => isar.tokens
        .where()
        .typeEqualTo(tokenType)
        .and()
        .businessIdEqualTo(businessId)
        .findFirst());

    if (token == null) {
      return false;
    }

    final now = DateTime.now();

    if (token.validFrom != null && token.validUntil != null) {
      if (now.isBefore(token.validFrom!) || now.isAfter(token.validUntil!)) {
        db.write((isar) => isar.tokens.delete(token.id));
        return false;
      }
    } else {
      return false;
    }
    String? localToken = ProxyService.box.whatsAppToken();
    if (localToken == null) {
      return false;
    }
    return true;
  }

  @override
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) async {
    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$commApi/login"),
      body: json.encode({"email": phoneNumberOrEmail, "password": password}),
    );

    if (response.statusCode == 200) {
      SocialToken responseBody = SocialToken.fromRawJson(response.body);
      return responseBody;
    } else {
      //// TODO: this is not a stopper when performing app global login
      /// instead implement global non fatal error reporting so it can be addressed separately
      // throw Exception("Failed to get token");
      return null;
    }
  }

  /// Retrieves the social setting asynchronously.
  ///
  /// This function retrieves the social setting based on the user's phone number.
  /// If the user's phone number is not available, it returns `null`.
  /// It first checks if the setting is available in the `isar.settings` database using the user's phone number.
  /// If the setting is found, it returns the setting.
  /// If the setting is not found in the database, it makes an HTTP GET request to the flipperHttpClient
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

    Setting? setting = db.read((isar) =>
        db.settings.where().businessPhoneNumberEqualTo(number).findFirst());

    if (setting != null) {
      return setting;
    }
    Future.delayed(Duration(seconds: 20));
    final Uri uri = Uri.parse("$commApi/settings/$number");
    final http.Response response = await flipperHttpClient.get(uri);

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
    final http.Response response = await flipperHttpClient.patch(
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
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    // get device from isar with linking code and return it
    return db.read((isar) => isar.devices
        .where()
        .phoneEqualTo(phone)
        .and()
        .deletedAtIsNull()
        .and()
        .linkingCodeEqualTo(linkingCode)
        .findFirst());
  }

  @override
  Future<Device?> getDeviceById({required String id}) async {
    // get device from isar with linking code and return it
    return db.read((isar) => isar.devices.where().idEqualTo(id).findFirst());
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) async {
    return db.read((isar) => isar.devices
        .where()
        .businessIdEqualTo(businessId)
        .and()
        .pubNubPublishedEqualTo(false)
        .findAll());
  }

  @override
  Future<ITenant?> getTenantBYUserId({required int userId}) async {
    return await db.iTenants.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Future<ITenant?> getTenantBYPin({required int pin}) async {
    return await db.iTenants
        .where()
        .pinEqualTo(pin)
        .and()
        .isDefaultEqualTo(true)
        .findFirst();
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

    final response = await flipperHttpClient.get(Uri.parse(
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
        /// Set lastKey to the value returned by the API
        String createdAt = jsonDecode(response.body)['lastEvaluatedKey']
            ['createdAt'] as String;
        int id = jsonDecode(response.body)['lastEvaluatedKey']['id'] as int;
        ProxyService.box.writeString(key: 'createdAt', value: createdAt);
        ProxyService.box.writeInt(key: 'id', value: id);
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
    final response = await flipperHttpClient.patch(
      Uri.parse("$commApi/contacts/${businessId}"),
      body: jsonEncode(contact),
    );
    if (response.statusCode != 200) {
      return false;
    }
    return true;
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

    return db.write((isar) {
      isar.stocks.onPut(stock);
      return isar.stocks.get(stock.id);
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
    return db
        .read((isar) => db.eBMs.where().branchIdEqualTo(branchId).findFirst());
  }

  /// Retrieves unsynced data from the local database for the current branch.
  ///
  /// Returns a map containing unsynced lists for stocks, variants, products,
  /// favorites, devices, transactions, and transaction items. Filters for entities
  /// that have been created, updated, or deleted since last sync.
  @override
  Future<
      ({
        List<Stock> stocks,
        List<Variant> variants,
        List<Product> products,
        List<Favorite> favorites,
        List<Device> devices,
        List<ITransaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData() async {
    return db.read((isar) {
      final List<Stock> stocks = isar.stocks
          .where()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .actionIsNotEmpty()
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<Variant> variants = isar.variants
          .where()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<Product> products = isar.products
          .where()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<Favorite> favorites = isar.favorites
          .where()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<Device> devices = isar.devices
          .where()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<ITransaction> transactions = isar.iTransactions
          .where()
          .statusEqualTo(COMPLETE)
          .or()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
          .or()
          .actionEqualTo(AppActions.deleted)
          .and()
          .branchIdEqualTo(ProxyService.box.getBranchId()!)
          .findAll();
      final List<TransactionItem> transactionItems = isar.transactionItems
          .where()
          .doneWithTransactionEqualTo(true)
          .or()
          .actionEqualTo(AppActions.updated)
          .or()
          .actionEqualTo(AppActions.created)
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
    });
  }

  /// App Streams should not be overused... streams should be defined between these comments
  @override
  Stream<Social> socialsStream({required int branchId}) {
    log("socialsStream called", name: "${branchId}");
    return db.read((isar) => db.socials
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .isAccountSetEqualTo(true)
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first));
  }

  /// Retrieves a list of transactions from the database based on the provided filters.
  ///
  /// Status, transaction type, and branch ID can be optionally filtered. Cash out transactions can be isolated.
  /// Pending transactions can optionally be included.
  ///
  /// The filtered query is executed against the database and the matching transactions are returned.
  @override
  Future<List<ITransaction>> transactionsFuture({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  }) async {
    final isarQuery =
        db.iTransactions.where().statusEqualTo(status ?? COMPLETE);

    if (isCashOut) {
      isarQuery.and().transactionTypeEqualTo(TransactionType.cashOut);
    } else {
      isarQuery
          .and()
          .transactionTypeEqualTo(TransactionType.cashIn)
          .or()
          .transactionTypeEqualTo(TransactionType.sale)
          .or()
          .transactionTypeEqualTo(TransactionType.custom)
          .or()
          .transactionTypeEqualTo(TransactionType.onlineSale);
    }

    if (branchId != null) {
      isarQuery.and().branchIdEqualTo(branchId);
    } else {
      branchId = ProxyService.box.getBranchId()!;
      isarQuery.and().branchIdEqualTo(branchId);
    }

    final transactions =
        await db.read((isar) => isarQuery.and().deletedAtIsNull().findAll());

    return transactions;
  }

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  }) {
    final isarQuery =
        db.iTransactions.where().statusEqualTo(status ?? COMPLETE);

    if (isCashOut) {
      isarQuery.and().transactionTypeEqualTo(TransactionType.cashOut);
    } else {
      isarQuery
          .and()
          .transactionTypeEqualTo(TransactionType.cashIn)
          .or()
          .transactionTypeEqualTo(TransactionType.sale)
          .or()
          .transactionTypeEqualTo(TransactionType.custom)
          .or()
          .transactionTypeEqualTo(TransactionType.onlineSale);
    }

    if (branchId != null) {
      isarQuery.and().branchIdEqualTo(branchId);
    } else {
      branchId = ProxyService.box.getBranchId()!;
      isarQuery.and().branchIdEqualTo(branchId);
    }

    return db.read((isar) =>
        isarQuery.and().deletedAtIsNull().watch(fireImmediately: true));
  }

  @override
  Future<List<TransactionItem>> transactionItems(
      {required String transactionId,
      required bool doneWithTransaction,
      required bool active}) async {
    int branchId = ProxyService.box.getBranchId()!;
    return db.read((isar) => db.transactionItems
        .where()
        .transactionIdEqualTo(transactionId)
        .and()
        .doneWithTransactionEqualTo(doneWithTransaction)
        .and()
        .branchIdEqualTo(branchId)
        .and()
        .deletedAtIsNull()
        .and()
        .activeEqualTo(active)
        .findAll());
  }

  @override
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required String customerId}) async* {
    yield* db.read((isar) =>
        isar.iTransactions.where().customerIdEqualTo(customerId).watch());
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    // get device from isar with linking code and return it
    return db.read((isar) => isar.devices
        .where()
        .businessIdEqualTo(businessId)
        .and()
        .deletedAtIsNull()
        .findAll());
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    if (ProxyService.box.getUserPhone() == null) return Stream.empty();
    final phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
    log(phone, name: "top5Conversations");

    return db.read((isar) {
      return isar.conversations
          .where()
          .toNumberEqualTo(phone)
          .or()
          .fromNumberEqualTo(phone)
          .and()
          .deliveredEqualTo(true)
          .sortByCreatedAtDesc()
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
        uniqueConversations
            .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        // Return the top 5 recent conversations
        return uniqueConversations.take(5).toList();
      });
    });
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) {
    if (conversationId == null && ProxyService.box.getUserPhone() != null) {
      // get all conversations addressed to me or from me
      String phone = ProxyService.box.getUserPhone()!.replaceAll("+", "");
      log(phone, name: "LoadInitialList of conversations");
      return db.read((isar) {
        return isar.conversations
            .where()
            .toNumberEqualTo(phone)
            .or()
            .fromNumberEqualTo(phone)
            .and()
            .deliveredEqualTo(true)
            .watch(fireImmediately: true)
            .asyncMap((event) {
          final uniqueUserNames = <String>{};
          final uniqueConversations = <Conversation>[];

          for (final message in event) {
            if (!uniqueUserNames.contains(message.userName)) {
              uniqueUserNames.add(message.userName);
              uniqueConversations.add(message);
            }
          }

          return uniqueConversations;
        });
      });
    } else {
      return db.read((isar) {
        return isar.conversations
            .where()
            .conversationIdEqualTo(conversationId)
            .watch(fireImmediately: true);
      });
    }
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
    log(ProxyService.box.getBranchId()!.toString(), name: "ticketsStreams()");
    return db.read((isar) => isar.iTransactions
        .where()
        .statusEqualTo(PARKED)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .watch(fireImmediately: true));
  }

  Future<void> assignStockToVariant({required String variantId}) async {
    Variant? variant = db.read((isar) => isar.variants.get(variantId));

    Stock? stock = db.read((isar) => isar.stocks
        .where()
        .variantIdEqualTo(variantId)
        .and()
        .branchIdEqualTo(ProxyService.box.getBranchId()!)
        .findFirst());
    if (stock == null) {
      db.write(
        (isar) => isar.stocks.onPut(
          Stock(
              lastTouched: DateTime.now(),
              id: randomString(),
              action: 'create',
              branchId: ProxyService.box.getBranchId()!,
              variantId: variantId,
              currentStock: 0.0,
              productId: variant!.productId),
        ),
      );
    }
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    return db.favorites
        .where()
        .favIndexEqualTo(favIndex)
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    int branchId = ProxyService.box.getBranchId()!;
    return db.variants
        .where()
        .productIdEqualTo(productId)
        .and()
        .deletedAtIsNull()
        .and()
        .branchIdEqualTo(branchId)
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<List<Product>> getProductList({String? prodIndex}) async {
    int branchId = ProxyService.box.getBranchId()!;

    final completer = Completer<List<Product>>();
    final queryBuilder = db.read((isar) => isar.products
        .where()
        .branchIdEqualTo(branchId)
        .and()
        .deletedAtIsNull());

    if (prodIndex != null) {
      queryBuilder.idEqualTo(prodIndex);
    }

    final products = await queryBuilder.findAll();

    completer.complete(products);
    return completer.future;
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    int branchId = ProxyService.box.getBranchId()!;
    if (prodIndex == null) {
      return db.read((isar) => isar.products
          .where()
          .branchIdEqualTo(branchId)
          .and()
          .deletedAtIsNull()
          .watch(fireImmediately: true));
    } else {
      return db.read((isar) => isar.products
          .where()
          .branchIdEqualTo(branchId)
          .and()
          .deletedAtIsNull()
          .and()
          .idEqualTo(prodIndex)
          .watch(fireImmediately: true));
    }
  }

  @override
  Future<Customer?> getCustomer({String? key, String? transactionId}) async {
    if (transactionId != null) {
      ITransaction? tr = db.iTransactions.get(transactionId);
      final customer = await db.read((isar) => isar.customers
          .where()
          .idEqualTo(tr!.customerId ?? '0')
          .deletedAtIsNull()
          .sortByLastTouchedDesc()
          .findFirst());

      return customer;
    } else {
      final customer = await db.read((isar) => db.customers
          .where()
          .nameContains(key!)
          .or()
          .emailContains(key)
          .or()
          .phoneContains(key)
          .and()
          .deletedAtIsNull()
          .findFirst());

      return customer;
    }
  }

  Future<bool> hasNoActivityInLast5Minutes(
      {required int userId, int? refreshRate = 5}) async {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time [timer] minutes ago
    DateTime fiveMinutesAgo =
        currentTime.subtract(Duration(minutes: refreshRate!));

    // Retrieve the user activities
    List<UserActivity> userActivities = await activities(userId: userId);

    // Assume no activity in the last 5 minutes by default
    bool returnValue = true;

    for (var activity in userActivities) {
      if (activity.lastTouched!.isAfter(fiveMinutesAgo)) {
        // The user has done an activity within the last 5 minutes
        returnValue = false;
        break; // No need to continue checking, we found an activity
      }
    }
    return returnValue;
  }

  @override
  Stream<ITenant?> authState({required int branchId}) {
    int userId = ProxyService.box.getUserId()!;
    return db.read((isar) => isar.iTenants
        .where()
        .userIdEqualTo(userId)
        .deletedAtIsNull()
        .sortByLastTouchedDesc()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first));
  }

  @override
  Future<void> refreshSession(
      {required int branchId, int? refreshRate = 5}) async {
    while (true) {
      try {
        int userId = ProxyService.box.getUserId()!;
        bool noActivity = await hasNoActivityInLast5Minutes(
            userId: userId, refreshRate: refreshRate);
        log(noActivity.toString(), name: 'session');
        log(userId.toString(), name: 'session');
        if (noActivity) {
          ITenant? tenant = await ProxyService.isar
              .getTenantBYUserId(userId: ProxyService.box.getUserId()!);
          tenant?.sessionActive = false;
          ProxyService.isar.update(data: tenant);
        }
      } catch (error) {
        print('Error fetching tenant: $error');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) async {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return db.read((isar) => isar.userActivitys
        .where()
        .lastTouchedBetween(startOfDay, endOfDay)
        .findAll());
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) async {
    db.write((isar) => isar.userActivitys.put(UserActivity(
        userId: userId,
        action: activity,
        id: randomString(),
        timestamp: DateTime.now(),
        lastTouched: DateTime.now())));
  }

  /// there is cases where singup fail and there is some variable saved
  /// in this case for us to be clean better clean them for next attempt
  @override
  Future<void> logOutLight() async {
    ProxyService.box.remove(key: 'userId');
    ProxyService.box.remove(key: 'getIsTokenRegistered');
    ProxyService.box.remove(key: 'bearerToken');
    ProxyService.box.remove(key: 'branchId');
    ProxyService.box.remove(key: 'userPhone');
    ProxyService.box.remove(key: 'UToken');
    ProxyService.box.remove(key: 'businessId');
    ProxyService.box.remove(key: 'defaultApp');
  }

  //  @override
  ///TODO: @Richard add flag from backend to define if tenant is default
  @override
  Stream<ITenant?> getDefaultTenant({required int businessId}) {
    return db.iTenants
        .where()
        .businessIdEqualTo(businessId)
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .asyncMap((event) => event.first);
  }

  @override
  Future<List<Customer>> customers({required int branchId}) async {
    return db.read(
        (isar) => isar.customers.where().branchIdEqualTo(branchId).findAll());
  }

  @override
  Future<List<SyncRecord>> syncedModels({required int branchId}) async {
    return db.read(
        (isar) => isar.syncRecords.where().branchIdEqualTo(branchId).findAll());
  }

  List<ITransaction> findAndFilter(
      List<ITransaction> transactions, int branchId) {
    return transactions
        .where((transaction) => transaction.supplierId == branchId)
        .toList();
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    return db.read(
      (isar) => isar.iTransactions
          .where()
          .statusEqualTo(PENDING)
          .watch(fireImmediately: true)
          .map((transactions) => findAndFilter(transactions, branchId)),
    );
  }
}
