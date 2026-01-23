import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart' hide Category;

/// Base class that provides core Ditto functionality
class DittoCore {
  /// The Ditto instance, accessible to mixins
  Ditto? _ditto;

  /// Sets the Ditto instance (called from main.dart after initialization)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
  }

  /// Get the Ditto instance (for use by cache implementations)
  Ditto? get dittoInstance => _ditto;

  /// Get the Ditto store for direct access to Ditto operations
  Store? get store => _ditto?.store;

  /// Checks if Ditto is properly initialized and ready to use
  bool isReady() {
    return _ditto != null;
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

  /// Helper method to execute upsert operation
  Future<void> executeUpsert(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await dittoInstance!.store.execute(
      "INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE",
      arguments: {
        "data": {"_id": docId, ...data},
      },
    );
  }

  /// Helper method to execute update operation
  Future<void> executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    await dittoInstance!.store.execute(
      "UPDATE $collection SET $fields WHERE _id = :id",
      arguments: {"id": docId, ...data},
    );
  }
}
