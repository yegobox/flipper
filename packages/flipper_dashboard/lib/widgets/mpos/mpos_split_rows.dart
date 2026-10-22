import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/utils/split_tender.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One row per tender while a mobile sale is paid several ways.
///
/// The rows are the [paymentMethodsProvider] lines themselves; the parent
/// re-balances them on every edit ([rebalanceSplit]), so the cashier types
/// one figure and the other row shows what is left.
class MposSplitRows extends StatelessWidget {
  const MposSplitRows({
    super.key,
    required this.payments,
    required this.total,
    required this.methods,
    required this.labelFor,
    required this.onAmountChanged,
    required this.onMethodChanged,
    required this.onRemove,
    required this.onAdd,
  });

  final List<Payment> payments;
  final double total;

  /// Every tender a row may use, in picker order.
  final List<String> methods;
  final String Function(String method) labelFor;
  final void Function(int index, String raw) onAmountChanged;
  final void Function(int index, String method) onMethodChanged;
  final void Function(int index) onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final summary = splitSummary(mposSplitTenders(payments), total);
    final canAdd =
        unusedSplitMethod(mposSplitTenders(payments), methods) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < payments.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _SplitRow(
            key: ValueKey('mposSplitRow$i'),
            payment: payments[i],
            // A method another row already uses would merge the two lines.
            methods: [
              for (final m in methods)
                if (m == payments[i].method ||
                    !payments.any((p) => p.method == m))
                  m,
            ],
            labelFor: labelFor,
            onAmountChanged: (raw) => onAmountChanged(i, raw),
            onMethodChanged: (m) => onMethodChanged(i, m),
            onRemove: () => onRemove(i),
          ),
        ],
        if (canAdd)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('mposSplitAddMethod'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(l10n.barAddPaymentMethod),
              style: TextButton.styleFrom(
                foregroundColor: PosTokens.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 14,
          runSpacing: 4,
          children: [
            _SummaryText(l10n.barSplitPaid(mposMoneyLabel(summary.paid))),
            _SummaryText(
              l10n.barSplitRemaining(mposMoneyLabel(summary.remaining)),
              emphasis: summary.remaining > 0.01,
            ),
            if (summary.change > 0.01)
              _SummaryText(l10n.barSplitChange(mposMoneyLabel(summary.change))),
          ],
        ),
        if (summary.nonCashOverTotal) ...[
          const SizedBox(height: 6),
          Text(
            l10n.mposSplitNonCashOverTotal,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: PosTokens.lossInk,
            ),
          ),
        ],
      ],
    );
  }
}

class _SplitRow extends StatelessWidget {
  const _SplitRow({
    super.key,
    required this.payment,
    required this.methods,
    required this.labelFor,
    required this.onAmountChanged,
    required this.onMethodChanged,
    required this.onRemove,
  });

  final Payment payment;
  final List<String> methods;
  final String Function(String method) labelFor;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onMethodChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: payment.method,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
              ),
              items: [
                for (final m in {...methods, payment.method})
                  DropdownMenuItem(value: m, child: Text(labelFor(m))),
              ],
              onChanged: (m) {
                if (m != null) onMethodChanged(m);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: payment.controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: PosTokens.ink1,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: '0',
                suffixText: ' RWF',
                suffixStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PosTokens.ink3,
                ),
              ),
              onChanged: onAmountChanged,
            ),
          ),
          IconButton(
            tooltip: context.flipperL10n.remove,
            onPressed: onRemove,
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: PosTokens.ink3,
            ),
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
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: emphasis ? FontWeight.w800 : FontWeight.w600,
        color: emphasis ? PosTokens.ink1 : PosTokens.ink3,
      ),
    );
  }
}
