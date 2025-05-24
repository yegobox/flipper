import 'package:supabase_models/brick/models/log.model.dart';

/// Interface for log management operations
///
/// This interface defines methods for saving, retrieving, and managing log entries.
/// It must be implemented by CoreSyncBase as per the modular architecture requirements.
abstract class LogInterface {
  /// Saves a log entry to the database
  Future<void> saveLog(Log log);

  /// Retrieves logs filtered by type and/or business ID
  Future<List<Log>> getLogs({
    String? type,
    int? businessId,
    int limit = 100,
  });

  /// Clears logs older than the specified duration
  Future<int> clearOldLogs({
    required Duration olderThan,
    int? businessId,
  });
}
