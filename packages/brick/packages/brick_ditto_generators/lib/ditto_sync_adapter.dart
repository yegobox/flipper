/// Defines the synchronization direction for a Ditto-synced model.
enum SyncDirection {
  /// Model sends data to Ditto only. Initial data is seeded, but no remote
  /// updates are fetched back to the local database.
  sendOnly,

  /// Model receives data from Ditto only. Local changes are not pushed.
  receiveOnly,

  /// Model both sends and receives data (full bidirectional sync).
  bidirectional,
}

/// Annotation to mark a class for Ditto synchronization adapter generation.
class DittoAdapter {
  /// The collection name in Ditto for this model.
  final String collectionName;

  /// The synchronization direction for this model.
  /// Defaults to [SyncDirection.bidirectional].
  final SyncDirection syncDirection;

  /// Creates a DittoAdapter annotation.
  const DittoAdapter(
    this.collectionName, {
    this.syncDirection = SyncDirection.bidirectional,
  });
}
