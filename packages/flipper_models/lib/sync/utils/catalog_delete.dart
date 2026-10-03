/// Ditto-side removal of catalog documents (products, variants, stocks).
///
/// The catalog is read straight from Ditto, so an item is only gone once its
/// documents leave the store — a `DELETE` here also replicates to every other
/// peer and the cloud. Before these existed, the Capella `flipperDelete`
/// ignored products and variants entirely: the UI dropped the tile from memory
/// and the item came back on the next catalog read.
///
/// Every lookup also matches `id`, not only `_id`: older documents were written
/// without `_id` and carry a random one (see `ditto_document_reconcile.dart`),
/// so deleting by `_id` alone leaves those copies behind.
library;

/// Ids of variants and stocks deleted by this process.
///
/// A screen or background job can still hold a `Variant` it read before the
/// delete, and the variant/stock save paths upsert whole documents
/// (`INSERT … ON ID CONFLICT DO UPDATE`), which would re-create the deleted
/// document under the same id. Those paths check this set and skip.
final DeletedCatalogIds deletedCatalogIds = DeletedCatalogIds();

class DeletedCatalogIds {
  final Set<String> _ids = {};

  bool contains(String? id) => id != null && _ids.contains(id);

  void addAll(Iterable<String?> ids) {
    for (final id in ids) {
      if (id != null && id.isNotEmpty) _ids.add(id);
    }
  }
}

/// What [deleteVariantDocs] removed, so the caller can mirror it elsewhere and
/// decide whether the parent product is now empty.
class DeletedVariantDocs {
  const DeletedVariantDocs({
    required this.variantId,
    this.stockId,
    this.productId,
  });

  final String variantId;
  final String? stockId;
  final String? productId;
}

/// Deletes variant [variantId] and its stock document.
///
/// [stockId] / [productId] are read from the variant document when not given.
Future<DeletedVariantDocs> deleteVariantDocs(
  dynamic store, {
  required String variantId,
  String? stockId,
  String? productId,
}) async {
  if (_isBlank(stockId) || _isBlank(productId)) {
    final result = await store.execute(
      'SELECT stockId, productId FROM variants WHERE _id = :id OR id = :id',
      arguments: {'id': variantId},
    );
    for (final item in result.items) {
      final doc = Map<String, dynamic>.from(item.value);
      if (_isBlank(stockId)) stockId = _str(doc['stockId']);
      if (_isBlank(productId)) productId = _str(doc['productId']);
    }
  }

  if (!_isBlank(stockId)) {
    await store.execute(
      'DELETE FROM stocks WHERE _id = :id OR id = :id',
      arguments: {'id': stockId},
    );
  }
  await store.execute(
    'DELETE FROM variants WHERE _id = :id OR id = :id',
    arguments: {'id': variantId},
  );

  return DeletedVariantDocs(
    variantId: variantId,
    stockId: _isBlank(stockId) ? null : stockId,
    productId: _isBlank(productId) ? null : productId,
  );
}

/// Whether any variant document still points at [productId].
Future<bool> productHasVariants(dynamic store, String productId) async {
  final result = await store.execute(
    'SELECT _id FROM variants WHERE productId = :pid LIMIT 1',
    arguments: {'pid': productId},
  );
  return result.items.isNotEmpty;
}

/// Deletes product [productId], every variant under it and their stocks.
///
/// Returns what was removed for each variant.
Future<List<DeletedVariantDocs>> deleteProductDocs(
  dynamic store, {
  required String productId,
}) async {
  final result = await store.execute(
    'SELECT _id, stockId FROM variants WHERE productId = :pid',
    arguments: {'pid': productId},
  );
  final deleted = <DeletedVariantDocs>[];
  for (final item in result.items) {
    final doc = Map<String, dynamic>.from(item.value);
    final variantId = _str(doc['_id']);
    if (variantId == null) continue;
    deleted.add(
      await deleteVariantDocs(
        store,
        variantId: variantId,
        stockId: _str(doc['stockId']),
        productId: productId,
      ),
    );
  }

  await store.execute(
    'DELETE FROM products WHERE _id = :id OR id = :id',
    arguments: {'id': productId},
  );
  return deleted;
}

bool _isBlank(String? value) => value == null || value.isEmpty;

String? _str(Object? value) {
  final s = value?.toString();
  return (s == null || s.isEmpty) ? null : s;
}
