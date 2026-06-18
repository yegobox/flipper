import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:supabase_models/brick/models/supplier.model.dart';

/// POS bridge from the pure [PartyDraft] to the Brick [Supplier] model.
Supplier supplierFromDraft(PartyDraft draft) {
  assert(draft.kind == PartyKind.supplier);
  final tin = draft.tin?.trim();
  final phone = draft.phone.trim();
  return Supplier(
    id: draft.id,
    custNm: draft.name,
    custTin: tin != null && tin.isNotEmpty ? tin : null,
    email: draft.email.isNotEmpty ? draft.email : null,
    telNo: phone.isNotEmpty ? phone : null,
    adrs: draft.address,
    updatedAt: draft.updatedAt,
    branchId: draft.branchId,
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
