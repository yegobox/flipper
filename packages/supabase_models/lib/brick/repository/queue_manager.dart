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
}
