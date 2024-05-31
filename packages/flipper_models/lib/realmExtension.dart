import 'dart:isolate';
import 'dart:ui';

import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

extension RealmExtension on Realm {
  void put<T extends RealmObject>(
    T object, {
    Function(T)? onAdd,
  }) {
    write(() {
      final talker = TalkerFlutter.init();
      add(object);
      talker.warning(
          "Saved using standart non async on realm extension :) ${object.toEJson()}");
      TaxController(object: object).handleReceipt();
      _spawnIsolate("transactions", IsolateHandler.handleEBMTrigger);
    });
  }

  Future<void> putAsync<T extends RealmObject>(T object) async {
    await writeAsync(() {
      final talker = TalkerFlutter.init();
      add(object);
      talker.warning(
          "Saved using async on realm Extension:) ${object.toEJson()}");
      TaxController(object: object).handleReceipt();
      _spawnIsolate("transactions", IsolateHandler.handleEBMTrigger);
    });
  }

  Future<void> _spawnIsolate(String name, dynamic isolateHandler) async {
    try {
      String encryptionKey = ProxyService.box.encryptionKey();
      Business business = ProxyService.realm.realm!.query<Business>(
          r'id == $0', [ProxyService.box.getBusinessId()!]).first;

      EBM ebm = ProxyService.realm.realm!.query<EBM>(
          r'businessId == $0', [ProxyService.box.getBusinessId()!]).first;

      ReceivePort receivePort = ReceivePort();
      await Isolate.spawn(
        isolateHandler,
        [
          RootIsolateToken.instance,
          receivePort.sendPort,
          ProxyService.box.getBranchId()!,
          await ProxyService.realm.dbPath(path: 'fallback'),
          encryptionKey,
          business.tinNumber,
          ebm.bhfId
        ],
      );
    } catch (error) {}
  }
}
