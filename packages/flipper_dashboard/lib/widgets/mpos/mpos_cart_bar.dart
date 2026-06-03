import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';

class MposCartBar extends StatelessWidget {
  const MposCartBar({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onReviewPay,
    this.emptyLabel = 'Tap a product to start a sale',
  });

  final int itemCount;
  final double total;
  final VoidCallback? onReviewPay;
  final String emptyLabel;

  bool get _isEmpty => itemCount <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PosTokens.surface,
        border: Border(top: BorderSide(color: PosTokens.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x2E103240),
            offset: Offset(0, -10),
            blurRadius: 30,
            spreadRadius: -16,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: _isEmpty
          ? Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PosTokens.surface2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                emptyLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: PosTokens.ink3,
                ),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onReviewPay,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  height: MposTokens.cartBarHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: MposTokens.gradBtn,
                    boxShadow: MposTokens.shadowBlue,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Container(
                        constraints: const BoxConstraints(minWidth: 30),
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$itemCount',
                          style: mposMonoStyle(
                            Theme.of(context).textTheme,
                            fontSize: 14,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$itemCount ${itemCount == 1 ? 'item' : 'items'} in cart',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            Text(
                              'RWF ${mposMoneyLabel(total)}',
                              style: mposMonoStyle(
                                Theme.of(context).textTheme,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Review & Pay',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
