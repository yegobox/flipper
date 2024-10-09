import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_models/power_sync/schema.dart';

import 'package:firebase_auth/firebase_auth.dart';

enum SyncProvider { FIRESTORE, POWERSYNC }

abstract class SyncInterface {
  Future<void> processbatchBackUp<T extends RealmObject>(List<T> batch);
  Future<bool> firebaseLogin({String? token});
  void cancelWatch({required String tableName});
  void cancelAll();
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
  Future<void> deleteRecord(
      {required String tableName, required String idField, required int id});
  Future<void> updateRecord({
    required String tableName,
    required String idField,
    required Map<String, dynamic> map,
    required int id,
    required SyncProvider syncProvider,
  });

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
  Future<void> deleteDuplicate({required String tableName});
}

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CloudSync implements SyncInterface {
  final Map<String, StreamSubscription<QuerySnapshot>> _subscriptions = {};

  final FirebaseFirestore? _firestore;
  final RealmApiInterface _realm;
  final Set<int> _processingIds = {};

  CloudSync(this._firestore, this._realm);

  @override
  Future<void> deleteDuplicate({required String tableName}) async {
    try {
      final idField = tableName.singularize() + "_id";
      Map<dynamic, List<String>> idMap = {};

      // Use pagination to handle large collections
      var query = _firestore!.collection(tableName).limit(500);
      while (true) {
        final snapshot = await query.get();
        if (snapshot.docs.isEmpty) break;

        for (var doc in snapshot.docs) {
          final id = doc.data()[idField];
          if (id != null) {
            idMap.putIfAbsent(id, () => []).add(doc.id);
          }
        }

        query = query.startAfterDocument(snapshot.docs.last);
      }

      // Use a batched write for better performance and atomicity
      final batch = _firestore!.batch();
      for (var entry in idMap.entries) {
        if (entry.value.length > 1) {
          for (int i = 1; i < entry.value.length; i++) {
            batch.delete(_firestore!.collection(tableName).doc(entry.value[i]));
          }
        }
      }
      await batch.commit();
    } catch (e, s) {
      talker.error('Error in deleteDuplicate: $e');
      talker.error(s);
    }
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
        final branchId = ProxyService.box.getBranchId();
        // Get Firestore collection changes without listening
        final querySnapshot = await _firestore!
            .collection(tableName)
            .where('branch_id', isEqualTo: branchId)
            .get();

        print(
            "Retrieved ${querySnapshot.docs.length} documents from Firestore");

        for (var docChange in querySnapshot.docs) {
          final id = int.parse(docChange.id);
          final data = docChange.data();

          print("Processing document with ID: $id");

          // Process the document based on the change type
          // Assuming all changes are either added or modified for this example
          var realmObject =
              _realm.realm!.query<T>(r'id == $0', [id]).firstOrNull;
          if (realmObject == null) {
            realmObject = createRealmObject(data);
            _realm.realm!.write(() {
              _realm.realm!.add<T>(realmObject!);
            });
            print("Added new object to Realm with ID: $id");
          } else {
            updateRealmObject(realmObject, data);
            print("Updated existing object in Realm with ID: $id");
          }
        }

        print("Finished processing all documents");
      } catch (e) {
        print("Error fetching or processing Firestore changes: $e");
      }
    }
  }

  @override
  Future<void> processbatchBackUp<T extends RealmObject>(List<T> batch) async {
    WriteBatch writeBatch = _firestore!.batch();

    for (T item in batch) {
      // Changed TransactionItem to T

      final data = item.toEJson().toFlipperJson();
      final docRef = _firestore!
          .collection('transactionsItems')
          .doc(data['id'].toString());

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
            talker.warning("processed ID ${id}");
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

            await deleteRecord(
                tableName: tableName, idField: idField, id: deletedId);
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
  Future<void> deleteRecord(
      {required String tableName,
      required String idField,
      required int id}) async {
    // await db.execute(
    //   'DELETE FROM $tableName WHERE $idField = ?',
    //   [id],
    // );
    talker.warning("Firestore deleting $tableName with id $id");
    cancelWatch(tableName: tableName);
    await _firestore!.collection(tableName).doc(id.toString()).delete();

    _realm.realm!.writeN(
        tableName: deletedObjectTable,
        writeCallback: () {
          DeletedObject? obj =
              _realm.realm!.query<DeletedObject>(r'id == $0', [id]).firstOrNull;
          if (obj != null) {
            final deletedObject = DeletedObject(
              ObjectId(),
              objectName: tableName,
              branchId: ProxyService.box.getBranchId()!,
              id: id,
              businessId: ProxyService.box.getBusinessId()!,
              deviceCount: 1,
              expectedDeviceCount: 1,
            );
            return deletedObject;
          }
        });
    // re-start pull change
    // PullChange().start(
    //     firestore: _firestore!,
    //     localRealm: _realm.realm!,
    //     tableName: tableName);

    /// delete record in firestore
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
      return;
    }
    // get a modified map
    final modifiedMap =
        map.map((key, value) => MapEntry(camelToSnakeCase(key), value));
    modifiedMap[idField] = map['id'];
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        // Check if the document already exists
        final docRef = _firestore!.collection(tableName).doc(id.toString());
        final docSnapshot = await docRef.get();

        /// first cancel the subscription to avoid re-writing back into the same document
        cancelWatch(tableName: tableName);

        if (docSnapshot.exists) {
          talker.warning("UpdatedFirestore ${id}");
          // Update existing document
          await docRef.update(modifiedMap);
        } else {
          talker.warning("created");
          // Create new document
          await docRef.set(modifiedMap);
        }
        // re-start pull change
        // PullChange().start(
        //     firestore: _firestore!,
        //     localRealm: _realm.realm!,
        //     tableName: tableName);
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
        rethrow;
      }
    }
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
        if (_firestore == null) return;
        final branchId = ProxyService.box.getBranchId();
        // Listen for Firestore collection changes
        final subscription = _firestore!
            .collection(tableName)
            .where('branch_id', isEqualTo: branchId)
            .snapshots()
            .listen((querySnapshot) {
          for (var docChange in querySnapshot.docChanges) {
            final id = int.parse(docChange.doc.id);
            final data = docChange.doc.data()!;

            // Process the document based on the change type
            switch (docChange.type) {
              case DocumentChangeType.added:
              case DocumentChangeType.modified:
                try {
                  if (_realm.realm!.isClosed) return;
                  T? realmObject =
                      _realm.realm!.query<T>(r'id == $0', [id]).firstOrNull;
                  if (realmObject == null) {
                    /// check if this object was deleted and is found in deletedObjects
                    DeletedObject? deletedObject = _realm.realm!
                        .query<DeletedObject>(r'id == $0', [id]).firstOrNull;
                    if (deletedObject == null) {
                      realmObject = createRealmObject(data);
                      _realm.realm!.write(() {
                        _realm.realm!.add<T>(realmObject!);
                      });
                    }
                  } else {
                    talker.warning(
                        "Firestore changes updateRealmObject $tableName: ${id}");
                    updateRealmObject(realmObject, data);
                  }
                } catch (e, s) {
                  talker.warning("E: ${e}");
                  talker.warning("S: ${s}");
                }

                break;
              case DocumentChangeType.removed:
                _realm.realm!.write(() {
                  T? realmObject =
                      _realm.realm!.query<T>(r'id == $0', [id]).firstOrNull;

                  if (realmObject != null) {
                    var eJson = (realmObject is Stock)
                        ? realmObject
                            .toEJson(includeVariant: false)
                            .toFlipperJson()
                        : realmObject.toEJson().toFlipperJson();

                    _realm.realm!.add<DeletedObject>(
                      DeletedObject(
                        ObjectId(),
                        id: (realmObject is Stock)
                            ? realmObject.id!
                            : eJson['id'],
                        branchId: eJson['branch_id'],
                        businessId: eJson['business_id'],
                        deviceCount: 1,
                      ),
                    );

                    _realm.realm!.delete(realmObject);
                  }
                });
                break;
            }
          }
        }, onError: (error) {
          talker.error("Error listening to Firestore changes: $error");
        });
        _subscriptions[tableName] = subscription;
      } catch (e) {
        talker.error("Error setting up Firestore listener: $e");
        throw Exception("Error syncing: $e");
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
          //         _realm.realm!.query<T>('id == $id').firstOrNull;
          //     if (realmObject == null) {
          //       realmObject = createRealmObject(item);
          //       _realm.realm!.add<T>(realmObject);
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
          //       _realm.realm!.query<T>('id == $id').firstOrNull;
          //   if (realmObject == null) {
          //     realmObject = createRealmObject(data);
          //     _realm.realm!.add<T>(realmObject);
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

  bool compareChanges(Map<String, dynamic> item, Map<String, dynamic> map) {
    for (final key in item.keys) {
      if (map[key]?.toString() != item[key]?.toString()) {
        return true;
      }
    }
    return false;
  }

  static const int BATCH_SIZE = 100;

  Future<void> backUp(
      {required int branchId,
      required String encryptionKey,
      required String dbPath}) async {
    try {
      List<TransactionItem> items = _realm.realm!
          .query<TransactionItem>(r'branchId == $0', [branchId]).toList();
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

  @override
  Future<bool> firebaseLogin({String? token}) async {
    int? userId = ProxyService.box.getUserId();
    if (userId == null) return false;
    final pinLocal = ProxyService.local.getPinLocal(userId: userId);
    try {
      token ??= pinLocal?.tokenUid;

      if (token != null) {
        talker.warning(token);
        await FirebaseAuth.instance.signInWithCustomToken(token);

        return true;
      }
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      talker.error(e);
      // talker.info("Retry ${pinLocal?.uid ?? "NULL"}");
      final http.Response response = await ProxyService.local.sendLoginRequest(
          pinLocal!.phoneNumber!, ProxyService.http, AppSecrets.apihubProd,
          uid: pinLocal.uid!);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        /// path the user pin, with
        final IUser user = IUser.fromJson(json.decode(response.body));
        ProxyService.local.realm!.write(() {
          pinLocal.tokenUid = user.uid;
        });
      }

      return false;
    }
  }

  @override
  void cancelAll() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void cancelWatch({required String tableName}) {
    final subscription = _subscriptions[tableName];
    if (subscription != null) {
      subscription.cancel();
      _subscriptions
          .remove(tableName); // Remove it from the map after cancellation
    }
  }
}
