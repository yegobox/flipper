import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_status_chip.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_by_id_provider.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

const double _rowHeight = 52;
const double _checkboxWidth = 40;
const double _hPad = 16;

/// The table's columns, in order.
enum OrdersColumn { branch, requested, items, qty, delivery, status }

/// Columns that fit a table [width] wide. Counts and status keep fixed
/// widths, so on a narrow desktop (the detail pane takes ~320–440px) the
/// table drops Delivery, then Items (both are in the detail pane) instead of
/// squeezing numbers to nothing.
List<OrdersColumn> ordersColumnsFor(double width) => [
  OrdersColumn.branch,
  OrdersColumn.requested,
  if (width >= 520) OrdersColumn.items,
  OrdersColumn.qty,
  if (width >= 640) OrdersColumn.delivery,
  OrdersColumn.status,
];

/// Number columns are right-aligned, with a wider gap after them so a number
/// never reads as part of the next column.
bool _isNumeric(OrdersColumn c) =>
    c == OrdersColumn.items || c == OrdersColumn.qty;

/// One cell, sized the same in the header and every row so they line up.
Widget _cell(OrdersColumn c, Widget child) {
  final padded = Padding(
    padding: EdgeInsets.only(right: _isNumeric(c) ? 20 : 12),
    child: child,
  );
  return switch (c) {
    OrdersColumn.items => SizedBox(width: 80, child: padded),
    OrdersColumn.qty => SizedBox(width: 92, child: padded),
    OrdersColumn.status => SizedBox(width: 112, child: padded),
    OrdersColumn.branch => Expanded(flex: 25, child: padded),
    OrdersColumn.requested => Expanded(flex: 20, child: padded),
    OrdersColumn.delivery => Expanded(flex: 15, child: padded),
  };
}

/// Requested vs approved units across a request's lines. Falls back to the
/// stored line count when the lines are not loaded with the request.
(int requested, int approved) requestQuantities(InventoryRequest request) {
  final items = request.transactionItems ?? const <TransactionItem>[];
  if (items.isEmpty) return (request.itemCounts?.toInt() ?? 0, 0);
  var requested = 0;
  var approved = 0;
  for (final item in items) {
    requested += item.quantityRequested ?? 0;
    approved += item.quantityApproved ?? 0;
  }
  return (requested, approved);
}

int requestLineCount(InventoryRequest request) =>
    request.transactionItems?.length ?? request.itemCounts?.toInt() ?? 0;

/// Short reference staff can read out; the same 5 characters the decline SMS
/// quotes (`incomingOrdersDeclinedSms`).
String requestReference(InventoryRequest request) =>
    '#${request.id.length > 5 ? request.id.substring(0, 5) : request.id}'
        .toUpperCase();

/// Desktop stock-request list: a dense, scannable table. Rows are built
/// lazily and read only fields already on the request, so a long history
/// costs nothing until it scrolls into view.
class OrdersRequestTable extends StatefulWidget {
  const OrdersRequestTable({
    super.key,
    required this.title,
    required this.requests,
    required this.selectedId,
    required this.onSelect,
    required this.isIncoming,
    required this.onLoadMore,
  });

  final String title;
  final List<InventoryRequest> requests;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final bool isIncoming;
  final VoidCallback onLoadMore;

  @override
  State<OrdersRequestTable> createState() => _OrdersRequestTableState();
}

class _OrdersRequestTableState extends State<OrdersRequestTable> {
  final _scroll = ScrollController();
  final _focus = FocusNode(debugLabel: 'orders-table');

  /// Fires loadMore once per arrival at the bottom, not on every settling
  /// scroll notification while parked there.
  bool _loadMoreFired = false;

