import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/analytics_event_store.dart';
import '../models/pending_analytics_event.dart';

class SharedPreferencesAnalyticsEventStore implements AnalyticsEventStore {
  static const _prefsKey = 'pending_analytics_events';

  SharedPreferences? _prefs;

  @override
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> deleteByIds(List<String> ids) async {
    await initialize();
    final existing = await _loadAll();
    final filtered = existing
        .where((event) => !ids.contains(event.id))
        .toList();
    await _write(filtered);
  }

  @override
  Future<void> enqueue(PendingAnalyticsEvent event) async {
    await initialize();
    final existing = await _loadAll();
    existing.add(event);
    await _write(existing);
  }

  @override
  Future<void> incrementAttempts(String id) async {
    await initialize();
    final existing = await _loadAll();
    final updated = existing
        .map(
          (event) => event.id == id
              ? event.copyWith(attemptCount: event.attemptCount + 1)
              : event,
        )
        .toList();
    await _write(updated);
  }

  @override
  Future<List<PendingAnalyticsEvent>> peekBatch({int limit = 50}) async {
    await initialize();
    final events = await _loadAll();
    return events.take(limit).toList();
  }

  Future<List<PendingAnalyticsEvent>> _loadAll() async {
    final raw = _prefs?.getStringList(_prefsKey) ?? const [];
    final events = <PendingAnalyticsEvent>[];
    for (final value in raw) {
      try {
        events.add(
          PendingAnalyticsEvent.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          ),
        );
      } catch (e, st) {
        debugPrint('Skipping corrupted analytics event entry: $e\n$st');
      }
    }
    events.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return events;
  }

  Future<void> _write(List<PendingAnalyticsEvent> events) async {
    final encoded = events
        .map((event) => jsonEncode(event.toJson()))
        .toList(growable: false);
    await _prefs!.setStringList(_prefsKey, encoded);
  }
}
