import '../interfaces/analytics_event_store.dart';
import '../interfaces/analytics_transport.dart';
import '../models/pending_analytics_event.dart';

mixin OfflineFirstAnalyticsMixin {
  AnalyticsTransport get transport;
  AnalyticsEventStore get eventStore;

  Future<void> sendOrQueue(PendingAnalyticsEvent event) async {
    try {
      await transport.send(event);
    } catch (_) {
      await eventStore.enqueue(event);
    }
  }
}
