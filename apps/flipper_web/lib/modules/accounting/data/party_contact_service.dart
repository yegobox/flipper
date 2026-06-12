import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:flipper_web/modules/accounting/data/repository/party_repository.dart';

/// Dual-write: canonical party row + accounting contact extension.
Future<({PartyDraft draft, String localId})> savePartyContactWithBranch({
  required PartyRepository partyRepository,
  required AccountingDocumentsRepository documentsRepository,
  required String businessId,
  required String branchId,
  required bool isCustomer,
  required AccountingContact contact,
  required int existingContactCount,
}) async {
  final draft = PartyDraft(
    name: contact.name,
    phone: contact.phone,
    email: contact.email,
    tin: contact.tin,
    customerType: 'Business',
    branchId: branchId,
    kind: isCustomer ? PartyKind.customer : PartyKind.supplier,
  );
  await partyRepository.upsertParty(Party.fromDraft(draft));

  final prefix = isCustomer ? 'C' : 'S';
  final localId = '$prefix-${existingContactCount + 1}';
  await documentsRepository.upsertContact(
    businessId: businessId,
    isCustomer: isCustomer,
    contact: contact.copyWith(id: localId, partyId: draft.id),
  );
  return (draft: draft, localId: localId);
}
