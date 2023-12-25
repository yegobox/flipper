import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  bool isFutureDateCompareTo(DateTime? other) {
    if (other == null) return false;
    return compareTo(other) > 0;
  }
}

extension NullableDateTimeExtensions on DateTime? {
  bool isFutureDateCompareTo(DateTime? other) {
    if (this == null) return false;
    return this!.isFutureDateCompareTo(other);
  }
}

extension ColorExtension on Color {
  String toHex() {
    return '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

extension IsarO<ID, OBJ> on IsarCollection<ID, OBJ> {
  void onPut(OBJ object) {
    put(object);

    ///TODO: re-enable this when cloud_firestore is stable
    /// https://github.com/firebase/flutterfire/issues/11933
    if (!isWindows) {
      if (object is Product) {
        ProxyService.syncFirestore.onSave<Product>(item: object);
      }
      if (object is Variant) {
        ProxyService.syncFirestore.onSave<Variant>(item: object);
      }
      if (object is Stock) {
        ProxyService.syncFirestore.onSave<Stock>(item: object);
      }
      if (object is Device) {
        ProxyService.syncFirestore.onSave<Device>(item: object);
      }
      if (object is ITransaction) {
        ProxyService.syncFirestore.onSave<ITransaction>(item: object);
      }
      if (object is TransactionItem) {
        ProxyService.syncFirestore.onSave<TransactionItem>(item: object);
      }
      if (object is Drawers) {
        ProxyService.syncFirestore.onSave<Drawers>(item: object);
      }
    }
    if (object is TransactionItem) {
      ProxyService.realm.onSave<TransactionItem>(item: object);
    }
    if (object is ITransaction) {
      ProxyService.realm.onSave<ITransaction>(item: object);
    }

    if (object is Product) {
      ProxyService.realm.onSave<Product>(item: object);
    }

    if (object is Stock) {
      ProxyService.realm.onSave<Stock>(item: object);
    }
    if (object is Variant) {
      ProxyService.realm.onSave<Variant>(item: object);
    }
  }
}