  @override
  void dispose() {
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final step = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowDown => 1,
      LogicalKeyboardKey.arrowUp => -1,
      _ => 0,
    };
    if (step == 0 || widget.requests.isEmpty) return KeyEventResult.ignored;
    final current = widget.requests.indexWhere(
      (r) => r.id == widget.selectedId,
    );
    final next = (current + step).clamp(0, widget.requests.length - 1);
    widget.onSelect(widget.requests[next].id);
    _reveal(next);
    return KeyEventResult.handled;
  }

  /// Scrolls just enough to show row [index].
  void _reveal(int index) {
    if (!_scroll.hasClients) return;
    final top = index * _rowHeight;
    final bottom = top + _rowHeight;
    final position = _scroll.position;
    if (top < position.pixels) {
      _scroll.jumpTo(top);
    } else if (bottom > position.pixels + position.viewportDimension) {
      _scroll.jumpTo(bottom - position.viewportDimension);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = widget.requests;
    return Focus(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            _table(requests, ordersColumnsFor(constraints.maxWidth)),
      ),
    );
  }

  Widget _table(List<InventoryRequest> requests, List<OrdersColumn> columns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OrdersTableCaption(title: widget.title, count: requests.length),
        OrdersTableHeader(
          showCheckbox: widget.isIncoming,
          requestIds: [for (final r in requests) r.id],
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              final atEnd = n.metrics.pixels >= n.metrics.maxScrollExtent - 40;
              if (atEnd && !_loadMoreFired) {
                _loadMoreFired = true;
                widget.onLoadMore();
              } else if (!atEnd) {
                _loadMoreFired = false;
              }
              return false;
            },
            child: ListView.builder(
              controller: _scroll,
              itemExtent: _rowHeight,
              itemCount: requests.length,
              itemBuilder: (context, i) {
                final request = requests[i];
                return _RequestRow(
                  key: ValueKey(request.id),
                  request: request,
                  columns: columns,
                  isIncoming: widget.isIncoming,
                  selected: request.id == widget.selectedId,
                  onTap: () {
                    _focus.requestFocus();
                    widget.onSelect(request.id);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// "Received orders · 3 requests" above the header row.
class OrdersTableCaption extends StatelessWidget {
  const OrdersTableCaption({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: _hPad + 4),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(title, style: PosTokens.sectionTitle),
          if (count != null) ...[
            const SizedBox(width: 10),
            Text(
              context.flipperL10n.incomingOrdersRequestCount(count!),
              style: PosTokens.meta,
            ),
          ],
        ],
      ),
    );
  }
}

/// Column labels. [requestIds] drives the select-all checkbox.
class OrdersTableHeader extends ConsumerWidget {
  const OrdersTableHeader({
    super.key,
    required this.showCheckbox,
    this.requestIds = const [],
  });

  final bool showCheckbox;
  final List<String> requestIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    String label(OrdersColumn c) => switch (c) {
      OrdersColumn.branch => l10n.incomingOrdersColBranch,
      OrdersColumn.requested => l10n.incomingOrdersColRequested,
      OrdersColumn.items => l10n.incomingOrdersColItems,
      OrdersColumn.qty => l10n.incomingOrdersColQty,
      OrdersColumn.delivery => l10n.incomingOrdersColDelivery,
      OrdersColumn.status => l10n.incomingOrdersStatus,
    };

    Widget? checkbox;
    if (showCheckbox) {
      final selected = ref.watch(selectionProvider);
      final picked = requestIds.where(selected.contains).length;
      final bool? value = picked == 0
          ? false
          : picked == requestIds.length
          ? true
          : null;
      checkbox = SizedBox(
        width: _checkboxWidth,
        child: Align(
          alignment: Alignment.centerLeft,
          child: _TableCheckbox(
            value: value,
            tristate: true,
            onChanged: requestIds.isEmpty
                ? null
                : () {
                    final notifier = ref.read(selectionProvider.notifier);
                    if (value == true) {
                      notifier.deselectAll();
                    } else {
                      notifier.selectAll(requestIds);
                    }
                  },
          ),
        ),
      );
    }

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: _hPad),
      decoration: const BoxDecoration(
        color: PosTokens.surface2,
        border: Border.symmetric(horizontal: BorderSide(color: PosTokens.line)),
      ),
      child: LayoutBuilder(
        // The header sits inside the same card as the rows, so its width
        // (plus padding) picks the same columns.
        builder: (context, constraints) => Row(
          children: [
            ?checkbox,
            for (final c in ordersColumnsFor(constraints.maxWidth + 2 * _hPad))
              _cell(
                c,
                Text(
                  label(c).toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: _isNumeric(c) ? TextAlign.right : TextAlign.left,
                  style: PosTokens.eyebrow,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RequestRow extends ConsumerStatefulWidget {
  const _RequestRow({
    super.key,
    required this.request,
    required this.columns,
    required this.isIncoming,
    required this.selected,
    required this.onTap,
  });

  final InventoryRequest request;
  final List<OrdersColumn> columns;
  final bool isIncoming;
  final bool selected;
  final VoidCallback onTap;

  @override
  ConsumerState<_RequestRow> createState() => _RequestRowState();
}

class _RequestRowState extends ConsumerState<_RequestRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final checked = widget.isIncoming
        ? ref.watch(selectionProvider.select((s) => s.contains(request.id)))
        : false;
    final (requested, approved) = requestQuantities(request);
    final isPending =
        (request.status ?? RequestStatus.pending) == RequestStatus.pending;
    final created = request.createdAt;
    final delivery = request.deliveryDate;
    final mono = PosTokens.posMonoStyle(
      Theme.of(context).textTheme,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    final bg = widget.selected
        ? PosTokens.blueTint
        : _hover
        ? PosTokens.surface2
        : PosTokens.surface;

    Widget cell(OrdersColumn c) => switch (c) {
      OrdersColumn.branch => _BranchCell(
        request: request,
        isIncoming: widget.isIncoming,
      ),
      OrdersColumn.requested => _TwoLine(
        top: created == null ? '—' : DateFormat('d MMM yyyy').format(created),
        bottom: created == null ? null : DateFormat('HH:mm').format(created),
      ),
      OrdersColumn.items => Text(
        '${requestLineCount(request)}',
        maxLines: 1,
        style: mono,
        textAlign: TextAlign.right,
      ),
      OrdersColumn.qty => Text.rich(
        TextSpan(
          children: [
            if (!isPending)
              TextSpan(
                text: '$approved',
                style: mono.copyWith(fontWeight: FontWeight.w700),
              ),
            if (!isPending)
              TextSpan(
                text: ' / ',
                style: mono.copyWith(color: PosTokens.ink4),
              ),
            TextSpan(
              text: '$requested',
              style: isPending
                  ? mono.copyWith(fontWeight: FontWeight.w700)
                  : mono.copyWith(color: PosTokens.ink3),
            ),
          ],
        ),
        maxLines: 1,
        textAlign: TextAlign.right,
      ),
      OrdersColumn.delivery => Text(
        delivery == null ? '—' : DateFormat('d MMM yyyy').format(delivery),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: PosTokens.body.copyWith(
          color: delivery == null ? PosTokens.ink4 : PosTokens.ink2,
        ),
      ),
      OrdersColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: OrdersStatusChip(status: request.status),
      ),
    };

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: PosTokens.hoverTransition,
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              left: BorderSide(
                color: widget.selected ? PosTokens.blue : Colors.transparent,
                width: 3,
              ),
              bottom: const BorderSide(color: PosTokens.line),
            ),
          ),
          padding: const EdgeInsets.only(left: _hPad - 3, right: _hPad),
          child: Row(
            children: [
              if (widget.isIncoming)
                SizedBox(
                  width: _checkboxWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _TableCheckbox(
                      value: checked,
                      onChanged: () => ref
                          .read(selectionProvider.notifier)
                          .toggle(request.id),
                    ),
                  ),
                ),
              for (final c in widget.columns) _cell(c, cell(c)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Branch the request is with: the requester for incoming, the branch asked
/// to fulfil it for outgoing (the requester there is always this shop).
class _BranchCell extends ConsumerWidget {
  const _BranchCell({required this.request, required this.isIncoming});

  final InventoryRequest request;
  final bool isIncoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unknown = context.flipperL10n.incomingOrdersUnknown;
    String name;
    if (isIncoming) {
      name = request.branch?.name ?? unknown;
    } else {
      // One stream per distinct branch, shared by every row that names it.
      name = request.mainBranchId == null
          ? unknown
          : ref
                    .watch(branchByIdProvider(branchId: request.mainBranchId))
                    .value
                    ?.name ??
                '…';
    }
    final initial = name.trim().isEmpty || name == '…'
        ? '?'
        : name.trim().characters.first.toUpperCase();

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: PosTokens.blueTint,
            borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          ),
          child: Text(
            initial,
            style: PosTokens.bodyStrong.copyWith(color: PosTokens.blue),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TwoLine(
            top: name,
            bottom: requestReference(request),
            strong: true,
          ),
        ),
      ],
    );
  }
}

class _TwoLine extends StatelessWidget {
  const _TwoLine({required this.top, this.bottom, this.strong = false});

  final String top;
  final String? bottom;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          top,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: strong ? PosTokens.bodyStrong : PosTokens.body,
        ),
        if (bottom != null) ...[
          const SizedBox(height: 2),
          Text(
            bottom!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: PosTokens.meta.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ],
    );
  }
}

/// 16px square checkbox in the table's colours. A plain `Checkbox` brings a
/// 40px touch target and Material splash that crowd a 52px desktop row.
class _TableCheckbox extends StatelessWidget {
  const _TableCheckbox({
    required this.value,
    required this.onChanged,
    this.tristate = false,
  });

  final bool? value;
  final VoidCallback? onChanged;
  final bool tristate;

  @override
  Widget build(BuildContext context) {
    final on = value != false;
    return Semantics(
      checked: value == true,
      mixed: tristate && value == null,
      enabled: onChanged != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedContainer(
            duration: PosTokens.pressTransition,
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: on ? PosTokens.blue : PosTokens.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: on ? PosTokens.blue : PosTokens.lineStrong,
                width: 1.5,
              ),
            ),
            child: on
                ? Icon(
                    value == null ? Icons.remove : Icons.check,
                    size: 12,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
