import 'package:flipper_dashboard/ordering/ordering_cart_actions.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog.dart';
import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Centre pane: the supplier's catalogue as a dense, scannable table.
///
/// One row per product with the four numbers a buyer decides on — their stock,
/// optional retail margin, unit cost, and how many to order — so the decision
/// and the action sit on the same line.
class OrderingCatalogTable extends ConsumerWidget {
  const OrderingCatalogTable({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSubmitted,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  /// Enter in the search field: add the top match.
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The pane's own width, not the window's: the rail and the order pane take
    // their share first.
    return LayoutBuilder(
      builder: (context, constraints) => _Table(
        searchController: searchController,
        searchFocusNode: searchFocusNode,
        onSubmitted: onSubmitted,
        showMarginColumn: constraints.maxWidth >=
            OrderingTokens.marginColumnMinPaneWidth,
      ),
    );
  }
}

class _Table extends ConsumerWidget {
  const _Table({
    required this.searchController,
    required this.searchFocusNode,
    required this.onSubmitted,
    required this.showMarginColumn,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onSubmitted;
  final bool showMarginColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(orderingCatalogProvider);
    final query = ref.watch(orderingQueryProvider);
    final showMargin =
        ref.watch(orderingShowMarginProvider) && showMarginColumn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchHeader(
          controller: searchController,
          focusNode: searchFocusNode,
          resultLabel: catalog.value?.resultLabel,
          hasQuery: query.isNotEmpty,
          onChanged: (value) =>
              ref.read(orderingQueryProvider.notifier).state = value,
          onClear: () {
            searchController.clear();
            ref.read(orderingQueryProvider.notifier).state = '';
          },
          onSubmitted: onSubmitted,
        ),
        _ColumnHeader(showMargin: showMargin),
        Expanded(
          child: ColoredBox(
            color: OrderingTokens.surface,
            child: catalog.when(
              loading: () => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: OrderingTokens.blue,
                  ),
                ),
              ),
              error: (error, _) => _CatalogError(error: error),
              data: (data) => data.visible.isEmpty
                  ? _NoResults(query: query, total: data.totalCount)
                  : _Rows(catalog: data, showMargin: showMargin),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.resultLabel,
    required this.hasQuery,
    required this.onChanged,
    required this.onClear,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? resultLabel;
  final bool hasQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surface,
        border: Border(bottom: BorderSide(color: OrderingTokens.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: OrderingSearchField(
              controller: controller,
              focusNode: focusNode,
              filled: true,
              hintText: 'Search products, SKU or barcode…',
              onChanged: onChanged,
              onClear: hasQuery ? onClear : null,
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
          if (resultLabel != null) ...[
            const SizedBox(width: 14),
            Text(resultLabel!, style: OrderingTokens.label),
          ],
        ],
      ),
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({required this.showMargin});

  final bool showMargin;

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, double width) => SizedBox(
      width: width,
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.right,
        style: OrderingTokens.columnHeader,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surfaceHeader,
        border: Border(bottom: BorderSide(color: OrderingTokens.lineSoft)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      child: Row(
        children: [
          const Expanded(
            child: Text('PRODUCT', style: OrderingTokens.columnHeader),
          ),
          const SizedBox(width: 14),
          cell('Their stock', OrderingTokens.colStock),
          if (showMargin) ...[
            const SizedBox(width: 14),
            cell('Retail · margin', OrderingTokens.colMargin),
          ],
          const SizedBox(width: 14),
          cell('Unit cost', OrderingTokens.colCost),
          const SizedBox(width: 14),
          cell('Order qty', OrderingTokens.colQty),
        ],
      ),
    );
  }
}

class _Rows extends ConsumerWidget {
  const _Rows({required this.catalog, required this.showMargin});

  final OrderingCatalog catalog;
  final bool showMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qtyByVariant = ref.watch(posCartQtyByVariantIdProvider);

    // Flattened so one scroll view covers every group: a Column of per-group
    // ListViews would build all rows of every category up front.
    final entries = <_Entry>[];
    for (final group in catalog.groups) {
      if (group.label.isNotEmpty) {
        entries.add(_Entry.header(group.label, group.items.length));
      }
      entries.addAll(group.items.map(_Entry.product));
    }

    // Rows size themselves rather than sharing a fixed extent: the row's
    // height depends on whether the margin column is on, and a constant tall
    // enough for one is too short for the other.
    return ListView.builder(
      primary: false,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        if (entry.isHeader) {
          return _GroupHeader(label: entry.label!, count: entry.count!);
        }
        final variant = entry.variant!;
        return _ProductRow(
          variant: variant,
          qty: qtyByVariant[variant.id] ?? 0,
          showMargin: showMargin,
        );
      },
    );
  }
}

class _Entry {
  _Entry.header(this.label, this.count) : variant = null;
  _Entry.product(this.variant) : label = null, count = null;

