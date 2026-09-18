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

/// Right pane: the order being built, and the one button that sends it.
///
/// Swaps wholesale for a confirmation once the order is placed — after sending,
/// what matters is what went out and what to do next, not the cart that is now
/// empty.
class OrderingCartPanel extends ConsumerWidget {
  const OrderingCartPanel({
    super.key,
    required this.supplierName,
    required this.noteController,
    required this.isPlacing,
    required this.onPlaceOrder,
    required this.onStartAnother,
  });

  final String supplierName;
  final TextEditingController noteController;
  final bool isPlacing;
  final VoidCallback onPlaceOrder;
  final VoidCallback onStartAnother;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placed = ref.watch(orderingPlacedProvider);

    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surface,
        border: Border(left: BorderSide(color: OrderingTokens.line)),
      ),
      child: placed != null
          ? _PlacedPanel(placed: placed, onStartAnother: onStartAnother)
          : _OrderBuilder(
              noteController: noteController,
              isPlacing: isPlacing,
              onPlaceOrder: onPlaceOrder,
            ),
    );
  }
}

class _OrderBuilder extends ConsumerWidget {
  const _OrderBuilder({
    required this.noteController,
    required this.isPlacing,
    required this.onPlaceOrder,
  });

  final TextEditingController noteController;
  final bool isPlacing;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref
        .watch(posCartDisplayItemsProvider)
        .where((item) => item.active != false)
        .toList();
    final summary = ref.watch(posCartSummaryProvider);
    final actions = ref.read(orderingCartActionsProvider);

    // Catalogue rows back the "cost changed" and "over stock" notes; without
    // them a line still renders, just without those two comparisons.
    final catalogue = ref.watch(productFromSupplierWrapper).value;
    final byVariantId = {
      for (final variant in catalogue ?? const <Variant>[])
        variant.id: variant,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PanelHeader(
          lineCount: summary.activeLineCount,
          unitCount: summary.unitQtyTotal,
          onClear: lines.isEmpty ? null : actions.clearAll,
        ),
        Expanded(
          child: lines.isEmpty
              ? const _EmptyOrder()
              : ListView.builder(
                  primary: false,
                  itemCount: lines.length,
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return _OrderLine(
                      key: ValueKey(line.id),
                      line: line,
                      variant: byVariantId[line.variantId],
                    );
                  },
                ),
        ),
        _OrderFooter(
          subtotal: summary.lineSubtotal,
          tax: summary.lineTax,
          hasLines: lines.isNotEmpty,
          isPlacing: isPlacing,
          noteController: noteController,
          onPlaceOrder: onPlaceOrder,
        ),
      ],
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.lineCount,
    required this.unitCount,
    required this.onClear,
  });

  final int lineCount;
  final int unitCount;
  final Future<void> Function()? onClear;

  @override
  Widget build(BuildContext context) {
    final countLabel = lineCount == 0
        ? 'empty'
        : '$lineCount ${lineCount == 1 ? 'line' : 'lines'} · '
              '$unitCount ${unitCount == 1 ? 'unit' : 'units'}';

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: OrderingTokens.lineSoft)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Flexible(
            child: Text(
              'This order',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: OrderingTokens.sectionTitle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              countLabel,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: OrderingTokens.monoStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: OrderingTokens.ink4,
              ),
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: 12),
            OrderingHover(
              builder: (context, hovered) => GestureDetector(
                onTap: onClear,
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontFamily: OrderingTokens.sans,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: hovered
                        ? OrderingTokens.dangerHover
                        : OrderingTokens.danger,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyOrder extends StatelessWidget {
  const _EmptyOrder();

  @override
  Widget build(BuildContext context) {
    return OrderingEmptyState(
      icon: Icons.shopping_cart_outlined,
      iconSize: 30,
      title: 'No lines yet',
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 56),
      hintWidget: DefaultTextStyle(
        style: OrderingTokens.body.copyWith(
          fontSize: 13.5,
          color: OrderingTokens.ink4,
          height: 1.55,
        ),
        textAlign: TextAlign.center,
        child: const Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          runSpacing: 4,
          children: [
            Text('Search a product and press'),
            OrderingKbd('↵'),
            Text('— the top match lands here.'),
          ],
        ),
      ),
    );
  }
}

