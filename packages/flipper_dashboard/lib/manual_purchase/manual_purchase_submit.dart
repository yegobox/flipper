import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_models/services/pos_purchase_journal_poster.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
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
        title: const Text('Duplicate invoice'),
        content: const Text(
          'A purchase with this invoice number already exists for this '
          'branch. Save anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save anyway'),
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
      await ManualPurchaseDitto.setPurchaseStatus(
        purchase: saved,
        pchsSttsCd: '02',
      );
      await PosPurchaseJournalPoster.postPurchase(
        purchase: saved,
        postToLedger: true,
        supplierId: terms.selectedSupplierId,
        paidUpfront: paidUpfront,
        dueDate: terms.dueDate,
      );
      toast('Purchase recorded and approved');
    } catch (e) {
      // The purchase stays in Waiting; nothing is lost.
      toast('Purchase saved as waiting. Approval failed: $e');
    }
  } else {
    // The draft bill carries the credit terms until the purchase is approved.
    await PosPurchaseJournalPoster.postPurchase(
      purchase: saved,
      postToLedger: false,
      supplierId: terms.selectedSupplierId,
      paidUpfront: paidUpfront,
      dueDate: terms.dueDate,
    );
    toast('Purchase saved as waiting');
  }
  return true;
}
