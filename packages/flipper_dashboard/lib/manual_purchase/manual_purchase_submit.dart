import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_stock_in.dart';
import 'package:flipper_models/services/purchase_expense_recorder.dart';
import 'package:flipper_models/services/pos_purchase_journal_poster.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

/// Saves the purchase held by [manualPurchaseProvider], shared by the desktop
/// form and the mobile screen. Returns true when the purchase was saved (the
/// caller then closes its screen); false when the user backed out or the
/// notifier rejected the input (its `error` explains why).
///
/// [approve] posts it to the ledger straight away; otherwise it waits for
/// approval, with the credit terms kept on its draft bill.
Future<bool> submitManualPurchase({
  required BuildContext context,
  required WidgetRef ref,
  required bool approve,
}) async {
  final notifier = ref.read(manualPurchaseProvider.notifier);

  if (await notifier.invoiceAlreadyExists()) {
    if (!context.mounted) return false;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.flipperL10n.manualPurchaseDuplicateInvoice),
        content: Text(context.flipperL10n.manualPurchaseDuplicateInvoiceBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.flipperL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.flipperL10n.manualPurchaseSaveAnyway),
          ),
        ],
      ),
    );
    if (proceed != true) return false;
  }

  final terms = ref.read(manualPurchaseProvider);
  final saved = await notifier.save();
  if (saved == null) return false;

  final paidUpfront = terms.pmtTyCd == '03' ? terms.paidUpfront : null;
  if (approve) {
    try {
      // Stock first: each line goes onto its product (created for new items).
      final stock = await stockInManualPurchase(saved);
      await PosPurchaseJournalPoster.postPurchase(
        purchase: saved,
        postToLedger: true,
        supplierId: terms.selectedSupplierId,
        paidUpfront: paidUpfront,
        dueDate: terms.isOnCredit ? terms.effectiveDueDate : null,
      );
      // What was paid now shows with the other expenses (like a cash-out).
      await PurchaseExpenseRecorder.record(
        purchase: saved,
        paidUpfront: paidUpfront ?? 0,
      );
      toast(
        stock.rraMessage ?? FlipperL10n.current.manualPurchaseRecordedApproved,
      );
    } catch (e) {
      // The purchase stays in Waiting; nothing is lost.
      toast(FlipperL10n.current.manualPurchaseApprovalFailed(e.toString()));
    }
  } else {
    // The draft bill carries the credit terms until the purchase is approved.
    await PosPurchaseJournalPoster.postPurchase(
      purchase: saved,
      postToLedger: false,
      supplierId: terms.selectedSupplierId,
      paidUpfront: paidUpfront,
      dueDate: terms.isOnCredit ? terms.effectiveDueDate : null,
    );
    toast(FlipperL10n.current.manualPurchaseSavedAsWaiting);
  }
  return true;
}
