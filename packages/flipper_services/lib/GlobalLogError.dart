import 'dart:async';
import 'dart:isolate';
import 'package:flipper_services/log_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static final LogService _logService = LogService();

  /// Initialize global error handling
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log to your service
      _logService.logException(
        details.exception,
        stackTrace: details.stack,
        type: 'flutter_error',
        extra: {
          'library': details.library,
          'context': details.context.toString(),
          'informationCollector':
              details.informationCollector?.call().toString(),
        },
      );

      // Also print to console in debug mode
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Catch errors outside of Flutter framework (async errors, etc.)
    PlatformDispatcher.instance.onError = (error, stack) {
      _logService.logException(
        error,
        stackTrace: stack,
        type: 'platform_error',
        extra: {
          'error_type': error.runtimeType.toString(),
        },
      );
      return true; // Handled
    };

    // Catch isolate errors
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        final error = errorAndStacktrace.first;
        final stackTrace = errorAndStacktrace.last;

        await _logService.logException(
          error,
          stackTrace: StackTrace.fromString(stackTrace.toString()),
          type: 'isolate_error',
          extra: {
            'error_type': error.runtimeType.toString(),
          },
        );
      }).sendPort,
    );
  }

  /// Manual error logging method
  static Future<void> logError(
    Object error, {
    StackTrace? stackTrace,
    String? type,
    Map<String, dynamic>? context,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    await _logService.logException(
      error,
      stackTrace: stackTrace,
      type: type ?? 'manual',
      tags: tags,
      extra: extra,
    );
  }

  /// Log custom messages
  static Future<void> logMessage(
    String message, {
    String? type,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    await _logService.logMessage(
      message,
      type: type ?? 'info',
      tags: tags,
      extra: extra,
    );
  }

  /// Enhanced runApp wrapper with error handling
  void runAppWithErrorHandling(Widget app) {
    // Initialize error handling first
    GlobalErrorHandler.initialize();

    // Run the app in a error zone
    runZonedGuarded<Future<void>>(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        // Any other initialization code here
        // e.g., Firebase, SharedPreferences, etc.

        runApp(app);
      },
      (error, stackTrace) {
        // This catches any errors not caught by Flutter
        GlobalErrorHandler.logError(
          error,
          stackTrace: stackTrace,
          type: 'zone_error',
          extra: {
            'error_type': error.runtimeType.toString(),
          },
        );
      },
    );
  }

  /// Example of how to use in your main.dart
/*
void main() {
  runAppWithErrorHandling(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: ErrorBoundary(
        child: MyHomePage(),
        errorBuilder: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Custom Error UI'),
                  ElevatedButton(
                    onPressed: () {
                      // Restart app or navigate to safe screen
                    },
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
}
