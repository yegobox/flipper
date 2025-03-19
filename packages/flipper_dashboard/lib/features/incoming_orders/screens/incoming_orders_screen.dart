import 'package:flipper_dashboard/NoOrderPlaceholder.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomingOrdersScreen extends HookConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final stockRequests =
        ref.watch(stockRequestsProvider((filter: stringValue)));
    final incomingBranchAsync = ref.watch(activeBranchProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: stockRequests.when(
          data: (requests) {
            if (requests.isEmpty) {
              return buildNoOrdersPlaceholder();
            }

            return incomingBranchAsync.when(
              data: (incomingBranch) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) => RequestCard(
                    request: requests[index],
                    incomingBranch: incomingBranch,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    SizedBox(height: 16),
                    Text(
                      'Error loading branch',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      err.toString(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                SizedBox(height: 16),
                Text(
                  'Error loading requests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  err.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
