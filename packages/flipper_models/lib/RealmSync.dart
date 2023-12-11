import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
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
      realm =
          Realm(Configuration.flexibleSync(user, [RealmITransaction.schema]));
      realm!.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.add(realm!.all<RealmITransaction>());
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
        realm!.write(() {
          realm!.add<RealmITransaction>(realmITransaction);
        });
      });
    }
  }

  @override
  void pull() {
    if (realm != null) {
      final iTransactionsCollection = realm!.all<RealmITransaction>();
      final subscription = iTransactionsCollection.changes.listen((changes) {
        for (final result in changes.results) {
          final transactionModel = createTransactionModel(result);
          handleItem(model: transactionModel, branchId: result.branchId);
        }
      });

      subscription.cancel();
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

  @override
  Future<void> push() {
    // TODO: implement push
    throw UnimplementedError();
  }
}
