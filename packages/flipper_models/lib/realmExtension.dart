import 'dart:isolate';
import 'dart:ui';

import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/CloudSync.dart';

extension RealmExtension on Realm {
  T writeN<T>(
      {required String tableName, required T Function() writeCallback}) {
    assert(!_isFuture<T>(), 'writeCallback must be synchronous');
    final transaction = beginWrite();
    try {
      T result = writeCallback();
      transaction.commit();

      if (result is Iterable) {
        for (var item in result) {
          _syncToFirestore(tableName, item);
        }
      } else if (result != null) {
        _syncToFirestore(tableName, result);
      }
      return result;
    } catch (e, s) {
      talker.error(s);
      if (transaction.isOpen) {
        transaction.rollback();
      }
      rethrow;
    }
  }

  void deleteN<T extends RealmObjectBase>(
      {required String tableName, required T Function() deleteCallback}) {
    T object = deleteCallback();
    _syncToFirestoreDelete(tableName, object);
    delete(object);
  }

  void put<T extends RealmObject>(
    T object, {
    required String tableName,
    Function(T)? onAdd,
  }) {
    write(() {
      add<T>(object, update: true);
      _syncToFirestore(tableName, object);
      _spawnIsolate("transactions", IsolateHandler.handleEBMTrigger);
      if (onAdd != null) {
        onAdd(object);
      }
    });
  }

  void _syncToFirestoreDelete<T>(String tableName, T data) {
    final firestore = FirebaseFirestore.instance;
    final map = data is Stock
        ? data.toEJson(includeVariant: false)!.toFlipperJson()
        : data.toEJson().toFlipperJson();
    final id = map['id'];
    map['deleted_at'] = DateTime.now().toIso8601String();
    CloudSync(firestore, ProxyService.local.realm!).deleteRecord(
      tableName: tableName,
      idField: tableName.singularize() + "_id",
      id: id,
    );
  }

  void _syncToFirestore<T>(String tableName, T data) {
    final firestore = FirebaseFirestore.instance;
    final map = data is Stock
        ? data.toEJson(includeVariant: false)!.toFlipperJson()
        : data.toEJson().toFlipperJson();
    final id = map['id'];
    CloudSync(firestore, ProxyService.local.realm!).updateRecord(
      tableName: tableName,
      idField: tableName.singularize() + "_id",
      map: map,
      id: id,
      syncProvider: SyncProvider.FIRESTORE,
    );
  }

  bool _isSubtype<S, T>() => <S>[] is List<T>;
  bool _isFuture<T>() => T != Never && _isSubtype<T, Future>();

  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    try {
      String encryptionKey = ProxyService.box.encryptionKey();
      Business business = ProxyService.local.realm!.query<Business>(
          r'id == $0', [ProxyService.box.getBusinessId()!]).first;

      EBM ebm = ProxyService.local.realm!.query<EBM>(
          r'businessId == $0', [ProxyService.box.getBusinessId()!]).first;

      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(
        isolateHandler,
        [
          RootIsolateToken.instance,
          receivePort.sendPort,
          ProxyService.box.getBranchId()!,
          'synced-removed',
          encryptionKey,
          business.tinNumber,
          ebm.bhfId
        ],
      );
    } catch (error) {}
  }
}
