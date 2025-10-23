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
  final Map<Type, SyncSubscription> _subscriptions = {};
  final Map<Type, Set<String>> _suppressedIds = {};
  final Map<Type, Map<String, int>> _documentHashes = {};
  Ditto? _ditto;
  bool _isObserving = false;
  bool _skipInitialFetch = false;
  Timer? _upsertDebouncer;

  /// Set the Ditto instance to be used for sync operations.
  /// Passing `null` tears down existing observers.
  Future<void> setDitto(Ditto? ditto, {bool skipInitialFetch = false}) async {
    if (_ditto == ditto) {
      return;
    }

    await _disposeObservers();
    _ditto = ditto;
    _skipInitialFetch = skipInitialFetch;

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
    _documentHashes.putIfAbsent(type, () => <String, int>{});

    if (_ditto != null) {
      await _startObserverFor(type);
    }
  }

  /// Restores remote data for the provided generic type using the adapter's
  /// backup pull configuration. Returns the number of records upserted.
  Future<int> pullBackupFor<T extends OfflineFirstWithSupabaseModel>({
    bool includeDependencies = true,
  }) async {
    return _pullBackupForType(
      T,
      includeDependencies: includeDependencies,
    );
  }

  /// Restores remote data for all adapters that support backup pulls. Returns
  /// a map of restored counts keyed by the adapter type.
  Future<Map<Type, int>> pullBackupForAll({
    List<Type>? types,
    bool includeDependencies = true,
  }) async {
    final selectedTypes = types ??
        _adapters.entries
            .where((entry) => entry.value.supportsBackupPull)
            .map((entry) => entry.key)
            .toList();

    final results = <Type, int>{};
    for (final type in selectedTypes) {
      results[type] = await _pullBackupForType(
        type,
        includeDependencies: includeDependencies,
      );
    }
    return results;
  }

  /// Unregisters an adapter and cancels its observation if running.
  Future<void>
      unregisterAdapter<T extends OfflineFirstWithSupabaseModel>() async {
    final type = T;
    await _stopObserverFor(type);
    _adapters.remove(type);
    _suppressedIds.remove(type);
    _documentHashes.remove(type);
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
    debugPrint('DittoSyncCoordinator: notifyLocalUpsert for $T ($docId)');
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
      //
      await ditto.store.execute(
        'DELETE FROM ${adapter.collectionName} WHERE _id = :id',
        arguments: {'id': docId},
      );
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto delete failed for $T ($docId): $error\n$stack');
      }
    }
  }

  /// Performs a one-off hydration for the adapter associated with [T].
  ///
  /// This executes the adapter's [DittoSyncAdapter.buildHydrationQuery] and
  /// feeds the results through the normal observation pipeline as an initial
  /// fetch. If the adapter or Ditto instance is unavailable, the call is a
  /// no-op.
  Future<void> hydrate<T extends OfflineFirstWithSupabaseModel>() async {
    // Skip hydration if initial fetch is disabled (startup optimization)
    if (_skipInitialFetch) {
      if (kDebugMode) {
        debugPrint(
            '⏭️  Skipping manual hydration for $T (skipInitialFetch enabled)');
      }
      return;
    }

    final adapter = _adapters[T];
    final ditto = _ditto;
    if (adapter == null || ditto == null) {
      return;
    }

    try {
      final query = await adapter.buildHydrationQuery();
      if (query == null) {
        if (kDebugMode) {
          debugPrint('Ditto hydration skipped for $T (null query).');
        }
        return;
      }

      final result =
          await ditto.store.execute(query.query, arguments: query.arguments);
      await _handleQueryResult(T, result, isInitialFetch: true);
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto hydration failed for $T: $error\n$stack');
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

    try {
      _subscriptions[type]?.cancel();
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint(
            'Ditto subscription cancel failed for $type: $error\n$stack');
      }
    }

    try {
      final subscription = ditto.sync.registerSubscription(
        query.query,
        arguments: query.arguments,
      );
      _subscriptions[type] = subscription;
      if (kDebugMode) {
        debugPrint('📡 Registered Ditto subscription for $type');
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint(
            '❌ Failed to register Ditto subscription for $type: $error\n$stack');
      }
    }

    final observer = ditto.store.registerObserver(
      query.query,
      arguments: query.arguments,
      onChange: (result) => _handleQueryResult(type, result),
    );

    _observers[type] = observer;

    // Only fetch initial data if not skipping (e.g., on app startup we skip)
    if (!_skipInitialFetch) {
      try {
        final initial =
            await ditto.store.execute(query.query, arguments: query.arguments);
        await _handleQueryResult(type, initial, isInitialFetch: true);
      } catch (error, stack) {
        if (kDebugMode) {
          debugPrint('Ditto initial fetch failed for $type: $error\n$stack');
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            '⏭️  Skipping Ditto initial fetch for $type (startup optimization)');
      }

      if (!_skipInitialFetch && adapter.shouldHydrateOnStartup) {
        try {
          final hydrationQuery = await adapter.buildHydrationQuery();
          if (hydrationQuery != null) {
            if (kDebugMode) {
              debugPrint(
                  '💧 Performing manual Ditto hydration for $type using ${hydrationQuery.query}');
            }
            final hydration = await ditto.store.execute(hydrationQuery.query,
                arguments: hydrationQuery.arguments);
            await _handleQueryResult(type, hydration, isInitialFetch: true);
          } else if (kDebugMode) {
            debugPrint(
                'ℹ️  Adapter for $type opted into hydration but returned null query.');
          }
        } catch (error, stack) {
          if (kDebugMode) {
            debugPrint('❌ Ditto hydration failed for $type: $error\n$stack');
          }
        }
      }
    }
  }

  Future<void> _handleQueryResult(
    Type type,
    dynamic result, {
    bool isInitialFetch = false,
  }) async {
    // Skip processing if initial fetch is disabled (startup optimization)
    if (_skipInitialFetch) {
      if (kDebugMode) {
        debugPrint(
            '⏭️  Skipping query result processing for $type (skipInitialFetch enabled)');
      }
      return;
    }

    final adapter = _adapters[type];
    if (adapter == null) {
      return;
    }

    final itemsDynamic = result.items as Iterable<dynamic>?;
    if (itemsDynamic == null) {
      return;
    }

    final Iterable<dynamic> items = itemsDynamic;
    final List<Future<void>> upsertTasks = [];

    for (final item in items) {
      final payload =
          Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>);

      final docId = await adapter.documentIdFromRemote(payload);
      if (docId == null) continue;

      // Calculate hash of the document to detect actual changes
      final currentHash = _calculateHash(payload);
      final previousHash = _documentHashes[type]?[docId];

      // Skip if document hasn't changed (unless it's initial fetch)
      if (!isInitialFetch && previousHash == currentHash) {
        if (kDebugMode) {
          // debugPrint('⏭️  Skipping unchanged $type document: $docId');
        }
        continue;
      }

      // Store new hash
      _documentHashes[type]?[docId] = currentHash;

      if (await adapter.shouldApplyRemote(payload)) {
        final model = await adapter.fromDittoDocument(payload);
        if (model != null) {
          _suppressedIds[type]?.add(docId);

          // Add to batch instead of executing immediately
          upsertTasks.add(_performUpsert(type, model, docId, adapter));
        }
      }
    }

    // Process upserts in batches to avoid database locking
    if (upsertTasks.isNotEmpty) {
      await _processBatchedUpserts(upsertTasks, type);
    }
  }

  Future<void> _performUpsert(
    Type type,
    dynamic model,
    String docId,
    DittoSyncAdapter adapter,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Upserting $type from Ditto: $docId');
      }
      await adapter.upsertToRepository(model);
      if (kDebugMode) {
        debugPrint('✅ Successfully upserted $type from Ditto: $docId');
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('❌ Local upsert failed for Ditto change on $type: '
            '$error\n$stack');
      }
      _suppressedIds[type]?.remove(docId);
    }
  }

  Future<void> _processBatchedUpserts(
    List<Future<void>> upsertTasks,
    Type type,
  ) async {
    if (kDebugMode) {
      debugPrint('📦 Processing ${upsertTasks.length} upserts for $type');
    }

    // Process in small batches with delays to prevent database locking
    const batchSize = 5;
    const delayBetweenBatches = Duration(milliseconds: 100);

    for (var i = 0; i < upsertTasks.length; i += batchSize) {
      final end = (i + batchSize < upsertTasks.length)
          ? i + batchSize
          : upsertTasks.length;
      final batch = upsertTasks.sublist(i, end);

      await Future.wait(batch);

      // Add delay between batches
      if (end < upsertTasks.length) {
        await Future.delayed(delayBetweenBatches);
      }
    }

    if (kDebugMode) {
      debugPrint('✅ Completed batch processing for $type');
    }
  }

  /// Simple hash function for change detection
  int _calculateHash(Map<String, dynamic> document) {
    // Remove _id from hash calculation as it's not part of the content
    final docCopy = Map<String, dynamic>.from(document);
    docCopy.remove('_id');
    return docCopy.toString().hashCode;
  }

  Future<void> _stopObserverFor(Type type) async {
    await _observers[type]?.cancel();
    _observers.remove(type);

    _subscriptions[type]?.cancel();
    _subscriptions.remove(type);
  }

  Future<void> _disposeObservers() async {
    _upsertDebouncer?.cancel();
    _upsertDebouncer = null;

    for (final observer in _observers.values) {
      await observer.cancel();
    }
    _observers.clear();

    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _isObserving = false;
  }

  Future<int> _pullBackupForType(
    Type type, {
    required bool includeDependencies,
  }) async {
    final adapter = _adapters[type];
    final ditto = _ditto;
    if (adapter == null) {
      if (kDebugMode) {
        debugPrint('No Ditto adapter registered for $type; skipping backup.');
      }
      return 0;
    }

    if (ditto == null) {
      throw StateError('Ditto instance not set. Call setDitto before pulling.');
    }

    if (!adapter.supportsBackupPull) {
      if (kDebugMode) {
        debugPrint('Adapter for $type does not support backup pull.');
      }
      return 0;
    }

    final query = await adapter.buildBackupPullQuery();
    if (query == null) {
      if (kDebugMode) {
        debugPrint('Adapter for $type returned null backup query.');
      }
      return 0;
    }

    try {
      final result = await ditto.store.execute(
        query.query,
        arguments: query.arguments,
      );

      final itemsDynamic = result.items as Iterable<dynamic>?;
      if (itemsDynamic == null) {
        return 0;
      }

      final items = itemsDynamic;
      final visited = <_BackupKey>{};
      var restored = 0;

      for (final item in items) {
        final document =
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>);
        final didRestore = await _restoreDocument(
          type: type,
          document: document,
          includeDependencies: includeDependencies,
          visited: visited,
        );
        if (didRestore) {
          restored++;
        }
      }

      return restored;
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto backup pull failed for $type: $error\n$stack');
      }
      return 0;
    }
  }

  Future<bool> _restoreDocument({
    required Type type,
    required Map<String, dynamic> document,
    required bool includeDependencies,
    required Set<_BackupKey> visited,
  }) async {
    final adapter = _adapters[type];
    if (adapter == null) {
      return false;
    }

    final docId = await adapter.documentIdFromRemote(document);
    if (docId == null) {
      return false;
    }

    final model = await adapter.fromDittoDocument(document);
    if (model == null) {
      return false;
    }

    await adapter.onBackupModelRestored(model, document);
    await adapter.upsertToRepository(model);

    if (!includeDependencies) {
      return true;
    }

    for (final link in adapter.backupLinks) {
      final identifier = document[link.field];
      if (identifier == null) {
        continue;
      }

      final idString =
          identifier is String ? identifier : identifier.toString();
      if (idString.isEmpty) {
        continue;
      }

      final depKey = _BackupKey(link.targetType, idString);
      if (!visited.add(depKey)) {
        continue;
      }

      await _restoreDependency(
        type: link.targetType,
        identifier: idString,
        remoteKey: link.remoteKey,
        includeDependencies: link.cascade,
        visited: visited,
      );
    }

    return true;
  }

  Future<void> _restoreDependency({
    required Type type,
    required String identifier,
    required String remoteKey,
    required bool includeDependencies,
    required Set<_BackupKey> visited,
  }) async {
    final adapter = _adapters[type];
    final ditto = _ditto;
    if (adapter == null || ditto == null) {
      if (kDebugMode) {
        debugPrint('Missing adapter or Ditto instance for dependency $type.');
      }
      return;
    }

    final queries = <DittoSyncQuery>[
      DittoSyncQuery(
        query: 'SELECT * FROM ${adapter.collectionName} WHERE $remoteKey = :id',
        arguments: {'id': identifier},
      ),
    ];

    if (remoteKey != '_id') {
      queries.add(
        DittoSyncQuery(
          query: 'SELECT * FROM ${adapter.collectionName} WHERE _id = :id',
          arguments: {'id': identifier},
        ),
      );
    }

    Map<String, dynamic>? document;

    for (final query in queries) {
      try {
        final result = await ditto.store.execute(
          query.query,
          arguments: query.arguments,
        );
        final itemsDynamic = result.items as Iterable<dynamic>?;
        if (itemsDynamic == null) {
          continue;
        }

        final items = itemsDynamic;
        if (items.isEmpty) {
          continue;
        }

        document = Map<String, dynamic>.from(
            items.first.value as Map<dynamic, dynamic>);
        break;
      } catch (error, stack) {
        if (kDebugMode) {
          debugPrint(
            'Ditto dependency fetch failed for $type ($identifier): '
            '$error\n$stack',
          );
        }
      }
    }

    if (document == null) {
      return;
    }

    await _restoreDocument(
      type: type,
      document: document,
      includeDependencies: includeDependencies,
      visited: visited,
    );
  }
}

class _BackupKey {
  const _BackupKey(this.type, this.id);

  final Type type;
  final String id;

  @override
  bool operator ==(Object other) {
    return other is _BackupKey && other.type == type && other.id == id;
  }

  @override
  int get hashCode => Object.hash(type, id);
}
