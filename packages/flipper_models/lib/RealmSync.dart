import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/realm/realmTransactionItem.dart';
import 'package:flipper_models/sync_service.dart';
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
    if (realm == null) {
      final app = App(AppConfiguration('application-0-hwctb'));
      final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
      realm = Realm(Configuration.flexibleSync(
          user, [RealmITransaction.schema, RealmITransactionItem.schema]));
      realm!.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(realm!.all<RealmITransaction>());
        mutableSubscriptions.add(realm!.all<RealmITransactionItem>());
      });
      return;
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
        retailerId: item.retailerId,
        ticketName: item.ticketName,
        updatedAt: item.updatedAt,
      );

      // Save _RealmITransaction to the Realm database
      await realm!.write(() {
        realm!.add<RealmITransaction>(realmITransaction);
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

      // Save _RealmITransaction to the Realm database
      await realm!.write(() {
        realm!.add<RealmITransactionItem>(realmITransactionItem);
      });
    }
  }

  @override
  Future<void> pull() async {
    if (realm == null) {
      await configure();
    }
    if (realm != null) {
      final iTransactionsCollection = realm!.all<RealmITransaction>();
      final iTransactionSubscription =
          iTransactionsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      final iTransactionsItemCollection = realm!.all<RealmITransactionItem>();
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
      retailerId: result.retailerId,
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
