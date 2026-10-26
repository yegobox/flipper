import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// "Credit · N" on the tables screen: opens the unpaid bills. Always shown, so
/// staff can find where loans live before the first one exists; a red dot
/// once a bill is overdue.
///
/// Collecting is settling, so it asks for a manager PIN wherever Settle does.
class BarCreditFloorButton extends ConsumerWidget {
  const BarCreditFloorButton({super.key, this.compact = false});

  /// Phone header: icon and count only.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(barCreditTabsProvider).value ?? const [];
    final overdue = loans.any((l) => barCreditIsOverdue(l));
    final l10n = context.flipperL10n;
    // Phone header: the icon alone until somebody owes something.
    final label = loans.isEmpty
        ? (compact ? '' : l10n.barCredit)
        : compact
        ? '${loans.length}'
        : l10n.barCreditCount(loans.length);

    void open() {
      final notifier = ref.read(barModeProvider.notifier);
      final cashier = ref.read(barModeProvider).activeCashier;
      final isManager = cashier != null && barTenantIsManager(cashier);
      if (isManager || !BarModeSettings.managerSettle) {
        notifier.goCredit();
      } else {
        notifier.showManagerPin(then: BarScreen.credit);
      }
    }

    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        key: const ValueKey('bar_credit_floor_button'),
        onTap: open,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          height: compact ? 40 : 46,
          padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(color: BarTokens.line, width: 1.5),
            boxShadow: BarTokens.shadow1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: 18,
                    color: BarTokens.blue,
                  ),
                  if (overdue)
                    Positioned(
                      top: -2,
                      right: -3,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: BarTokens.lossInk,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 9),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: BarTokens.ink2,
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
