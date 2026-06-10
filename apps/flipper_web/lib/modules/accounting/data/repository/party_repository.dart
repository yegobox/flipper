import 'package:flipper_web/modules/accounting/data/party_models.dart';

/// Backend-agnostic contract for the canonical party stores (`customers` /
/// `suppliers`) shared with the POS app.
///
/// Reads follow the selected backend strategy; writes ALWAYS dual-write
/// (Supabase canonical first, Ditto best-effort) because POS has two read
/// paths hitting different stores: Brick reads Supabase/SQLite, Capella
/// reads Ditto. See the cross-app visibility contract in the unification
/// plan.
abstract class PartyRepository {
  Stream<List<Party>> watchParties({
    required String branchId,
    required PartyKind kind,
  });

  Future<List<Party>> fetchParties({
    required String branchId,
    required PartyKind kind,
  });

  Future<void> upsertParty(Party party);

  /// Deletes the canonical party row. Use with care: POS transactions
  /// reference customers via transaction.customerId.
  Future<void> deleteParty({required String id, required PartyKind kind});
}
