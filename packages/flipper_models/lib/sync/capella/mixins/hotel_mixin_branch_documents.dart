part of 'hotel_mixin.dart';

/// Writes to `branch_document_settings`, shared by the stamp save and the
/// receipt-header save.
extension _CapellaBranchDocumentWrites on CapellaHotelMixin {
  /// Upserts whatever [toDoc] returns. DO UPDATE writes only the fields it is
  /// given, which is what lets the receipt header (a partial document) be
  /// saved without touching the stamp, and the stamp without the header.
  Future<void> _upsertBranchDocument(
    BranchDocumentSettings settings,
    Map<String, dynamic> Function(BranchDocumentSettings) toDoc,
  ) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    _ensureBranchDocumentSettingsSync(ditto, settings.branchId);
    final doc = toDoc(settings.copyWith(updatedAt: DateTime.now().toUtc()));
    await ditto.store.execute(
      'INSERT INTO branch_document_settings DOCUMENTS (:doc) '
      'ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }
}
