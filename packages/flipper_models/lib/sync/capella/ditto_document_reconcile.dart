/// Re-keying Ditto documents that were written without an `_id`.
///
/// `Product.toJson` / `SKU.toJson` used to omit `_id`, so Ditto generated a
/// fresh document id on every write and `ON ID CONFLICT DO UPDATE` never
/// matched — each save left another copy behind. The models now set
/// `'_id': id` (see `ditto_document_id_test.dart`), which stops new duplicates
/// but does not clean up the ones already in the collection.
///
/// This plans that cleanup: pick one winner per app `id`, rewrite it under
/// `_id == id`, and drop the stray copies. The logic is pure so it can be
/// tested without a Ditto instance; `applyDittoDocumentReconcile` runs it.
library;

/// What to write and what to delete for one collection.
class DittoReconcilePlan {
  /// Winning documents, each already re-keyed so `_id == id`.
  final List<Map<String, dynamic>> upserts;

  /// `_id`s of the stray copies, safe to delete once [upserts] are written.
  final List<String> deletes;

  const DittoReconcilePlan({required this.upserts, required this.deletes});

  bool get isEmpty => upserts.isEmpty && deletes.isEmpty;

  @override
  String toString() =>
      'DittoReconcilePlan(upserts: ${upserts.length}, deletes: ${deletes.length})';
}

DateTime? _touchedAt(Map<String, dynamic> doc) {
  final raw = doc['lastTouched'];
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  return DateTime.tryParse(raw.toString());
}

/// True when [doc] is already keyed the way we want.
bool _isCanonical(Map<String, dynamic> doc) {
  final id = doc['id']?.toString();
  return id != null && id.isNotEmpty && doc['_id']?.toString() == id;
}

/// Which of two copies of the same record wins.
///
/// Freshest `lastTouched` first. A document with no `lastTouched` loses to one
/// that has it — an un-stamped row is the older write path. Ties go to the
/// already-canonical copy so a re-run is stable, and finally to the lower
/// `_id` so the outcome does not depend on scan order.
bool _beats(Map<String, dynamic> candidate, Map<String, dynamic> incumbent) {
  final a = _touchedAt(candidate);
  final b = _touchedAt(incumbent);
  if (a != null && b == null) return true;
  if (a == null && b != null) return false;
  if (a != null && b != null && !a.isAtSameMomentAs(b)) return a.isAfter(b);

  final aCanonical = _isCanonical(candidate);
  final bCanonical = _isCanonical(incumbent);
  if (aCanonical != bCanonical) return aCanonical;

  return (candidate['_id']?.toString() ?? '')
          .compareTo(incumbent['_id']?.toString() ?? '') <
      0;
}

/// Plan the cleanup for [docs] — every raw document in one collection.
///
/// Documents with no usable `id` field are left completely alone: there is no
/// app identity to re-key them onto, so deleting them could drop the only copy
/// of a record.
DittoReconcilePlan planDittoDocumentReconcile(
  List<Map<String, dynamic>> docs,
) {
  final winners = <String, Map<String, dynamic>>{};
  final seenDocIds = <String, Set<String>>{};

  for (final doc in docs) {
    final id = doc['id']?.toString();
    if (id == null || id.isEmpty) continue;

    final docId = doc['_id']?.toString();
    if (docId != null && docId.isNotEmpty) {
      seenDocIds.putIfAbsent(id, () => <String>{}).add(docId);
    }

    final incumbent = winners[id];
    if (incumbent == null || _beats(doc, incumbent)) {
      winners[id] = doc;
    }
  }

  final upserts = <Map<String, dynamic>>[];
  final deletes = <String>[];

  for (final entry in winners.entries) {
    final id = entry.key;
    final docIds = seenDocIds[id] ?? const <String>{};
    final strays = docIds.where((d) => d != id).toList()..sort();

    // Nothing to do when the only copy is already keyed on the app id.
    if (strays.isEmpty && _isCanonical(entry.value)) continue;

    upserts.add({...entry.value, '_id': id, 'id': id});
    deletes.addAll(strays);
  }

  upserts.sort((a, b) => a['_id'].toString().compareTo(b['_id'].toString()));
  deletes.sort();
  return DittoReconcilePlan(upserts: upserts, deletes: deletes);
}
