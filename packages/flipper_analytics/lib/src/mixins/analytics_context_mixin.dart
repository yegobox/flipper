import '../events/analytics_properties.dart';
import '../interfaces/analytics_context_provider.dart';

mixin AnalyticsContextMixin {
  AnalyticsContextProvider get contextProvider;

  /// The base properties, for person and group properties (identify, group).
  Map<String, Object?> withContext(Map<String, Object?> properties) {
    return {...contextProvider.buildBaseProperties(), ...properties};
  }

  /// [withContext] plus the event's `$groups`, for anything PostHog records
  /// as an event (capture, screen, exception).
  ///
  /// The groups are read when the event happens and travel inside its
  /// properties, so an event that waits in the offline queue keeps the
  /// business and branch it belongs to, even if the till switched since.
  Map<String, Object?> withEventContext(Map<String, Object?> properties) {
    final groups = currentGroups();
    return {
      ...contextProvider.buildBaseProperties(),
      if (groups.isNotEmpty) AnalyticsGroups.property: groups,
      ...properties,
    };
  }

  /// The session's PostHog groups: `{business: <id>, branch: <id>}`, leaving
  /// out any that is unknown.
  Map<String, String> currentGroups() {
    final businessId = _present(contextProvider.businessId);
    final branchId = _present(contextProvider.branchId);
    return {
      if (businessId != null) AnalyticsGroups.business: businessId,
      if (branchId != null) AnalyticsGroups.branch: branchId,
    };
  }

  static String? _present(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
