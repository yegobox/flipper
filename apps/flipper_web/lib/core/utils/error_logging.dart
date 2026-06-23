import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Console + framework error hooks for flipper_web (no flipper_services dependency).
void initializeErrorLogging() {
  final previousFlutterOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    _logError(
      details.exception,
      details.stack,
      type: 'flutter_error',
      extra: {
        'library': details.library,
        'context': details.context?.toString(),
      },
    );
    previousFlutterOnError?.call(details);
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  final previousPlatformOnError = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    _logError(error, stack, type: 'platform_error');
    return previousPlatformOnError?.call(error, stack) ?? true;
  };
}

void logCaughtError(
  Object error,
  StackTrace? stackTrace, {
  String? type,
  Map<String, dynamic>? extra,
}) {
  _logError(error, stackTrace, type: type ?? 'caught', extra: extra);
}

void _logError(
  Object error,
  StackTrace? stackTrace, {
  required String type,
  Map<String, dynamic>? extra,
}) {
  final buffer = StringBuffer('[flipper_web][$type] $error');
  if (extra != null && extra.isNotEmpty) {
    buffer.write(' extra=$extra');
  }
  if (stackTrace != null) {
    buffer.write('\n$stackTrace');
  }
  debugPrint(buffer.toString());
}

/// Runs [bootstrap] in a guarded zone.
///
/// [WidgetsFlutterBinding.ensureInitialized] and [runApp] must both run inside
/// [bootstrap] so Flutter's binding uses the same zone for initialization and
/// the widget tree.
Future<void> runZonedWithErrorLogging(
  Future<void> Function() bootstrap,
) async {
  await runZonedGuarded(
    bootstrap,
    (error, stackTrace) => _logError(error, stackTrace, type: 'zone_error'),
  );
}
