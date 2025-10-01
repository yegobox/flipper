import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

/// Represents a Ditto query definition (SQL + optional arguments).
class DittoSyncQuery {
  const DittoSyncQuery({required this.query, this.arguments = const {}});

  final String query;
  final Map<String, dynamic> arguments;
}

/// Contract for integrating an OfflineFirst model with Ditto peer-to-peer sync.
abstract class DittoSyncAdapter<T extends OfflineFirstWithSupabaseModel> {
  /// Logical Ditto collection backing this model (e.g. `counters`).
  String get collectionName;

  /// Builds the observation query we should listen to.
  /// Returning `null` disables remote observation (useful for write-only data).
  Future<DittoSyncQuery?> buildObserverQuery();

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
}
