import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin EventMixin on DittoCore {
  /// Save an event to the events collection and replicate via Ditto Cloud.
  Future<void> saveEvent(Map<String, dynamic> eventData, String eventId) async {
    if (dittoInstance == null) return handleNotInitialized('saveEvent');
    final channel = _eventChannel(eventData, eventId);
    await ensureEventsChannelSubscription(channel);
    final flattened = _flattenEventData(eventData, eventId);
    await executeUpsert('events', eventId, flattened);
    debugPrint('Saved event with ID: $eventId (channel: $channel)');
  }

  /// Register replication for [channel] so cloud peers (e.g. desktop QR login)
  /// receive events published from a phone.
  Future<void> ensureEventsChannelSubscription(String channel) async {
    final ditto = dittoInstance;
    if (ditto == null || channel.isEmpty) return;

    final prepared = prepareDqlSyncSubscription(
      'SELECT * FROM events WHERE channel = :channel',
      {'channel': channel},
    );
    try {
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
    } catch (e) {
      debugPrint('ensureEventsChannelSubscription($channel): $e');
    }
  }

  String _eventChannel(Map<String, dynamic> eventData, String eventId) {
    final top = eventData['channel'];
    if (top is String && top.isNotEmpty) return top;
    if (eventData['data'] is Map<String, dynamic>) {
      final nested = (eventData['data'] as Map<String, dynamic>)['channel'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return eventId;
  }

  /// Get events for a specific channel and type
  Future<List<Map<String, dynamic>>> getEvents(
    String channel,
    String eventType,
  ) async {
    if (dittoInstance == null)
      return handleNotInitializedAndReturn('getEvents', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM events WHERE channel = :channel AND type = :eventType ORDER BY timestamp DESC",
      arguments: {"channel": channel, "eventType": eventType},
    );
    return result.items
        .map((doc) => Map<String, dynamic>.from(doc.value))
        .toList();
  }

  /// Helper method to flatten event data
  Map<String, dynamic> _flattenEventData(
    Map<String, dynamic> eventData,
    String eventId,
  ) {
    final Map<String, dynamic> flattened = {};
    flattened.addAll(eventData);
    if (eventData['data'] is Map<String, dynamic>) {
      flattened.addAll(Map<String, dynamic>.from(eventData['data']));
      flattened.remove('data');
    }
    flattened['timestamp'] = DateTime.now().toIso8601String();
    flattened['_id'] = eventId;
    // Keep the logical login/response channel from the payload — [eventId] may
    // be a unique doc id while [channel] is the QR session id desktop polls.
    flattened['channel'] = flattened['channel'] ?? eventId;
    return flattened;
  }
}
