// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:brick_offline_first/offline_queue.dart';

/// Manages offline request queue operations
class QueueManager {
  static final _logger = Logger('QueueManager');
  final OfflineRequestQueue offlineRequestQueue;

  QueueManager(this.offlineRequestQueue);

  /// Get the number of requests in the queue
  Future<int> availableQueue() async {
    try {
      final requests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);
      return requests.length;
    } catch (e) {
      _logger.warning("Error checking queue: $e");
      return 0;
    }
  }

  /// Clear any locked requests in the queue
  Future<void> deleteUnprocessedRequests() async {
    try {
      // Retrieve unprocessed requests
      final requests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);

      // Extract the primary key column name
      final primaryKeyColumn =
          offlineRequestQueue.requestManager.primaryKeyColumn;

      // Create a list to hold the futures for deletion operations
      final List<Future<void>> deletionFutures = [];

      // Iterate through the unprocessed requests
      for (final request in requests) {
        // Retrieve the request ID using the primary key column
        final requestId = request[primaryKeyColumn] as int;

        // Add the deletion future to the list
        deletionFutures.add(
          offlineRequestQueue.requestManager
              .deleteUnprocessedRequest(requestId),
        );
      }

      // Wait for all deletion operations to complete
      await Future.wait(deletionFutures);

      _logger.info("All locked requests have been cleared.");
    } catch (e) {
      _logger.warning("An error occurred while clearing locked requests: $e");
    }
  }

  /// Get information about the queue status
  /// Returns a map with counts of locked and unlocked requests
  Future<Map<String, int>> getQueueStatus() async {
    try {
      // Get locked requests (failed attempts)
      final lockedRequests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);

      // Get all unprocessed requests
      final allRequests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: false);

      // Calculate unlocked requests (waiting to be processed)
      final unlockedRequests = allRequests.length - lockedRequests.length;

      return {
        'locked': lockedRequests.length, // Failed requests
        'unlocked': unlockedRequests, // Waiting requests
        'total': allRequests.length // Total queue size
      };
    } catch (e) {
      _logger.warning("Error checking queue status: $e");
      return {'locked': 0, 'unlocked': 0, 'total': 0};
    }
  }

  /// Delete only locked (failed) requests from the queue
  /// Returns the number of requests deleted
  Future<int> deleteFailedRequests() async {
    try {
      // Retrieve only locked requests (these are the failed ones)
      final requests = await offlineRequestQueue.requestManager
          .unprocessedRequests(onlyLocked: true);

      // Extract the primary key column name
      final primaryKeyColumn =
          offlineRequestQueue.requestManager.primaryKeyColumn;

      // Create a list to hold the futures for deletion operations
      final List<Future<void>> deletionFutures = [];

      // Iterate through the locked requests
      for (final request in requests) {
        // Retrieve the request ID using the primary key column
        final requestId = request[primaryKeyColumn] as int;

        // Add the deletion future to the list
        deletionFutures.add(
          offlineRequestQueue.requestManager
              .deleteUnprocessedRequest(requestId),
        );
      }

      // Wait for all deletion operations to complete
      await Future.wait(deletionFutures);

      _logger.info("${requests.length} failed requests have been deleted.");
      return requests.length;
    } catch (e) {
      _logger.warning("An error occurred while deleting failed requests: $e");
      return 0;
    }
  }

  /// Cleanup failed requests from the queue
  /// This method is designed to be called from CronService
  /// Returns the number of failed requests that were cleaned up
  Future<int> cleanupFailedRequests() async {
    try {
      // Get queue status first to log information
      final status = await getQueueStatus();
      
      if (status['locked']! > 0) {
        _logger.info("Queue cleanup: Found ${status['locked']} failed requests");
        
        // Delete failed requests
        final deleted = await deleteFailedRequests();
        _logger.info("Queue cleanup: Deleted $deleted failed requests");
        return deleted;
      } else {
        _logger.info("Queue cleanup: No failed requests found");
        return 0;
      }
    } catch (e) {
      _logger.warning("Error during queue cleanup: $e");
      return 0;
    }
  }
}
