import 'package:flipper_models/power_sync/powersync.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/secrets.dart';
// ignore: unused_import
import 'dart:async';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/realmModels.dart';

enum SyncProvider { POWERSYNC, FIRESTORE }

abstract class SyncInterface {
  Future<void> processbatchBackUp<T extends RealmObject>(List<T> batch);
  Future<void> handleChanges<T>(
      {required RealmResults<T> results,
      required String tableName,
      required String idField,
      required int Function(T) getId,
      required Map<String, dynamic> Function(T) convertToMap,
      required Function(Map<String, dynamic>) preProcessMap,
      required SyncProvider syncProvider});
  Future<void> deleteRecord(String tableName, String idField, int id);
  Future<void> updateRecord(
      {required String tableName,
      required String idField,
      required Map<String, dynamic> map,
      required int id,
      required SyncProvider syncProvider});
  void listen();
  SyncInterface instance();
  Future<void> watchTable<T extends RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
  });
  Future<void> backUp(
      {required int branchId,
      required String encryptionKey,
      required String dbPath});
}

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CloudSync implements SyncInterface {
  // static final CloudSync _instance = CloudSync._internal();
  // CloudSync._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Set<int> _processingIds = {};

  @override
  SyncInterface instance() {
    return this;
  }

  @override
  Future<void> processbatchBackUp<T extends RealmObject>(List<T> batch) async {
    WriteBatch writeBatch = _firestore.batch();

    for (T item in batch) {
      // Changed TransactionItem to T

      final data = item.toEJson().toFlipperJson();
      final docRef =
          _firestore.collection('transactionsItems').doc(data['id'].toString());

      // Check if the document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        writeBatch.update(docRef, data);
      } else {
        writeBatch.set(docRef, data);
      }
    }

    // Commit the batch
    await writeBatch.commit();

    talker.info("Processed and committed batch of ${batch.length} items");
  }

  @override
  Future<void> handleChanges<T>(
      {required RealmResults<T> results,
      required String tableName,
      required String idField,
      required int Function(T) getId,
      required Map<String, dynamic> Function(T) convertToMap,
      required Function(Map<String, dynamic>) preProcessMap,
      required SyncProvider syncProvider}) async {
    results.changes.listen(
      (changes) async {
        for (var obj in changes.modified) {
          final modifiedItem = results[obj];
          final id = getId(modifiedItem);
          Map<String, dynamic> map = convertToMap(modifiedItem);
          if (syncProvider == SyncProvider.FIRESTORE) {
            await updateRecord(
                tableName: tableName,
                idField: idField,
                map: map,
                id: id,
                syncProvider: SyncProvider.POWERSYNC);
            return;
          }

          // Skip if this ID is currently being processed by watchTable
          if (_processingIds.contains(id)) continue;

          final item = await db.getOptional(
            'SELECT * FROM $tableName WHERE $idField = ?',
            [id],
          );

          if (item != null) {
            try {
              preProcessMap(map);

              bool hasChanges = compareChanges(item, map);

              if (hasChanges) {
                await updateRecord(
                    tableName: tableName,
                    idField: idField,
                    map: map,
                    id: id,
                    syncProvider: SyncProvider.POWERSYNC);
              }
            } catch (e) {
              throw Exception();
            }
          }
        }

        // Handle deleted objects if necessary
        for (var index in changes.deleted) {
          try {
            final deletedId = getId(results[index]);

            // Skip if this ID is currently being processed by watchTable
            if (_processingIds.contains(deletedId)) continue;

            await deleteRecord(tableName, idField, deletedId);
          } catch (e, s) {
            print('Error deleting record: $e');
            print(s);
          }
        }
      },
      onError: (error) {},
    );
  }

  @override
  Future<void> deleteRecord(String tableName, String idField, int id) async {
    await db.execute(
      'DELETE FROM $tableName WHERE $idField = ?',
      [id],
    );
  }

  @override
  Future<void> updateRecord(
      {required String tableName,
      required String idField,
      required Map<String, dynamic> map,
      required int id,
      required SyncProvider syncProvider}) async {
    final keysToUpdate =
        map.keys.map((key) => '${camelToSnakeCase(key)} = ?').join(', ');
    final valuesToUpdate = map.values.toList();

    if (syncProvider == SyncProvider.POWERSYNC) {
      await db.execute(
        'UPDATE $tableName SET $keysToUpdate WHERE $idField = ?',
        [...valuesToUpdate, id],
      );
    }
    if (syncProvider == SyncProvider.FIRESTORE) {
      // Check if the document already exists
      final docRef = _firestore.collection(tableName).doc(id.toString());
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        talker.warning("UpdatedFirestore");
        // Update existing document
        await docRef.update(map);
      } else {
        talker.warning("created");
        // Create new document
        await docRef.set(map);
      }
    }
  }

  bool compareChanges(Map<String, dynamic> item, Map<String, dynamic> map) {
    for (final key in item.keys) {
      if (map[key]?.toString() != item[key]?.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> watchTable<T extends RealmObject>({
    required String tableName,
    required String idField,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    bool useWatch = false, // ... existing code ...
  }) async {
    try {
      if (useWatch) {
        final changes =
            await db.watch('SELECT * FROM $tableName ORDER BY created_at DESC');
        changes.listen((data) {
          for (var item in data) {
            final id = item[idField];

            // Add this ID to the processing set
            _processingIds.add(id);

            // Find existing object or create a new one
            var realmObject =
                ProxyService.local.realm!.query<T>('id == $id').firstOrNull;
            if (realmObject == null) {
              realmObject = createRealmObject(item);
              ProxyService.local.realm!.add<T>(realmObject);
            } else {
              updateRealmObject(realmObject, item);
            }

            // Remove this ID from the processing set after a short delay
            Future.delayed(Duration(seconds: 2), () {
              _processingIds.remove(id);
            });
          }
        });
      } else {
        final results = await db
            .execute('SELECT * FROM $tableName ORDER BY created_at DESC');
        for (var data in results) {
          final id = data[idField];

          // Add this ID to the processing set
          _processingIds.add(id);

          // Find existing object or create a new one
          var realmObject =
              ProxyService.local.realm!.query<T>('id == $id').firstOrNull;
          if (realmObject == null) {
            realmObject = createRealmObject(data);
            ProxyService.local.realm!.add<T>(realmObject);
          } else {
            updateRealmObject(realmObject, data);
          }

          // Remove this ID from the processing set after a short delay
          Future.delayed(Duration(seconds: 2), () {
            _processingIds.remove(id);
          });
        }
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  @override
  void listen() {
    ///watchers for upload

    handleChanges<Stock>(
      syncProvider: SyncProvider.FIRESTORE,
      results: ProxyService.local.realm!.all<Stock>(),
      tableName: 'stocks',
      idField: 'stock_id',
      getId: (stock) => stock.id!,
      convertToMap: (stock) => stock.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('variant');
        map['stock_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Product>(
      syncProvider: SyncProvider.FIRESTORE,
      results: ProxyService.local.realm!.all<Product>(),
      tableName: 'products',
      idField: 'product_id',
      getId: (product) => product.id!,
      convertToMap: (product) => product.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('composites');
        map['product_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Variant>(
      syncProvider: SyncProvider.FIRESTORE,
      results: ProxyService.local.realm!.all<Variant>(),
      tableName: 'variants',
      idField: 'variant_id',
      getId: (variant) => variant.id!,
      convertToMap: (variant) => variant.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('branchIds');
        map['variant_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Counter>(
      syncProvider: SyncProvider.FIRESTORE,
      results: ProxyService.local.realm!.all<Counter>(),
      tableName: 'counters',
      idField: 'counter_id',
      getId: (counter) => counter.id!,
      convertToMap: (counter) => counter.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map['counter_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );
  }

  static const int BATCH_SIZE = 100;
  Realm? _realm;
  Future<void> backUp(
      {required int branchId,
      required String encryptionKey,
      required String dbPath}) async {
    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser;
    if (user == null) return;

    FlexibleSyncConfiguration config = Configuration.flexibleSync(
      user,
      realmModels,
      encryptionKey: encryptionKey.toIntList(),
      path: dbPath,
    );

    _realm?.close();
    _realm = Realm(config);

    try {
      List<TransactionItem> items = _realm!
          .query<TransactionItem>(r'branchId == $0', [branchId]).toList();
      List<List<TransactionItem>> batches =
          _splitIntoBatches(items, BATCH_SIZE);

      for (var batch in batches) {
        await CloudSync().processbatchBackUp(batch);
      }
      talker.info("Backup completed successfully for branch $branchId");
    } catch (e, stackTrace) {
      talker.error("Error during backup for branch $branchId: $e", stackTrace);
      rethrow;
    } finally {
      _realm?.close();
    }
  }

  List<List<TransactionItem>> _splitIntoBatches(
      List<TransactionItem> items, int batchSize) {
    return [
      for (var i = 0; i < items.length; i += batchSize)
        items.sublist(
            i, i + batchSize > items.length ? items.length : i + batchSize)
    ];
  }
}
