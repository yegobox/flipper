
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin EventMixin on DittoCore {
  /// Save an event to the events collection
  Future<void> saveEvent(Map<String, dynamic> eventData, String eventId) async {
    if (dittoInstance == null) return _handleNotInitialized('saveEvent');
    final flattened = _flattenEventData(eventData, eventId);
    await _executeUpsert('events', eventId, flattened);
    debugPrint('Saved event with ID: $eventId');
  }

  /// Get events for a specific channel and type
  Future<List<Map<String, dynamic>>> getEvents(
    String channel,
    String eventType,
  ) async {
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getEvents', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM events WHERE channel = :channel AND type = :eventType ORDER BY timestamp DESC",
      arguments: {"channel": channel, "eventType": eventType},
    );
    return result.items
        .map((doc) => Map<String, dynamic>.from(doc.value))
        .toList();
  }

  /// Helper method to flatten event data
  Map<String, dynamic> _flattenEventData(Map<String, dynamic> eventData, String eventId) {
    final Map<String, dynamic> flattened = {};
    flattened.addAll(eventData);
    if (eventData['data'] is Map<String, dynamic>) {
      flattened.addAll(Map<String, dynamic>.from(eventData['data']));
      flattened.remove('data');
    }
    flattened['timestamp'] = DateTime.now().toIso8601String();
    flattened['_id'] = eventId;
    flattened['channel'] = eventId;
    return flattened;
  }

  /// Helper method to handle not initialized case
  void _handleNotInitialized(String methodName) {
    debugPrint('Ditto not initialized, cannot $methodName');
  }

  /// Helper method to handle not initialized case and return a value
  T _handleNotInitializedAndReturn<T>(String methodName, T defaultValue) {
    debugPrint('Ditto not initialized, cannot $methodName');
    return defaultValue;
  }

  /// Helper method to execute upsert operation
  Future<void> _executeUpsert(String collection, String docId, Map<String, dynamic> data) async {
    await dittoInstance!.store.execute(
      "INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE",
      arguments: {
        "data": {"_id": docId, ...data},
      },
    );
  }
}