import 'package:flipper_web/modules/accounting/data/mapper/party_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/party_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase-first party repository. Reads stream from PostgREST; writes
/// dual-write (Supabase canonical, then Ditto best-effort so POS Capella
/// live lists see the change).
class SupabasePartyRepository implements PartyRepository {
  const SupabasePartyRepository(this._client, this._ditto);

  final SupabaseClient _client;
  final DittoService _ditto;

  @override
  Stream<List<Party>> watchParties({
    required String branchId,
    required PartyKind kind,
  }) {
    return _client
        .from(kind.storeName)
        .stream(primaryKey: ['id'])
        .eq('branch_id', branchId)
        .map((rows) => rows
            .map((r) => PartyRowMapper.partyFromRow(r, kind: kind))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)));
  }

  @override
  Future<List<Party>> fetchParties({
    required String branchId,
    required PartyKind kind,
  }) async {
    final rows = await _client
        .from(kind.storeName)
        .select()
        .eq('branch_id', branchId);
    return [
      for (final r in rows) PartyRowMapper.partyFromRow(r, kind: kind),
    ];
  }

  @override
  Future<void> upsertParty(Party party) async {
    await _client
        .from(party.kind.storeName)
        .upsert(PartyRowMapper.toSupabaseRow(party), onConflict: 'id');
    try {
      await _ditto.upsertPartyDoc(
        party.kind.storeName,
        party.id,
        PartyRowMapper.toDittoRow(party),
      );
    } catch (e) {
      // Supabase row is canonical; the web party backfill reconciler heals
      // Ditto gaps on next contacts load.
      debugPrint('[Party] Ditto upsert failed (will reconcile): $e');
    }
  }

  @override
  Future<void> deleteParty({
    required String id,
    required PartyKind kind,
  }) async {
    await _client.from(kind.storeName).delete().eq('id', id);
    try {
      await _ditto.deletePartyDoc(kind.storeName, id);
    } catch (e) {
      debugPrint('[Party] Ditto delete failed: $e');
    }
  }
}
