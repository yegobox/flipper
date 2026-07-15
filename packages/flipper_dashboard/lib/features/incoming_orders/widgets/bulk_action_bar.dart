import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        color: OmTokens.surface,
        border: const Border(top: BorderSide(color: OmTokens.line)),
        boxShadow: OmTokens.shadowSm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: OmTokens.accentWash,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${selectedIds.length} selected',
                style: OmTokens.text(
                  color: OmTokens.accentStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                ref.read(selectionProvider.notifier).deselectAll();
              },
              child: Text(
                'Cancel',
                style: OmTokens.text(
                  color: OmTokens.ink2,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                backgroundColor: OmTokens.greenStrong,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(OmTokens.radiusSm),
                ),
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Approve'),
            ),
            const SizedBox(width: 8),
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
                backgroundColor: OmTokens.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(OmTokens.radiusSm),
                ),
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
