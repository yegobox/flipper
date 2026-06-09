import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingBottomNav extends ConsumerWidget {
  const AccountingBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(accountingMobileTabProvider);
    final pending = ref.watch(pendingCountProvider);

    return Container(
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(top: BorderSide(color: AccountingTokens.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _TabBtn(
                icon: Icons.home_outlined,
                label: 'Snapshot',
                selected: tab == AccountingMobileTab.snapshot,
                onTap: () => ref.read(accountingMobileTabProvider.notifier).state = AccountingMobileTab.snapshot,
              ),
              _TabBtn(
                icon: Icons.verified_user_outlined,
                label: 'Approvals',
                selected: tab == AccountingMobileTab.approvals,
                badge: pending,
                onTap: () => ref.read(accountingMobileTabProvider.notifier).state = AccountingMobileTab.approvals,
              ),
              _TabBtn(
                icon: Icons.bar_chart_outlined,
                label: 'Reports',
                selected: tab == AccountingMobileTab.reports,
                onTap: () => ref.read(accountingMobileTabProvider.notifier).state = AccountingMobileTab.reports,
              ),
              _TabBtn(
                icon: Icons.grid_view,
                label: 'More',
                selected: tab == AccountingMobileTab.more,
                onTap: () => ref.read(accountingMobileTabProvider.notifier).state = AccountingMobileTab.more,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AccountingTokens.accent : AccountingTokens.ink3;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22, color: color),
                if (badge != null && badge! > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(color: AccountingTokens.warnAmber, borderRadius: BorderRadius.circular(8)),
                      child: Text('$badge', style: AccountingTokens.mono(fontSize: 9, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: AccountingTokens.sans(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
