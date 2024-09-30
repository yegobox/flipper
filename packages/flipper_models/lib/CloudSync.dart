// import 'package:flipper_models/power_sync/powersync.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:realm/realm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/secrets.dart';
// ignore: unused_import
import 'dart:async';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/realmModels.dart';

enum SyncProvider { FIRESTORE, POWERSYNC }

abstract class SyncInterface {
  Future<void> processbatchBackUp<T extends RealmObject>(List<T> batch);
  Future<void> handleRealmChanges<T>({
    required RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
    required SyncProvider syncProvider,
  });
  Future<void> handleRealmChangesAsync<T>({
    required RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
    required SyncProvider syncProvider,
  });
  Future<void> deleteRecord(String tableName, String idField, int id);
  Future<void> updateRecord({
    required String tableName,
    required String idField,
    required Map<String, dynamic> map,
    required int id,
    required SyncProvider syncProvider,
  });
  void listen();
  SyncInterface instance();
  Future<void> watchTable<T extends RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
  });

  Future<void> watchTableAsync<T extends RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
  });
  Future<void> backUp({
    required int branchId,
    required String encryptionKey,
    required String dbPath,
  });
}

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CloudSync implements SyncInterface {
  // static final CloudSync _instance = CloudSync._internal();
  // CloudSync._internal();

  final FirebaseFirestore _firestore;
  final Realm _realm;
  final Set<int> _processingIds = {};

  CloudSync(this._firestore, this._realm);
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
  Future<void> handleRealmChanges<T>(
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
          try {
            // Skip if this ID is currently being processed by watchTable
            if (_processingIds.contains(id)) continue;
            _processingIds.add(id);
            Map<String, dynamic> map = convertToMap(modifiedItem);
            if (syncProvider == SyncProvider.FIRESTORE) {
              talker.warning("Change in realm happened");
              await updateRecord(
                tableName: tableName,
                idField: idField,
                map: map,
                id: id,
                syncProvider: syncProvider,
              );
              Future.delayed(Duration(seconds: 2), () {
                _processingIds.remove(id);
              });
              return;
            }
          } catch (e, s) {
            talker.warning(e);
            talker.error(s);
          }

          // final item = await db.getOptional(
          //   'SELECT * FROM $tableName WHERE $idField = ?',
          //   [id],
          // );

          // if (item != null) {
          //   try {
          //     preProcessMap(map);

          //     bool hasChanges = compareChanges(item, map);

          //     if (hasChanges) {
          //       await updateRecord(
          //           tableName: tableName,
          //           idField: idField,
          //           map: map,
          //           id: id,
          //           syncProvider: SyncProvider.POWERSYNC);
          //     }
          //   } catch (e) {
          //     throw Exception();
          //   }
          // }
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
    // await db.execute(
    //   'DELETE FROM $tableName WHERE $idField = ?',
    //   [id],
    // );
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

    if (syncProvider == "POWERSYNC") {
      // await db.execute(
      //   'UPDATE $tableName SET $keysToUpdate WHERE $idField = ?',
      //   [...valuesToUpdate, id],
      // );
    }
    // get a modified map
    final modifiedMap =
        map.map((key, value) => MapEntry(camelToSnakeCase(key), value));
    modifiedMap[idField] = map['id'];
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        // Check if the document already exists
        final docRef = _firestore.collection(tableName).doc(id.toString());
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          talker.warning("UpdatedFirestore");
          // Update existing document
          await docRef.update(modifiedMap);
        } else {
          talker.warning("created");
          // Create new document
          await docRef.set(modifiedMap);
        }
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
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
    bool useWatch = false,
    required SyncProvider syncProvider,
  }) async {
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        // Listen for Firestore collection changes
        _firestore.collection(tableName).snapshots().listen((querySnapshot) {
          for (var docChange in querySnapshot.docChanges) {
            final id = int.parse(docChange.doc.id);
            final data = docChange.doc.data()!;

            // Process the document based on the change type
            switch (docChange.type) {
              case DocumentChangeType.added:
              case DocumentChangeType.modified:
                var realmObject = _realm.query<T>('id == "$id"').firstOrNull;
                if (realmObject == null) {
                  realmObject = createRealmObject(data);
                  _realm.write(() {
                    _realm.add<T>(realmObject!);
                  });
                } else {
                  talker.warning("Firestore changes updateRealmObject");
                  updateRealmObject(realmObject, data);
                }

                break;
              case DocumentChangeType.removed:
                _realm.write(() {
                  var realmObject =
                      _realm.query<T>('$idField == "$id"').firstOrNull;
                  if (realmObject != null) {
                    _realm.delete(realmObject);
                  }
                });
                break;
            }
          }
        }, onError: (error) {
          talker.error("Error listening to Firestore changes: $error");
        });
      } catch (e) {
        talker.error("Error setting up Firestore listener: $e");
      }
    }
    if (syncProvider == "POWERSYNC") {
      try {
        if (useWatch) {
          // final changes =
          //     await db.watch('SELECT * FROM $tableName ORDER BY created_at DESC');
          // changes.listen((data) {
          //   for (var item in data) {
          //     final id = item[idField];

          //     // Add this ID to the processing set
          //     _processingIds.add(id);

          //     // Find existing object or create a new one
          //     var realmObject =
          //         _realm.query<T>('id == $id').firstOrNull;
          //     if (realmObject == null) {
          //       realmObject = createRealmObject(item);
          //       _realm.add<T>(realmObject);
          //     } else {
          //       updateRealmObject(realmObject, item);
          //     }

          //     // Remove this ID from the processing set after a short delay
          // Future.delayed(Duration(seconds: 2), () {
          //   _processingIds.remove(id);
          // });
          //   }
          // });
        } else {
          // final results = await db
          //     .execute('SELECT * FROM $tableName ORDER BY created_at DESC');
          // for (var data in results) {
          //   final id = data[idField];

          //   // Add this ID to the processing set
          //   _processingIds.add(id);

          //   // Find existing object or create a new one
          //   var realmObject =
          //       _realm.query<T>('id == $id').firstOrNull;
          //   if (realmObject == null) {
          //     realmObject = createRealmObject(data);
          //     _realm.add<T>(realmObject);
          //   } else {
          //     updateRealmObject(realmObject, data);
          //   }

          //   // Remove this ID from the processing set after a short delay
          //   Future.delayed(Duration(seconds: 2), () {
          //     _processingIds.remove(id);
          //   });
          // }
        }
      } catch (e, s) {
        talker.error(s);
      }
    }
  }

  @override
  void listen() {
    ///watchers for upload
  }

  static const int BATCH_SIZE = 100;

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

    try {
      List<TransactionItem> items =
          _realm.query<TransactionItem>(r'branchId == $0', [branchId]).toList();
      List<List<TransactionItem>> batches =
          _splitIntoBatches(items, BATCH_SIZE);

      for (var batch in batches) {
        await processbatchBackUp(batch);
      }
      talker.info("Backup completed successfully for branch $branchId");
    } catch (e, stackTrace) {
      talker.error("Error during backup for branch $branchId: $e", stackTrace);
      rethrow;
    } finally {}
  }

  List<List<TransactionItem>> _splitIntoBatches(
      List<TransactionItem> items, int batchSize) {
    return [
      for (var i = 0; i < items.length; i += batchSize)
        items.sublist(
            i, i + batchSize > items.length ? items.length : i + batchSize)
    ];
  }

  Future<void> watchTableAsync<T extends RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
  }) async {
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        // Get Firestore collection changes without listening
        _firestore.collection(tableName).get().then((querySnapshot) {
          for (var docChange in querySnapshot.docs) {
            final id = int.parse(docChange.id);
            final data = docChange.data();

            // Process the document based on the change type
            // Assuming all changes are either added or modified for this example
            var realmObject = _realm.query<T>('id == "$id"').firstOrNull;
            if (realmObject == null) {
              realmObject = createRealmObject(data);
              _realm.write(() {
                _realm.add<T>(realmObject!);
              });
            } else {
              talker.warning("Firestore changes updateRealmObject:)");
              updateRealmObject(realmObject, data);
            }
          }
        }, onError: (error) {
          talker.error("Error fetching Firestore changes: $error");
        });
      } catch (e) {
        talker.error("Error fetching Firestore changes: $e");
      }
    }
  }

  Future<void> handleRealmChangesAsync<T>({
    required RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
    required SyncProvider syncProvider,
  }) async {
    //loop through all data and bulk update
    for (T result in results) {
      final id = getId(result);

      try {
        // Skip if this ID is currently being processed by watchTable
        if (_processingIds.contains(id)) continue;
        Map<String, dynamic> map = convertToMap(result);
        if (syncProvider == SyncProvider.FIRESTORE) {
          talker.warning("Change in realm happened Async");
          _processingIds.add(id);
          await updateRecord(
              tableName: tableName,
              idField: idField,
              map: map,
              id: id,
              syncProvider: syncProvider);
          Future.delayed(Duration(seconds: 2), () {
            _processingIds.remove(id);
          });
          return;
        }
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
      }
    }
  }
}
