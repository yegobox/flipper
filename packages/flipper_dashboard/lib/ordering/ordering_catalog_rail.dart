import 'package:flipper_dashboard/ordering/ordering_catalog.dart';
import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Left rail: narrow the catalogue, and see what you last bought here.
class OrderingCatalogRail extends ConsumerWidget {
  const OrderingCatalogRail({
    super.key,
    required this.supplierId,
    this.marginColumnFits = true,
  });

  final String supplierId;

  /// Whether the catalogue pane is wide enough to render the margin column.
  /// When it is not, the toggle is not offered rather than offered inertly.
  final bool marginColumnFits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(orderingCatalogProvider).value;
    final selected = ref.watch(orderingCategoryProvider);
    final stockOnly = ref.watch(orderingStockOnlyProvider);
    final showMargin = ref.watch(orderingShowMarginProvider);
    final categories = catalog?.categories ?? const <OrderingCategory>[];

    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surface,
        border: Border(right: BorderSide(color: OrderingTokens.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const OrderingEyebrow(
                    'Categories',
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 6),
                  ),
                  if (categories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Loading…',
                        style: OrderingTokens.body,
                      ),
                    )
                  else
                    for (final category in categories)
                      _CategoryRow(
                        category: category,
                        selected: category.name == selected,
                        onTap: () => ref
                            .read(orderingCategoryProvider.notifier)
                            .state = category.name,
                      ),
                  const SizedBox(height: 22),
                  const OrderingEyebrow(
                    'Filter',
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderingCheckbox(
                          value: stockOnly,
                          label: 'In stock only',
                          onChanged: () => ref
                              .read(orderingStockOnlyProvider.notifier)
                              .state = !stockOnly,
                        ),
                        // The handoff makes the margin column a build-time
                        // prop. On a real buying desk it is the one column
                        // whose usefulness changes per operator, so it gets a
                        // control rather than a constant.
                        if (marginColumnFits) ...[
                          const SizedBox(height: 10),
                          OrderingCheckbox(
                            value: showMargin,
                            label: 'Show retail margin',
                            onChanged: () => ref
                                .read(orderingShowMarginProvider.notifier)
                                .state = !showMargin,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          stockOnly
                              ? 'Hiding items the supplier has none of.'
                              : 'Out-of-stock items still show, marked red.',
                          style: OrderingTokens.body.copyWith(
                            fontSize: 12.5,
                            color: OrderingTokens.ink4,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _LastOrderCard(supplierId: supplierId),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final OrderingCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OrderingHover(
      builder: (context, hovered) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? OrderingTokens.blueTint
                : (hovered ? OrderingTokens.bg : Colors.transparent),
            borderRadius: const BorderRadius.all(
              Radius.circular(OrderingTokens.rStepper),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.label,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: OrderingTokens.sans,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? OrderingTokens.blueHover
                        : OrderingTokens.ink2,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${category.count}',
                style: OrderingTokens.monoStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? OrderingTokens.blueCount
                      : OrderingTokens.ink6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LastOrderCard extends ConsumerWidget {
  const _LastOrderCard({required this.supplierId});

  final String supplierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = ref.watch(orderingLastOrderProvider(supplierId)).value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: const BoxDecoration(
        color: OrderingTokens.surfaceInset,
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrderingEyebrow('Last order'),
          const SizedBox(height: 7),
          if (last == null)
            Text(
              'No previous order with this supplier.',
              style: OrderingTokens.body.copyWith(
                fontSize: 12.5,
                height: 1.45,
              ),
            )
          else ...[
            Text(
              orderingMoney(last.total),
              style: OrderingTokens.monoStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _meta(last),
              style: OrderingTokens.body.copyWith(fontSize: 12.5),
            ),
          ],
        ],
      ),
    );
  }

  static String _meta(LastOrder last) {
    final parts = <String>[
      '${last.lineCount} ${last.lineCount == 1 ? 'line' : 'lines'}',
      if (last.placedAt != null)
        DateFormat('d MMM y').format(last.placedAt!.toLocal()),
      _statusLabel(last.status),
    ];
    return parts.join(' · ');
  }

  static String _statusLabel(String status) {
    return switch (status) {
      RequestStatus.pending => 'awaiting approval',
      RequestStatus.approved => 'approved',
      RequestStatus.partiallyApproved => 'partly approved',
      _ => status,
    };
  }
}
