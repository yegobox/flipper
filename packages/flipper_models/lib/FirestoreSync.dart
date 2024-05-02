// import 'dart:io';
// import 'dart:isolate';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/sync_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flipper_services/constants.dart';
import 'sync.dart';
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';

abstract class SyncFirestore<M extends IJsonSerializable> implements Sync {
  Future<void> onSave<T extends IJsonSerializable>({required T item});
  factory SyncFirestore.create() => FirestoreSync<M>();
  void configure();
}

class FirestoreSync<M extends IJsonSerializable> implements SyncFirestore<M> {
  @override
  Future<void> onSave<T extends IJsonSerializable>({required T item}) async {
    throw UnimplementedError();
    // RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
    // if (rootIsolateToken == null) {
    //   print("Cannot get the RootIsolateToken");
    //   return;
    // }
    // Map<String, dynamic> data = item.toJson();
    // if (data['action'] == AppActions.synchronized) return;

    // /// isolate is not working proper on android, so no need of isolate on mobile then
    // if (Platform.isAndroid || Platform.isIOS) {
    //   final String collectionName = getCollectionName<T>();
    //   final collectionRef =
    //       FirebaseFirestore.instance.collection(collectionName);
    //   try {
    //     final doc = collectionRef.doc(getItemId<T>(item));

    //     await doc.set(data, SetOptions(merge: true));
    //   } catch (e) {
    //     print('Error: $e');
    //     // Send an error message back to the main thread
    //   }
    // } else {
    //   data['secretId'] = "111";
    //   ReceivePort receivePort = ReceivePort();
    //   await Isolate.spawn(
    //     saveItem<T>,
    //     [rootIsolateToken, receivePort.sendPort, item, data],
    //   );
    //   receivePort.listen((message) {
    //     print('Message from isolate: $message');
    //   });
    // }
  }

  Future<void> saveItem<T extends IJsonSerializable>(List<dynamic> args) async {
    throw UnimplementedError();
    // final rootIsolateToken = args[0] as RootIsolateToken;
    // final sendPort = args[1] as SendPort;
    // final item = args[2] as T; // Retrieve item from the argument list
    // final data = args[3] as Map<String, dynamic>;
    // BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // if (Firebase.apps.isEmpty) {
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    // }

    // final String collectionName = getCollectionName<T>();
    // final collectionRef = FirebaseFirestore.instance.collection(collectionName);
    // try {
    //   final doc = collectionRef.doc(getItemId<T>(item));

    //   await doc.set(data, SetOptions(merge: true));
    //   sendPort.send('Item saved successfully');
    // } catch (e) {
    //   print('Error: $e');
    //   // Send an error message back to the main thread
    //   sendPort.send('Error saving item: $e');
    // }
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

  int getItemId<T>(T item) {
    if (item is Product) {
      return item.id!;
    } else if (item is Variant) {
      return item.id!;
    } else if (item is Stock) {
      return item.id!;
    } else if (item is Device) {
      return item.id!;
    } else if (item is ITransaction) {
      return item.id!;
    } else if (item is TransactionItem) {
      return item.id!;
    } else if (item is Drawers) {
      return item.id!;
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
  Future<void> pull() async {
    throw UnimplementedError();
    // final int? branchId = ProxyService.box.getBranchId();
    // if (branchId == null) return await Future.value(null);

    // for (final collectionName in [
    //   'products',
    //   'variants',
    //   'stocks',
    //   'devices',
    //   'transactions',
    //   'transactionItems',
    //   'drawers'
    // ]) {
    //   final collectionRef =
    //       FirebaseFirestore.instance.collection(collectionName);

    //   final collectionSnapshots = collectionRef.snapshots();
    //   collectionSnapshots.listen((querySnapshot) {
    //     for (final docSnapshot in querySnapshot.docs) {
    //       final updatedJson = docSnapshot.data();
    //       handleItem(
    //           model: getSpecificModel(collectionName, updatedJson),
    //           branchId: branchId);
    //     }
    //   });
    // }
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

  @override
  void configure() {
    // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  }

  @override
  Future<void> syncCounter() {
    // TODO: implement syncCounter
    throw UnimplementedError();
  }
}
