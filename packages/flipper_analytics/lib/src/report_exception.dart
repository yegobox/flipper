import 'dart:async';

import 'bootstrap/flipper_analytics_bootstrap.dart';
import 'interfaces/product_analytics.dart';

/// Sends [error] to PostHog error tracking.
///
/// For error handlers and catch blocks: fire-and-forget, never throws, and
/// does nothing before analytics has started or while the device is opted out
/// (local mode). [type] says where it was caught (`flutter_error`,
/// `platform_error`, `caught`, ...). Callers should deduplicate repeats, as
/// `GlobalErrorHandler` does, so one stuck assertion is not sent per frame.
void reportException(
  Object error,
  StackTrace? stackTrace, {
  String? type,
  Map<String, Object?> properties = const {},
  ProductAnalytics? analytics,
}) {
  final target = analytics ?? FlipperAnalytics.maybeInstance;
  if (target == null) return;
  unawaited(
    target
        .captureException(
          error,
          stackTrace: stackTrace,
          properties: {...properties, if (type != null) 'error_type': type},
        )
        .catchError((Object _) {}),
  );
}
