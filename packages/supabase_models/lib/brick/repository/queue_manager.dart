// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:brick_offline_first/offline_queue.dart';

/// Manages offline request queue operations
class QueueManager {
  static final _logger = Logger('QueueManager');
  final OfflineRequestQueue offlineRequestQueue;
  
  // Batch size for processing queue operations
  static const int _batchSize = 10;
  // Delay between batches to prevent lock contention
  static const Duration _batchDelay = Duration(milliseconds: 50);

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

      // Process in batches to reduce lock contention
      await _processBatches(requests, primaryKeyColumn);
      
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

      // Process in batches to reduce lock contention
      await _processBatches(requests, primaryKeyColumn);
      
      _logger.info("${requests.length} failed requests have been deleted.");
      return requests.length;
    } catch (e) {
      _logger.warning("An error occurred while deleting failed requests: $e");
      return 0;
    }
  }

  /// Process requests in batches to prevent database locks
  Future<void> _processBatches(List<Map<String, dynamic>> requests, String primaryKeyColumn) async {
    // Calculate number of batches needed
    final int totalBatches = (requests.length / _batchSize).ceil();
    
    for (int batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
      // Calculate start and end indices for this batch
      final int startIdx = batchIndex * _batchSize;
      final int endIdx = (startIdx + _batchSize < requests.length) 
          ? startIdx + _batchSize 
          : requests.length;
      
      // Get the current batch of requests
      final currentBatch = requests.sublist(startIdx, endIdx);
      
      // Process each request in the batch sequentially
      for (final request in currentBatch) {
        final requestId = request[primaryKeyColumn] as int;
        await offlineRequestQueue.requestManager.deleteUnprocessedRequest(requestId);
      }
      
      // Add a small delay between batches to prevent lock contention
      if (batchIndex < totalBatches - 1) {
        await Future.delayed(_batchDelay);
      }
      
      _logger.fine("Processed batch ${batchIndex + 1}/$totalBatches of queue operations");
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
