import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

extension IsarO<ID, OBJ> on IsarCollection<OBJ> {
  /// this create a standard local update withour necessarily calling
  /// our sync service such as realm or firestore
  void onUpdate(OBJ object) {
    put(object);
  }

  Future<Id> onPut(OBJ object) async {
    final result = await put(object);

    /// when it is time to print receipt do it right way.
    EBMHandler(object: object).handleReceipt();

    // after saving object into isar db, we may save same object to a sync database
    // the database is responsible to take data accross devices
    // TODO: re-enable this when cloud_firestore is stable
    // https://github.com/firebase/flutterfire/issues/11933
    // https://github.com/flutter/flutter/issues/134346
    if (!isWindows &&
        ProxyService.remoteConfig.isFirestoreEnabled() &&
        ProxyService.remoteConfig.isSyncAvailable()) {
      // if (object is Product) {
      //   ProxyService.syncFirestore.onSave<Product>(item: object);
      // }
      // if (object is Variant) {
      //   ProxyService.syncFirestore.onSave<Variant>(item: object);
      // }
      // if (object is Stock) {
      //   ProxyService.syncFirestore.onSave<Stock>(item: object);
      // }
      // if (object is Device) {
      //   ProxyService.syncFirestore.onSave<Device>(item: object);
      // }
      // if (object is ITransaction) {
      //   ProxyService.syncFirestore.onSave<ITransaction>(item: object);
      // }
      // if (object is TransactionItem) {
      //   ProxyService.syncFirestore.onSave<TransactionItem>(item: object);
      // }
      // if (object is Drawers) {
      //   ProxyService.syncFirestore.onSave<Drawers>(item: object);
      // }
      // if (object is IUnit) {
      //   ProxyService.syncFirestore.onSave<IUnit>(item: object);
      // }
    }
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      //await ProxyService.realm.configure();
      if (object is TransactionItem) {
        // log(object.toJson().toString(), name: 'onPut');
        // ProxyService.realm.onSave<TransactionItem>(item: object);
      }
      if (object is ITransaction) {
        // log(object.toJson().toString(), name: 'onPut');
        // ProxyService.realm.onSave<ITransaction>(item: object);
      }

      if (object is Product) {
        // log(object.toJson().toString(), name: 'onPut');
        // ProxyService.realm.onSave<Product>(item: object);
      }

      if (object is Stock) {
        // log(object.toJson().toString(), name: 'onPut');
        // ProxyService.realm.onSave<Stock>(item: object);
      }
      if (object is Variant) {
        // log(object.toJson().toString(), name: 'onPut');
        // log("Called onPut in Async there is no problem:${ProxyService.box.tin()}",
        //     name: 'onPut');

        /// save extra fields that where not provided during creating
        /// these fields are crucial when dealing with RRA and because we want
        /// to simplify and provide the best user experience for the user we do all heavy lifting
        /// for the suer and add some field we know to their defaults.!
        Variant variant = object;
        variant.bhfId = ProxyService.box.bhfId();
        variant.tin = ProxyService.box.tin();

        /// localUpdate provide localUpdate to avoid recursive calls
        ProxyService.isar.update(data: variant, localUpdate: true);

        /// save extra fields that where not provided
        // ProxyService.realm.onSave<Variant>(item: variant);
      }
      if (object is IUnit) {
        // ProxyService.realm.onSave<IUnit>(item: object);
      }
      if (object is Receipt) {
        // ProxyService.realm.onSave<Receipt>(item: object);
      }
      if (object is ICounter) {
        // ProxyService.realm.onSave<Counter>(item: object);
      }
      if (object is Customer) {
        // ProxyService.realm.onSave<Customer>(item: object);
      }
    }

    return result;
  }
}
