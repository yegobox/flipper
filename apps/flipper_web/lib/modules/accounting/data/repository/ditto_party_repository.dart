import 'package:flipper_web/modules/accounting/data/mapper/party_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/party_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Ditto-first party repository. Reads observe the local Ditto store; writes
/// dual-write (Supabase canonical first, then Ditto) so POS Brick reads see
/// the row even when this client is Ditto-backed.
class DittoPartyRepository implements PartyRepository {
  const DittoPartyRepository(this._ditto, this._client);

  final DittoService _ditto;
  final SupabaseClient _client;

  @override
  Stream<List<Party>> watchParties({
    required String branchId,
    required PartyKind kind,
  }) {
    return _ditto
        .watchCollection(
          kind.storeName,
          'SELECT * FROM ${kind.storeName} WHERE branchId = :branchId',
          {'branchId': branchId},
        )
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
    final rows = await _ditto.queryCollection(
      kind.storeName,
      'SELECT * FROM ${kind.storeName} WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    return [
      for (final r in rows) PartyRowMapper.partyFromRow(r, kind: kind),
    ];
  }

  @override
  Future<void> upsertParty(Party party) async {
    // Supabase first: it is the canonical store POS Brick hydrates from.
    try {
      await _client
          .from(party.kind.storeName)
          .upsert(PartyRowMapper.toSupabaseRow(party), onConflict: 'id');
    } catch (e) {
      debugPrint('[Party] Supabase upsert failed (Ditto still applied): $e');
    }
    await _ditto.upsertPartyDoc(
      party.kind.storeName,
      party.id,
      PartyRowMapper.toDittoRow(party),
    );
  }

  @override
  Future<void> deleteParty({
    required String id,
    required PartyKind kind,
  }) async {
    try {
      await _client.from(kind.storeName).delete().eq('id', id);
    } catch (e) {
      debugPrint('[Party] Supabase delete failed: $e');
    }
    await _ditto.deletePartyDoc(kind.storeName, id);
  }
}
