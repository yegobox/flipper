import 'dart:convert';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart' as realmO;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart' as old;
import 'package:flipper_models/power_sync/schema.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'dart:typed_data';
import 'package:flipper_models/FlipperInterfaceCapella.dart';
import 'package:firestore_models/firestore_models.dart';
import 'package:firestore_models/transaction.dart' as trans;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/abstractions/storage.dart' as storage;
import 'package:flipper_services/constants.dart';
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class FirestoreSync implements FlipperInterfaceCapella {
  final Map<String, StreamSubscription<QuerySnapshot>> _subscriptions = {};
  final FirebaseFirestore? _firestore;
  realmO.Realm? realm;
  final Set<int> _processingIds = {};

  bool isInIsolate() {
    return Isolate.current.debugName != null;
  }

  @override
  void replicateData<T>(String tableName, T data,
      {bool? useNewImplementation = false}) {
    try {
      final map = useNewImplementation!
          ? (data is Counter
              ? data.toJson()
              : (data != null ? (data as dynamic).toJson() : {}))
          : (data is old.Stock
              ? data.toEJson(includeVariant: false)?.toFlipperJson() ?? {}
              : data.toEJson()?.toFlipperJson() ?? {});
      talker.warning(map);
      final id = _getId(map);

      if (!useNewImplementation) {
        _removeFields(map, ['variant', 'stock', 'branch_ids']);
      }

      updateRecord(
        tableName: tableName,
        idField: "${tableName.singularize()}_id",
        map: map,
        id: id,
        syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// Helper to extract and parse `id`
  dynamic _getId(Map<dynamic, dynamic> map) {
    return map['id'] is String
        ? int.parse(map['id'])
        : map['id'] ??= randomNumber();
  }

// Helper to remove unwanted fields from the map
  void _removeFields(Map<String, dynamic> map, List<String> fields) {
    for (var field in fields) {
      map.remove(field);
    }
  }

  FirestoreSync(this._firestore, {this.realm, SupabaseClient? client});
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

  Future<void> watchTableAsync<T extends realmO.RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
    required List<int> branchIds,
  }) async {
    /// if it is not isolate re-init the Realm
    if (!isInIsolate()) {
      realm = ProxyService.local.realm!;
    }
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        // Get Firestore collection changes without listening
        final querySnapshot = await _firestore!
            .collection(tableName)
            .where('branch_id', whereIn: branchIds)
            .limit(10)
            .get();

        for (var docChange in querySnapshot.docs) {
          final id = int.parse(docChange.id);
          final data = docChange.data();

          // Process the document based on the change type
          // Assuming all changes are either added or modified for this example
          realm!.refresh();
          var realmObject = realm!.query<T>(r'id == $0', [id]).firstOrNull;
          if (realmObject == null) {
            realmObject = createRealmObject(data);
            realm!.write(() {
              realm!.add<T>(realmObject!);
            });
            print("Added new object to Realm with ID: $id");
          } else {
            updateRealmObject(realmObject, data);
            print("Updated existing object in Realm with ID: $id");
          }
        }

        print("Finished processing all documents");
      } catch (e, s) {
        print("Error fetching or processing Firestore changes: $e");
        print(s);
      }
    }
  }

  @override
  Future<void> processbatchBackUp<T extends realmO.RealmObject>(
      List<T> batch) async {
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
      {required realmO.RealmResults<T> results,
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
                syncProviders: [syncProvider, SyncProvider.SUPABASE],
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
    if (!isInIsolate()) {
      realm = ProxyService.local.realm!;
    }

    cancelWatch(tableName: tableName);
    await _firestore!.collection(tableName).doc(id.toString()).delete();

    talker.warning("Firestore deleted $tableName with id $id");
  }

  @override
  Future<void> updateRecord(
      {required String tableName,
      required String idField,
      required Map<String, dynamic> map,
      required int id,
      required List<SyncProvider> syncProviders}) async {
    if (!isInIsolate()) {
      realm = ProxyService.local.realm!;
    }
    // get a modified map
    final modifiedMap =
        map.map((key, value) => MapEntry(camelToSnakeCase(key), value));
    modifiedMap[idField] = map['id'];
    // add updated_at to any change made
    modifiedMap['updated_at'] = DateTime.now().toIso8601String();
    modifiedMap['local_update'] = true;

    if (syncProviders.contains(SyncProvider.FIRESTORE)) {
      try {
        // Check if the document already exists
        final docRef = _firestore!.collection(tableName).doc(id.toString());
        final docSnapshot = await docRef.get();

        /// first cancel the subscription to avoid re-writing back into the same document
        cancelWatch(tableName: tableName);

        if (docSnapshot.exists) {
          talker.warning("UpdatedFirestore ${tableName} ${id}");
          // Update existing document
          await docRef.update(modifiedMap);
        } else {
          talker.warning("created");
          // Create new document
          await docRef.set(modifiedMap);
        }
        await docRef.update({'local_update': FieldValue.delete()});
      } catch (e, s) {
        talker.warning(e);
        talker.error(s);
        rethrow;
      }
    }
    if (syncProviders.contains(SyncProvider.SUPABASE)) {
      /// replicate data to second database as well.
      brickUpdateRecord(
        tableName: tableName,
        idField: idField,
        map: map,
        id: id,
        syncProviders: syncProviders,
      );
      // ProxyService.capela.updateRecord(
      //   tableName: tableName,
      //   idField: idField,
      //   map: map,
      //   id: id,
      //   syncProviders: syncProviders,
      // );
    }
  }

  brickUpdateRecord(
      {required String tableName,
      required String idField,
      required Map<String, dynamic> map,
      required int id,
      required List<SyncProvider> syncProviders}) async {
    final repository = brick.Repository();
    if (tableName == countersTable) {
      try {
        final upCounter = models.Counter(
          id: map['id'],
          lastTouched: DateTime.now(),
          createdAt: DateTime.now(),
          branchId: map['branchId'],
          curRcptNo: map['curRcptNo'],
          totRcptNo: map['totRcptNo'],
          invcNo: map['invcNo'],
          businessId: map['businessId'],
          receiptType: map['receiptType'],
        );
        repository.upsert(upCounter);
      } catch (e) {
        talker.error(e);
      }
    }
  }

  Future<void> _supa({required String tableName, required int id}) async {
    await ProxyService.supa.init();
    try {
      // Attempt to call the RPC function
      final rpcResult =
          await ProxyService.supa.client?.rpc('insert_key', params: {
        'current_secret_key': AppSecrets.insertKey,
      });

      // If RPC call is successful, proceed with the insert operation
      if (rpcResult != null) {
        final response =
            await ProxyService.supa.client?.from(dataMapperTable).upsert({
          'table_name': tableName,
          'object_id': id,
          'device_identifier': await ProxyService.local.getPlatformDeviceId(),

          /// Tobe done incorporate it into payment wall the device expected to download the object.
          'sync_devices': 0,

          /// this exclude the device that is writing the object setting it to 1
          'device_downloaded_object': 1
        }).select();
        talker.warning(response);
      }
    } catch (e) {
      talker.error('Error occurred: $e');
      // Handle the error appropriately (e.g., show an error message to the user)
    }
  }

  @override
  Future<void> watchTable<T extends realmO.RealmObject>({
    required String tableName,
    required String idField,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    bool useWatch = false,
    required List<int> branchIds,
    required SyncProvider syncProvider,
  }) async {
    if (syncProvider == SyncProvider.FIRESTORE) {
      try {
        if (!isInIsolate()) {
          realm = ProxyService.local.realm!;
        }
        if (_firestore == null) return;

        print("QueryingOn: ${branchIds}");
        // Listen for Firestore collection changes
        final subscription = _firestore!
            .collection(tableName)
            .where('branch_id', whereIn: branchIds)
            .orderBy('updated_at', descending: true)
            .limit(100)
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
                  if (realm!.isClosed) return;
                  if (data['local_update'] == true) {
                    // Ignore this update as it was triggered by our local write
                    continue;
                  }
                  T? realmObject =
                      realm!.query<T>(r'id == $0', [id]).firstOrNull;
                  if (realmObject == null) {
                    /// check if this object was deleted and is found in deletedObjects
                    old.DeletedObject? deletedObject = realm!
                        .query<old.DeletedObject>(
                            r'id == $0', [id]).firstOrNull;
                    if (deletedObject == null) {
                      realmObject = createRealmObject(data);
                      realm!.write(() {
                        realm!.add<T>(realmObject!);
                      });
                    }
                  } else {
                    print(
                        "Firestore changes updateRealmObject $tableName: ${id}");
                    updateRealmObject(realmObject, data);
                  }
                } catch (e, s) {
                  print("E: ${e}");
                  print("S: ${s}");
                }

                break;
              case DocumentChangeType.removed:
                realm!.write(() {
                  T? realmObject =
                      realm!.query<T>(r'id == $0', [id]).firstOrNull;

                  if (realmObject != null) {
                    var eJson = (realmObject is old.Stock)
                        ? realmObject
                            .toEJson(includeVariant: false)
                            .toFlipperJson()
                        : realmObject.toEJson().toFlipperJson();

                    realm!.add<old.DeletedObject>(
                      old.DeletedObject(
                        realmO.ObjectId(),
                        id: (realmObject is old.Stock)
                            ? realmObject.id!
                            : eJson['id'],
                        branchId: eJson['branch_id'],
                        businessId: eJson['business_id'],
                        deviceCount: 1,
                      ),
                    );

                    realm!.delete(realmObject);
                  }
                });
                break;
            }
          }
        }, onError: (error) {
          print("Error listening to Firestore changes: $error");
        });
        _subscriptions[tableName] = subscription;
      } catch (e) {
        print("Error setting up Firestore listener: $e");
        throw Exception("Error syncing: $e");
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
      List<old.TransactionItem> items = realm!
          .query<old.TransactionItem>(r'branchId == $0', [branchId]).toList();
      List<List<old.TransactionItem>> batches =
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

  List<List<old.TransactionItem>> _splitIntoBatches(
      List<old.TransactionItem> items, int batchSize) {
    return [
      for (var i = 0; i < items.length; i += batchSize)
        items.sublist(
            i, i + batchSize > items.length ? items.length : i + batchSize)
    ];
  }

  Future<void> handleRealmChangesAsync<T>({
    required realmO.RealmResults<T> results,
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
            syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
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

  @override
  AsyncCollection? accessCollection;

  @override
  AsyncCollection? branchCollection;

  @override
  AsyncCollection? businessCollection;

  @override
  DatabaseProvider? capella;

  @override
  AsyncCollection? permissionCollection;

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  @override
  List<Accesses> access({required int userId}) {
    // TODO: implement access
    throw UnimplementedError();
  }

  @override
  Future<Branch> activeBranch() {
    // TODO: implement activeBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) {
    // TODO: implement activeBusinesses
    throw UnimplementedError();
  }

  @override
  Category? activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Activity>> activities({required int userId}) {
    // TODO: implement activities
    throw UnimplementedError();
  }

  @override
  Future<Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      required String userOwnerPhoneNumber,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement addBranch
    throw UnimplementedError();
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  void addTransactionItem(
      {required trans.Transaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // TODO: implement addTransactionItem
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future<void> amplifyLogout() {
    // TODO: implement amplifyLogout
    throw UnimplementedError();
  }

  @override
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
  }

  @override
  Stream<Tenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({required int productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Branch? branch({required int serverId}) {
    // TODO: implement branch
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<ext.BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  List<Business> businesses() {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required int branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Stream<List<Category>> categoryStream() {
    // TODO: implement categoryStream
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIn({required String? checkInCode}) {
    // TODO: implement checkIn
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void clearData({required ClearData data}) {
    // TODO: implement clearData
  }

  @override
  void clearVariants() {
    // TODO: implement clearVariants
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    // TODO: implement closeDrawer
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<List<trans.Transaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) {
    // TODO: implement completedTransactions
    throw UnimplementedError();
  }

  @override
  Composite composite({required int variantId}) {
    // TODO: implement composite
    throw UnimplementedError();
  }

  @override
  List<Composite> composites({required int productId}) {
    // TODO: implement composites
    throw UnimplementedError();
  }

  @override
  List<Composite> compositesByVariantId({required int variantId}) {
    // TODO: implement compositesByVariantId
    throw UnimplementedError();
  }

  @override
  Future<FlipperInterfaceCapella> configureCapella(
      {required bool useInMemory, required storage.LocalStorage box}) {
    // TODO: implement configureCapella
    throw UnimplementedError();
  }

  @override
  Future<FlipperInterfaceCapella> configureLocal(
      {required bool useInMemory, required storage.LocalStorage box}) {
    // TODO: implement configureLocal
    throw UnimplementedError();
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) {
    // TODO: implement configureSystem
    throw UnimplementedError();
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  Future<Voucher?> consumeVoucher({required int voucherCode}) {
    // TODO: implement consumeVoucher
    throw UnimplementedError();
  }

  @override
  Future<T?> create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  void createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) {
    // TODO: implement createNewStock
  }

  @override
  void createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) {
    // TODO: implement createOrUpdateBranchOnCloud
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required trans.Transaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter,
      required int invoiceNumber}) {
    // TODO: implement createReceipt
    throw UnimplementedError();
  }

  @override
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId}) {
    // TODO: implement createStockRequest
    throw UnimplementedError();
  }

  @override
  void createVariant(
      {required String barCode,
      required String sku,
      required int productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name}) {
    // TODO: implement createVariant
  }

  @override
  List<Customer> customers({required int branchId}) {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  Future<String> dbPath({required String path, int? folder}) {
    // TODO: implement dbPath
    throw UnimplementedError();
  }

  @override
  Branch? defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> defaultBusiness() {
    // TODO: implement defaultBusiness
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(
      {required int id,
      String? endPoint,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllProducts() {
    // TODO: implement deleteAllProducts
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement deleteBranch
    throw UnimplementedError();
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, int? transactionId}) {
    // TODO: implement deleteItemFromCart
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) {
    // TODO: implement deleteTransactionByIndex
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) {
    // TODO: implement downloadAsset
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) {
    // TODO: implement downloadAssetSave
    throw UnimplementedError();
  }

  @override
  EBM? ebm({required int branchId}) {
    // TODO: implement ebm
    throw UnimplementedError();
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) {
    // TODO: implement enableAttendance
    throw UnimplementedError();
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) {
    // TODO: implement findProductByTenantId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Assets? getAsset({String? assetName, int? productId}) {
    // TODO: implement getAsset
    throw UnimplementedError();
  }

  @override
  Business getBusiness({int? businessId}) {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Business? getBusinessById({required int businessId}) {
    // TODO: implement getBusinessById
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<Business> getBusinessFuture({int? businessId}) {
    // TODO: implement getBusinessFuture
    throw UnimplementedError();
  }

  @override
  Future<Configurations?> getByTaxType({required String taxtype}) async {
    final response = await configurationsRef
        .whereTaxType(isEqualTo: taxtype)
        .whereBranchId(isEqualTo: ProxyService.box.getBranchId()!)
        .get();
    if (response.docs.isEmpty) {
      return null;
    }
    return response.docs.first.data;
  }

  @override
  Future<PColor?> getColor({required int id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
    final repository = brick.Repository();
    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('receiptType').isExactly(receiptType),
    ]);
    final counter = await repository.get<models.Counter>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemote);
    return counter
        .map((e) => Counter(
            id: e.id,
            branchId: e.branchId,
            businessId: e.businessId,
            receiptType: e.receiptType,
            totRcptNo: e.totRcptNo,
            curRcptNo: e.curRcptNo,
            invcNo: e.invcNo,
            lastTouched: e.lastTouched))
        .firstOrNull;
  }

  @override
  Future<List<Counter>> getCounters({required int branchId}) async {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<models.Counter>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemote);

    return counters
        .map((e) => Counter(
              id: e.id,
              branchId: e.branchId,
              businessId: e.businessId,
              receiptType: e.receiptType,
              totRcptNo: e.totRcptNo,
              curRcptNo: e.curRcptNo,
              invcNo: e.invcNo,
              lastTouched: DateTime.now(),
            ))
        .toList();
  }

  @override
  Future<AsyncCollection> getCountersCollection() {
    // TODO: implement getCountersCollection
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant(
      {required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId}) {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomer({String? key, int? id}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomerFuture({String? key, int? id}) {
    // TODO: implement getCustomerFuture
    throw UnimplementedError();
  }

  @override
  List<Customer> getCustomers({String? key, int? id}) {
    // TODO: implement getCustomers
    throw UnimplementedError();
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
    // TODO: implement getDefaultTenant
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) {
    // TODO: implement getDevice
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDeviceById({required int id}) {
    // TODO: implement getDeviceById
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) {
    // TODO: implement getDrawer
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) {
    // TODO: implement getFavoriteById
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) {
    // TODO: implement getFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    // TODO: implement getFavoriteByIndexStream
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) {
    // TODO: implement getFavoriteByProdId
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<String> getIdToken() {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }

  @override
  FlipperSaleCompaign? getLatestCompaign() {
    // TODO: implement getLatestCompaign
    throw UnimplementedError();
  }

  @override
  Future<models.Plan?> getPaymentPlan({required int businessId}) async {
    try {
      final repository = brick.Repository();

      final query = brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
      ]);
      final result = await repository.get<models.Plan>(
          query: query, policy: OfflineFirstGetPolicy.awaitRemote);
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }

  @override
  List<TransactionPaymentRecord> getPaymentType({required int transactionId}) {
    // TODO: implement getPaymentType
    throw UnimplementedError();
  }

  @override
  Future<ext.IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Pin? getPinLocal({required int userId}) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }

  @override
  Future<String?> getPlatformDeviceId() {
    // TODO: implement getPlatformDeviceId
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductByBarCode(
      {required String barCode, required int branchId}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Future<List<Product?>> getProductByName(
      {required String name, required int branchId}) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductList(
      {int? prodIndex, required int branchId}) {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  List<Product> getProducts({String? key}) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
    // TODO: implement getReceipt
    throw UnimplementedError();
  }

  @override
  Future<({double grossProfit, double netProfit})> getReportData() {
    // TODO: implement getReportData
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock({required int branchId, required int variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Stock? getStockById({required int id}) {
    // TODO: implement getStockById
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId}) {
    // TODO: implement getStockStream
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    // TODO: implement getStockValue
    throw UnimplementedError();
  }

  @override
  Tenant getTenant({required int userId}) {
    // TODO: implement getTenant
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> getTenantBYPin({required int pin}) {
    // TODO: implement getTenantBYPin
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> getTenantBYUserId({required int userId}) {
    // TODO: implement getTenantBYUserId
    throw UnimplementedError();
  }

  @override
  Future<trans.Transaction?> getTransactionById({required int id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) {
    // TODO: implement getTransactionItemsByTransactionId
    throw UnimplementedError();
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
    throw UnimplementedError();
  }

  @override
  Future<
      ({
        List<Device> devices,
        List<Favorite> favorites,
        List<Product> products,
        List<Stock> stocks,
        List<TransactionItem> transactionItems,
        List<trans.Transaction> transactions,
        List<Variant> variants
      })> getUnSyncedData() {
    // TODO: implement getUnSyncedData
    throw UnimplementedError();
  }

  @override
  Variant? getVariantById({required int id}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  Variant? getVariantByProductId({required int productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    // TODO: implement getVariantByProductIdStream
    throw UnimplementedError();
  }

  @override
  List<Variant> getVariants({String? key}) {
    // TODO: implement getVariants
    throw UnimplementedError();
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    return ProxyService.local.hasActiveSubscription(
        businessId: businessId, flipperHttpClient: flipperHttpClient);
  }

  @override
  Future<void> initCollections() {
    // TODO: implement initCollections
    throw UnimplementedError();
  }

  @override
  FlipperInterfaceCapella instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  bool isAdmin({required int userId, required String appFeature}) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  bool isRealmClosed() {
    // TODO: implement isRealmClosed
    throw UnimplementedError();
  }

  @override
  Future<bool> isSubscribed(
      {required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled({required Business business}) {
    // TODO: implement isTaxEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId}) {
    // TODO: implement isTokenValid
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<ext.SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  Future<trans.Transaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) {
    // TODO: implement manageCashInOutTransaction
    throw UnimplementedError();
  }

  @override
  trans.Transaction manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  Stream<trans.Transaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) {
    // TODO: implement manageTransactionStream
    throw UnimplementedError();
  }

  @override
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) {
    // TODO: implement markModelForEbmUpdate
    throw UnimplementedError();
  }

  @override
  AppNotification notification({required int id}) {
    // TODO: implement notification
    throw UnimplementedError();
  }

  @override
  Stream<List<AppNotification>> notificationStream({required int identifier}) {
    // TODO: implement notificationStream
    throw UnimplementedError();
  }

  @override
  void notify({required AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Stream<List<trans.Transaction>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Stream<PaymentPlan?> paymentPlanStream({required int businessId}) {
    // TODO: implement paymentPlanStream
    throw UnimplementedError();
  }

  @override
  Future<LPermission?> permission({required int userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  List<LPermission> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    final products = productsRef
        .whereId(isEqualTo: prodIndex)
        .whereBranchId(isEqualTo: ProxyService.box.getBranchId()!);
    return products
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data).toList());
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    return products.docs.map((doc) => doc.data).toList();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    return products.docs.map((doc) => doc.data).toList();
  }

  @override
  void reDownloadAsset() {
    // TODO: implement reDownloadAsset
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) {
    // TODO: implement recordUserActivity
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
    throw UnimplementedError();
  }

  @override
  void removeCustomerFromTransaction({required trans.Transaction transaction}) {
    // TODO: implement removeCustomerFromTransaction
  }

  @override
  Future<bool> removeS3File({required String fileName}) {
    // TODO: implement removeS3File
    throw UnimplementedError();
  }

  @override
  Report report({required int id}) {
    // TODO: implement report
    throw UnimplementedError();
  }

  @override
  Stream<List<Report>> reports({required int branchId}) {
    // TODO: implement reports
    throw UnimplementedError();
  }

  @override
  List<StockRequest> requests({required int branchId}) {
    // TODO: implement requests
    throw UnimplementedError();
  }

  @override
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter}) {
    final response =
        stockRequestsRef.whereMain_branch_id(isEqualTo: branchId).snapshots();
    return response
        .map((snapshot) => snapshot.docs.map((doc) => doc.data).toList());
  }

  @override
  void saveComposite({required Composite composite}) {
    updateRecord(
      tableName: compositesTable,
      idField: "${compositesTable.singularize()}_id",
      map: composite.toJson(),
      id: composite.id!,
      syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
    );
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  void saveEbm(
      {required int branchId,
      required String severUrl,
      required String bhFId}) {
    // TODO: implement saveEbm
  }
  @override
  Future<void> saveOrUpdatePaymentPlan({
    required int businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    String? customerCode,
    models.Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  }) async {
    final repository = brick.Repository();

    try {
      final num = ProxyService.box.numberOfPayments() ?? numberOfPayments;
      // compute next billing date
      final nextBillingDate = isYearlyPlan
          ? DateTime.now().add(Duration(days: 365 * num))
          : DateTime.now().add(Duration(days: 30 * num));
      // Fetch existing plan and addons
      final existingPlanAddons =
          await _fetchExistingAddons(repository, businessId);

      // Process new addons if provided
      final updatedAddons = await _processNewAddons(
        repository: repository,
        businessId: businessId,
        existingAddons: existingPlanAddons,
        newAddonNames: addons,
        isYearlyPlan: isYearlyPlan,
      );

      // Create or update the plan
      await _upsertPlan(
        repository: repository,
        businessId: businessId,
        selectedPlan: selectedPlan,
        numberOfPayments: numberOfPayments,
        additionalDevices: additionalDevices,
        isYearlyPlan: isYearlyPlan,
        totalPrice: totalPrice,
        payStackUserId: payStackUserId,
        paymentMethod: paymentMethod,
        addons: updatedAddons,
        nextBillingDate: nextBillingDate,
      );
    } catch (e) {
      talker.error('Failed to save/update payment plan: $e');
      rethrow;
    }
  }

  Future<List<models.PlanAddon>> _fetchExistingAddons(
    brick.Repository repository,
    int businessId,
  ) async {
    try {
      final query = brick.Query.where(
        'addons',
        brick.Where('planId').isExactly(businessId),
      );

      final planWithAddons = await repository.get<models.Plan>(
        query: query,
        policy: OfflineFirstGetPolicy.awaitRemote,
      );

      return planWithAddons.expand((plan) => plan.addons).toList();
    } catch (e) {
      talker.error('Failed to fetch existing addons: $e');
      rethrow;
    }
  }

  Future<List<models.PlanAddon>> _processNewAddons({
    required brick.Repository repository,
    required int businessId,
    required List<models.PlanAddon> existingAddons,
    required List<String>? newAddonNames,
    required bool isYearlyPlan,
  }) async {
    if (newAddonNames == null) return existingAddons;

    final updatedAddons = List<models.PlanAddon>.from(existingAddons);
    final existingAddonNames = existingAddons.map((e) => e.addonName).toSet();

    for (final addonName in newAddonNames) {
      if (existingAddonNames.contains(addonName)) continue;

      final newAddon = models.PlanAddon(
        id: randomNumber(),
        addonName: addonName,
        createdAt: DateTime.now(),
        planId: businessId,
      );

      // Create temporary plan for foreign key relationship
      await _createTemporaryPlan(
        repository: repository,
        businessId: businessId,
        isYearlyPlan: isYearlyPlan,
        addons: updatedAddons,
      );

      await repository.upsert(newAddon);
      updatedAddons.add(newAddon);
    }

    return updatedAddons;
  }

  Future<void> _createTemporaryPlan({
    required brick.Repository repository,
    required int businessId,
    required bool isYearlyPlan,
    required List<models.PlanAddon> addons,
  }) async {
    await repository.upsert(
      models.Plan(
        id: businessId,
        rule: isYearlyPlan ? 'yearly' : 'monthly',
        addons: addons,
      ),
      query: brick.Query(
        where: [brick.Where('businessId').isExactly(businessId)],
      ),
    );
  }

  Future<void> _upsertPlan({
    required brick.Repository repository,
    required int businessId,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    required List<models.PlanAddon> addons,
    required DateTime nextBillingDate,
    required int numberOfPayments,
  }) async {
    final plan = models.Plan(
      id: businessId,
      businessId: businessId,
      selectedPlan: selectedPlan,
      additionalDevices: additionalDevices,
      isYearlyPlan: isYearlyPlan,
      rule: isYearlyPlan ? 'yearly' : 'monthly',
      totalPrice: totalPrice.toInt(),
      createdAt: DateTime.now(),
      numberOfPayments: numberOfPayments,
      nextBillingDate: nextBillingDate,
      payStackCustomerId: payStackUserId,
      paymentMethod: paymentMethod,
      addons: addons,
    );

    await repository.upsert(
      plan,
      query: brick.Query(
        where: [brick.Where('businessId').isExactly(businessId)],
      ),
    );
  }

  @override
  void savePaymentType({required TransactionPaymentRecord paymentRecord}) {
    // TODO: implement savePaymentType
  }

  @override
  Future<Pin?> savePin({required Pin pin}) {
    // TODO: implement savePin
    throw UnimplementedError();
  }

  @override
  void saveStock({required Variant variant}) {
    // TODO: implement saveStock
  }

  @override
  Future<Tenant?> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required HttpClientInterface flipperHttpClient,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError();
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin, required String bhfId, required String lastReqDt}) {
    // TODO: implement selectImportItems
    throw UnimplementedError();
  }

  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) {
    // TODO: implement sendLoginRequest
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessageToIsolate() {
    // TODO: implement sendMessageToIsolate
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<List<ext.ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<SKU?> sku({required int branchId, required int businessId}) {
    // TODO: implement sku
    throw UnimplementedError();
  }

  @override
  Stream<double> soldStockValue({required branchId}) {
    // TODO: implement soldStockValue
    throw UnimplementedError();
  }

  @override
  Future<void> spawnIsolate(isolateHandler) {
    // TODO: implement spawnIsolate
    throw UnimplementedError();
  }

  @override
  Future<void> startReplicator() {
    // TODO: implement startReplicator
    throw UnimplementedError();
  }

  @override
  Future<Stock?> stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false}) {
    // TODO: implement stockByVariantIdFuture
    throw UnimplementedError();
  }

  @override
  Stream<double> stockValue({required branchId}) {
    // TODO: implement stockValue
    throw UnimplementedError();
  }

  @override
  List<Stock> stocks({required int branchId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Future<({String customerCode, String url, int userId})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    // TODO: implement syncUserWithAwsIncognito
    throw UnimplementedError();
  }

  @override
  Tenant? tenant({int? businessId, int? userId}) {
    // TODO: implement tenant
    throw UnimplementedError();
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<ext.ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement tenantsFromOnline
    throw UnimplementedError();
  }

  @override
  Future<List<trans.Transaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Stream<List<trans.Transaction>> ticketsStreams() {
    // TODO: implement ticketsStreams
    throw UnimplementedError();
  }

  @override
  Future<double> totalStock({int? productId, int? variantId}) {
    // TODO: implement totalStock
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    // TODO: implement transactionItemList
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required int branchId,
      required bool active}) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsFuture
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsStreams
    throw UnimplementedError();
  }

  @override
  Stream<List<trans.Transaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement transactionList
    throw UnimplementedError();
  }

  @override
  Stream<List<trans.Transaction>> transactionStreamById(
      {required int id, required FilterType filterType}) {
    // TODO: implement transactionStreamById
    throw UnimplementedError();
  }

  @override
  List<trans.Transaction> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isExpense = false,
      bool includePending = false}) {
    // TODO: implement transactions
    throw UnimplementedError();
  }

  @override
  Stream<List<trans.Transaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<List<UniversalProduct>> universalProductNames(
      {required int branchId}) {
    // TODO: implement universalProductNames
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  @override
  void upSert() {
    // TODO: implement upSert
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  void updateCounters(
      {required List<Counter> counters, RwApiResponse? receiptSignature}) {
    final repository = brick.Repository();
    // build brick Counter to pass in to upsert
    for (Counter counter in counters) {
      final upCounter = models.Counter(
        createdAt: DateTime.now(),
        lastTouched: DateTime.now(),
        id: counter.id!,
        branchId: counter.branchId,
        curRcptNo: counter.curRcptNo,
        totRcptNo: counter.totRcptNo,
        invcNo: counter.invcNo! + 1,
        businessId: counter.businessId,
        receiptType: counter.receiptType,
      );
      repository.upsert(upCounter);
      counter.invcNo = counter.invcNo! + 1;
      ProxyService.capela.updateRecord(
          tableName: countersTable,
          idField: 'id',
          map: counter.toJson(),
          id: counter.id!,
          syncProviders: [SyncProvider.CAPELLA]);
    }
  }

  @override
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement updateNonRealm
    throw UnimplementedError();
  }

  @override
  void updateStock({required int stockId, required double qty}) {
    // TODO: implement updateStock
  }

  @override
  void updateTransactionItemQty(
      {required qty, required int transactionItemId}) {
    // TODO: implement updateTransactionItemQty
  }

  @override
  void updateTransactionStatus(
      trans.Transaction transaction, String receiptType) {
    // TODO: implement updateTransactionStatus
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) {
    // TODO: implement uploadPdfToS3
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, int? productId, int? page, int? itemsPerPage}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  Future<trans.Transaction> collectPayment(
      {required double cashReceived,
      required trans.Transaction transaction,
      required String paymentType,
      required double discount,
      required int branchId,
      required String bhfId,
      required bool isProformaMode,
      required bool isTrainingMode,
      required String transactionType,
      String? categoryId,
      bool directlyHandleReceipt = false,
      required bool isIncome}) {
    // TODO: implement collectPayment
    throw UnimplementedError();
  }

  @override
  void whoAmI() {
    talker.warning("I am FirestoreSync");
  }

  @override
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage}) {
    // TODO: implement saveTax
    throw UnimplementedError();
  }

  @override
  Future<Configurations> taxes({required int branchId}) {
    // TODO: implement taxes
    throw UnimplementedError();
  }
}
