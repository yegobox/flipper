import '../repository.dart' show DatabaseConfigStorage;

/// Adapter class that bridges between any storage implementation
/// and the DatabaseConfigStorage interface used in Repository
class StorageAdapter implements DatabaseConfigStorage {
  final String Function() _getDatabaseFilename;
  final String Function() _getQueueFilename;

  /// Create a new adapter with function references to get database filenames
  /// This avoids direct dependencies between packages
  StorageAdapter({
    required String Function() getDatabaseFilename,
    required String Function() getQueueFilename,
  })  : _getDatabaseFilename = getDatabaseFilename,
        _getQueueFilename = getQueueFilename;

  @override
  String getDatabaseFilename() {
    return _getDatabaseFilename();
  }

  @override
  String getQueueFilename() {
    return _getQueueFilename();
  }
}
