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

  /// Whether this adapter should expose a backup pull workflow even if the
  /// sync direction normally prevents receiving remote updates. When enabled,
  /// the generated adapter exposes metadata that can be used to fetch and
  /// restore documents on demand.
  final bool enableBackupPull;

  /// Whether the generated adapter should perform a manual hydration when
  /// observers start while the coordinator skips Ditto's initial fetch.
  /// Defaults to `false` to avoid delaying startup while waiting for
  /// additional context (for example, the active branch).
  final bool hydrateOnStartup;

  /// Creates a DittoAdapter annotation.
  const DittoAdapter(
    this.collectionName, {
    this.syncDirection = SyncDirection.bidirectional,
    this.enableBackupPull = false,
    this.hydrateOnStartup = false,
  });
}

/// Describes how a model retrieved via a backup pull links to additional
/// collections that should also be restored. Apply this annotation to the
/// field holding the foreign key that references the related model.
class DittoBackupLink {
  /// Name of the field holding the foreign key that references the related
  /// document. Defaults to the annotated field name when omitted.
  final String? field;

  /// Remote identifier field on the related document. Usually `id`, but some
  /// collections use `_id` or custom values.
  final String remoteKey;

  /// Whether to recursively restore the dependencies of the related model.
  final bool cascade;

  /// Type of the related model (must also be decorated with [DittoAdapter]).
  final Type model;

  const DittoBackupLink({
    required this.model,
    this.field,
    this.remoteKey = 'id',
    this.cascade = true,
  });
}
