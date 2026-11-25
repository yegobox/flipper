abstract final class AnalyticsProperties {
  static const app = 'app';
  static const platform = 'platform';
  static const source = 'source';
  static const businessId = 'business_id';
  static const branchId = 'branch_id';
  static const userId = 'user_id';
  static const buildMode = 'build_mode';
  static const appVersion = 'app_version';
  static const releaseCommit = 'release_commit';
  static const route = 'route';
  static const screenName = 'screen_name';
  static const module = 'module';
  static const action = 'action';

  /// On an event the offline queue sent late: when it happened by the
  /// device's own clock (ISO 8601, UTC). PostHog stamps an event with the
  /// moment it reaches the SDK and posthog_flutter cannot set that stamp.
  /// This value is not corrected for clock skew, so use it for display only;
  /// analyses by time use `timestamp - queued_ms`.
  static const capturedAt = 'captured_at';

  /// On an event the offline queue sent late: how long it waited, in
  /// milliseconds, measured on one device clock. `timestamp - queued_ms` is
  /// when the event happened, with PostHog's skew correction kept. Its
  /// absence means the event went out when it happened.
  static const queuedMs = 'queued_ms';
}

/// PostHog group types; `business` is group type index 0 (`$group_0`).
abstract final class AnalyticsGroups {
  static const business = 'business';
  static const branch = 'branch';

  /// The event property PostHog reads an event's groups from.
  static const property = r'$groups';
}
