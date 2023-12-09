import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_services/proxy.dart';
import 'remote_service.dart';
import 'sync.dart';

abstract class SyncFirestore<M extends IJsonSerializable> implements Sync {
  Future<void> onSave<T extends IJsonSerializable>({required T item});
  factory SyncFirestore.create() => FirestoreSync<M>();
}

class FirestoreSync<M extends IJsonSerializable>
    with HandleItemMixin
    implements SyncFirestore<M> {
  @override
  Future<void> onSave<T extends IJsonSerializable>({required T item}) async {
    final String collectionName = getCollectionName<T>();
    final collectionRef = FirebaseFirestore.instance.collection(collectionName);
    try {
      final doc = collectionRef.doc(getItemId<T>(item));
      await doc.set(item.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error: $e');
      // Handle the error appropriately.
    }
  }

  String getCollectionName<T>() {
    if (T == Product) {
      return 'products';
    } else if (T == Variant) {
      return 'variants';
    } else if (T == Stock) {
      return 'stocks';
    } else if (T == Device) {
      return 'devices';
    } else if (T == ITransaction) {
      return 'transactions';
    } else if (T == TransactionItem) {
      return 'transactionItems';
    } else if (T == Drawers) {
      return 'drawers';
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  String getItemId<T>(T item) {
    if (item is Product) {
      return item.id;
    } else if (item is Variant) {
      return item.id;
    } else if (item is Stock) {
      return item.id;
    } else if (item is Device) {
      return item.id;
    } else if (item is ITransaction) {
      return item.id;
    } else if (item is TransactionItem) {
      return item.id;
    } else if (item is Drawers) {
      return item.id;
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  @override
  Future<void> localChanges() async {
    // TODO: implement localChanges
    throw UnimplementedError();
  }

  @override
  void pull() {
    final int? branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    for (final collectionName in [
      'products',
      'variants',
      'stocks',
      'devices',
      'transactions',
      'transactionItems',
      'drawers'
    ]) {
      final collectionRef =
          FirebaseFirestore.instance.collection(collectionName);

      final collectionSnapshots = collectionRef.snapshots();
      collectionSnapshots.listen((querySnapshot) {
        for (final docSnapshot in querySnapshot.docs) {
          final updatedJson = docSnapshot.data();
          handleItem(
              model: getSpecificModel(collectionName, updatedJson),
              branchId: branchId);
        }
      });
    }
  }

  @override
  Future<void> push() async {}

  IJsonSerializable getSpecificModel(
      String collectionName, Map<String, dynamic> data) {
    switch (collectionName) {
      case 'products':
        return Product.fromJson(data);
      case 'variants':
        return Variant.fromJson(data);
      case 'stocks':
        return Stock.fromJson(data);
      case 'devices':
        return Device.fromJson(data);
      case 'transactions':
        return ITransaction.fromJson(data);
      case 'transactionItems':
        return TransactionItem.fromJson(data);
      case 'drawers':
        return Drawers.fromJson(data);
      default:
        throw ArgumentError('Unsupported collection name: $collectionName');
    }
  }
}
