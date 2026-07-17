import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_header.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final selectionMode = selectedIds.isNotEmpty;
    final open = useState(false);

    return Container(
      decoration: BoxDecoration(
        color: OmTokens.surface,
        borderRadius: BorderRadius.circular(OmTokens.radiusLg),
        border: Border.all(
          color: isSelected ? OmTokens.accent : OmTokens.line,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: OmTokens.shadowSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => open.value = !open.value,
              onLongPress: () {
                ref.read(selectionProvider.notifier).toggle(request.id);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    if (selectionMode) ...[
                      Checkbox(
                        value: isSelected,
                        activeColor: OmTokens.accent,
                        onChanged: (_) {
                          ref
                              .read(selectionProvider.notifier)
                              .toggle(request.id);
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: RequestHeader(
                        request: request,
                        isIncoming: isIncoming,
                        expanded: open.value,
                        onToggle: () => open.value = !open.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (open.value)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: OmTokens.line),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BranchInfo(
                    request: request,
                    activeBranch: incomingBranch,
                    isIncoming: isIncoming,
                  ),
                  const SizedBox(height: 18),
                  ItemsList(request: request, isIncoming: isIncoming),
                  const SizedBox(height: 18),
                  StatusDeliveryInfo(request: request),
                  if (request.orderNote?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 18),
                    OrderNote(request: request),
                  ],
                  if (isIncoming) ...[
                    const SizedBox(height: 4),
                    ActionRow(request: request),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
