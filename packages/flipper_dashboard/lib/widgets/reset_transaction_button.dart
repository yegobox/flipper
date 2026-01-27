import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';

/// A button widget that allows users to reset/delete the current pending transaction
/// with a confirmation dialog to prevent accidental deletions.
class ResetTransactionButton extends ConsumerWidget {
  const ResetTransactionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );

    return transactionAsyncValue.maybeWhen(
      data: (transaction) {
        // Prevent resetting if it's a ticket (has ticketName) or has partial payments
        final bool isTicket =
            transaction.ticketName != null &&
            transaction.ticketName!.isNotEmpty;
        final bool hasPayments =
            (transaction.cashReceived ?? 0) > 0 ||
            (transaction.payments?.isNotEmpty ?? false);

        if (isTicket || hasPayments) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(
            FluentIcons.delete_16_regular,
            color: Colors.red,
            size: 20,
          ),
          tooltip: 'Reset Transaction',
          onPressed: () async {
            final dialogService = locator<DialogService>();
            final response = await dialogService.showCustomDialog(
              variant: DialogType.info,
              title: 'Reset Transaction?',
              description:
                  'This will delete the current pending transaction and all its items. This action cannot be undone.',
              data: {'status': InfoDialogStatus.warning},
            );

            if (response?.confirmed == true && context.mounted) {
              await _resetTransaction(context, ref, transaction);
            }
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  /// Resets the transaction by deleting it and refreshing the stream
  Future<void> _resetTransaction(
    BuildContext context,
    WidgetRef ref,
    ITransaction transaction,
  ) async {
    try {
      // Delete the pending transaction
      await ProxyService.strategy.flipperDelete(
        id: transaction.id,
        endPoint: 'transaction',
      );

      // Refresh the transaction stream
      if (context.mounted) {
        ref.invalidate(pendingTransactionStreamProvider(isExpense: false));

        // Show success message
        _showSuccessMessage(context);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, e);
      }
    }
  }

  /// Shows a success message after successfully resetting the transaction
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Transaction reset successfully'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Shows an error message if the transaction reset fails
  void _showErrorMessage(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text('Error resetting transaction: $error'),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
