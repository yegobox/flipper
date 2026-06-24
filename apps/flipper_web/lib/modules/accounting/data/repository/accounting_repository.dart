/// Backend-agnostic contract for fetching raw transaction rows that feed
/// the accounting module. Two implementations exist:
///   - [SupabaseAccountingRepository] — Supabase REST (web default)
///   - [DittoAccountingRepository]    — Ditto DQL  (swap in via provider override)
///
/// All methods return raw [Map] rows so the mapper layer stays decoupled from
/// any ORM or sync library.
abstract class AccountingRepository {
  /// One-shot fetch of completed transactions for [branchId], optionally
  /// bounded by [startDate] / [endDate] (inclusive, local midnight boundaries).
  Future<List<Map<String, dynamic>>> fetchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Batch-fetch line items for the given transaction IDs.
  /// Returns [] when [transactionIds] is empty (no query issued).
  Future<List<Map<String, dynamic>>> fetchTransactionItems({
    required List<String> transactionIds,
  });

  /// Real-time stream of completed transactions. Emits a new list on every
  /// remote change. Implementations should close internal resources when the
  /// stream subscription is cancelled.
  Stream<List<Map<String, dynamic>>> watchTransactions({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
