import 'dart:convert';

import 'package:uuid/uuid.dart';

enum PendingAnalyticsEventType {
  capture,
  screen,
}

class PendingAnalyticsEvent {
  PendingAnalyticsEvent({
    String? id,
    required this.eventName,
    required this.properties,
    required this.type,
    DateTime? createdAt,
    this.attemptCount = 0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toUtc();

  final String id;
  final String eventName;
  final Map<String, Object?> properties;
  final PendingAnalyticsEventType type;
  final DateTime createdAt;
  final int attemptCount;

  PendingAnalyticsEvent copyWith({
    String? id,
    String? eventName,
    Map<String, Object?>? properties,
    PendingAnalyticsEventType? type,
    DateTime? createdAt,
    int? attemptCount,
  }) {
    return PendingAnalyticsEvent(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      properties: properties ?? this.properties,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'properties': properties,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'attemptCount': attemptCount,
    };
  }

  Map<String, Object?> toDbMap() {
    return {
      'id': id,
      'event_name': eventName,
      'properties_json': jsonEncode(properties),
      'event_type': type.name,
      'created_at': createdAt.toIso8601String(),
      'attempt_count': attemptCount,
    };
  }

  static PendingAnalyticsEvent fromJson(Map<String, dynamic> json) {
    return PendingAnalyticsEvent(
      id: json['id'] as String,
      eventName: json['eventName'] as String,
      properties: Map<String, Object?>.from(
        json['properties'] as Map? ?? const {},
      ),
      type: PendingAnalyticsEventType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      attemptCount: (json['attemptCount'] as num?)?.toInt() ?? 0,
    );
  }

  static PendingAnalyticsEvent fromDbMap(Map<String, Object?> map) {
    final encoded = map['properties_json']?.toString() ?? '{}';
    final decoded = jsonDecode(encoded);
    return PendingAnalyticsEvent(
      id: map['id'] as String,
      eventName: map['event_name'] as String,
      properties: decoded is Map<String, dynamic>
          ? Map<String, Object?>.from(decoded)
          : const {},
      type: PendingAnalyticsEventType.values.byName(
        map['event_type'] as String,
      ),
      createdAt: DateTime.parse(map['created_at'] as String).toUtc(),
      attemptCount: (map['attempt_count'] as num?)?.toInt() ?? 0,
    );
  }
}
