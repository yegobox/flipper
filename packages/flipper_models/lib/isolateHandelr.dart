import 'dart:isolate';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmIUnit.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart';

import 'package:flutter/services.dart';
import 'models.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

mixin IsolateHandler {
  static late Isar isar;
  Future updateIsolate<T>(T value) async {
    isar = await isarK();
    // do the actual isar update
    if (value is Product) {
      isar.write((isar) => isar.products.put(value));
    }
  }

  static Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final realmDirectory = '${appDocsDirectory.path}/flipper-sync';
    if (!Directory(realmDirectory).existsSync()) {
      await Directory(realmDirectory).create(recursive: true);
    }
    return "$realmDirectory/$fileName";
  }

  static Future handleRealm(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final encryptionKey = args[3] as String;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // get isar instances
    isar = await isarK();

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    List<int> key = encryptionKey.toIntList();
    final config = Configuration.flexibleSync(
      user!,
      [
        RealmITransaction.schema,
        RealmITransactionItem.schema,
        RealmProduct.schema,
        RealmVariant.schema,
        RealmStock.schema,
        RealmIUnit.schema
      ],
      path: await absolutePath("db_"),
      shouldCompactCallback: ((totalSize, usedSize) {
        // Compact if the file is over 10MB in size and less than 50% 'used'
        const tenMB = 10 * 1048576;
        return (totalSize > tenMB) &&
            (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
      }),
    );

    final realm = Realm(config);
    sendPort.send('Inited isar');
    Realm.logger.level = RealmLogLevel.trace;
    // final realm = await Realm.open(config);
    sendPort.send('Inited realm ${branchId}');
    // Subscribe to changes for transactions
    final iTransactionsCollection =
        realm.query<RealmITransaction>(r'branchId == $0', [branchId]);

    await for (final changes in iTransactionsCollection.changes) {
      for (final result in changes.results) {
        final model = createmodel(result);

        /// avoid saving saving a pending transaction to avoid
        /// missing out showing this transaction, when we support showing pending
        /// transaction on different device this might change
        if (model.status == PENDING) return;
        if (model.action == AppActions.deleted && model.deletedAt == null) {
          model.deletedAt = DateTime.now();
        }
        ITransaction data = ITransaction.fromJson(model.toJson());
        data.action = AppActions.synchronized;
        ITransaction? localTransaction = isar.iTransactions.get(data.id);
        if (localTransaction == null) {
          data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
          isar.write((isar) {
            isar.iTransactions.put(data);
          });

          sendPort.send('Created transaction ${model.subTotal}');
        } else if (data.lastTouched
            .isNewDateCompareTo(localTransaction.lastTouched)) {
          data.action = AppActions.synchronized;

          data.lastTouched = DateTime.now().toLocal().add(Duration(hours: 2));
          isar.write((isar) {
            isar.iTransactions.put(data);
          });
          sendPort.send('Updated transaction ${model.id}');
        }
      }
    }

    /// subscribe to change for
    final iTransactionsItemCollection =
        realm.query<RealmITransactionItem>(r'branchId == $0', [branchId]);

    await for (final changes in iTransactionsItemCollection.changes) {
      for (final result in changes.results) {
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
    }

    //
    final iVariantsCollection =
        realm.query<RealmVariant>(r'branchId == $0', [branchId]);

    await for (final changes in iVariantsCollection.changes) {
      for (final result in changes.results) {
        final model = createVariantModel(result);
        if (model.action == AppActions.deleted && model.deletedAt == null) {
          model.deletedAt = DateTime.now();
        }
        // handleItem(model: model, branchId: result.branchId);
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
    }
    //
    final iProductsCollection =
        realm.query<RealmProduct>(r'branchId == $0', [branchId]);

    await for (final changes in iProductsCollection.changes) {
      for (final result in changes.results) {
        final model = createProductModel(result);
        if (model.action == AppActions.deleted && model.deletedAt == null) {
          model.deletedAt = DateTime.now();
        }
        // handleItem(model: model, branchId: result.branchId);
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
    }
    //
    final iStocksCollection =
        realm.query<RealmStock>(r'branchId == $0', [branchId]);
    await for (final changes in iStocksCollection.changes) {
      for (final result in changes.results) {
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
      prc: item.prc,
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

  static ITransaction createmodel(RealmITransaction result) {
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

  static Future<Isar> isarK() async {
    return await Isar.open(
      schemas: models,
      directory: '',
      engine: IsarEngine.isar,
      name: 'default',
    );
  }
}
