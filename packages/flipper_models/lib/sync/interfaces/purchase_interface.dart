import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/db_model_export.dart';

/// Import/purchase RRA sync uses data-connector HTTP.
/// Manual purchases use Ditto via Capella [saveManualPurchase].
abstract class PurchaseInterface {
  Future<Purchase> saveManualPurchase({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
  });

  Future<Supplier> upsertSupplierParty(PartyDraft draft);
}
