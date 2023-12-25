import 'dart:io';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'remote_service.dart';
import 'sync.dart';
import 'package:realm/realm.dart';

abstract class SyncReaml<M extends IJsonSerializable> implements Sync {
  Future<void> onSave<T extends IJsonSerializable>({required T item});
  factory SyncReaml.create() => RealmSync<M>();
  Future<void> configure();
}

class RealmSync<M extends IJsonSerializable>
    with HandleItemMixin
    implements SyncReaml<M> {
  Realm? realm;
  @override
  Future<void> configure() async {
    int? branchId = ProxyService.box.getBranchId();
    if (realm == null) {
      final app = App(AppConfiguration('application-0-hwctb'));
      final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
      realm = Realm(Configuration.flexibleSync(user, [
        RealmITransaction.schema,
        RealmITransactionItem.schema,
        RealmProduct.schema,
        RealmVariant.schema,
        RealmStock.schema,
      ]));
      realm!.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(
            realm!.query<RealmITransaction>(r'branchId == $0', [branchId]));
        mutableSubscriptions.add(
            realm!.query<RealmITransactionItem>(r'branchId == $0', [branchId]));

        mutableSubscriptions
            .add(realm!.query<RealmProduct>(r'branchId == $0', [branchId]));

        mutableSubscriptions
            .add(realm!.query<RealmVariant>(r'branchId == $0', [branchId]));

        mutableSubscriptions
            .add(realm!.query<RealmStock>(r'branchId == $0', [branchId]));
      });
      await realm!.subscriptions.waitForSynchronization();
    }
  }

  @override
  Future<void> localChanges() {
    // TODO: implement localChanges
    throw UnimplementedError();
  }

  @override
  Future<void> onSave<T extends IJsonSerializable>({required T item}) async {
    if (realm == null) {
      await configure();
    }
    if (item is ITransaction) {
      if (item.action == AppActions.updatedLocally) return;
      final realmITransaction = RealmITransaction(
        item.id,
        ObjectId(),
        item.reference,
        item.transactionNumber,
        item.branchId,
        item.status,
        item.transactionType,
        item.subTotal,
        item.paymentType,
        item.cashReceived,
        item.customerChangeDue,
        item.createdAt,
        item.action,
        categoryId: item.categoryId,
        customerId: item.customerId,
        deletedAt: item.deletedAt,
        lastTouched: item.lastTouched,
        note: item.note,
        receiptType: item.receiptType,
        retailerId: item.supplierId,
        ticketName: item.ticketName,
        updatedAt: item.updatedAt,
      );

      // Save _RealmITransaction to the Realm database
      await realm!.write(() {
        final findableObject =
            realm!.query<RealmITransaction>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm!.add(realmITransaction, update: true);
        } else {
          findableObject.first.reference = realmITransaction.reference;
          findableObject.first.transactionNumber =
              realmITransaction.transactionNumber;
          findableObject.first.branchId = realmITransaction.branchId;
          findableObject.first.status = realmITransaction.status;
          findableObject.first.transactionType =
              realmITransaction.transactionType;
          findableObject.first.subTotal = realmITransaction.subTotal;
          findableObject.first.paymentType = realmITransaction.paymentType;
          findableObject.first.cashReceived = realmITransaction.cashReceived;
          findableObject.first.customerChangeDue =
              realmITransaction.customerChangeDue;
          findableObject.first.createdAt = realmITransaction.createdAt;
          findableObject.first.action = realmITransaction.action;
          findableObject.first.categoryId = realmITransaction.categoryId;
          findableObject.first.customerId = realmITransaction.customerId;
          findableObject.first.deletedAt = realmITransaction.deletedAt;
          findableObject.first.lastTouched = realmITransaction.lastTouched;
          findableObject.first.note = realmITransaction.note;
          findableObject.first.receiptType = realmITransaction.receiptType;
          findableObject.first.retailerId = realmITransaction.retailerId;
          findableObject.first.ticketName = realmITransaction.ticketName;
          findableObject.first.updatedAt = realmITransaction.updatedAt;
        }
      });
    }

    if (item is TransactionItem) {
      if (item.action == AppActions.updatedLocally) return;
      final realmITransactionItem = RealmITransactionItem(
        ObjectId(),
        item.name,
        item.transactionId,
        item.variantId,
        item.qty,
        item.price,
        item.action,
        item.branchId,
        item.remainingStock,
        item.createdAt,
        item.id,
        item.updatedAt,
        item.isTaxExempted,
        addInfo: item.addInfo,
        deletedAt: item.deletedAt,
        lastTouched: item.lastTouched,
        bcd: item.bcd,
        bhfId: item.bhfId,
        dcAmt: item.dcAmt,
        dcRt: item.dcRt,
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
        modrNm: item.modrNm,
        orgnNatCd: item.orgnNatCd,
        pkg: item.pkg,
        pkgUnitCd: item.pkgUnitCd,
        prc: item.prc,
        qtyUnitCd: item.qtyUnitCd,
        regrId: item.regrId,
        regrNm: item.regrNm,
        splyAmt: item.splyAmt,
        taxAmt: item.taxAmt,
        taxTyCd: item.taxTyCd,
        taxblAmt: item.taxAmt,
        tin: item.tin,
        totAmt: item.totAmt,
        type: item.type,
        useYn: item.useYn,
      );

      // Save _RealmITransaction to the Realm database
      await realm!.write(() {
        final findableObject =
            realm!.query<RealmITransactionItem>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm!.add(realmITransactionItem, update: true);
        } else {
          findableObject.first.action = realmITransactionItem.action;
          findableObject.first.branchId = realmITransactionItem.branchId;
          findableObject.first.remainingStock =
              realmITransactionItem.remainingStock;
          findableObject.first.createdAt = realmITransactionItem.createdAt;
          findableObject.first.name = realmITransactionItem.name;
          findableObject.first.transactionId =
              realmITransactionItem.transactionId;
          findableObject.first.variantId = realmITransactionItem.variantId;
          findableObject.first.qty = realmITransactionItem.qty;
          findableObject.first.price = realmITransactionItem.price;
          findableObject.first.id = realmITransactionItem.id;
          findableObject.first.updatedAt = realmITransactionItem.updatedAt;
          findableObject.first.isTaxExempted =
              realmITransactionItem.isTaxExempted;
        }
      });
    }
    if (item is Product) {
      if (item.action == AppActions.updatedLocally) return;
      final realmProduct = RealmProduct(
        item.id,
        ObjectId(), // Auto-generate ObjectId for realmId
        item.name,
        item.color,
        item.businessId,
        item.branchId,
        item.action,
        description: item.description,
        taxId: item.taxId,
        supplierId: item.supplierId,
        categoryId: item.categoryId,
        createdAt: item.createdAt,
        unit: item.unit,
        imageUrl: item.imageUrl,
        expiryDate: item.expiryDate,
        barCode: item.barCode,
        nfcEnabled: item.nfcEnabled,
        bindedToTenantId: item.bindedToTenantId,
        isFavorite: item.isFavorite,
        lastTouched: item.lastTouched, // Update lastTouched timestamp
      );

      // Save _RealmITransaction to the Realm database
      realm!.refresh();
      await realm!.write(() {
        final findableObject =
            realm!.query<RealmProduct>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          final o = realm!.add(realmProduct);
          print(o);
        } else {
          findableObject.first.action = realmProduct.action;
          findableObject.first.branchId = realmProduct.branchId;
          findableObject.first.name = realmProduct.name;
          findableObject.first.color = realmProduct.color;
        }
      });
    }
    if (item is Variant) {
      if (item.action == AppActions.updatedLocally) return;
      final realmVariant = RealmVariant(
        ObjectId(), // Auto-generate ObjectId for realmId
        item.name,
        item.color,
        item.sku,
        item.productId,
        item.unit,
        item.productName,
        item.branchId,
        item.isTaxExempted,
        item.action,
        item.id,
        item.retailPrice,
        item.supplyPrice,
        dftPrc: item.dftPrc,
        taxName: item.taxName,
        taxPercentage: item.taxPercentage,
        isrcAplcbYn: item.isrcAplcbYn,
        modrId: item.modrId,
        rsdQty: item.rsdQty,
        taxTyCd: item.taxTyCd,
        bcd: item.bcd,
        itemClsCd: item.itemClsCd,
        itemTyCd: item.itemTyCd,
        itemStdNm: item.itemStdNm,
        addInfo: item.addInfo,
        pkg: item.pkg,
        useYn: item.useYn,
        regrNm: item.regrNm,
        modrNm: item.modrNm,
        itemNm: item.itemNm,
        lastTouched: item.lastTouched,
        deletedAt: item.deletedAt,
        tin: item.tin,
        bhfId: item.bhfId,
        regrId: item.regrId,
        orgnNatCd: item.orgnNatCd,
        itemSeq: item.itemSeq,
        itemCd: item.itemCd,
        isrccCd: item.isrccCd,
        pkgUnitCd: item.pkgUnitCd,
        qtyUnitCd: item.qtyUnitCd,
        isrccNm: item.isrccNm,
        qty: item.qty,
        isrcRt: item.isrcRt,
        prc: item.prc,
        isrcAmt: item.isrcAmt,
        splyAmt: item.splyAmt,
      );

      await realm!.write(() {
        final findableObject =
            realm!.query<RealmVariant>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Variant doesn't exist, add it
          realm!.add(realmVariant);
        } else {
          // Variant exists, update it
          findableObject.first.action = realmVariant.action;
          findableObject.first.branchId = realmVariant.branchId;
          findableObject.first.name = realmVariant.name;
          findableObject.first.color = realmVariant.color;
          findableObject.first.sku = realmVariant.sku;
          findableObject.first.productId = realmVariant.productId;
          findableObject.first.unit = realmVariant.unit;
          findableObject.first.productName = realmVariant.productName;
          findableObject.first.isTaxExempted = realmVariant.isTaxExempted;
          findableObject.first.id = realmVariant.id;
          findableObject.first.retailPrice = realmVariant.retailPrice;
          findableObject.first.supplyPrice = realmVariant.supplyPrice;
          findableObject.first.dftPrc = realmVariant.dftPrc;
          findableObject.first.taxName = realmVariant.taxName;
          findableObject.first.taxPercentage = realmVariant.taxPercentage;
          findableObject.first.isrcAplcbYn = realmVariant.isrcAplcbYn;
          findableObject.first.modrId = realmVariant.modrId;
          findableObject.first.rsdQty = realmVariant.rsdQty;
          findableObject.first.taxTyCd = realmVariant.taxTyCd;
          findableObject.first.bcd = realmVariant.bcd;
          findableObject.first.itemClsCd = realmVariant.itemClsCd;
          findableObject.first.itemTyCd = realmVariant.itemTyCd;
          findableObject.first.itemStdNm = realmVariant.itemStdNm;
          findableObject.first.addInfo = realmVariant.addInfo;
          findableObject.first.pkg = realmVariant.pkg;
          findableObject.first.useYn = realmVariant.useYn;
          findableObject.first.regrNm = realmVariant.regrNm;
          findableObject.first.modrNm = realmVariant.modrNm;
          findableObject.first.itemNm = realmVariant.itemNm;
          findableObject.first.tin = realmVariant.tin;
          findableObject.first.bhfId = realmVariant.bhfId;
          findableObject.first.regrId = realmVariant.regrId;
          findableObject.first.orgnNatCd = realmVariant.orgnNatCd;
          findableObject.first.itemSeq = realmVariant.itemSeq;
          findableObject.first.itemCd = realmVariant.itemCd;
          findableObject.first.pkgUnitCd = realmVariant.pkgUnitCd;
          findableObject.first.qtyUnitCd = realmVariant.qtyUnitCd;
        }
      });
    }
    if (item is Stock) {
      if (item.action == AppActions.updatedLocally) return;
      final realmStock = RealmStock(
        item.id,
        ObjectId(), // Auto-generate ObjectId for realmId
        item.branchId,
        item.variantId,
        item.currentStock,
        item.productId,
        item.action,
        lowStock: item.lowStock,
        canTrackingStock: item.canTrackingStock,
        showLowStockAlert: item.showLowStockAlert,
        active: item.active,
        value: item.value,
        rsdQty: item.rsdQty,
        supplyPrice: item.supplyPrice,
        retailPrice: item.retailPrice,
        lastTouched: item.lastTouched,
        deletedAt: item.deletedAt,
      );

      await realm!.write(() {
        final findableObject = realm!.query<RealmStock>(r'id == $0', [item.id]);
        if (findableObject.isEmpty) {
          // Stock doesn't exist, add it
          realm!.add(realmStock);
        } else {
          // Stock exists, update it
          findableObject.first.action = realmStock.action;
          findableObject.first.branchId = realmStock.branchId;
          findableObject.first.variantId = realmStock.variantId;
          findableObject.first.currentStock = realmStock.currentStock;
          findableObject.first.productId = realmStock.productId;
          findableObject.first.lowStock = realmStock.lowStock;
          findableObject.first.canTrackingStock = realmStock.canTrackingStock;
          findableObject.first.showLowStockAlert = realmStock.showLowStockAlert;
          findableObject.first.active = realmStock.active;
          findableObject.first.value = realmStock.value;
          findableObject.first.rsdQty = realmStock.rsdQty;
          findableObject.first.supplyPrice = realmStock.supplyPrice;
          findableObject.first.retailPrice = realmStock.retailPrice;
        }
      });
    }
  }

  @override
  Future<void> pull() async {
    int branchId = ProxyService.box.getBranchId()!;
    if (realm == null) {
      await configure();
    }
    if (realm != null) {
      // Subscribe to changes for transactions
      final iTransactionsCollection =
          realm!.query<RealmITransaction>(r'branchId == $0', [branchId]);

      iTransactionsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      // Subscribe to changes for transaction items
      final iTransactionsItemCollection =
          realm!.query<RealmITransactionItem>(r'branchId == $0', [branchId]);

      iTransactionsItemCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionItemModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      // Subscribe to changes for products
      final iProductsCollection =
          realm!.query<RealmProduct>(r'branchId == $0', [branchId]);

      iProductsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final productModel = createProductModel(result);
          handleItem(model: productModel, branchId: result.branchId);
        }
      });

      // Subscribe to changes for variants
      final iVariantsCollection =
          realm!.query<RealmVariant>(r'branchId == $0', [branchId]);

      iVariantsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final variantModel = createVariantModel(result);
          handleItem(model: variantModel, branchId: result.branchId);
        }
      });

      // Subscribe to changes for stocks
      final iStocksCollection =
          realm!.query<RealmStock>(r'branchId == $0', [branchId]);
      iStocksCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final stockModel = createStockModel(result);
          handleItem(model: stockModel, branchId: result.branchId);
        }
      });

      // Cancel subscriptions when done
      // iTransactionSubscription.cancel();
      // iTransactionItemSubscription.cancel();
      // iProductSubscription.cancel();
      // iVariantSubscription.cancel();
      // iStockSubscription.cancel();
    }
  }

  ITransaction createTransactionModel(RealmITransaction result) {
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
      supplierId: result.retailerId,
      id: result.id,
      lastTouched: result.lastTouched,
      action: result.action,
    );
  }

  Variant createVariantModel(RealmVariant realmVariant) {
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

  Stock createStockModel(RealmStock realmStock) {
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

  Product createProductModel(RealmProduct realmProduct) {
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

  TransactionItem createTransactionItemModel(RealmITransactionItem item) {
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

  @override
  Future<void> push() {
    // TODO: implement push
    throw UnimplementedError();
  }
}