class _OrderLine extends ConsumerWidget {
  const _OrderLine({super.key, required this.line, required this.variant});

  final TransactionItem line;
  final Variant? variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(orderingCartActionsProvider);
    final qty = line.qty.round();
    final lastCost = variant?.supplyPrice;
    final stock = variant?.stock?.currentStock;

    final costDelta = (lastCost == null || lastCost <= 0)
        ? null
        : ((line.price - lastCost) / lastCost * 100).round();
    final overStock = stock != null && qty > stock;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: OrderingTokens.lineFaint)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: OrderingTokens.lineName,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      variant == null ? '—' : orderingSkuOf(variant!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: OrderingTokens.monoStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: OrderingTokens.ink4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                orderingMoney(line.price * line.qty),
                style: OrderingTokens.monoStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              OrderingIconButton(
                icon: Icons.close,
                iconSize: 13,
                size: 22,
                radius: OrderingTokens.rMd,
                bordered: false,
                background: Colors.transparent,
                hoverBackground: OrderingTokens.dangerBg,
                foreground: OrderingTokens.ink6,
                hoverForeground: OrderingTokens.danger,
                tooltip: 'Remove line',
                onPressed: () => actions.removeLine(line),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _LineQtyStepper(
                qty: qty,
                onDecrement: variant == null
                    ? null
                    : () => actions.decrementOne(variant: variant!),
                onIncrement: variant == null
                    ? null
                    : () => actions.addOne(
                        context: context,
                        variant: variant!,
                      ),
                onSet: variant == null
                    ? null
                    : (value) => actions.setQty(
                        context: context,
                        variant: variant!,
                        qty: value,
                      ),
              ),
              Text(
                '×',
                style: OrderingTokens.body.copyWith(
                  fontSize: 12.5,
                  color: OrderingTokens.ink4,
                ),
              ),
              _LineCostField(
                cost: line.price,
                onCommit: (value) =>
                    actions.setLineCost(line: line, cost: value),
              ),
              if (costDelta != null && costDelta != 0)
                OrderingBadge(
                  label:
                      '${costDelta > 0 ? '+' : ''}$costDelta% vs last',
                  foreground: OrderingTokens.warn,
                  background: OrderingTokens.warnBg,
                ),
              if (overStock)
                OrderingBadge(
                  label: 'only ${orderingCount(stock)} available',
                  foreground: OrderingTokens.danger,
                  background: OrderingTokens.dangerBg,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact stepper for a cart line (the catalogue's is the blue-bordered one).
class _LineQtyStepper extends StatefulWidget {
  const _LineQtyStepper({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
    required this.onSet,
  });

  final int qty;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final ValueChanged<int>? onSet;

  @override
  State<_LineQtyStepper> createState() => _LineQtyStepperState();
}

class _LineQtyStepperState extends State<_LineQtyStepper> {
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
  void didUpdateWidget(_LineQtyStepper old) {
    super.didUpdateWidget(old);
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
    if (typed == null || typed == widget.qty || widget.onSet == null) {
      _controller.text = '${widget.qty}';
      return;
    }
    widget.onSet!(typed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: OrderingTokens.surfaceInset,
        border: Border.all(color: OrderingTokens.line),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderingIconButton(
            icon: Icons.remove,
            iconSize: 13,
            size: 24,
            radius: OrderingTokens.rSm,
            bordered: false,
            hoverBackground: OrderingTokens.lineSoft,
            tooltip: 'Order one less',
            onPressed: widget.onDecrement,
          ),
          SizedBox(
            width: 34,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              enabled: widget.onSet != null,
              cursorColor: OrderingTokens.blue,
              onSubmitted: (_) => _commit(),
              style: OrderingTokens.monoStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          OrderingIconButton(
            icon: Icons.add,
            iconSize: 13,
            size: 24,
            radius: OrderingTokens.rSm,
            bordered: false,
            hoverBackground: OrderingTokens.lineSoft,
            tooltip: 'Order one more',
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

/// Editable unit cost. The order is placed at what is typed here, not at the
/// catalogue price.
class _LineCostField extends StatefulWidget {
  const _LineCostField({required this.cost, required this.onCommit});

  /// `TransactionItem.price` is a `num`; rounded to whole units for display.
  final num cost;
  final ValueChanged<double> onCommit;

  @override
  State<_LineCostField> createState() => _LineCostFieldState();
}

class _LineCostFieldState extends State<_LineCostField> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.cost),
  );
  final FocusNode _focusNode = FocusNode();

  static String _format(num value) => value.round().toString();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(_LineCostField old) {
    super.didUpdateWidget(old);
    if (widget.cost != old.cost && !_focusNode.hasFocus) {
      _controller.text = _format(widget.cost);
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
    final typed = double.tryParse(
      _controller.text.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    if (typed == null || typed == widget.cost) {
      _controller.text = _format(widget.cost);
      return;
    }
    widget.onCommit(typed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: OrderingTokens.surfaceInset,
        border: Border.all(color: OrderingTokens.line),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            orderingCurrencySymbol,
            style: OrderingTokens.monoStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: OrderingTokens.ink4,
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: 62,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              cursorColor: OrderingTokens.blue,
              onSubmitted: (_) => _commit(),
              style: OrderingTokens.monoStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderFooter extends ConsumerWidget {
  const _OrderFooter({
    required this.subtotal,
    required this.tax,
    required this.hasLines,
    required this.isPlacing,
    required this.noteController,
    required this.onPlaceOrder,
  });

  final double subtotal;
  final double tax;
  final bool hasLines;
  final bool isPlacing;
  final TextEditingController noteController;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = subtotal + tax;
    // The rate is read back off the lines rather than assumed: a purchase can
    // mix taxable and exempt items, and the label should say what was charged.
    final rate = subtotal <= 0 ? null : (tax / subtotal * 100).round();
    // Only an unanswered fork blocks. No finance provider configured is not a
    // missing answer, and treating it as one made the order unplaceable.
    final financePending = ref.watch(orderingFinanceChoicePendingProvider);
    final canPlace = hasLines && !financePending && !isPlacing;

    return Container(
      decoration: const BoxDecoration(
        color: OrderingTokens.surfaceFooter,
        border: Border(top: BorderSide(color: OrderingTokens.lineSoft)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TotalRow(label: 'Subtotal', value: subtotal),
          const SizedBox(height: 7),
          _TotalRow(
            label: rate == null ? 'VAT' : 'VAT $rate%',
            value: tax,
          ),
          const SizedBox(height: 7),
          const _DashedDivider(),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Total',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: OrderingTokens.sans,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: OrderingTokens.ink1,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  orderingMoney(total),
                  maxLines: 1,
                  softWrap: false,
                  style: OrderingTokens.monoTotal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const OrderingEyebrow('Pay with'),
          const SizedBox(height: 7),
          const _FinanceChips(),
          const SizedBox(height: 14),
          _NoteField(controller: noteController),
          const SizedBox(height: 14),
          // The label carries the reason, so a disabled button never leaves
          // the operator guessing what it wants.
          OrderingPrimaryButton(
            label: isPlacing
                ? 'Sending order…'
                : !hasLines
                ? 'Add a product to continue'
                : financePending
                ? 'Choose how you are paying'
                : 'Place order · ${orderingMoney(total)}',
            icon: isPlacing ? null : Icons.send_outlined,
            expand: true,
            height: 52,
            onPressed: canPlace ? onPlaceOrder : null,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    // spaceBetween with a flexible label: the amount is never truncated, the
    // label gives way first, and both stay pinned to their own edge.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: OrderingTokens.body,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          orderingMoney(value),
          style: OrderingTokens.monoStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 4.0;
        const gap = 3.0;
        final count = (constraints.maxWidth / (dash + gap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => const Padding(
              padding: EdgeInsets.only(right: gap),
              child: SizedBox(
                width: dash,
                height: 1,
                child: ColoredBox(color: OrderingTokens.lineStrong),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FinanceChips extends ConsumerWidget {
  const _FinanceChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(orderingFinanceOptionsProvider);
    // The effective one, so a lone option shows as taken rather than as an
    // unmade decision.
    final selected = ref.watch(orderingEffectiveFinanceProvider);

    return options.when(
      loading: () => Text(
        'Loading payment options…',
        style: OrderingTokens.body.copyWith(fontSize: 12.5),
      ),
      error: (error, _) => Text(
        'Payment options unavailable — the order will be sent without one.',
        style: OrderingTokens.body.copyWith(fontSize: 12.5),
      ),
      data: (providers) {
        if (providers.isEmpty) {
          // Reassurance, not a blocker: financing is optional on a purchase
          // order, and this business has none set up.
          return Text(
            'No payment option set up for this business — the order will be '
            'sent without one.',
            style: OrderingTokens.body.copyWith(
              fontSize: 12.5,
              height: 1.45,
            ),
          );
        }
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final provider in providers)
              _FinanceChip(
                label: provider.name,
                selected: selected?.id == provider.id,
                onTap: () => ref
                    .read(orderingFinanceProvider.notifier)
                    .state = provider,
              ),
          ],
        );
      },
    );
  }
}

class _FinanceChip extends StatelessWidget {
  const _FinanceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OrderingHover(
      builder: (context, hovered) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? OrderingTokens.blueTint
                : OrderingTokens.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(OrderingTokens.rStepper),
            ),
            border: Border.all(
              color: selected || hovered
                  ? OrderingTokens.blue
                  : OrderingTokens.lineStrong,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: OrderingTokens.sans,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? OrderingTokens.blueHover
                  : OrderingTokens.ink2,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OrderingTokens.surface,
        borderRadius: OrderingTokens.controlRadius,
        border: Border.all(color: OrderingTokens.line, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: TextField(
        controller: controller,
        cursorColor: OrderingTokens.blue,
        style: const TextStyle(
          fontFamily: OrderingTokens.sans,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: OrderingTokens.ink1,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 11),
          hintText: 'Delivery note (optional)',
          hintStyle: TextStyle(
            fontFamily: OrderingTokens.sans,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: OrderingTokens.ink4,
          ),
        ),
      ),
    );
  }
}

class _PlacedPanel extends StatelessWidget {
  const _PlacedPanel({required this.placed, required this.onStartAnother});

  final PlacedOrder placed;
  final VoidCallback onStartAnother;

  @override
  Widget build(BuildContext context) {
    final summary =
        '${placed.lineCount} ${placed.lineCount == 1 ? 'line' : 'lines'} · '
        '${placed.unitCount} ${placed.unitCount == 1 ? 'unit' : 'units'} · '
        '${orderingMoney(placed.total)}';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: OrderingTokens.goodBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 28,
              color: OrderingTokens.good,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Order sent to ${placed.supplierName}',
            textAlign: TextAlign.center,
            style: OrderingTokens.placedTitle,
          ),
          const SizedBox(height: 14),
          Text(
            '$summary\nThey get an SMS now; you will see it under '
            'Incoming orders once accepted.',
            textAlign: TextAlign.center,
            style: OrderingTokens.body.copyWith(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 20),
          // The handoff pairs this with "View order". There is no desktop
          // screen to send them to — placed orders live on the Incoming orders
          // dashboard page, which this route cannot select — so the copy above
          // points there instead of a button that would land somewhere else.
          OrderingPrimaryButton(
            label: 'Start another order',
            onPressed: onStartAnother,
          ),
        ],
      ),
    );
  }
}
