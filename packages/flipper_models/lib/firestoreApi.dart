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
    await collectionRef.doc(getItemId<T>(item)).set(item.toJson());
  }

  String getCollectionName<T>() {
    if (T == Product) {
      return 'products';
    } else if (T == Variant) {
      return 'variants';
    } else if (T == Stock) {
      return 'stocks';
    }

    throw ArgumentError('Unsupported type: $T');
  }

  String getItemId<T>(T item) {
    if (item is Product) {
      return item.id;
    } else if (item is Variant) {
      return item.id;
    } else if (item is Stock) {
      return item.id;
    }
    throw ArgumentError('Unsupported type: $T');
  }

  @override
  Future<void> localChanges() {
    // TODO: implement localChanges
    throw UnimplementedError();
  }

  @override
  void pull() {
    final productCollectionRef =
        FirebaseFirestore.instance.collection('products');
    int branchId = ProxyService.box.getBranchId()!;
    final productSnapshots = productCollectionRef.snapshots();
    productSnapshots.listen((querySnapshot) {
      for (final docSnapshot in querySnapshot.docs) {
        final updatedJson = docSnapshot.data();
        handleItem(model: Product.fromJson(updatedJson), branchId: branchId);
      }
    });

    final variantCollectionRef =
        FirebaseFirestore.instance.collection('variants');

    final variantSnapshots = variantCollectionRef.snapshots();
    variantSnapshots.listen((querySnapshot) {
      for (final docSnapshot in querySnapshot.docs) {
        final updatedJson = docSnapshot.data();
        handleItem(model: Variant.fromJson(updatedJson), branchId: branchId);
      }
    });

    final stockCollectionRef = FirebaseFirestore.instance.collection('stocks');

    final stockSnapshots = stockCollectionRef.snapshots();
    stockSnapshots.listen((querySnapshot) {
      for (final docSnapshot in querySnapshot.docs) {
        final updatedJson = docSnapshot.data();
        handleItem(model: Stock.fromJson(updatedJson), branchId: branchId);
      }
    });
  }

  @override
  Future<void> push() async {}
}
