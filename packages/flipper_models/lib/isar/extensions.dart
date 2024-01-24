import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime? {
  bool isNewDateCompareTo(DateTime? other) {
    if (this == null || other == null) return false;
    return this!.compareTo(other) > 0;
  }
}

extension ColorExtension on Color {
  String toHex() {
    return '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

extension IsarO<ID, OBJ> on IsarCollection<ID, OBJ> {
  OBJ? onGet(ID id) => getAll([id]).firstOrNull;

  /// this create a standard local update withour necessarily calling
  /// our sync service such as realm or firestore
  void onUpdate(OBJ object) {
    put(object);
  }

  void onPut(OBJ object) {
    put(object);

    ///TODO: re-enable this when cloud_firestore is stable
    /// https://github.com/firebase/flutterfire/issues/11933
    /// https://github.com/flutter/flutter/issues/134346
    if (!isWindows &&
        ProxyService.remoteConfig.isFirestoreEnabled() &&
        ProxyService.remoteConfig.isSyncAvailable()) {
      // if (object is Product) {
      //   ProxyService.syncFirestore.onSave<Product>(item: object);
      // }
      // if (object is Variant) {
      //   ProxyService.syncFirestore.onSave<Variant>(item: object);
      // }
      // if (object is Stock) {
      //   ProxyService.syncFirestore.onSave<Stock>(item: object);
      // }
      // if (object is Device) {
      //   ProxyService.syncFirestore.onSave<Device>(item: object);
      // }
      if (object is ITransaction) {
        ProxyService.syncFirestore.onSave<ITransaction>(item: object);
      }
      if (object is TransactionItem) {
        ProxyService.syncFirestore.onSave<TransactionItem>(item: object);
      }
      // if (object is Drawers) {
      //   ProxyService.syncFirestore.onSave<Drawers>(item: object);
      // }
      // if (object is IUnit) {
      //   ProxyService.syncFirestore.onSave<IUnit>(item: object);
      // }
    }
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      //await ProxyService.realm.configure();
      if (object is TransactionItem) {
        log(object.toJson().toString(), name: 'onPut');
        ProxyService.realm.onSave<TransactionItem>(item: object);
      }
      if (object is ITransaction) {
        log(object.toJson().toString(), name: 'onPut');
        ProxyService.realm.onSave<ITransaction>(item: object);
      }

      if (object is Product) {
        log(object.toJson().toString(), name: 'onPut');
        ProxyService.realm.onSave<Product>(item: object);
      }

      if (object is Stock) {
        log(object.toJson().toString(), name: 'onPut');
        ProxyService.realm.onSave<Stock>(item: object);
      }
      if (object is Variant) {
        log(object.toJson().toString(), name: 'onPut');
        ProxyService.realm.onSave<Variant>(item: object);
      }
      if (object is IUnit) {
        ProxyService.realm.onSave<IUnit>(item: object);
      }
      // ProxyService.realm.close();
    }
  }
}
