import 'dart:async';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';

/// Coordinates two-way synchronisation between Ditto and OfflineFirst models.
class DittoSyncCoordinator {
  DittoSyncCoordinator._internal();

  static final DittoSyncCoordinator instance = DittoSyncCoordinator._internal();

  final Map<Type, DittoSyncAdapter> _adapters = {};
  final Map<Type, dynamic> _observers = {};
  final Map<Type, Set<String>> _suppressedIds = {};
  Ditto? _ditto;
  bool _isObserving = false;

  /// Set the Ditto instance to be used for sync operations.
  /// Passing `null` tears down existing observers.
  Future<void> setDitto(Ditto? ditto) async {
    if (_ditto == ditto) {
      return;
    }

    await _disposeObservers();
    _ditto = ditto;

    if (_ditto != null) {
      await _startObservers();
    }
  }

  /// Registers an adapter. If Ditto is already available the observation will
  /// start immediately.
  Future<void> registerAdapter<T extends OfflineFirstWithSupabaseModel>(
    DittoSyncAdapter<T> adapter,
  ) async {
    final type = T;
    if (_adapters.containsKey(type)) {
      return;
    }

    _adapters[type] = adapter;
    _suppressedIds.putIfAbsent(type, () => <String>{});

    if (_ditto != null) {
      await _startObserverFor(type);
    }
  }

  /// Unregisters an adapter and cancels its observation if running.
  Future<void>
      unregisterAdapter<T extends OfflineFirstWithSupabaseModel>() async {
    final type = T;
    await _stopObserverFor(type);
    _adapters.remove(type);
    _suppressedIds.remove(type);
  }

  /// Should be invoked when a model is upserted locally so the change can be
  /// written to Ditto.
  Future<void> notifyLocalUpsert<T extends OfflineFirstWithSupabaseModel>(
      T model) async {
    final adapter = _adapters[T];
    final ditto = _ditto;
    if (adapter == null || ditto == null) {
      return;
    }

    final docId = await adapter.documentIdForModel(model);
    if (docId == null) {
      return;
    }

    if (_suppressedIds[T]?.remove(docId) == true) {
      // Skip feedback loops caused by remote upserts.
      return;
    }

    try {
      final document = await adapter.toDittoDocument(model);
      await ditto.store.execute(
        'INSERT INTO ${adapter.collectionName} DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {
          'doc': {'_id': docId, ...document},
        },
      );
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto upsert failed for $T ($docId): $error\n$stack');
      }
    }
  }

  /// Should be invoked when a model is deleted locally so it is removed from
  /// Ditto as well.
  Future<void> notifyLocalDelete<T extends OfflineFirstWithSupabaseModel>(
      T model) async {
    final adapter = _adapters[T];
    final ditto = _ditto;
    if (adapter == null || ditto == null) {
      return;
    }

    final docId = await adapter.documentIdForModel(model);
    if (docId == null) {
      return;
    }

    try {
      await ditto.store.execute(
        'REMOVE FROM COLLECTION ${adapter.collectionName} WHERE _id = :id',
        arguments: {'id': docId},
      );
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto delete failed for $T ($docId): $error\n$stack');
      }
    }
  }

  Future<void> _startObservers() async {
    if (_isObserving || _ditto == null) {
      return;
    }
    _isObserving = true;

    for (final type in _adapters.keys.toList()) {
      await _startObserverFor(type);
    }
  }

  Future<void> _startObserverFor(Type type) async {
    final adapter = _adapters[type];
    final ditto = _ditto;
    if (adapter == null || ditto == null) {
      return;
    }

    final query = await adapter.buildObserverQuery();
    if (query == null) {
      return;
    }

    await _observers[type]?.cancel();

    final observer = ditto.store.registerObserver(
      query.query,
      arguments: query.arguments,
      onChange: (result) => _handleQueryResult(type, result),
    );

    _observers[type] = observer;

    try {
      final initial =
          await ditto.store.execute(query.query, arguments: query.arguments);
      await _handleQueryResult(type, initial);
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto initial fetch failed for $type: $error\n$stack');
      }
    }
  }

  Future<void> _handleQueryResult(Type type, dynamic result) async {
    final adapter = _adapters[type];
    if (adapter == null) {
      return;
    }

    final dynamic itemsDynamic = result.items;
    if (itemsDynamic == null) {
      return;
    }

    final Iterable<dynamic> items = itemsDynamic as Iterable<dynamic>;
    for (final item in items) {
      final payload =
          Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>);
      if (await adapter.shouldApplyRemote(payload)) {
        final model = await adapter.fromDittoDocument(payload);
        if (model != null) {
          final docId = await adapter.documentIdFromRemote(payload);
          if (docId != null) {
            _suppressedIds[type]?.add(docId);
          }
          try {
            if (kDebugMode) {
              debugPrint('🔄 Upserting $type from Ditto: ${model.runtimeType}');
            }
            // Use the adapter to upsert with correct type parameter
            await adapter.upsertToRepository(model);
            if (kDebugMode) {
              debugPrint('✅ Successfully upserted $type from Ditto');
            }
          } catch (error, stack) {
            if (kDebugMode) {
              debugPrint('Local upsert failed for Ditto change on $type: '
                  '$error\n$stack');
            }
            if (docId != null) {
              _suppressedIds[type]?.remove(docId);
            }
          }
        }
      }
    }
  }

  Future<void> _stopObserverFor(Type type) async {
    await _observers[type]?.cancel();
    _observers.remove(type);
  }

  Future<void> _disposeObservers() async {
    for (final observer in _observers.values) {
      await observer.cancel();
    }
    _observers.clear();
    _isObserving = false;
  }
}
