import 'package:flipper_models/domain/party/party_draft.dart';

export 'package:flipper_models/domain/party/party_draft.dart'
    show PartyKind, PartyKindStore;

/// Light DTO for a canonical party row (the shared `customers` / `suppliers`
/// store also used by the POS app).
///
/// Deliberately NOT the Brick `Customer`/`Supplier` model: those import
/// sqflite/proxy and are not wasm-safe. This carries the FULL canonical field
/// set so web edits round-trip losslessly (RRA fields are preserved, never
/// regenerated on update).
class Party {
  const Party({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.tin,
    required this.branchId,
    required this.customerType,
    this.address,
    this.custNo,
    this.regrNm,
    this.regrId,
    this.modrNm,
    this.modrId,
    this.ebmSynced = false,
    this.bhfId = '00',
    this.useYn = 'N',
    this.updatedAtIso,
    this.kind = PartyKind.customer,
  });

  /// New party from the shared domain draft (applies RRA defaults exactly as
  /// the POS CoreViewModel does).
  factory Party.fromDraft(PartyDraft draft) => Party(
        id: draft.id,
        name: draft.name,
        phone: draft.phone,
        email: draft.email,
        tin: draft.custTin,
        branchId: draft.branchId,
        customerType: draft.customerType,
        address: draft.address,
        custNo: draft.custNo,
        regrNm: draft.regrNm,
        regrId: draft.regrId,
        modrNm: draft.modrNm,
        modrId: draft.modrId,
        bhfId: draft.bhfId,
        updatedAtIso: draft.updatedAt.toIso8601String(),
        kind: draft.kind,
      );

  final String id;
  final String name;
  final String phone;
  final String email;
  final String tin;
  final String branchId;
  final String customerType;
  final String? address;
  final String? custNo;
  final String? regrNm;
  final String? regrId;
  final String? modrNm;
  final String? modrId;
  final bool ebmSynced;
  final String bhfId;
  final String useYn;
  final String? updatedAtIso;
  final PartyKind kind;

  Party copyWith({
    String? name,
    String? phone,
    String? email,
    String? tin,
    String? branchId,
    String? customerType,
    String? address,
    String? updatedAtIso,
  }) =>
      Party(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        tin: tin ?? this.tin,
        branchId: branchId ?? this.branchId,
        customerType: customerType ?? this.customerType,
        address: address ?? this.address,
        custNo: custNo,
        regrNm: regrNm,
        regrId: regrId,
        modrNm: modrNm,
        modrId: modrId,
        ebmSynced: ebmSynced,
        bhfId: bhfId,
        useYn: useYn,
        updatedAtIso: updatedAtIso ?? this.updatedAtIso,
        kind: kind,
      );
}
