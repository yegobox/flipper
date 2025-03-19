import 'package:flipper_dashboard/features/incoming_orders/widgets/request_header.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestCard extends ConsumerWidget {
  final InventoryRequest request;
  final Branch incomingBranch;

  const RequestCard({
    Key? key,
    required this.request,
    required this.incomingBranch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: RequestHeader(request: request),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BranchInfo(request: request, incomingBranch: incomingBranch),
                  SizedBox(height: 16.0),
                  ItemsList(request: request),
                  SizedBox(height: 16.0),
                  StatusDeliveryInfo(request: request),
                  if (request.orderNote?.isNotEmpty ?? false) ...[
                    SizedBox(height: 16.0),
                    OrderNote(request: request),
                  ],
                  SizedBox(height: 20.0),
                  ActionRow(request: request),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
