import 'dart:async';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:stack_trace/stack_trace.dart';

/// A service for logging exceptions and errors to the database
///
/// This service captures exceptions and stack traces and saves them to the Log model,
/// which can then be synced to the server for debugging and monitoring purposes.
class LogService {
  /// Logs an exception with its stack trace to the database
  ///
  /// [exception] - The exception object to log
  /// [stackTrace] - The stack trace associated with the exception
  /// [type] - Optional type categorization (e.g., 'tax', 'network', 'database')
  /// [businessId] - Optional business ID associated with the log
  Future<void> logException(
    Object exception, {
    StackTrace? stackTrace,
    String? type,
    int? businessId,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    try {
      // Format the stack trace if provided
      final String formattedStack = stackTrace != null
          ? Trace.from(stackTrace).terse.toString()
          : 'No stack trace provided';

      // Create message combining exception and stack trace
      final String message = '''
Exception: $exception
Stack Trace:
$formattedStack
''';

      // Get business ID from proxy service if not provided
      final int? logBusinessId = businessId ?? ProxyService.box.getBusinessId();

      // Create log entry
      final log = Log(
        message: message,
        type: type ?? 'exception',
        businessId: logBusinessId,
        tags: tags,
        extra: extra,
      );

      // Save to database
      await _saveLog(log);

      // Also log to talker for immediate visibility
      talker.error('LogService captured: $exception', stackTrace);
    } catch (e, st) {
      // If logging fails, at least log to talker
      talker.error('LogService failed to log exception: $e', st);
    }
  }

  /// Logs a simple message without an exception
  ///
  /// [message] - The message to log
  /// [type] - Optional type categorization
  /// [businessId] - Optional business ID associated with the log
  Future<void> logMessage(
    String message, {
    String? type,
    int? businessId,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    try {
      // Get business ID from proxy service if not provided
      final int? logBusinessId = businessId ?? ProxyService.box.getBusinessId();

      // Create log entry
      final log = Log(
        message: message,
        type: type ?? 'message',
        businessId: logBusinessId,
        tags: tags,
        extra: extra,
      );

      // Save to database
      await _saveLog(log);
    } catch (e, st) {
      // If logging fails, at least log to talker
      talker.error('LogService failed to log message: $e', st);
    }
  }

  /// Internal method to save a log to the database
  Future<void> _saveLog(Log log) async {
    try {
      // Use the strategy to save the log
      await ProxyService.strategy.saveLog(log);
    } catch (e, st) {
      talker.error('LogService failed to save log: $e', st);
    }
  }

  /// Gets logs filtered by type and/or business ID
  ///
  /// [type] - Optional type to filter by
  /// [businessId] - Optional business ID to filter by
  /// [limit] - Maximum number of logs to retrieve (default: 100)
  Future<List<Log>> getLogs({
    String? type,
    int? businessId,
    int limit = 100,
  }) async {
    try {
      return await ProxyService.strategy.getLogs(
        type: type,
        businessId: businessId,
        limit: limit,
      );
    } catch (e, st) {
      talker.error('LogService failed to get logs: $e', st);
      return [];
    }
  }

  /// Clears logs older than the specified duration
  ///
  /// [olderThan] - Duration to keep logs (e.g., 30 days)
  /// [businessId] - Optional business ID to filter by
  Future<int> clearOldLogs({
    required Duration olderThan,
    int? businessId,
  }) async {
    try {
      return await ProxyService.strategy.clearOldLogs(
        olderThan: olderThan,
        businessId: businessId,
      );
    } catch (e, st) {
      talker.error('LogService failed to clear old logs: $e', st);
      return 0;
    }
  }
}
