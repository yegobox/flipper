import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/purchase_journal_poster.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

/// Fire-and-forget GL posting for manual purchases so Books finds bills/journals.
class PosPurchaseJournalPoster {
  PosPurchaseJournalPoster._();

  static final Talker _talker = Talker();

  static PurchasePostingInput inputFromPurchase(Purchase purchase) {
    final lines = purchase.variants ?? const <Variant>[];
    return PurchasePostingInput(
      purchaseId: purchase.id,
      supplierName: purchase.spplrNm,
      supplierTin: purchase.spplrTin,
      invoiceNo: purchase.spplrInvcNo,
      pmtTyCd: purchase.pmtTyCd,
      totAmt: purchase.totAmt.toDouble(),
      totTaxAmt: purchase.totTaxAmt.toDouble(),
      purchaseDate: purchase.createdAt,
      lines: [
        for (final v in lines)
          PurchasePostingLine(
            description: v.name ?? v.itemNm ?? 'Item',
            qty: v.qty?.toDouble() ?? 0,
            unitPrice: v.prc?.toDouble() ?? 0,
          ),
      ],
    );
  }

  /// Never throws — purchase persistence must not depend on GL success.
  static Future<void> postPurchase({
    required Purchase purchase,
    required bool postToLedger,
  }) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null || businessId.isEmpty) return;
      final ditto = DittoService.instance;
      if (!ditto.isReady()) return;

      final ledger = DittoAccountingLedgerRepository(ditto);
      await ledger.ensureSeeded(businessId: businessId);
      final accounts = await ledger
          .watchChartOfAccounts(businessId: businessId)
          .first
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => defaultChartOfAccountsSeed,
          );

      await PurchaseJournalPoster(
        ditto,
        audit: AuditTrailRecorder(ditto),
      ).postPurchaseRecorded(
        businessId: businessId,
        purchase: inputFromPurchase(purchase),
        accounts: accounts,
        postToLedger: postToLedger,
      );
    } catch (e, s) {
      _talker.error('[PosPurchaseJournalPoster] failed: $e', s);
    }
  }
}
