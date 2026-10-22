import 'package:flipper_dashboard/features/bar_mode/bar_split_tender.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Display label for a settle tender; the raw value is what gets persisted.
String barTenderLabel(FlipperAppLocalizations l10n, String method) =>
    switch (method) {
      kBarCash => l10n.cash,
      kMobileMoney => l10n.barMobileMoney,
      kBarCard => l10n.barCard,
      _ => method,
    };

/// "Cash + Mobile Money" for the settled toast.
String barTendersLabel(
  FlipperAppLocalizations l10n,
  List<PaymentLineForSaleCompletion> lines,
  String fallbackMethod,
) {
  final methods = <String>{for (final line in lines) line.method};
  if (methods.isEmpty) return barTenderLabel(l10n, fallbackMethod);
  return methods.map((m) => barTenderLabel(l10n, m)).join(' + ');
}

/// "Split payment" under the method cards: turns the bill into tender rows.
class BarSplitPaymentLink extends StatelessWidget {
  const BarSplitPaymentLink({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        key: const Key('barSplitPayment'),
        onPressed: onTap,
        icon: const Icon(Icons.call_split, size: 18),
        label: Text(context.flipperL10n.barSplitPayment),
        style: TextButton.styleFrom(
          foregroundColor: BarTokens.blue,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}

/// One row per tender while a table is paid several ways.
///
/// Typing into a row re-balances the others ([barRebalanceTenders]), so the
/// waiter types only the MoMo part and the cash row shows what is left.
class BarSplitTenderRows extends StatefulWidget {
  const BarSplitTenderRows({
    super.key,
    required this.tenders,
    required this.total,
    required this.onChanged,
  });

  final List<BarTender> tenders;
  final double total;

  /// Called with the new split. A list of one tender means the split was
  /// undone and the screen should go back to its single-method view.
  final ValueChanged<List<BarTender>> onChanged;

  @override
  State<BarSplitTenderRows> createState() => _BarSplitTenderRowsState();
}

class _BarSplitTenderRowsState extends State<BarSplitTenderRows> {
  final _controllers = <TextEditingController>[];
  final _focusNodes = <FocusNode>[];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant BarSplitTenderRows oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Keeps one controller per row and mirrors re-balanced amounts into every
  /// row except the one being typed into, so the caret never jumps.
  void _syncControllers() {
    while (_controllers.length < widget.tenders.length) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    while (_controllers.length > widget.tenders.length) {
      // The dropped row's field is still mounted until this build finishes.
      final controller = _controllers.removeLast();
      final focusNode = _focusNodes.removeLast();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.dispose();
        focusNode.dispose();
      });
    }
    for (var i = 0; i < widget.tenders.length; i++) {
      if (_focusNodes[i].hasFocus) continue;
      final text = _amountText(widget.tenders[i].amount);
      if (_controllers[i].text != text) _controllers[i].text = text;
    }
  }

  static String _amountText(double amount) =>
      amount <= 0 ? '' : amount.round().toString();

  void _onAmountChanged(int index, String raw) {
    final amount = double.tryParse(raw) ?? 0;
    final next = [...widget.tenders];
    next[index] = next[index].copyWith(amount: amount);
    widget.onChanged(
      barRebalanceTenders(next, widget.total, editedIndex: index),
    );
  }

  void _onMethodChanged(int index, String method) {
    final next = [...widget.tenders];
    next[index] = next[index].copyWith(method: method);
    widget.onChanged(next);
  }

  void _add() {
    final next = barAddTender(widget.tenders, widget.total);
    if (next != null) widget.onChanged(next);
  }

  /// The surplus controller is trimmed in [_syncControllers] once the parent
  /// rebuilds; disposing it here would pull it from under a mounted field.
  void _remove(int index) {
    FocusScope.of(context).unfocus();
    widget.onChanged(barRemoveTender(widget.tenders, index, widget.total));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final summary = barSplitSummary(widget.tenders, widget.total);
    final money = NumberFormat('#,###');
    final canAdd = barUnusedMethod(widget.tenders) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.tenders.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _TenderRow(
            key: ValueKey('barSplitRow$i'),
            method: widget.tenders[i].method,
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            onMethodChanged: (m) => _onMethodChanged(i, m),
            onAmountChanged: (raw) => _onAmountChanged(i, raw),
            onRemove: () => _remove(i),
          ),
        ],
        if (canAdd) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('barSplitAddMethod'),
              onPressed: _add,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.barAddPaymentMethod),
              style: TextButton.styleFrom(
                foregroundColor: BarTokens.blue,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                textStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: BarTokens.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BarTokens.line),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _SummaryText(
                l10n.barSplitPaid('RWF ${money.format(summary.paid)}'),
              ),
              _SummaryText(
                l10n.barSplitRemaining(
                  'RWF ${money.format(summary.remaining)}',
                ),
                emphasis: summary.remaining > 0.01,
              ),
              if (summary.change > 0.01)
                _SummaryText(
                  l10n.barSplitChange('RWF ${money.format(summary.change)}'),
                ),
            ],
          ),
        ),
        if (summary.nonCashOverTotal) ...[
          const SizedBox(height: 8),
          Text(
            l10n.barSplitNonCashOverTotal,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              color: BarTokens.lossInk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _TenderRow extends StatelessWidget {
  const _TenderRow({
    super.key,
    required this.method,
    required this.controller,
    required this.focusNode,
    required this.onMethodChanged,
    required this.onAmountChanged,
    required this.onRemove,
  });

  final String method;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        border: Border.all(color: BarTokens.line),
      ),
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: method,
              borderRadius: BorderRadius.circular(12),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: BarTokens.ink1,
              ),
              items: [
                for (final m in {...barSettleMethods, method})
                  DropdownMenuItem(
                    value: m,
                    child: Text(barTenderLabel(l10n, m)),
                  ),
              ],
              onChanged: (m) {
                if (m != null) onMethodChanged(m);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.jetBrainsMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: BarTokens.ink1,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: '0',
                suffixText: ' RWF',
                suffixStyle: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: BarTokens.ink4,
                ),
              ),
              onChanged: onAmountChanged,
            ),
          ),
          IconButton(
            tooltip: l10n.remove,
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18, color: BarTokens.ink4),
          ),
        ],
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText(this.text, {this.emphasis = false});

  final String text;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
        color: emphasis ? BarTokens.ink1 : BarTokens.ink3,
      ),
    );
  }
}