  final String? label;
  final int? count;
  final Variant? variant;

  bool get isHeader => variant == null;
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OrderingTokens.surface,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 11, bottom: 7),
      child: Row(
        children: [
          Text(label.toUpperCase(), style: OrderingTokens.groupHeader),
          const SizedBox(width: 10),
          const Expanded(
            child: Divider(
              height: 1,
              thickness: 1,
              color: OrderingTokens.lineSoft,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$count ${count == 1 ? 'item' : 'items'}',
            style: OrderingTokens.monoStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: OrderingTokens.ink5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends ConsumerWidget {
  const _ProductRow({
    required this.variant,
    required this.qty,
    required this.showMargin,
  });

  final Variant variant;
  final int qty;
  final bool showMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inOrder = qty > 0;
    final actions = ref.read(orderingCartActionsProvider);

    return OrderingHover(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovered) => AnimatedContainer(
        duration: OrderingTokens.hover,
        decoration: BoxDecoration(
          color: inOrder
              ? OrderingTokens.blueRow
              : (hovered
                    ? OrderingTokens.surfaceHeader
                    : OrderingTokens.surface),
          border: const Border(
            bottom: BorderSide(color: OrderingTokens.lineFaint),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            _Thumb(variant: variant),
            const SizedBox(width: 14),
            Expanded(child: _NameCell(variant: variant)),
            const SizedBox(width: 14),
            SizedBox(
              width: OrderingTokens.colStock,
              child: _StockCell(stock: variant.stock?.currentStock),
            ),
            if (showMargin) ...[
              const SizedBox(width: 14),
              SizedBox(
                width: OrderingTokens.colMargin,
                child: _MarginCell(variant: variant),
              ),
            ],
            const SizedBox(width: 14),
            SizedBox(
              width: OrderingTokens.colCost,
              child: Text(
                orderingMoney(variant.supplyPrice ?? 0),
                textAlign: TextAlign.right,
                style: OrderingTokens.monoStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: OrderingTokens.colQty,
              child: Align(
                alignment: Alignment.centerRight,
                child: inOrder
                    ? _QtyStepper(
                        qty: qty,
                        onDecrement: () =>
                            actions.decrementOne(variant: variant),
                        onIncrement: () => actions.addOne(
                          context: context,
                          variant: variant,
                        ),
                        onSet: (value) => actions.setQty(
                          context: context,
                          variant: variant,
                          qty: value,
                        ),
                      )
                    : OrderingSecondaryButton(
                        label: 'Add',
                        icon: Icons.add,
                        onPressed: () => actions.addOne(
                          context: context,
                          variant: variant,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.variant});

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    final url = variant.imageUrl?.trim();
    final color = _variantColor(variant.color);
    final initials = _initials(variant.name);

    final fallback = ColoredBox(
      color: color,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: OrderingTokens.sans,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.13,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );

    return SizedBox(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(OrderingTokens.rStepper),
        ),
        child: url == null || url.isEmpty
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                // A catalogue of a hundred rows should not turn into a
                // hundred broken-image boxes when the CDN is unreachable.
                errorBuilder: (_, _, _) => fallback,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : fallback,
              ),
      ),
    );
  }

  static Color _variantColor(String? hex) {
    final value = hex?.trim() ?? '';
    if (value.length >= 7 && value.startsWith('#')) {
      final parsed = int.tryParse(value.substring(1, 7), radix: 16);
      if (parsed != null) {
        final color = Color(parsed | 0xFF000000);
        // White is the model's default; it would leave the initials invisible.
        if (color.computeLuminance() < 0.75) return color;
      }
    }
    return OrderingTokens.inkGroup;
  }

  static String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.length >= 2
        ? trimmed.substring(0, 2).toUpperCase()
        : trimmed.toUpperCase();
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.variant});

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variant.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: OrderingTokens.productName,
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Flexible(
              child: Text(
                orderingSkuOf(variant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: OrderingTokens.monoMeta,
              ),
            ),
            const SizedBox(width: 9),
            Container(
              width: 1,
              height: 10,
              color: OrderingTokens.lineStrong,
            ),
            const SizedBox(width: 9),
            // Flexible as well as the SKU: on the narrowest pane the name
            // column can be under 50px, and a rigid unit would overflow it.
            Flexible(
              child: Text(
                orderingUnitOf(variant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: OrderingTokens.monoMeta,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StockCell extends StatelessWidget {
  const _StockCell({required this.stock});

  final double? stock;

  @override
  Widget build(BuildContext context) {
    // Unknown is not zero: the supplier's stock row may simply not have come
    // back with the catalogue.
    final (label, color) = switch (stock) {
      null => ('—', OrderingTokens.ink6),
      <= 0 => ('none', OrderingTokens.danger),
      final value when value < 50 => (
        orderingCount(value),
        OrderingTokens.warn,
      ),
      final value => (orderingCount(value), OrderingTokens.good),
    };

    return Text(
      label,
      textAlign: TextAlign.right,
      style: OrderingTokens.monoStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class _MarginCell extends StatelessWidget {
  const _MarginCell({required this.variant});

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    final cost = variant.supplyPrice ?? 0;
    final retail = variant.retailPrice ?? 0;
    final pct = cost <= 0 ? null : ((retail - cost) / cost * 100).round();
    final color = switch (pct) {
      null => OrderingTokens.ink6,
      >= 30 => OrderingTokens.good,
      >= 15 => OrderingTokens.warn,
      _ => OrderingTokens.danger,
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          orderingMoney(retail),
          style: OrderingTokens.monoStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: OrderingTokens.inkGroup,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          pct == null ? '—' : '${pct >= 0 ? '+' : ''}$pct%',
          style: OrderingTokens.badge.copyWith(color: color),
        ),
      ],
    );
  }
}

/// `−  12  +` on a product already in the order. The number is editable.
class _QtyStepper extends StatefulWidget {
  const _QtyStepper({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
    required this.onSet,
  });

  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<int> onSet;

  @override
  State<_QtyStepper> createState() => _QtyStepperState();
}

class _QtyStepperState extends State<_QtyStepper> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.qty}',
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_QtyStepper old) {
    super.didUpdateWidget(old);
    // While the operator is typing, the cart is not allowed to overwrite the
    // field; every other change (a stepper tap, a cart edit) syncs it.
    if (widget.qty != old.qty && !_focusNode.hasFocus) {
      _controller.text = '${widget.qty}';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _commit();
  }

  void _commit() {
    final typed = int.tryParse(_controller.text.replaceAll(RegExp(r'\D'), ''));
    if (typed == null || typed == widget.qty) {
      _controller.text = '${widget.qty}';
      return;
    }
    widget.onSet(typed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: OrderingTokens.surface,
        borderRadius: OrderingTokens.stepperRadius,
        border: Border.all(color: OrderingTokens.blue, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderingIconButton(
            icon: Icons.remove,
            iconSize: 14,
            size: 26,
            radius: OrderingTokens.rMd,
            bordered: false,
            background: OrderingTokens.blueTint,
            hoverBackground: OrderingTokens.blueTint2,
            foreground: OrderingTokens.blue,
            hoverForeground: OrderingTokens.blue,
            tooltip: 'Order one less',
            onPressed: widget.onDecrement,
          ),
          SizedBox(
            width: 38,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              cursorColor: OrderingTokens.blue,
              onSubmitted: (_) => _commit(),
              style: OrderingTokens.monoStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          OrderingIconButton(
            icon: Icons.add,
            iconSize: 14,
            size: 26,
            radius: OrderingTokens.rMd,
            bordered: false,
            background: OrderingTokens.blue,
            hoverBackground: OrderingTokens.blueHover,
            foreground: Colors.white,
            hoverForeground: Colors.white,
            tooltip: 'Order one more',
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

class _NoResults extends ConsumerWidget {
  const _NoResults({required this.query, required this.total});

  final String query;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (total == 0) {
      return const OrderingEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'This supplier has no products to order',
        hint: 'Nothing in their catalogue is shared with your branch yet.',
      );
    }
    return OrderingEmptyState(
      icon: Icons.search_off,
      title: query.isEmpty
          ? 'Nothing matches these filters'
          : 'Nothing matches “$query”',
      hint: 'Try a shorter word, or clear the in-stock filter.',
    );
  }
}

class _CatalogError extends ConsumerWidget {
  const _CatalogError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrderingEmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load this catalogue',
              hint: '$error',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),
            OrderingSecondaryButton(
              label: 'Retry',
              icon: Icons.refresh,
              onPressed: () => ref.invalidate(productFromSupplierWrapper),
            ),
          ],
        ),
      ),
    );
  }
}
