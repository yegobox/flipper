import 'dart:convert';
import 'dart:isolate';
import 'package:flipper_models/helperModels/business.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/Booting.dart';
import 'package:realm/realm.dart' as realmO;
import 'dart:async';
import 'package:flipper_models/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
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
import 'package:flipper_models/CoreDataInterface.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_services/abstractions/storage.dart' as storage;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/constants.dart';
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

/// A cloud sync that uses different sync provider such as powersync+ superbase, firesore and can easy add
/// anotherone to acheive sync for flipper app

class CoreSync with Booting implements CoreDataInterface {
  final Map<String, StreamSubscription<QuerySnapshot>> _subscriptions = {};
  final FirebaseFirestore? _firestore;
  realmO.Realm? realm;
  final Set<int> _processingIds = {};
  final String apihub = AppSecrets.apihubProd;
  final repository = Repository();
  bool offlineLogin = false;

  bool isInIsolate() {
    return Isolate.current.debugName != null;
  }

// Helper to remove unwanted fields from the map
  void _removeFields(Map<String, dynamic> map, List<String> fields) {
    for (var field in fields) {
      map.remove(field);
    }
  }

  CoreSync(this._firestore, {this.realm, SupabaseClient? client});
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
                        ? realmObject.toEJson().toFlipperJson()
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
  List<Access> access({required int userId}) {
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
      {required ITransaction transaction,
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
  void clearData({required ClearData data}) async {
    try {
      if (data == ClearData.Branch) {
        // Retrieve the list of Branches to delete based on the query
        // final query = brick.Query();
        final List<Branch> branches = await repository.get<Branch>();

        for (final branch in branches) {
          await repository.delete<Branch>(branch);
        }
      }

      if (data == ClearData.Business) {
        // Retrieve the list of Businesses to delete
        final List<Business> businesses = await repository.get<Business>();

        for (final business in businesses) {
          await repository.delete<Business>(business);
        }
      }
    } catch (e, s) {
      // Log the error with talker
      talker.error('Failed to clear data: $e');
      talker.error('Stack trace: $s');
    }
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
  Future<List<ITransaction>> completedTransactions(
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
  Future<CoreDataInterface> configureCapella(
      {required bool useInMemory, required storage.LocalStorage box}) {
    // TODO: implement configureCapella
    throw UnimplementedError();
  }

  @override
  Future<CoreDataInterface> configureLocal(
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
      required ITransaction transaction,
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
  Future<Ebm?> ebm({required int branchId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final result = await repository.get<models.Ebm>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Product?> findProductByTenantId({required int tenantId}) async {
    final query = brick.Query(
        where: [brick.Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<models.Product>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Branch?> branch({required int serverId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(serverId)]);
    final result = await repository.get<models.Branch>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(productId)]);
    // Return the stream directly instead of storing in variable
    return repository.subscribe<Variant>(query: query);
  }

  @override
  Future<Assets?> getAsset({String? assetName, int? productId}) async {
    final repository = Repository();
    final query = brick.Query(
        where: assetName != null
            ? [brick.Where('assetName').isExactly(assetName)]
            : productId != null
                ? [brick.Where('productId').isExactly(productId)]
                : throw Exception("no asset"));
    final result = await repository.get<models.Assets>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Business> getBusiness({int? businessId}) async {
    final repository = Repository();
    final query = brick.Query(
        where: businessId != null
            ? [brick.Where('serverId').isExactly(businessId)]
            : [brick.Where('isDefault').isExactly(true)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.first;
  }

  @override
  Future<Business?> getBusinessById({required int businessId}) async {
    final repository = Repository();
    final query =
        brick.Query(where: [brick.Where('serverId').isExactly(businessId)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) async {
    final repository = Repository();
    final query = brick.Query(where: [brick.Where('serverId').isExactly(id)]);
    final result = await repository.get<models.Business>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Business? business = result.firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(
          id: iBusiness.id!,
          serverId: iBusiness.id!,
          name: iBusiness.name,
          userId: iBusiness.userId,
          createdAt: DateTime.now().toIso8601String());

      business.serverId = id;
      await repository.upsert<models.Business>(business);
      return business;
    }
    return null;
  }

  @override
  Future<Configurations?> getByTaxType({required String taxtype}) async {
    final repository = Repository();
    final query = brick.Query(where: [
      brick.Where('taxType').isExactly(taxtype),
      brick.Where('branchId').isExactly(ProxyService.box.getBranchId()!),
    ]);
    final result = await repository.get<models.Configurations>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<PColor?> getColor({required int id}) async {
    final repository = Repository();
    final query = brick.Query(where: [brick.Where('id').isExactly(id)]);
    final result = await repository.get<models.PColor>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
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
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return counter.firstOrNull;
  }

  @override
  Future<List<Counter>> getCounters({required int branchId}) async {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<models.Counter>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    return counters;
  }

  @override
  Future<Variant?> getCustomVariant(
      {required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId}) async {
    // TODO: implement getCustomVariant
    final repository = Repository();
    final productQuery = brick.Query(where: [
      brick.Where('name').isExactly(CUSTOM_PRODUCT),
      brick.Where('branchId').isExactly(branchId),
    ]);
    final productResult = await repository.get<models.Product>(
        query: productQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Product? product = productResult.firstOrNull;

    if (product == null) {
      // Create a new custom product if it doesn't exist
      product = await createProduct(
          tinNumber: tinNumber,
          bhFId: bhFId,
          branchId: branchId,
          businessId: businessId,
          product: models.Product(
              id: randomNumber(),
              lastTouched: DateTime.now(),
              name: CUSTOM_PRODUCT,
              businessId: businessId,
              color: "#e74c3c",
              createdAt: DateTime.now().toIso8601String(),
              branchId: branchId));
    }

    /// for whatever reason if a product exist and there is no related variant please add it before we proceed.
    final variantQuery =
        brick.Query(where: [brick.Where('productId').isExactly(product!.id)]);
    final variantResult = await repository.get<models.Variant>(
        query: variantQuery,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    Variant? variant = variantResult.firstOrNull;

    if (variant == null) {
      /// If the variant doesn't exist, add it
      variant = await _addMissingVariant(variant, product, branchId, tinNumber);
    }

    return variant;
  }

  Future<Variant?> _addMissingVariant(
      Variant? variant, Product? product, int branchId, int tinNumber) async {
    final number = randomNumber().toString().substring(0, 5);
    final repository = Repository();
    try {
      if (variant == null) {
        int variantId = randomNumber();
        final stockId = randomNumber();
        variant = Variant(
            id: variantId,

            // branchIds: [ProxyService.box.getBranchId()!],
            lastTouched: DateTime.now(),
            name: product!.name,
            color: product.color,
            sku: 'sku',
            productId: product.id,
            unit: 'Per Item',
            productName: product.name,
            branchId: branchId,
            supplyPrice: 0,
            retailPrice: 0,
            itemNm: product.name,
            bhfId: await ProxyService.box.bhfId() ?? '00',
            // this is fixed but we can get the code to use on item we are saving under selectItemsClass endpoint
            itemClsCd: "5020230602",
            itemCd: randomNumber().toString().substring(0, 5),
            modrNm: number,
            modrId: number,
            pkgUnitCd: "BJ",
            regrId: randomNumber().toString().substring(0, 5),
            itemTyCd: "2", // this is a finished product
            /// available type for itemTyCd are 1 for raw material and 3 for service
            /// is insurance applicable default is not applicable
            isrcAplcbYn: "N",
            useYn: "N",
            itemSeq: 1,
            itemStdNm: product.name,
            taxPercentage: 18,
            tin: tinNumber,
            bcd: CUSTOM_PRODUCT,

            /// country of origin for this item we default until we support something different
            /// and this will happen when we do import.
            orgnNatCd: "RW",

            /// registration name
            regrNm: CUSTOM_PRODUCT,

            /// taxation type code
            taxTyCd: "B", // available types A(A-EX),B(B-18.00%),C,D
            // default unit price
            dftPrc: 0,

            // NOTE: I believe bellow item are required when saving purchase
            ///but I wonder how to get them when saving an item.
            spplrItemCd: randomNumber().toString().substring(0, 5),
            spplrItemClsCd: randomNumber().toString().substring(0, 5),
            spplrItemNm: CUSTOM_PRODUCT,
            qtyUnitCd: "U");

        Stock stock = Stock(
            variant: variant,
            lastTouched: DateTime.now(),
            id: stockId,
            branchId: branchId,
            variantId: variantId,
            currentStock: 0.0,
            productId: product.id)
          ..canTrackingStock = false
          ..showLowStockAlert = false
          ..currentStock = 0.0
          ..branchId = branchId
          ..variantId = variantId
          ..lowStock = 10.0 // default static
          ..canTrackingStock = true
          ..showLowStockAlert = true
          ..active = false
          ..productId = product.id
          ..rsdQty = 0.0;

        repository.upsert<Variant>(variant);

        repository.upsert<Stock>(stock);

        final variantQuery =
            brick.Query(where: [brick.Where('id').isExactly(variantId)]);
        final variantResult = await repository.get<models.Variant>(
            query: variantQuery,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        return variantResult.firstOrNull;
      }
    } catch (e, s) {
      // Handle error during write operation
      talker.error(e);
      talker.error(s);
      throw Exception(e);
    }
    return variant;
  }

  Future<Customer?> getCustomer({String? key, int? id}) async {
    if (key != null && id != null) {
      throw ArgumentError(
          'Cannot provide both a key and an id at the same time');
    }

    if (id != null) {
      // Query by ID
      final query = brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
      ]);
      final List<Customer> customers =
          await repository.get<Customer>(query: query);
      return customers.isNotEmpty ? customers.first : null;
    } else if (key != null) {
      // Queries for each field combined with OR logic
      final queries = [
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('custNm', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('email', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('telNo', value: key, compare: brick.Compare.contains),
        ]),
      ];

      for (final query in queries) {
        final List<Customer> customers = await repository.get<Customer>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        if (customers.isNotEmpty) return customers.first;
      }
    }

    return null;
  }

  @override
  Future<List<Customer>> getCustomers({String? key, int? id}) async {
    final List<Customer> customers = [];
    if (id != null) {
      // Query by ID
      final query = brick.Query(where: [
        brick.Where('id', value: id, compare: brick.Compare.exact),
      ]);
      final List<Customer> fetchedCustomers =
          await repository.get<Customer>(query: query);
      customers.addAll(fetchedCustomers);
    } else if (key != null) {
      // Queries for each field combined with OR logic
      final queries = [
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('custNm', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('email', value: key, compare: brick.Compare.contains),
        ]),
        brick.Query(where: [
          brick.Where('deletedAt', compare: brick.Compare.doesNotContain),
          brick.Where('telNo', value: key, compare: brick.Compare.contains),
        ]),
      ];

      for (final query in queries) {
        final List<Customer> fetchedCustomers = await repository.get<Customer>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
        customers.addAll(fetchedCustomers);
      }
    }
    return customers;
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
    final query =
        brick.Query(where: [brick.Where('businessId').isExactly(businessId)]);
    // Return the stream directly instead of storing in variable
    return repository
        .subscribe<Tenant>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist)
        .map((tenants) => tenants.firstOrNull);
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    final query = brick.Query(where: [
      brick.Where('phone', value: phone, compare: brick.Compare.exact),
      brick.Where(
        'linkingCode',
        value: linkingCode,
        compare: brick.Compare.exact,
      ),
    ]);
    final List<Device> fetchedDevices =
        await repository.get<Device>(query: query);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(id)]);
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    final query = brick.Query(
      where: [brick.Where('businessId').isExactly(businessId)],
    );
    final List<Device> fetchedDevices = await repository.get<Device>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDevices;
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    final query =
        brick.Query(where: [brick.Where('cashierId').isExactly(cashierId)]);
    final List<Drawers> fetchedDrawers = await repository.get<Drawers>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedDrawers.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) async {
    final query = brick.Query(where: [brick.Where('id').isExactly(favId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) async {
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    final repository = brick.Repository();
    final query =
        brick.Query(where: [brick.Where('favIndex').isExactly(favIndex)]);
    return repository
        .subscribe<Favorite>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist)
        .map((data) => data.firstOrNull);
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) async {
    final query =
        brick.Query(where: [brick.Where('productId').isExactly(prodId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    final query = brick.Query();
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedFavorites;
  }

  @override
  Future<String> getIdToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "NONE";
  }

  @override
  Future<FlipperSaleCompaign?> getLatestCompaign() async {
    final query = brick.Query(providerArgs: {'orderBy': 'createdAt DESC'});
    final List<FlipperSaleCompaign> fetchedCampaigns =
        await repository.get<FlipperSaleCompaign>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedCampaigns.firstOrNull;
  }

  @override
  Future<models.Plan?> getPaymentPlan({required int businessId}) async {
    try {
      final repository = brick.Repository();

      final query = brick.Query(where: [
        brick.Where('businessId').isExactly(businessId),
      ]);
      final result = await repository.get<models.Plan>(
          query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }

  @override
  Future<List<TransactionPaymentRecord>> getPaymentType(
      {required int transactionId}) async {
    final query = brick.Query(
        where: [brick.Where('transactionId').isExactly(transactionId)]);
    final List<TransactionPaymentRecord> fetchedPaymentTypes =
        await repository.get<TransactionPaymentRecord>(
            query: query,
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return fetchedPaymentTypes;
  }

  @override
  Future<ext.IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) async {
    final Uri uri = Uri.parse("$apihub/v2/api/pin/$pinString");

    try {
      final localPin = await repository.get<Pin>(
          query:
              brick.Query(where: [brick.Where('userId').isExactly(pinString)]),
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

      if (localPin.firstOrNull != null) {
        Business? business = await getBusinessById(
            businessId: localPin.firstOrNull!.businessId!);
        Branch? branchE =
            await branch(serverId: localPin.firstOrNull!.branchId!);
        if (branchE != null || business != null) {
          return IPin(
              id: localPin.firstOrNull?.id,
              pin: localPin.firstOrNull?.pin ?? int.parse(pinString),
              userId: localPin.firstOrNull!.userId!.toString(),
              phoneNumber: localPin.firstOrNull!.phoneNumber!,
              branchId: localPin.firstOrNull!.branchId!,
              businessId: localPin.firstOrNull!.businessId!,
              ownerName: localPin.firstOrNull!.ownerName!,
              tokenUid: localPin.firstOrNull!.tokenUid!);
        } else {
          clearData(data: ClearData.Branch);
          clearData(data: ClearData.Business);
        }
      } else {
        clearData(data: ClearData.Branch);
        clearData(data: ClearData.Business);
      }
      final response = await flipperHttpClient.get(uri);

      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw PinError(term: "Not found");
      } else {
        throw PinError(term: "Not found");
      }
    } catch (e, s) {
      talker.warning(e, s);

      throw UnknownError(term: e.toString());
    }
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
  Future<ITransaction?> getTransactionById({required int id}) {
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
  CoreDataInterface instance() {
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

  bool isEmail(String input) {
    // Implement your logic to check if input is an email
    // You can use regular expressions or any other email validation mechanism
    // For simplicity, this example checks if the input contains '@'
    return input.contains('@');
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  String _formatPhoneNumber(String userPhone) {
    if (!isEmail(userPhone) && !userPhone.startsWith('+')) {
      return '+$userPhone';
    }
    return userPhone;
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient}) async {
    final String phoneNumber = _formatPhoneNumber(userPhone);
    final IUser user =
        await _authenticateUser(phoneNumber, pin, flipperHttpClient);
    await ProxyService.box.writeBool(key: 'authComplete', value: true);
    if (stopAfterConfigure) return user;
    if (!skipDefaultAppSetup) {
      await setDefaultApp(user);
    }
    ProxyService.box.writeBool(key: 'pinLogin', value: false);
    try {
      _hasActiveSubscription();
    } catch (e) {
      rethrow;
    }
    return user;
  }

  Future<void> _hasActiveSubscription() async {
    await hasActiveSubscription(
        businessId: ProxyService.box.getBusinessId()!,
        flipperHttpClient: ProxyService.http);
  }

  Future<IUser> _authenticateUser(String phoneNumber, Pin pin,
      HttpClientInterface flipperHttpClient) async {
    List<Business> businessesE = businesses();
    List<Branch> branchesE = await branches(businessId: pin.businessId!);

    if (businessesE.isNotEmpty && branchesE.isNotEmpty) {
      offlineLogin = true;

      return _createOfflineUser(phoneNumber, pin, businessesE, branchesE);
    }

    final http.Response response =
        await sendLoginRequest(phoneNumber, flipperHttpClient, apihub);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      /// path the user pin, with
      final IUser user = IUser.fromJson(json.decode(response.body));
      await _patchPin(user.id!, flipperHttpClient, apihub,
          ownerName: user.tenants.first.name);
      ProxyService.box.writeInt(key: 'userId', value: user.id!);
      await ProxyService.backUp.firebaseLogin(token: user.uid);
      return user;
    } else {
      await _handleLoginError(response);
      throw Exception("Error during login");
    }
  }

  Future<http.Response> _patchPin(
      int pin, HttpClientInterface flipperHttpClient, String apihub,
      {required String ownerName}) async {
    return await flipperHttpClient.patch(
      Uri.parse(apihub + '/v2/api/pin/${pin}'),
      body: jsonEncode(<String, String?>{
        'ownerName': ownerName,
        'tokenUid': firebase.FirebaseAuth.instance.currentUser?.uid
      }),
    );
  }

  Future<void> _handleLoginError(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  IUser _createOfflineUser(String phoneNumber, Pin pin,
      List<Business> businesses, List<Branch> branches) {
    return IUser(
      token: pin.tokenUid!,
      uid: pin.tokenUid,
      channels: [],
      phoneNumber: pin.phoneNumber!,
      id: pin.userId!,
      tenants: [
        ITenant(
            id: randomNumber(),
            name: pin.ownerName == null ? "DEFAULT" : pin.ownerName!,
            phoneNumber: phoneNumber,
            permissions: [],
            branches: _convertBranches(branches),
            businesses: _convertBusinesses(businesses),
            businessId: 0,
            nfcEnabled: false,
            userId: pin.userId!,
            isDefault: false)
      ],
    );
  }

  List<IBranch> _convertBranches(List<Branch> branches) {
    return branches
        .map((e) => IBranch(
            id: e.id,
            name: e.name,
            businessId: e.businessId,
            longitude: e.longitude,
            latitude: e.latitude,
            location: e.location,
            active: e.active,
            isDefault: e.isDefault ?? false))
        .toList();
  }

  List<IBusiness> _convertBusinesses(List<Business> businesses) {
    return businesses
        .map((e) => IBusiness(
              id: e.serverId,
              encryptionKey: e.encryptionKey!,
              name: e.name,
              currency: e.currency,
              categoryId: e.categoryId,
              latitude: e.latitude,
              longitude: e.longitude,
              userId: e.userId,
              timeZone: e.timeZone,
              country: e.country,
              businessUrl: e.businessUrl,
              hexColor: e.hexColor,
              imageUrl: e.imageUrl,
              type: e.type,
              active: e.active,
              metadata: e.metadata,
              lastSeen: e.lastSeen,
              firstName: e.firstName,
              lastName: e.lastName,
              deviceToken: e.deviceToken,
              chatUid: e.chatUid,
              backUpEnabled: e.backUpEnabled,
              subscriptionPlan: e.subscriptionPlan,
              nextBillingDate: e.nextBillingDate,
              previousBillingDate: e.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  e.isLastSubscriptionPaymentSucceeded,
              backupFileId: e.backupFileId,
              email: e.email,
              lastDbBackup: e.lastDbBackup,
              fullName: e.fullName,
              role: e.role,
              tinNumber: e.tinNumber,
              bhfId: e.bhfId,
              dvcSrlNo: e.dvcSrlNo,
              adrs: e.adrs,
              taxEnabled: e.taxEnabled,
              taxServerUrl: e.taxServerUrl,
              isDefault: e.isDefault,
              businessTypeId: e.businessTypeId,
              deletedAt: e.deletedAt,
            ))
        .toList();
  }

  Future<ITransaction?> _pendingTransaction({
    required int branchId,
    required String transactionType,
    required bool isExpense,
    bool includeSubTotalCheck = true,
  }) async {
    try {
      // Build the query
      final query = brick.Query(where: [
        brick.Where('branchId', value: branchId, compare: brick.Compare.exact),
        brick.Where('isExpense',
            value: isExpense, compare: brick.Compare.exact),
        brick.Where('status', value: PENDING, compare: brick.Compare.exact),
        brick.Where('transactionType',
            value: transactionType, compare: brick.Compare.exact),
        if (includeSubTotalCheck)
          brick.Where('subTotal', value: 0, compare: brick.Compare.greaterThan),
      ]);

      // Fetch transactions
      final List<ITransaction> transactions =
          await repository.get<ITransaction>(query: query);

      // Check for transactions with items
      for (final transaction in transactions) {
        final List<TransactionItem> items = await transactionItems(
          branchId: branchId,
          transactionId: transaction.id,
          doneWithTransaction: false,
          active: true,
        );

        if (items.isNotEmpty) {
          return transaction;
        }
      }

      // If no transaction with items found, return the first transaction (if any)
      return transactions.isNotEmpty ? transactions.first : null;
    } catch (e, s) {
      // Log errors (optional, replace talker with your preferred logger)
      talker.error('Error in _pendingTransaction: $e');
      talker.error('Stack trace: $s');
      return null;
    }
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) async {
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) async {
    ITransaction? existTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck!);
    if (existTransaction == null) {
      final int id = randomNumber();
      final transaction = ITransaction(
          lastTouched: DateTime.now(),
          id: id,
          reference: randomNumber().toString(),
          transactionNumber: randomNumber().toString(),
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0,
          cashReceived: 0,
          updatedAt: DateTime.now().toIso8601String(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: DateTime.now().toIso8601String());

      // save transaction to isar
      repository.upsert<ITransaction>(transaction);

      return transaction;
    } else {
      return existTransaction;
    }
  }

  @override
  Stream<ITransaction> manageTransactionStream(
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
  Drawers? openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Stream<Plan?> paymentPlanStream({required int businessId}) {
    // TODO: implement paymentPlanStream
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
    // final products = productsRef
    //     .whereId(isEqualTo: prodIndex)
    //     .whereBranchId(isEqualTo: ProxyService.box.getBranchId()!);
    // return products
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs.map((doc) => doc.data).toList());
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products({required int branchId}) async {
    // final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    // return products.docs.map((doc) => doc.data).toList();
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) async {
    // final products = await productsRef.whereBranchId(isEqualTo: branchId).get();
    // return products.docs.map((doc) => doc.data).toList();
    throw UnimplementedError();
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
  void removeCustomerFromTransaction({required ITransaction transaction}) {
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
    // final response =
    //     stockRequestsRef.whereMain_branch_id(isEqualTo: branchId).snapshots();
    // return response
    //     .map((snapshot) => snapshot.docs.map((doc) => doc.data).toList());
    throw UnimplementedError();
  }

  @override
  void saveComposite({required Composite composite}) {
    // updateRecord(
    //   tableName: compositesTable,
    //   idField: "${compositesTable.singularize()}_id",
    //   map: composite.toJson(),
    //   id: composite.id!,
    //   syncProviders: [SyncProvider.FIRESTORE, SyncProvider.SUPABASE],
    // );
    throw UnimplementedError();
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
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
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
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
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
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement transactionList
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> transactionStreamById(
      {required int id, required FilterType filterType}) {
    // TODO: implement transactionStreamById
    throw UnimplementedError();
  }

  @override
  List<ITransaction> transactions(
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
  Stream<List<ITransaction>> transactionsStream(
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
  Future<List<UnversalProduct>> universalProductNames({required int branchId}) {
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
        id: counter.id,
        branchId: counter.branchId,
        curRcptNo: counter.curRcptNo,
        totRcptNo: counter.totRcptNo,
        invcNo: counter.invcNo! + 1,
        businessId: counter.businessId,
        receiptType: counter.receiptType,
      );
      repository.upsert(upCounter);
      counter.invcNo = counter.invcNo! + 1;
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
  void updateTransactionStatus(ITransaction transaction, String receiptType) {
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
  Future<ITransaction> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
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
    talker.warning("I am CoreSync");
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
