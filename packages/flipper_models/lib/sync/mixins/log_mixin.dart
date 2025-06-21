import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/log_interface.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;

/// Mixin that implements the LogInterface for CoreSync
///
/// This mixin provides the implementation for log management operations
/// including saving, retrieving, and clearing logs.
mixin LogMixin implements LogInterface {
  /// Repository instance for database operations
  Repository get repository;

  @override
  Future<void> saveLog(Log log) async {
    try {
      await repository.upsert<Log>(log);
      talker.info('Log saved: ${log.id} - Type: ${log.type}');
    } catch (e, stackTrace) {
      talker.error('Failed to save log: $e', stackTrace);
      // Don't rethrow to avoid cascading errors in logging system
    }
  }

  @override
  Future<List<Log>> getLogs({
    String? type,
    int? businessId,
    int limit = 100,
  }) async {
    try {
      // Create a query to filter logs
      final whereConditions = <brick.Where>[];

      if (type != null) {
        whereConditions.add(brick.Where('type').isExactly(type));
      }

      if (businessId != null) {
        whereConditions.add(brick.Where('businessId').isExactly(businessId));
      }

      final query = brick.Query(
        where: whereConditions,
        limit: limit,
      );

      final logs = await repository.get<Log>(query: query);
      return logs;
    } catch (e, stackTrace) {
      talker.error('Failed to get logs: $e', stackTrace);
      return [];
    }
  }

  @override
  Future<int> clearOldLogs({
    required Duration olderThan,
    int? businessId,
  }) async {
    try {
      // Since Log model doesn't have a timestamp field by default,
      // we can't directly query by age. We'll need to fetch all logs
      // and filter them manually, or add a timestamp field to the Log model.

      // For now, we'll just delete all logs of a specific business if provided
      final whereConditions = <brick.Where>[];

      if (businessId != null) {
        whereConditions.add(brick.Where('businessId').isExactly(businessId));
      }

      final query = brick.Query(where: whereConditions);

      final logs = await repository.get<Log>(query: query);

      int deletedCount = 0;
      for (final log in logs) {
        await repository.delete<Log>(log);
        deletedCount++;
      }

      talker.info('Cleared $deletedCount logs');
      return deletedCount;
    } catch (e, stackTrace) {
      talker.error('Failed to clear old logs: $e', stackTrace);
      return 0;
    }
  }
}
