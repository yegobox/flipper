import '../models/pending_analytics_event.dart';

abstract class AnalyticsEventStore {
  Future<void> initialize();

  Future<void> enqueue(PendingAnalyticsEvent event);

  Future<List<PendingAnalyticsEvent>> peekBatch({int limit = 50});

  Future<void> deleteByIds(List<String> ids);

  Future<void> incrementAttempts(String id);
}
