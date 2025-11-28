import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';

/// Represents a Ditto query definition (SQL + optional arguments).
class DittoSyncQuery {
  const DittoSyncQuery({required this.query, this.arguments = const {}});

  final String query;
  final Map<String, dynamic> arguments;
}

/// Describes how a model restored from a backup pull should fetch related
/// records to keep local relationships intact.
class DittoBackupLinkConfig {
  const DittoBackupLinkConfig({
    required this.field,
    required this.targetType,
    this.remoteKey = 'id',
    this.cascade = true,
  });

  /// Field on the parent document containing the foreign key identifier.
  final String field;

  /// Target model type for the related document.
  final Type targetType;

  /// Field on the related document indicating its identifier.
  final String remoteKey;

  /// Whether the related model should also restore its dependencies.
  final bool cascade;
}

/// Contract for integrating an OfflineFirst model with Ditto peer-to-peer sync.
abstract class DittoSyncAdapter<T extends OfflineFirstWithSupabaseModel> {
  /// Logical Ditto collection backing this model (e.g. `counters`).
  String get collectionName;

  /// The sync direction for this adapter.
  SyncDirection get syncDirection => SyncDirection.bidirectional;

  /// Whether the coordinator should perform an initial remote hydration for
  /// this adapter when observers are started while skipping the default Ditto
  /// initial fetch. Defaults to `false`.
  bool get shouldHydrateOnStartup => false;

  /// Indicates whether this adapter can participate in a backup pull flow even
  /// if its normal synchronisation direction would normally prevent remote
  /// reads (for example, `sendOnly`).
  bool get supportsBackupPull => false;

  /// Builds the query used when performing a backup pull. Defaults to `null`
  /// (no backup support).
  Future<DittoSyncQuery?> buildBackupPullQuery() async => null;

  /// Specifies the foreign-key links that should be restored alongside this
  /// model when backing up from Ditto.
  List<DittoBackupLinkConfig> get backupLinks => const [];

  /// Hook invoked after the model has been reconstructed from a Ditto document
  /// during a backup pull but before it is persisted locally. Override to
  /// compute derived fields or perform additional linking.
  Future<void> onBackupModelRestored(
    T model,
    Map<String, dynamic> document,
  ) async {}

  /// Builds the observation query we should listen to.
  /// Returning `null` disables remote observation (useful for write-only data).
  Future<DittoSyncQuery?> buildObserverQuery();

  /// Builds the query that should be executed when the coordinator performs an
  /// explicit hydration (a manual one-off fetch of existing Ditto documents).
  ///
  /// By default this simply delegates to [buildObserverQuery], but adapters can
  /// override this to wait for additional context (such as the active branch)
  /// before constructing the hydration query.
  Future<DittoSyncQuery?> buildHydrationQuery() => buildObserverQuery();

  /// Serialises the model into a Ditto document.
  Future<Map<String, dynamic>> toDittoDocument(T model);

  /// Hydrates a model from a Ditto document.
  /// Return `null` to skip a document (e.g. because of filtering).
  Future<T?> fromDittoDocument(Map<String, dynamic> document);

  /// Extract the Ditto document identifier for a model.
  Future<String?> documentIdForModel(T model);

  /// Extract the Ditto document identifier from a Ditto document.
  Future<String?> documentIdFromRemote(Map<String, dynamic> document) async {
    final dynamic value = document['_id'] ?? document['id'];
    return value is String ? value : value?.toString();
  }

  /// Whether a remote Ditto document should be upserted locally.
  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async => true;

  /// Upserts a model to the repository with the correct generic type.
  /// This method ensures that the SQLite provider can find the correct adapter
  /// by preserving the concrete type T rather than using the base type.
  /// Upserts a model to the repository with the correct generic type.
  /// This method ensures that the SQLite provider can find the correct adapter
  /// by preserving the concrete type T rather than using the base type.
  Future<T> upsertToRepository(T model) async {
    return Repository().upsertFromDitto<T>(
      model,
      policy: OfflineFirstUpsertPolicy.optimisticLocal,
    );
  }
}

