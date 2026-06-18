import 'package:flipper_web/modules/accounting/data/mapper/party_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// One-time-per-session reconciler: pushes canonical Supabase party rows into
/// the Ditto `customers`/`suppliers` collections for the branch.
///
/// Why: the unification migration creates/links parties in Supabase only, and
/// the data-connector has no customers pipeline, so POS Capella (Ditto-backed
/// live lists) would never see migrated rows. The web client is the only
/// place with both backends connected, making it the cheapest correct healer.
/// Also repairs dual-write gaps from failed Ditto upserts.
class PartyBackfill {
  PartyBackfill(this._client, this._ditto);

  final SupabaseClient _client;
  final DittoService _ditto;

  static final Set<String> _doneBranches = {};

  Future<void> run({required String branchId}) async {
    if (branchId.isEmpty) return;
    if (!_doneBranches.add(branchId)) return;
    if (!_ditto.isReady()) {
      _doneBranches.remove(branchId);
      return;
    }

    for (final kind in PartyKind.values) {
      try {
        final supaRows = await _client
            .from(kind.storeName)
            .select()
            .eq('branch_id', branchId);
        if (supaRows.isEmpty) continue;

        final dittoRows = await _ditto.queryCollection(
          kind.storeName,
          'SELECT * FROM ${kind.storeName} WHERE branchId = :branchId',
          {'branchId': branchId},
        );
        final dittoIds = {
          for (final r in dittoRows) (r['_id'] ?? r['id']).toString(),
        };

        var pushed = 0;
        for (final row in supaRows) {
          final party = PartyRowMapper.partyFromRow(row, kind: kind);
          if (party.id.isEmpty || dittoIds.contains(party.id)) continue;
          await _ditto.upsertPartyDoc(
            kind.storeName,
            party.id,
            PartyRowMapper.toDittoRow(party),
          );
          pushed++;
        }
        if (pushed > 0) {
          debugPrint(
            '[Party] backfilled $pushed ${kind.storeName} row(s) into Ditto '
            'for branch $branchId',
          );
        }
      } catch (e) {
        // Retry on next session/page load.
        _doneBranches.remove(branchId);
        debugPrint('[Party] backfill ${kind.storeName} failed: $e');
      }
    }
  }
}
