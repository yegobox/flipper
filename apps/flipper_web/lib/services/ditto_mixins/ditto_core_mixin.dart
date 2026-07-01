import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/ditto/ditto_cloud_write.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flutter/foundation.dart' hide Category;

/// Base class that provides core Ditto functionality
class DittoCore {
  /// The Ditto instance, accessible to mixins
  Ditto? _ditto;

  /// Sets the Ditto instance (called from main.dart after initialization)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
  }

  /// Drops the cached instance without closing it (caller must [Ditto.close] first).
  void clearDittoReference() {
    _ditto = null;
  }

  /// Get the Ditto instance (for use by cache implementations)
  Ditto? get dittoInstance => _ditto;

  /// Get the Ditto store for direct access to Ditto operations
  Store? get store => _ditto?.store;

  /// Ditto client is open (local reads/writes possible).
  bool isReady() => _ditto != null;

  /// Authenticated and syncing — required for writes that must reach Ditto Cloud.
  bool isCloudReady() {
    final ditto = _ditto;
    if (ditto == null) return false;
    try {
      return DittoSingleton.isAuthenticated(ditto) && ditto.sync.isActive;
    } catch (_) {
      return false;
    }
  }

  /// Helper method to handle not initialized case
  void handleNotInitialized(String methodName) {
    debugPrint('Ditto not initialized, cannot $methodName');
  }

  /// Helper method to handle not initialized case and return a value
  T handleNotInitializedAndReturn<T>(String methodName, T defaultValue) {
    debugPrint('Ditto not initialized, cannot $methodName');
    return defaultValue;
  }

  /// Upsert into the local Ditto store without requiring cloud auth/sync.
  ///
  /// Used for `user_access` during PIN login ([loginFastPath]) so Login Choices
  /// can read fresh `/v2/api/user` data before replication starts.
  Future<void> executeUpsertLocal(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final ditto = dittoInstance;
    if (ditto == null) {
      handleNotInitialized('executeUpsertLocal');
      throw StateError('Ditto not initialized');
    }

    try {
      await ditto.store.execute(
        'INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE',
        arguments: {
          'data': {'_id': docId, ...data},
        },
      );
    } catch (e, st) {
      debugPrint(
        'Error executing local upsert ($collection/$docId): $e\n$st',
      );
      rethrow;
    }

    if (kIsWeb) {
      final visible = await waitForDittoDocumentLocal(
        ditto: ditto,
        collection: collection,
        docId: docId,
        timeout: const Duration(seconds: 15),
      );
      if (!visible) {
        debugPrint(
          '[Ditto] local upsert($collection/$docId) — DQL read-back not yet visible '
          '(WASM eventual consistency; write was not rejected)',
        );
      }
    }
  }

  /// Upsert a document and replicate to Ditto Cloud when connected.
  Future<void> executeUpsert(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final ditto = dittoInstance;
    if (ditto == null) {
      handleNotInitialized('executeUpsert');
      throw StateError('Ditto not initialized');
    }

    await ensureDittoCloudWriteReady(ditto);

    try {
      await ditto.store.execute(
        'INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE',
        arguments: {
          'data': {'_id': docId, ...data},
        },
      );
    } catch (e, st) {
      debugPrint('Error executing upsert ($collection/$docId): $e\n$st');
      rethrow;
    }

    // dart2wasm: INSERT can succeed before SELECT sees the row. Never fail the
    // write on a follow-up read — Safari/js and Chrome/wasm timing differs.
    if (kIsWeb) {
      final visible = await waitForDittoDocumentLocal(
        ditto: ditto,
        collection: collection,
        docId: docId,
        timeout: const Duration(seconds: 15),
      );
      if (!visible) {
        debugPrint(
          '[Ditto] upsert($collection/$docId) — DQL read-back not yet visible '
          '(WASM eventual consistency; write was not rejected)',
        );
      }
    }
  }

  /// Removes a document from a Ditto collection.
  Future<void> executeRemove(String collection, String docId) async {
    if (dittoInstance == null) return handleNotInitialized('executeRemove');
    try {
      await dittoInstance!.store.execute(
        'EVICT FROM $collection WHERE _id = :id',
        arguments: {'id': docId},
      );
    } catch (e) {
      debugPrint('Error executing remove: $e');
    }
  }

  /// Helper method to execute update operation
  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final ditto = dittoInstance;
    if (ditto == null) {
      handleNotInitialized('executeUpdate');
      throw StateError('Ditto not initialized');
    }

    await ensureDittoCloudWriteReady(ditto);

    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    try {
      await ditto.store.execute(
        'UPDATE $collection SET $fields WHERE _id = :id',
        arguments: {'id': docId, ...data},
      );
    } catch (e, st) {
      debugPrint('Error executing update ($collection/$docId): $e\n$st');
      rethrow;
    }
  }

  /// Conditional update — returns whether any document matched.
  Future<bool> executeUpdateWhere(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    required String extraWhere,
    Map<String, dynamic> extraArgs = const {},
  }) async {
    final ditto = dittoInstance;
    if (ditto == null) {
      handleNotInitialized('executeUpdateWhere');
      throw StateError('Ditto not initialized');
    }

    await ensureDittoCloudWriteReady(ditto);

    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    try {
      final result = await ditto.store.execute(
        'UPDATE $collection SET $fields WHERE _id = :id AND ($extraWhere)',
        arguments: {'id': docId, ...data, ...extraArgs},
      );
      return result.mutatedDocumentIDs().isNotEmpty;
    } catch (e, st) {
      debugPrint(
        'Error executing conditional update ($collection/$docId): $e\n$st',
      );
      rethrow;
    }
  }
}
