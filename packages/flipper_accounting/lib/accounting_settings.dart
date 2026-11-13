import 'package:flipper_accounting/accounting_ditto_store.dart';

/// Books' per-business accounting settings: Ditto `accounting_settings`,
/// document `as_<businessId>` (the one data-connector seeds with the
/// default accounts; Books only adds its own fields to it).
///
/// [vatRegistered] is for a business with **no** EBM branch: is it
/// nevertheless registered for VAT with RRA (receipts from another EBM)?
/// - No (default): it owes no VAT. Its sales carry none, and the VAT it pays
///   on purchases is part of what the stock cost, so nothing reaches 2100.
/// - Yes: the ledger books VAT both ways, like an EBM business. data-connector
///   books output VAT on sales made from [vatRegisteredChangedAt] on.
///
/// EBM branches (`ebm.vatEnabled`) always book VAT, whatever this says.
class AccountingSettings {
  const AccountingSettings({
    this.vatRegistered = false,
    this.vatRegisteredChangedAt,
  });

  static const collection = 'accounting_settings';

  static String docId(String businessId) => 'as_$businessId';

  final bool vatRegistered;
  final DateTime? vatRegisteredChangedAt;

  factory AccountingSettings.fromRow(Map<String, dynamic>? row) {
    if (row == null) return const AccountingSettings();
    final raw = row['vatRegistered'] ?? row['vat_registered'];
    final changed =
        row['vatRegisteredChangedAt'] ?? row['vat_registered_changed_at'];
    return AccountingSettings(
      vatRegistered: raw == true,
      vatRegisteredChangedAt: changed == null
          ? null
          : DateTime.tryParse(changed.toString()),
    );
  }
}

/// Whether a purchase's VAT goes into the stock cost instead of 2100: no
/// EBM branch of the business has VAT on ([businessHasVatEbm], business-wide
/// like data-connector's `hasEbmBranch`) and Books does not say the business
/// is registered.
bool capitalizesPurchaseVat({
  required bool businessHasVatEbm,
  required AccountingSettings settings,
}) => !businessHasVatEbm && !settings.vatRegistered;

/// [capitalizesPurchaseVat] for a purchase being posted. An unknown EBM state
/// ([businessHasVatEbm] `null`) or a settings read that fails keeps the VAT
/// on 2100 as before, so the purchase still posts.
Future<bool> resolvePurchaseVatIsCost({
  required bool? businessHasVatEbm,
  required AccountingSettingsStore store,
  required String businessId,
}) async {
  if (businessHasVatEbm == null) return false;
  final AccountingSettings settings;
  try {
    settings = await store.read(businessId);
  } catch (_) {
    return false;
  }
  return capitalizesPurchaseVat(
    businessHasVatEbm: businessHasVatEbm,
    settings: settings,
  );
}

/// Reads and writes [AccountingSettings].
class AccountingSettingsStore {
  AccountingSettingsStore(this._ditto);

  final AccountingDittoStore _ditto;

  static const _byId =
      'SELECT * FROM ${AccountingSettings.collection} WHERE _id = :id';

  /// The business's settings; defaults when the document is missing or the
  /// store is not ready.
  Future<AccountingSettings> read(String businessId) async {
    if (businessId.isEmpty || !_ditto.isReady()) {
      return const AccountingSettings();
    }
    final rows = await _ditto.queryCollection(
      AccountingSettings.collection,
      _byId,
      {'id': AccountingSettings.docId(businessId)},
    );
    return AccountingSettings.fromRow(rows.isEmpty ? null : rows.first);
  }

  Stream<AccountingSettings> watch(String businessId) => _ditto
      .watchCollection(AccountingSettings.collection, _byId, {
        'id': AccountingSettings.docId(businessId),
      })
      .map(
        (rows) => AccountingSettings.fromRow(rows.isEmpty ? null : rows.first),
      );

  /// Records whether the business is registered for VAT. Only these fields
  /// are written; the seeded defaults in the same document stay as they are.
  ///
  /// Throws [StateError] when nothing can be saved (no business, or the store
  /// is not ready), so the caller can say so and the old setting stands.
  Future<void> setVatRegistered({
    required String businessId,
    required bool registered,
    DateTime? now,
  }) async {
    if (businessId.isEmpty || !_ditto.isReady()) {
      throw StateError('Accounting settings cannot be saved right now');
    }
    final at = (now ?? DateTime.now()).toUtc().toIso8601String();
    await _ditto.upsertPartyDoc(
      AccountingSettings.collection,
      AccountingSettings.docId(businessId),
      {
        'businessId': businessId,
        'business_id': businessId,
        'vatRegistered': registered,
        'vat_registered': registered,
        'vatRegisteredChangedAt': at,
        'vat_registered_changed_at': at,
      },
    );
  }
}
