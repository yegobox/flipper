import 'package:flipper_dashboard/checkout.dart' show OrderStatus;
import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_request_detail.dart';
import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_request_table.dart';
import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart'
    show OmDirection;
import 'package:flipper_dashboard/features/incoming_orders/widgets/bulk_action_bar.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/online_orders_view.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Desktop Orders page: a toolbar (direction tabs, status filter) over a
/// request table and the selected request's detail.
///
/// Pure layout. Every provider read, filter write and refresh stays in
/// [IncomingOrdersScreen], which also keeps the phone layout.
class OrdersDesktopView extends StatelessWidget {
  const OrdersDesktopView({
    super.key,
    required this.direction,
    required this.onDirection,
    required this.shopAvailable,
    required this.newOnline,
    required this.incomingCount,
    required this.outgoingCount,
    required this.orderStatus,
    required this.onStatusChanged,
    required this.onRefresh,
    required this.requestsAsync,
    required this.branchAsync,
    required this.status,
    required this.onLoadMore,
    required this.onRetryRequests,
    required this.onRetryBranch,
  });

  final OmDirection direction;
  final ValueChanged<OmDirection> onDirection;
  final bool shopAvailable;
  final int newOnline;
  final int? incomingCount;
  final int? outgoingCount;
  final OrderStatus orderStatus;
  final ValueChanged<OrderStatus> onStatusChanged;
  final VoidCallback onRefresh;
  final AsyncValue<List<InventoryRequest>> requestsAsync;
  final AsyncValue<Branch?> branchAsync;
  final String status;
  final VoidCallback onLoadMore;
  final VoidCallback onRetryRequests;
  final VoidCallback onRetryBranch;

  bool get _isOnline => direction == OmDirection.online;
  bool get _isIncoming => direction == OmDirection.incoming;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return ColoredBox(
      color: PosTokens.posBg,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Toolbar(
                tabs: [
                  _TabSpec(
                    OmDirection.incoming,
                    l10n.incomingOrdersIncoming,
                    Icons.move_to_inbox_outlined,
                    incomingCount,
                  ),
                  _TabSpec(
                    OmDirection.outgoing,
                    l10n.incomingOrdersOutgoing,
                    Icons.outbox_outlined,
                    outgoingCount,
                  ),
                  if (shopAvailable)
                    _TabSpec(
                      OmDirection.online,
                      l10n.onlineOrdersTab,
                      Icons.storefront_outlined,
                      newOnline,
                    ),
                ],
                selected: direction,
                onSelect: onDirection,
                trailing: _isOnline
                    ? const []
                    : [
                        _StatusFilter(
                          value: orderStatus,
                          onChanged: onStatusChanged,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: l10n.refresh,
                          onPressed: onRefresh,
                          iconSize: PosTokens.iconMd,
                          style: IconButton.styleFrom(
                            foregroundColor: PosTokens.ink2,
                            fixedSize: const Size.square(
                              PosTokens.controlHeightSm,
                            ),
                            minimumSize: const Size.square(
                              PosTokens.controlHeightSm,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                PosTokens.radiusMd,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
              ),
              Expanded(
                child: _isOnline
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1040),
                          child: const OnlineOrdersView(
                            padding: EdgeInsets.fromLTRB(24, 20, 24, 80),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: _requests(context),
                      ),
              ),
            ],
          ),
          if (!_isOnline)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BulkActionBar(),
            ),
        ],
      ),
    );
  }

  Widget _requests(BuildContext context) {
    final l10n = context.flipperL10n;
    final title = _isIncoming
        ? l10n.incomingOrdersReceivedOrders
        : l10n.incomingOrdersSentOrders;

    Widget shell(Widget body, {int? count}) => _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrdersTableCaption(title: title, count: count),
          OrdersTableHeader(showCheckbox: _isIncoming),
          Expanded(child: body),
        ],
      ),
    );

    final loading = shell(
      const Align(
        alignment: Alignment.topCenter,
        child: LinearProgressIndicator(
          minHeight: 2,
          color: PosTokens.blue,
          backgroundColor: PosTokens.blueTint,
        ),
      ),
    );

    // Keep the table up while a stream reloads (filter flip, refresh)
    // instead of flashing the loading bar.
    return requestsAsync.when(
      skipLoadingOnReload: true,
      loading: () => loading,
      error: (err, _) => shell(
        _Message(
          icon: Icons.error_outline,
          tone: PosTokens.lossInk,
          title: l10n.incomingOrdersErrorLoadingRequests,
          message: '$err',
          onRetry: onRetryRequests,
        ),
      ),
      data: (requests) => branchAsync.when(
        skipLoadingOnReload: true,
        loading: () => loading,
        error: (err, _) => shell(
          _Message(
            icon: Icons.error_outline,
            tone: PosTokens.lossInk,
            title: l10n.incomingOrdersErrorLoadingBranch,
            message: '$err',
            onRetry: onRetryBranch,
          ),
        ),
        data: (branch) {
          if (branch == null) {
            return shell(
              _Message(
                icon: Icons.error_outline,
                tone: PosTokens.lossInk,
                title: l10n.incomingOrdersBranchNotFound,
                message: l10n.incomingOrdersBranchLoadFailed,
                onRetry: onRetryBranch,
              ),
            );
          }
          if (requests.isEmpty) {
            return shell(
              _Message(
                icon: Icons.move_to_inbox_outlined,
                tone: PosTokens.ink3,
                title: l10n.incomingOrdersNoRequests(status),
                message: l10n.incomingOrdersNothingToShow,
              ),
              count: 0,
            );
          }
          return _Workspace(
            // A new tab or filter starts from its own first row.
            key: ValueKey('$direction/$status'),
            title: title,
            requests: requests,
            branch: branch,
            isIncoming: _isIncoming,
            onLoadMore: onLoadMore,
          );
        },
      ),
    );
  }
}

