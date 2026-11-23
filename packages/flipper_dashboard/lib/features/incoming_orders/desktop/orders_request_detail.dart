import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_request_table.dart';
import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_status_chip.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/action_row.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/branch_info.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/items_list.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/status_delivery_info.dart'
    show OrderNote;
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Right-hand pane of the desktop Orders page: one request in full, with its
/// actions pinned to the bottom so Approve is always in reach however long
/// the item list gets.
///
/// Reuses the card's own pieces ([BranchInfo], [ItemsList], [OrderNote],
/// [ActionRow]), so approve / produce / void behave exactly as on phones.
class OrdersRequestDetail extends StatelessWidget {
  const OrdersRequestDetail({
    super.key,
    required this.request,
    required this.activeBranch,
    required this.isIncoming,
  });

  final InventoryRequest request;
  final Branch activeBranch;
  final bool isIncoming;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final (requested, approved) = requestQuantities(request);
    final isPending =
        (request.status ?? RequestStatus.pending) == RequestStatus.pending;
    final created = request.createdAt;
    final delivery = request.deliveryDate;
    final dateTime = DateFormat('d MMM yyyy, HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: reference + status, then the from → to flow.
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: PosTokens.line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      requestReference(request),
                      style: PosTokens.sectionTitle.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  OrdersStatusChip(status: request.status),
                ],
              ),
              const SizedBox(height: 12),
              BranchInfo(
                request: request,
                activeBranch: activeBranch,
                isIncoming: isIncoming,
                embedded: true,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              _FactGrid(
                facts: [
                  (
                    l10n.incomingOrdersRequestedOn,
                    created == null ? '—' : dateTime.format(created),
                  ),
                  (
                    l10n.incomingOrdersColDelivery,
                    delivery == null
                        ? '—'
                        : DateFormat('d MMM yyyy').format(delivery),
                  ),
                  (l10n.incomingOrdersColItems, '${requestLineCount(request)}'),
                  (
                    l10n.incomingOrdersColQty,
                    isPending ? '$requested' : '$approved / $requested',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ItemsList(request: request, isIncoming: isIncoming),
              if (request.orderNote?.isNotEmpty ?? false) ...[
                const SizedBox(height: 20),
                OrderNote(request: request),
              ],
            ],
          ),
        ),
        if (isIncoming)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            color: PosTokens.surface,
            child: ActionRow(request: request),
          ),
      ],
    );
  }
}

/// Label / value pairs, two per row.
class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.facts});

  final List<(String, String)> facts;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < facts.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 14));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Fact(fact: facts[i])),
            const SizedBox(width: 16),
            Expanded(
              child: i + 1 < facts.length
                  ? _Fact(fact: facts[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }
    return Column(children: rows);
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.fact});

  final (String, String) fact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fact.$1.toUpperCase(), style: PosTokens.eyebrow),
        const SizedBox(height: 4),
        Text(
          fact.$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: PosTokens.bodyStrong.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// What the pane shows before a row is picked.
class OrdersDetailPlaceholder extends StatelessWidget {
  const OrdersDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 28,
              color: PosTokens.ink4,
            ),
            const SizedBox(height: 10),
            Text(
              context.flipperL10n.incomingOrdersSelectRequest,
              textAlign: TextAlign.center,
              style: PosTokens.body.copyWith(color: PosTokens.ink3),
            ),
          ],
        ),
      ),
    );
  }
}
