import 'dart:async';

import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/party_repository.dart';

class FakePartyRepository implements PartyRepository {
  FakePartyRepository({List<Party>? parties}) : _parties = parties ?? [];

  final List<Party> _parties;

  List<Party> get parties => List.unmodifiable(_parties);

  @override
  Stream<List<Party>> watchParties({
    required String branchId,
    required PartyKind kind,
  }) {
    return Stream.value(_filtered(branchId, kind));
  }

  @override
  Future<List<Party>> fetchParties({
    required String branchId,
    required PartyKind kind,
  }) async {
    return _filtered(branchId, kind);
  }

  @override
  Future<void> upsertParty(Party party) async {
    _parties.removeWhere((p) => p.id == party.id && p.kind == party.kind);
    _parties.add(party);
  }

  @override
  Future<void> deleteParty({
    required String id,
    required PartyKind kind,
  }) async {
    _parties.removeWhere((p) => p.id == id && p.kind == kind);
  }

  List<Party> _filtered(String branchId, PartyKind kind) => _parties
      .where((p) => p.kind == kind && p.branchId == branchId)
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}
