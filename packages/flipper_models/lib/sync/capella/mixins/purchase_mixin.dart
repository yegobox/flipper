import 'package:flipper_accounting/purchase_journal_poster.dart' show supplierContactToRow;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/supplier_factory.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

/// Capella: RRA sync via data-connector; manual purchases saved to Ditto only.
mixin CapellaPurchaseMixin on PurchaseMixin implements PurchaseInterface {
  @override
  Repository get repository;

  @override
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  @override
  Future<Purchase> saveManualPurchase({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
  }) {
    return ManualPurchaseDitto.save(
      purchase: purchase,
      branchId: branchId,
      supplier: supplier,
    );
  }

  /// Manual purchases stored in Ditto (`regTyCd: 'M'`) for list merge in UI.
  Future<List<Purchase>> manualPurchasesFromDitto(
    String branchId, {
    String? statusFilter,
  }) {
    return ManualPurchaseDitto.listForBranch(
      branchId,
      statusFilter: statusFilter,
    );
  }

  @override
  @override
  Future<Supplier> upsertSupplierParty(PartyDraft draft) async {
    if (draft.kind != PartyKind.supplier) {
      throw ArgumentError('upsertSupplierParty requires PartyKind.supplier');
    }

    final supplier = supplierFromDraft(draft);

    await dittoService.upsertPartyDoc(
      'suppliers',
      draft.id,
      draft.toDittoRow(),
    );

    final ditto = dittoService.dittoInstance;
    if (ditto != null) {
      final doc = await SupplierDittoAdapter.instance.toDittoDocument(supplier);
      await ditto.store.execute(
        'INSERT INTO suppliers DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
    }

    final businessId = ProxyService.box.getBusinessId();
    if (businessId != null && businessId.isNotEmpty && dittoService.isReady()) {
      final result = await dittoService.dittoInstance?.store.execute(
        'SELECT * FROM accounting_contacts '
        'WHERE businessId = :businessId AND contactKind = :kind',
        arguments: {'businessId': businessId, 'kind': 'supplier'},
      );
      final count = result?.items.length ?? 0;
      final localId = 'S-${count + 1}';
      final since = DateFormat('MMM y').format(DateTime.now());
      final docId = '${businessId}_supplier_$localId';
      await dittoService.upsertAccountingContact(
        businessId,
        supplierContactToRow(
          businessId: businessId,
          docId: docId,
          localId: localId,
          partyId: draft.id,
          name: draft.name,
          phone: draft.phone,
          email: draft.email,
          tin: draft.tin ?? '',
          sinceLabel: since,
        ),
        docId,
      );
    }

    return supplier;
  }
}
