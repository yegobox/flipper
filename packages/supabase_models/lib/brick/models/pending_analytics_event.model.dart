class PendingAnalyticsEventRecord {
  PendingAnalyticsEventRecord({
    required this.id,
    required this.eventName,
    required this.propertiesJson,
    required this.eventType,
    required this.createdAt,
    required this.attemptCount,
  });

  final String id;
  final String eventName;
  final String propertiesJson;
  final String eventType;
  final DateTime createdAt;
  final int attemptCount;
}
