import 'dart:isolate';
import 'dart:ui';

import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipper_models/CloudSync.dart';

extension RealmExtension on Realm {
  void put<T extends RealmObject>(
    T object, {
    required String tableName,
    Function(T)? onAdd,
  }) {
    write(() {
      add<T>(object, update: true);
      final firestore = FirebaseFirestore.instance;
      CloudSync(firestore, ProxyService.local.realm!).updateRecord(
          tableName: tableName,

          /// take tablename e.g products => product_id
          idField: tableName.singularize() + "_id",
          map: object is Stock
              ? object.toEJson(includeVariant: false)!.toFlipperJson()
              : object.toEJson()!.toFlipperJson(),
          id: object is Stock
              ? object.toEJson(includeVariant: false)!.toFlipperJson()['id']
              : object.toEJson()!.toFlipperJson()['id'],
          syncProvider: SyncProvider.FIRESTORE);
      _spawnIsolate("transactions", IsolateHandler.handleEBMTrigger);
      if (onAdd != null) {
        onAdd(object);
      }
    });
  }

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
