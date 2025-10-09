import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';

/// A button widget that allows users to reset/delete the current pending transaction
/// with a confirmation dialog to prevent accidental deletions.
class ResetTransactionButton extends ConsumerWidget {
  const ResetTransactionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsyncValue =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    return transactionAsyncValue.maybeWhen(
      data: (transaction) => IconButton(
        icon: const Icon(
          FluentIcons.delete_16_regular,
          color: Colors.red,
          size: 20,
        ),
        tooltip: 'Reset Transaction',
        onPressed: () =>
            _showResetConfirmationDialog(context, ref, transaction),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  /// Shows a confirmation dialog before resetting the transaction
  Future<void> _showResetConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange[700],
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Reset Transaction?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'This will delete the current pending transaction and all its items. This action cannot be undone.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reset'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await _resetTransaction(context, ref, transaction);
    }
  }

  /// Resets the transaction by deleting it and refreshing the stream
  Future<void> _resetTransaction(
    BuildContext context,
    WidgetRef ref,
    dynamic transaction,
  ) async {
    try {
      // Delete the pending transaction
      await ProxyService.strategy.flipperDelete(
        id: transaction.id,
        endPoint: 'transaction',
      );

      // Refresh the transaction stream
      if (context.mounted) {
        ref.invalidate(pendingTransactionStreamProvider(
          isExpense: false,
        ));

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
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text('Transaction reset successfully'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows an error message if the transaction reset fails
  void _showErrorMessage(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text('Error resetting transaction: $error'),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
