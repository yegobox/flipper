import 'dart:convert';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:supabase_models/brick/models/pending_analytics_event.model.dart';
import 'package:supabase_models/brick/repository.dart';

class RepositoryAnalyticsEventStore implements AnalyticsEventStore {
  RepositoryAnalyticsEventStore({Repository? repository})
      : _repository = repository ?? Repository();

  final Repository _repository;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> deleteByIds(List<String> ids) {
    return _repository.deleteAnalyticsEvents(ids);
  }

  @override
  Future<void> enqueue(PendingAnalyticsEvent event) {
    return _repository.enqueueAnalyticsEvent(
      PendingAnalyticsEventRecord(
        id: event.id,
        eventName: event.eventName,
        propertiesJson: jsonEncode(event.properties),
        eventType: event.type.name,
        createdAt: event.createdAt,
        attemptCount: event.attemptCount,
      ),
    );
  }

  @override
  Future<void> incrementAttempts(String id) {
    return _repository.incrementAnalyticsEventAttempt(id);
  }

  @override
  Future<List<PendingAnalyticsEvent>> peekBatch({int limit = 50}) async {
    final rows = await _repository.getPendingAnalyticsEvents(limit: limit);
    return rows
        .map(
          (row) => PendingAnalyticsEvent(
            id: row.id,
            eventName: row.eventName,
            properties: Map<String, Object?>.from(
              jsonDecode(row.propertiesJson) as Map<String, dynamic>,
            ),
            type: PendingAnalyticsEventType.values.byName(row.eventType),
            createdAt: row.createdAt,
            attemptCount: row.attemptCount,
          ),
        )
        .toList(growable: false);
  }
}
