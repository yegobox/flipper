import '../interfaces/analytics_event_store.dart';
import '../interfaces/analytics_transport.dart';
import '../models/pending_analytics_event.dart';

mixin OfflineFirstAnalyticsMixin {
  AnalyticsTransport get transport;
  AnalyticsEventStore get eventStore;

  /// Hands [event] to the SDK now, and queues it only when that fails.
  ///
  /// The SDK stamps the event as it takes it, so an event sent here carries
  /// the right time. On Android, iOS, macOS, Windows and Linux the SDK's
  /// capture does not throw (it keeps its own queue on disk, offline
  /// included), so this queue only holds web events from before posthog-js
  /// has loaded, and whatever older builds left behind. Those go out late,
  /// from flush, with their real time in a property.
  Future<void> sendOrQueue(PendingAnalyticsEvent event) async {
    try {
      await transport.send(event);
    } catch (_) {
      await eventStore.enqueue(event);
    }
  }
}
