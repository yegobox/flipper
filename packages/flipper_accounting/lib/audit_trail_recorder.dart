import 'package:flipper_accounting/accounting_ditto_store.dart';

/// Persists accounting audit events to the shared Ditto
/// `accounting_audit_logs` collection so the trail survives restarts, syncs
/// across devices, and captures system actions (POS posting, auto-poster,
/// backfill sweeps) — not just Books UI clicks.
///
/// Audit doc ids should be DETERMINISTIC for system events (e.g.
/// `audit_<journalEntryId>`) so idempotent re-posts upsert the same document
/// instead of duplicating the trail.
class AuditTrailRecorder {
  const AuditTrailRecorder(this._store);

  final AccountingDittoStore _store;

  static const collection = 'accounting_audit_logs';

  /// Never throws — the audit trail must not break the action it describes.
  Future<void> record({
    required String businessId,
    required String id,
    required String action,
    required String target,
    required String detail,
    String user = 'System',
    String role = 'Auto',
    String tone = 'blue',
    String iconName = 'Receipt',
    String src = 'POS',
    DateTime? at,
  }) async {
    try {
      if (businessId.isEmpty || !_store.isReady()) return;
      await _store.upsertAccountingAuditLog(businessId, {
        'ts': (at ?? DateTime.now().toUtc()).toIso8601String(),
        'user': user,
        'role': role,
        'action': action,
        'target': target,
        'detail': detail,
        'iconName': iconName,
        'tone': tone,
        'src': src,
      }, id);
    } catch (_) {
      // Swallow: auditing is best-effort by design.
    }
  }
}
