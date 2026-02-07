import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_header.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/providers/selection_provider.dart';

class RequestCard extends HookConsumerWidget {
  final InventoryRequest request;
  final Branch incomingBranch;
  final bool isIncoming;

  const RequestCard({
    Key? key,
    required this.request,
    required this.incomingBranch,
    this.isIncoming = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectionProvider);
    final isSelected = selectedIds.contains(request.id);

    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: selectedIds.isNotEmpty
              ? Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    ref.read(selectionProvider.notifier).toggle(request.id);
                  },
                )
              : null,
          title: GestureDetector(
            onLongPress: () {
              ref.read(selectionProvider.notifier).toggle(request.id);
            },
            child: RequestHeader(request: request),
          ),
          children: [
            GestureDetector(
              onLongPress: () {
                ref.read(selectionProvider.notifier).toggle(request.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BranchInfo(
                      request: request,
                      incomingBranch: incomingBranch,
                    ),
                    SizedBox(height: 16.0),
                    ItemsList(request: request, isIncoming: isIncoming),
                    SizedBox(height: 16.0),
                    StatusDeliveryInfo(request: request),
                    if (request.orderNote?.isNotEmpty ?? false) ...[
                      SizedBox(height: 16.0),
                      OrderNote(request: request),
                    ],
                    SizedBox(height: 20.0),
                    if (isIncoming) ActionRow(request: request),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
