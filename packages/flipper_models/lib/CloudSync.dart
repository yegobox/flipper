import 'package:flipper_models/power_sync/powersync.dart';
import 'package:flipper_models/helper_models.dart' as ext;
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
// ignore: unused_import
import 'dart:async';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/realm_model_export.dart';

abstract class SyncInterface {
  Future<void> handleChanges<T>({
    required RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
  });
  Future<void> deleteRecord(String tableName, String idField, int id);
  Future<void> updateRecord(
      String tableName, String idField, Map<String, dynamic> map, int id);
  void listen();
  SyncInterface instance();
  Future<void> watchTable<T extends RealmObject>({
    required String tableName,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
  });
}

class CloudSync implements SyncInterface {
  final Set<int> _processingIds = {};

  @override
  SyncInterface instance() {
    return this;
  }

  @override
  Future<void> handleChanges<T>({
    required RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
  }) async {
    results.changes.listen(
      (changes) async {
        for (var obj in changes.modified) {
          final modifiedItem = results[obj];
          final id = getId(modifiedItem);

          // Skip if this ID is currently being processed by watchTable
          if (_processingIds.contains(id)) continue;

          final item = await db.getOptional(
            'SELECT * FROM $tableName WHERE $idField = ?',
            [id],
          );

          if (item != null) {
            try {
              Map<String, dynamic> map = convertToMap(modifiedItem);
              preProcessMap(map);

              bool hasChanges = compareChanges(item, map);

              if (hasChanges) {
                await updateRecord(tableName, idField, map, id);
              }
            } catch (e, s) {
              print(e);
              print(s);
            }
          }
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
      onError: (error) {
        print('Error occurred while listening to changes: $error');
      },
    );
  }

  @override
  Future<void> deleteRecord(String tableName, String idField, int id) async {
    await db.execute(
      'DELETE FROM $tableName WHERE $idField = ?',
      [id],
    );
  }

  @override
  Future<void> updateRecord(String tableName, String idField,
      Map<String, dynamic> map, int id) async {
    final keysToUpdate =
        map.keys.map((key) => '${camelToSnakeCase(key)} = ?').join(', ');
    final valuesToUpdate = map.values.toList();

    await db.execute(
      'UPDATE $tableName SET $keysToUpdate WHERE $idField = ?',
      [...valuesToUpdate, id],
    );
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
    bool useWatch = false, // ... existing code ...
  }) async {
    try {
      if (useWatch) {
        final changes =
            await db.watch('SELECT * FROM $tableName ORDER BY created_at DESC');
        changes.listen((data) {
          for (var item in data) {
            final id = item[idField];

            // Add this ID to the processing set
            _processingIds.add(id);

            // Find existing object or create a new one
            var realmObject =
                ProxyService.local.realm!.query<T>('id == $id').firstOrNull;
            if (realmObject == null) {
              realmObject = createRealmObject(item);
              ProxyService.local.realm!.add<T>(realmObject);
            } else {
              updateRealmObject(realmObject, item);
            }

            // Remove this ID from the processing set after a short delay
            Future.delayed(Duration(seconds: 2), () {
              _processingIds.remove(id);
            });
          }
        });
      } else {
        final results = await db
            .execute('SELECT * FROM $tableName ORDER BY created_at DESC');
        for (var data in results) {
          final id = data[idField];

          // Add this ID to the processing set
          _processingIds.add(id);

          // Find existing object or create a new one
          var realmObject =
              ProxyService.local.realm!.query<T>('id == $id').firstOrNull;
          if (realmObject == null) {
            realmObject = createRealmObject(data);
            ProxyService.local.realm!.add<T>(realmObject);
          } else {
            updateRealmObject(realmObject, data);
          }

          // Remove this ID from the processing set after a short delay
          Future.delayed(Duration(seconds: 2), () {
            _processingIds.remove(id);
          });
        }
      }
    } catch (e, s) {
      talker.error(s);
    }
  }

  @override
  void listen() {
    ///watchers for upload

    handleChanges<Stock>(
      results: ProxyService.local.realm!.all<Stock>(),
      tableName: 'stocks',
      idField: 'stock_id',
      getId: (stock) => stock.id!,
      convertToMap: (stock) => stock.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('variant');
        map['stock_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Product>(
      results: ProxyService.local.realm!.all<Product>(),
      tableName: 'products',
      idField: 'product_id',
      getId: (product) => product.id!,
      convertToMap: (product) => product.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('composites');
        map['product_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Variant>(
      results: ProxyService.local.realm!.all<Variant>(),
      tableName: 'variants',
      idField: 'variant_id',
      getId: (variant) => variant.id!,
      convertToMap: (variant) => variant.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map.remove('branchIds');
        map['variant_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );

    handleChanges<Counter>(
      results: ProxyService.local.realm!.all<Counter>(),
      tableName: 'counters',
      idField: 'counter_id',
      getId: (counter) => counter.id!,
      convertToMap: (counter) => counter.toEJson().toFlipperJson(),
      preProcessMap: (map) {
        map['counter_id'] = map['id'];
        map.remove('id');
        map.remove('_id');
      },
    );
  }
}
