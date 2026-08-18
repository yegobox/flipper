import 'package:flipper_hr/features/leave/data/leave_balance.dart';
import 'package:flipper_hr/features/leave/data/leave_working_days.dart';
import 'package:flutter/material.dart';

/// One leave type's standing for the year: days left, and how much of the
/// entitlement is committed.
///
/// Uncapped types ([LeaveType.unpaid]) show what has been taken and no bar —
/// there is no denominator, and a full or empty bar would both be a lie.
class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({super.key, required this.balance});

  final LeaveBalance balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final remaining = balance.remaining;

    return Container(
      key: Key('leave-balance-${balance.type.wire}'),
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            balance.type.label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            remaining == null
                ? formatLeaveDays(balance.committed)
                : formatLeaveDays(remaining),
            style: theme.textTheme.headlineSmall?.copyWith(
              // An overdraft is a real state — more leave was approved than the
              // entitlement allows — and it should not look like a healthy
              // balance.
              color: balance.isExhausted ? scheme.error : scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            remaining == null
                ? 'taken · no yearly limit'
                : 'left of ${formatLeaveDays(balance.entitlement!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (balance.usedFraction case final fraction?) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: scheme.surfaceContainerHighest,
                color: balance.isExhausted ? scheme.error : scheme.primary,
              ),
            ),
          ],
          if (balance.pending > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${formatLeaveDays(balance.pending)} awaiting approval',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.tertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
