import 'dart:async';

import 'package:flutter/foundation.dart';

import 'bootstrap/flipper_analytics_bootstrap.dart';
import 'interfaces/product_analytics.dart';

/// Reports that came in before analytics started, held until it does.
final List<_EarlyReport> _early = [];

/// How many early reports are kept; later ones are dropped.
@visibleForTesting
const maxEarlyExceptions = 20;

/// Sends [error] to PostHog error tracking.
///
/// For error handlers and catch blocks: fire-and-forget and never throws.
/// [type] says where it was caught (`flutter_error`, `platform_error`,
/// `caught`, ...). Callers should deduplicate repeats, as `GlobalErrorHandler`
/// does, so one stuck assertion is not sent per frame.
///
/// Startup steps before analytics (database, services) fail before there is a
/// client to send to. Those reports are held, up to [maxEarlyExceptions],
/// and sent once [FlipperAnalytics.initialize] finishes. Nothing is sent while
/// the device is opted out (local mode).
void reportException(
  Object error,
  StackTrace? stackTrace, {
  String? type,
  Map<String, Object?> properties = const {},
  ProductAnalytics? analytics,
}) {
  final props = {...properties, if (type != null) 'error_type': type};
  final target = analytics ?? FlipperAnalytics.maybeInstance;
  if (target == null) {
    if (_early.length < maxEarlyExceptions) {
      _early.add(_EarlyReport(error, stackTrace, props));
    }
    return;
  }
  _send(target, error, stackTrace, props);
}

/// Sends the reports held from before analytics started. Called by
/// [FlipperAnalytics.initialize].
void flushEarlyExceptions(ProductAnalytics analytics) {
  final held = List<_EarlyReport>.of(_early);
  _early.clear();
  for (final report in held) {
    _send(analytics, report.error, report.stackTrace, {
      ...report.properties,
      'reported_before_analytics': true,
    });
  }
}

@visibleForTesting
int get earlyExceptionCount => _early.length;

@visibleForTesting
void debugClearEarlyExceptions() => _early.clear();

void _send(
  ProductAnalytics target,
  Object error,
  StackTrace? stackTrace,
  Map<String, Object?> properties,
) {
  unawaited(
    target
        .captureException(error, stackTrace: stackTrace, properties: properties)
        .catchError((Object _) {}),
  );
}

class _EarlyReport {
  _EarlyReport(this.error, this.stackTrace, this.properties);

  final Object error;
  final StackTrace? stackTrace;
  final Map<String, Object?> properties;
}
