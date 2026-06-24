import 'package:flipper_services/constants.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/proxy.dart';

/// Cross-cutting actions invoked from global keyboard shortcuts.
///
/// Add new domain helpers here, then bind them to [Intent]s in the dashboard
/// (or another shell) via [Shortcuts] / [Actions].
class GlobalAppShortcutService {
  GlobalAppShortcutService({KeyPadService? keypad})
    : _keypad = keypad ?? ProxyService.keypad;

  final KeyPadService _keypad;

  /// Multi-line summary of the current pending **sale** cart for sharing / support.
  Future<String> buildPendingSaleTransactionClipboardText() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return 'No branch is selected.';
    }

    final transaction = await _keypad.getPendingTransaction(branchId: branchId);
    if (transaction == null) {
      return 'No pending sale transaction.';
    }

    final activeBranch = await ProxyService.strategy.activeBranch(
      branchId: branchId,
    );
    final items = await ProxyService.strategy.transactionItems(
      branchId: activeBranch.id,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );

    final buf = StringBuffer()
      ..writeln('Flipper — pending sale')
      ..writeln('Transaction ID: ${transaction.id}')
      ..writeln(
        'Reference: ${transaction.reference ?? transaction.transactionNumber ?? '—'}',
      )
      ..writeln('Status: ${transaction.status ?? '—'}')
      ..writeln('Type: ${transaction.transactionType ?? TransactionType.sale}')
      ..writeln('Subtotal: ${transaction.subTotal ?? 0}')
      ..writeln('Payment: ${transaction.paymentType ?? '—'}')
      ..writeln(
        'Customer: ${transaction.customerName ?? transaction.customerId ?? '—'}',
      )
      ..writeln('Line items (${items.length}):');

    if (items.isEmpty) {
      buf.writeln('  (no lines yet)');
    } else {
      for (final item in items) {
        final lineTotal = item.totAmt ?? (item.qty * item.price);
        buf.writeln(
          '  - ${item.name}  x${item.qty}  @${item.price}  = $lineTotal',
        );
      }
    }

    return buf.toString();
  }
}
