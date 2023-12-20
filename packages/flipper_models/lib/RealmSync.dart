import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmProduct.dart';
import 'package:flipper_models/realm/realmVariant.dart';
import 'package:flipper_models/realm/realmStock.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/sync_service.dart';
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
      final findableObject =
          realm!.query<RealmITransaction>(r'id == $0', [item.id]);
      // Save _RealmITransaction to the Realm database
      await realm?.write(() {
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm?.add(realmITransaction);
        } else {
          realm?.add<RealmITransaction>(findableObject.first, update: true);
        }
      });
    }

    if (item is TransactionItem) {
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

      final findableObject =
          realm!.query<RealmITransactionItem>(r'id == $0', [item.id]);
      // Save _RealmITransaction to the Realm database
      await realm?.write(() {
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm?.add(realmITransactionItem);
        } else {
          realm?.add<RealmITransactionItem>(findableObject.first, update: true);
        }
      });
    }
    if (item is Product) {
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
      final findableObject = realm!.query<RealmProduct>(r'id == $0', [item.id]);
      // Save _RealmITransaction to the Realm database
      await realm?.write(() {
        if (findableObject.isEmpty) {
          // Transaction doesn't exist, add it
          realm?.add(realmProduct);
        } else {
          realm?.add<RealmProduct>(findableObject.first, update: true);
        }
      });
    }
    if (item is Variant) {
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

      final findableObject = realm!.query<RealmVariant>(r'id == $0', [item.id]);

      await realm?.write(() {
        if (findableObject.isEmpty) {
          // Variant doesn't exist, add it
          realm?.add(realmVariant);
        } else {
          // Variant exists, update it
          realm?.add<RealmVariant>(findableObject.first, update: true);
        }
      });
    }
    if (item is Stock) {
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

      final findableObject = realm!.query<RealmStock>(r'id == $0', [item.id]);

      await realm?.write(() {
        if (findableObject.isEmpty) {
          // Stock doesn't exist, add it
          realm?.add(realmStock);
        } else {
          // Stock exists, update it
          realm?.add<RealmStock>(findableObject.first, update: true);
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
      final iTransactionsCollection =
          realm!.query<RealmITransaction>('branchId == \$0', [branchId]);
      final iTransactionSubscription =
          iTransactionsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      final iTransactionsItemCollection =
          realm!.query<RealmITransactionItem>('branchId == \$0', [branchId]);
      final iTransactionItemSubscription =
          iTransactionsItemCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionItemModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      iTransactionSubscription.cancel();
      iTransactionItemSubscription.cancel();
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
