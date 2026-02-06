import 'package:flipper_models/SyncStrategy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';

class BulkActionBar extends HookConsumerWidget {
  const BulkActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectionProvider);

    if (selectedIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${selectedIds.length} selected',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                ref.read(selectionProvider.notifier).deselectAll();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () async {
                for (final id in selectedIds) {
                  await ProxyService.getStrategy(
                    Strategy.capella,
                  ).updateStockRequest(
                    stockRequestId: id,
                    status: RequestStatus.approved,
                  );
                }
                ref.read(selectionProvider.notifier).deselectAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Approve'),
            ),
            const SizedBox(width: 8),
            // Reject Button
            ElevatedButton.icon(
              onPressed: () async {
                for (final id in selectedIds) {
                  await ProxyService.getStrategy(
                    Strategy.capella,
                  ).updateStockRequest(
                    stockRequestId: id,
                    status: RequestStatus.rejected,
                  );
                }
                ref.read(selectionProvider.notifier).deselectAll();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Reject'),
            ),
          ],
        ),
      ),
    );
  }
}
