import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:supabase_models/brick/models/customer.model.dart';

/// POS-only bridge from the pure [PartyDraft] to the Brick [Customer] model.
///
/// Lives in its own file so the wasm-compiled web app never has to import
/// the Brick model graph (sqflite/proxy — not web-safe). Web code must
/// import party_draft.dart / party_validation.dart only.
Customer customerFromDraft(PartyDraft draft) {
  return Customer(
    id: draft.id,
    custNm: draft.name,
    custTin: draft.custTin,
    email: draft.email,
    telNo: draft.phone,
    adrs: draft.address,
    updatedAt: draft.updatedAt,
    branchId: draft.branchId,
    // NOTE: the Customer constructor ignores this and derives custNo from
    // telNo (strips the leading zero) — passed for documentation parity.
    custNo: draft.custNo,
    regrNm: draft.regrNm,
    modrId: draft.modrId,
    regrId: draft.regrId,
    ebmSynced: false,
    modrNm: draft.modrNm,
    bhfId: draft.bhfId,
    useYn: 'N',
    customerType: draft.customerType,
  );
}
