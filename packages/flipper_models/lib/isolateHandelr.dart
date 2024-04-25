import 'dart:isolate';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:flipper_models/realm/realmCounter.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
// import 'package:flipper_models/realm/realmIUnit.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart' as iRealm;

import 'package:flutter/services.dart';
import 'models.dart';
import './RealmSync.dart';

mixin IsolateHandler {
  static late Isar isar;

  static Future<void> handleEBMTrigger(List<dynamic> args) async {
    isar = await openIsarIsolate();
    do {
      // load all variants
      List<Variant> variants =
          await isar.read((isar) => isar.variants.where().findAll());
      for (Variant variant in variants) {
        if (!variant.ebmSynced) {
          try {
            RWTax().saveItem(variation: variant);
            variant.ebmSynced = true;
            isar.write((isar) => isar.variants.put(variant));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            variant.ebmSynced = false;
            isar.write((isar) => isar.variants.put(variant));
          }
        }
      }
      // load all stock
      List<Stock> stocks =
          await isar.read((isar) => isar.stocks.where().findAll());
      for (Stock stock in stocks) {
        if (!stock.ebmSynced) {
          try {
            RWTax().saveStock(stock: stock);
            stock.ebmSynced = true;
            isar.write((isar) => isar.stocks.put(stock));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            stock.ebmSynced = false;
            isar.write((isar) => isar.stocks.put(stock));
          }
        }
      }
      // load all customer
      List<Customer> customers =
          await isar.read((isar) => isar.customers.where().findAll());
      for (Customer customer in customers) {
        if (!customer.ebmSynced) {
          try {
            RWTax().saveCustomer(customer: customer);
            customer.ebmSynced = true;
            isar.write((isar) => isar.customers.put(customer));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            customer.ebmSynced = false;
            isar.write((isar) => isar.customers.put(customer));
          }
        }
      }
    } while (true);
  }

  Future updateIsolate<T>(T value) async {
    isar = await openIsarIsolate();
    // do the actual isar update
    if (value is Product) {
      isar.write((isar) => isar.products.put(value));
    }
  }

  static Future handleProducts(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await openIsarIsolate();
    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);

    final iProductsCollection =
        realm.query<RealmProduct>(r'branchId == $0', [branchId]);
    await for (final changes in iProductsCollection.changes) {
      for (final result in changes.results) {
        handleProduct(result, sendPort);
      }
    }
  }

  static Future handleCounters(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    isar = await openIsarIsolate();
    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);
    final iCountersCollection =
        realm.query<RealmCounter>(r'branchId == $0', [branchId]);

    await for (final changes in iCountersCollection.changes) {
      for (final result in changes.results) {
        handlecounter(result, sendPort);
      }
    }
  }

  static void handlecounter(RealmCounter result, SendPort sendPort) {
    final model = createCounterModel(result);
    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    Counter data = Counter.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    Counter? localTransaction = isar.counters
        .where()
        .receiptTypeEqualTo(result.receiptType!.toUpperCase())
        .findFirst();
    if (localTransaction == null) {
      isar.write((isar) {
        isar.counters.put(data);
      });
      sendPort.send('Created Counter ${model.id}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      isar.write((isar) {
        isar.counters.put(data);
      });
      sendPort.send('Updated Counter ${model.id}');
    }
  }

  static Future handleVariants(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await openIsarIsolate();
    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);
    final iVariantsCollection =
        realm.query<RealmVariant>(r'branchId == $0', [branchId]);

    await for (final changes in iVariantsCollection.changes) {
      for (final result in changes.results) {
        handleVariant(result, sendPort);
      }
    }
  }

  static Future handleStocs(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await openIsarIsolate();
    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);

    final iStocksCollection =
        realm.query<RealmStock>(r'branchId == $0', [branchId]);

    await for (final changes in iStocksCollection.changes) {
      for (final result in changes.results) {
        handleStock(result, sendPort);
      }
    }
  }

  static Future handleTransactionItems(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await openIsarIsolate();
    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);

    /// subscribe to change for
    final iTransactionsItemCollection =
        realm.query<RealmITransactionItem>(r'branchId == $0', [branchId]);

    await for (final changes in iTransactionsItemCollection.changes) {
      for (final result in changes.results) {
        handleTransactionItem(result, sendPort);
      }
    }
  }

  static Future handleTransactions(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await openIsarIsolate();

    final app = iRealm.App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    iRealm.FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = iRealm.Realm(config);
    sendPort.send('Initiated isar');
    // Realm.logger.level = RealmLogLevel.trace;
    // final realm = await Realm.open(config);
    sendPort.send('Initiated realm ${branchId}');
    // Subscribe to changes for transactions
    final iTransactionsCollection =
        realm.query<RealmITransaction>(r'branchId == $0', [branchId]);
    // query all local object and match them with read db

    // listen for changes
    await for (final changes in iTransactionsCollection.changes) {
      for (final result in changes.results) {
        handleTransactionData(result, sendPort);
      }
    }
  }

  static iRealm.FlexibleSyncConfiguration realmConfig(
    iRealm.User? user,
    List<int> encryptionKey,
    String dbPatch,
  ) {
    final config = iRealm.Configuration.flexibleSync(
      user!,
      realmModels,
      encryptionKey: encryptionKey,
      path: dbPatch,
    );
    return config;
  }

  static void handleStock(RealmStock result, SendPort sendPort) {
    final model = createStockModel(result);
    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    // handleItem(model: model, branchId: result.branchId);
    Stock data = Stock.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    Stock? localTransaction = isar.stocks.get(data.id);
    if (localTransaction == null) {
      isar.write((isar) {
        isar.stocks.put(data);
      });
      sendPort.send('Created Stock ${model.id}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      isar.write((isar) {
        isar.stocks.put(data);
      });
      sendPort.send('Updated Stock ${model.id}');
    }
  }

  static void handleProduct(RealmProduct result, SendPort sendPort) {
    final model = createProductModel(result);

    sendPort.send('Received Product ${model.id}');

    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    Product data = Product.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    Product? localTransaction = isar.products.get(data.id);
    if (localTransaction == null) {
      isar.write((isar) {
        isar.products.put(data);
      });
      sendPort.send('Created Product ${model.id}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      isar.write((isar) {
        isar.products.put(data);
      });
      sendPort.send('Updated Product ${model.id}');
    }
  }

  static void handleVariant(RealmVariant result, SendPort sendPort) {
    final model = createVariantModel(result);
    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    Variant data = Variant.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    Variant? localTransaction = isar.variants.get(data.id);
    if (localTransaction == null) {
      isar.write((isar) {
        isar.variants.put(data);
      });
      sendPort.send('Created Variant ${model.id}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      isar.write((isar) {
        isar.variants.put(data);
      });
      sendPort.send('Updated Variant ${model.id}');
    }
  }

  static void handleTransactionItem(
      RealmITransactionItem result, SendPort sendPort) {
    final model = createTransactionItemModel(result);
    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    //handleItem(model: model, branchId: result.branchId);
    TransactionItem data = TransactionItem.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    TransactionItem? localTransaction = isar.transactionItems.get(data.id);
    if (localTransaction == null) {
      isar.write((isar) {
        isar.transactionItems.put(data);
      });
      sendPort.send('Created transactionItem ${model.id}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
      isar.write((isar) {
        isar.transactionItems.put(data);
      });
      sendPort.send('Updated transactionItem ${model.id}');
    }
  }

  static void handleTransactionData(
      RealmITransaction result, SendPort sendPort) {
    final model = iTransactionModel(result);

    /// avoid saving saving a pending transaction to avoid
    /// missing out showing this transaction, when we support showing pending
    /// transaction on different device this might change
    if (model.status == PENDING) return;
    //sendPort.send('Got transaction ${model.subTotal}');

    if (model.action == AppActions.deleted && model.deletedAt == null) {
      model.deletedAt = DateTime.now();
    }
    ITransaction data = ITransaction.fromJson(model.toJson());
    data.action = AppActions.synchronized;
    ITransaction? localTransaction = isar.iTransactions.get(data.id);
    if (localTransaction == null) {
      isar.write((isar) {
        isar.iTransactions.put(data);
      });

      sendPort.send('Created transaction ${model.subTotal}');
    } else if (data.lastTouched
        .isNewDateCompareTo(localTransaction.lastTouched)) {
      data.action = AppActions.synchronized;

      isar.write((isar) {
        isar.iTransactions.put(data);
      });
      sendPort.send('Updated transaction ${model.id}');
    }
  }

  static Stock createStockModel(RealmStock realmStock) {
    return Stock(
      id: realmStock.id,
      branchId: realmStock.branchId,
      variantId: realmStock.variantId,
      lowStock: realmStock.lowStock,
      currentStock: realmStock.currentStock,
      canTrackingStock: realmStock.canTrackingStock,
      showLowStockAlert: realmStock.showLowStockAlert,
      productId: realmStock.productId,
      active: realmStock.active,
      value: realmStock.value,
      rsdQty: realmStock.rsdQty,
      supplyPrice: realmStock.supplyPrice,
      retailPrice: realmStock.retailPrice,
      lastTouched: realmStock.lastTouched,
      action: realmStock.action,
      deletedAt: realmStock.deletedAt,
    );
  }

  static Product createProductModel(RealmProduct realmProduct) {
    return Product(
      id: realmProduct.id,
      name: realmProduct.name,
      description: realmProduct.description,
      taxId: realmProduct.taxId,
      color: realmProduct.color,
      businessId: realmProduct.businessId,
      branchId: realmProduct.branchId,
      supplierId: realmProduct.supplierId,
      categoryId: realmProduct.categoryId,
      createdAt: realmProduct.createdAt,
      unit: realmProduct.unit,
      imageUrl: realmProduct.imageUrl,
      expiryDate: realmProduct.expiryDate,
      barCode: realmProduct.barCode,
      nfcEnabled: realmProduct.nfcEnabled,
      bindedToTenantId: realmProduct.bindedToTenantId,
      isFavorite: realmProduct.isFavorite,
      lastTouched: realmProduct.lastTouched,
      action: realmProduct.action,
      deletedAt: realmProduct.deletedAt,
      searchMatch: realmProduct.searchMatch ?? false,
    );
  }

  static Counter createCounterModel(RealmCounter realmCounter) {
    return Counter(
        id: realmCounter.id!,
        businessId: realmCounter.businessId!,
        action: AppActions.created,
        branchId: realmCounter.branchId!,
        curRcptNo: realmCounter.curRcptNo!,
        lastTouched: realmCounter.lastTouched,
        receiptType: realmCounter.receiptType!,
        totRcptNo: realmCounter.totRcptNo!);
  }

  static Variant createVariantModel(RealmVariant realmVariant) {
    return Variant(
      dftPrc: realmVariant.dftPrc,
      name: realmVariant.name,
      color: realmVariant.color,
      sku: realmVariant.sku,
      productId: realmVariant.productId,
      unit: realmVariant.unit,
      productName: realmVariant.productName,
      branchId: realmVariant.branchId,
      taxName: realmVariant.taxName,
      taxPercentage: realmVariant.taxPercentage,
      isTaxExempted: realmVariant.isTaxExempted,
      isrcAplcbYn: realmVariant.isrcAplcbYn,
      modrId: realmVariant.modrId,
      rsdQty: realmVariant.rsdQty,
      action: realmVariant.action,
      id: realmVariant.id,
      taxTyCd: realmVariant.taxTyCd,
      bcd: realmVariant.bcd,
      itemClsCd: realmVariant.itemClsCd,
      itemTyCd: realmVariant.itemTyCd,
      itemStdNm: realmVariant.itemStdNm,
      addInfo: realmVariant.addInfo,
      pkg: realmVariant.pkg,
      useYn: realmVariant.useYn,
      regrNm: realmVariant.regrNm,
      modrNm: realmVariant.modrNm,
      itemNm: realmVariant.itemNm,
      lastTouched: realmVariant.lastTouched,
      retailPrice: realmVariant.retailPrice,
      deletedAt: realmVariant.deletedAt,
      tin: realmVariant.tin,
      bhfId: realmVariant.bhfId,
      regrId: realmVariant.regrId,
      orgnNatCd: realmVariant.orgnNatCd,
      itemSeq: realmVariant.itemSeq,
      itemCd: realmVariant.itemCd,
      isrccCd: realmVariant.isrccCd,
      pkgUnitCd: realmVariant.pkgUnitCd,
      supplyPrice: realmVariant.supplyPrice,
      qtyUnitCd: realmVariant.qtyUnitCd,
      isrccNm: realmVariant.isrccNm,
      qty: realmVariant.qty,
      isrcRt: realmVariant.isrcRt,
      prc: realmVariant.prc,
      isrcAmt: realmVariant.isrcAmt,
      splyAmt: realmVariant.splyAmt,
    );
  }

  static TransactionItem createTransactionItemModel(
      RealmITransactionItem item) {
    return TransactionItem(
      action: item.action,
      id: item.id,
      branchId: item.branchId,
      createdAt: item.createdAt,
      isTaxExempted: item.isTaxExempted,
      name: item.name,
      price: item.price,
      qty: item.qty,
      remainingStock: item.remainingStock,
      transactionId: item.transactionId,
      updatedAt: item.createdAt,
      variantId: item.variantId,
      addInfo: item.addInfo,
      bcd: item.bcd,
      bhfId: item.bhfId,
      dcAmt: item.dcAmt,
      dcRt: item.dcRt,
      deletedAt: item.deletedAt,
      dftPrc: item.dftPrc,
      discount: item.discount,
      doneWithTransaction: item.doneWithTransaction,
      isRefunded: item.isRefunded,
      isrcAmt: item.isrcAmt,
      isrcAplcbYn: item.isrcAplcbYn,
      isrcRt: item.isrcRt,
      isrccCd: item.isrccCd,
      isrccNm: item.isrccNm,
      itemCd: item.itemCd,
      itemClsCd: item.itemClsCd,
      itemNm: item.itemNm,
      itemSeq: item.itemSeq,
      itemStdNm: item.itemStdNm,
      itemTyCd: item.itemTyCd,
      modrId: item.modrId,
      pkgUnitCd: item.pkgUnitCd,
      regrNm: item.regrNm,
      splyAmt: item.splyAmt,
      prc: item.prc ?? item.price,
      taxblAmt: item.taxblAmt,
      totAmt: item.totAmt,
      qtyUnitCd: item.qtyUnitCd,
      useYn: item.useYn,
      orgnNatCd: item.orgnNatCd,
      modrNm: item.modrNm,
      pkg: item.pkg,
      tin: item.tin,
      type: item.type,
      taxTyCd: item.taxTyCd,
      taxAmt: item.taxAmt,
      regrId: item.regrId,
      lastTouched: item.lastTouched,
    );
  }

  static ITransaction iTransactionModel(RealmITransaction result) {
    return ITransaction(
      reference: result.reference,
      transactionNumber: result.transactionNumber,
      branchId: result.branchId,
      status: result.status,
      transactionType: result.transactionType,
      subTotal: result.subTotal,
      paymentType: result.paymentType,
      cashReceived: result.cashReceived,
      customerChangeDue: result.customerChangeDue,
      createdAt: result.createdAt,
      supplierId: result.supplierId,
      id: result.id,
      lastTouched: result.lastTouched,
      action: result.action,
    );
  }

  /// receive data from realm, spwan new isolate
  /// https://stackoverflow.com/questions/71746186/multiple-isolates-vs-one-isolate
  /// ---->call the realm function that start everything in the isolate
  /// this is a function
  /// compute(onSave, 10000).then(() {
  ///print('isolate finished');
  ///});
  /// within also have the isar as required also initiated at the same tim
  /// in isolate

  static Future<Isar> openIsarIsolate() async {
    return await Isar.open(
      schemas: models,
      // in isolate we don't pass in the directory
      directory: '',
      engine: IsarEngine.isar,
      name: 'default',
      inspector: false,
    );
  }
}