/// Table + detail, side by side. Owns which row is open.
class _Workspace extends HookWidget {
  const _Workspace({
    super.key,
    required this.title,
    required this.requests,
    required this.branch,
    required this.isIncoming,
    required this.onLoadMore,
  });

  final String title;
  final List<InventoryRequest> requests;
  final Branch branch;
  final bool isIncoming;
  final VoidCallback onLoadMore;

  /// Detail width; the table takes the rest.
  static const double detailWidth = 440;

  @override
  Widget build(BuildContext context) {
    final picked = useState<String?>(null);
    // Falls back to the first row when nothing is picked yet or the picked
    // request left the list (approved elsewhere, filter changed upstream).
    InventoryRequest? selected;
    for (final r in requests) {
      if (r.id == picked.value) {
        selected = r;
        break;
      }
    }
    selected ??= requests.first;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _Card(
            child: OrdersRequestTable(
              title: title,
              requests: requests,
              selectedId: selected.id,
              onSelect: (id) => picked.value = id,
              isIncoming: isIncoming,
              onLoadMore: onLoadMore,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: detailWidth,
          child: _Card(
            child: OrdersRequestDetail(
              key: ValueKey(selected.id),
              request: selected,
              activeBranch: branch,
              isIncoming: isIncoming,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(PosTokens.radiusLg),
        border: Border.all(color: PosTokens.line),
        boxShadow: PosTokens.shadow1,
      ),
      child: child,
    );
  }
}

/// Empty / error state inside the table card: small and quiet, the way a
/// work queue says "nothing to do".
class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.tone,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PosTokens.surface2,
                  borderRadius: BorderRadius.circular(PosTokens.radiusLg),
                  border: Border.all(color: PosTokens.line),
                ),
                child: Icon(icon, size: 22, color: tone),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: PosTokens.sectionTitle.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: PosTokens.body.copyWith(color: PosTokens.ink3),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(context.flipperL10n.incomingOrdersTryAgain),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PosTokens.blue,
                    side: const BorderSide(color: PosTokens.blue),
                    minimumSize: const Size(0, PosTokens.controlHeightSm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(PosTokens.radiusMd),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.value, this.label, this.icon, this.count);

  final OmDirection value;
  final String label;
  final IconData icon;
  final int? count;
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.tabs,
    required this.selected,
    required this.onSelect,
    required this.trailing,
  });

  final List<_TabSpec> tabs;
  final OmDirection selected;
  final ValueChanged<OmDirection> onSelect;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PosTokens.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: PosTokens.surface,
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tab in tabs)
            _Tab(
              spec: tab,
              selected: tab.value == selected,
              onTap: () => onSelect(tab.value),
            ),
          const Spacer(),
          if (trailing.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: trailing),
        ],
      ),
    );
  }
}

/// Underline tab with an optional count. Selected = ink + 2px brand bar.
class _Tab extends StatefulWidget {
  const _Tab({required this.spec, required this.selected, required this.onTap});

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final fg = selected
        ? PosTokens.ink1
        : _hover
        ? PosTokens.ink2
        : PosTokens.ink3;
    final count = widget.spec.count;

    return Semantics(
      selected: selected,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: PosTokens.hoverTransition,
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? PosTokens.blue : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.spec.icon,
                  size: PosTokens.iconSm,
                  color: selected ? PosTokens.blue : fg,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.spec.label,
                  style: PosTokens.bodyStrong.copyWith(
                    fontSize: 13.5,
                    color: fg,
                  ),
                ),
                if (count != null && count > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    constraints: const BoxConstraints(minWidth: 20),
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? PosTokens.blue : PosTokens.surface2,
                      borderRadius: BorderRadius.circular(9),
                      border: selected
                          ? null
                          : Border.all(color: PosTokens.line),
                    ),
                    child: Text(
                      '$count',
                      style: PosTokens.meta.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : PosTokens.ink2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Pending / Approved switch for the toolbar.
class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.value, required this.onChanged});

  final OrderStatus value;
  final ValueChanged<OrderStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final options = [
      (OrderStatus.pending, l10n.incomingOrdersStatusPending),
      (OrderStatus.approved, l10n.approved),
    ];
    return Container(
      height: PosTokens.controlHeightSm,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (option, label) in options)
            Semantics(
              selected: option == value,
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(option),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: PosTokens.hoverTransition,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: option == value
                          ? PosTokens.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                      boxShadow: option == value ? PosTokens.shadow1 : null,
                    ),
                    child: Text(
                      label,
                      style: PosTokens.bodyStrong.copyWith(
                        fontSize: 12.5,
                        color: option == value
                            ? PosTokens.ink1
                            : PosTokens.ink3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
