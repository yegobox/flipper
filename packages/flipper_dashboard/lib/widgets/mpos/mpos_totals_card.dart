import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';

class MposTotalsCard extends StatelessWidget {
  const MposTotalsCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.alreadyPaid = 0,
    this.pendingPayment = 0,
    this.remainingBalance = 0,
    this.change,
    this.balanceDue,
  });

  final double subtotal;
  final double tax;
  final double total;
  final double alreadyPaid;
  final double pendingPayment;
  final double remainingBalance;
  final double? change;
  final double? balanceDue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return MposCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _row(context, 'Subtotal', subtotal),
          _row(context, 'Tax', tax),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: PosTokens.lineStrong, width: 1),
                ),
              ),
              padding: const EdgeInsets.only(top: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.ink1,
                    ),
                  ),
                  _money(theme, total, fontSize: 24),
                ],
              ),
            ),
          ),
          if (alreadyPaid > 0) ...[
            const SizedBox(height: 8),
            _row(context, 'Already paid', alreadyPaid, ink: PosTokens.blue),
          ],
          if (pendingPayment > 0) ...[
            const SizedBox(height: 4),
            _row(context, 'This payment', pendingPayment, ink: PosTokens.blue),
          ],
          if (remainingBalance > 0 && (change == null || change! <= 0)) ...[
            const SizedBox(height: 4),
            _row(
              context,
              'Remaining balance',
              remainingBalance,
              ink: MposTokens.lossInk,
              bold: true,
            ),
          ],
          if (balanceDue != null && balanceDue! > 0) ...[
            const SizedBox(height: 4),
            _row(
              context,
              'Balance due',
              balanceDue!,
              ink: MposTokens.lossInk,
              bold: true,
            ),
          ],
          if (change != null && change! > 0) ...[
            const SizedBox(height: 4),
            _row(
              context,
              'Change',
              change!,
              ink: MposTokens.gainInk,
              bold: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    double amount, {
    Color? ink,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 15 : 13.5,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: bold ? PosTokens.ink1 : PosTokens.ink2,
            ),
          ),
          _money(
            Theme.of(context).textTheme,
            amount,
            fontSize: bold ? 18 : 14.5,
            color: ink,
            bold: bold,
          ),
        ],
      ),
    );
  }

  Widget _money(
    TextTheme theme,
    double amount, {
    double fontSize = 14.5,
    Color? color,
    bool bold = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'RWF ',
          style: TextStyle(
            fontSize: fontSize * 0.85,
            fontWeight: FontWeight.w600,
            color: PosTokens.ink3,
          ),
        ),
        Text(
          mposMoneyLabel(amount),
          style: mposMonoStyle(
            theme,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
