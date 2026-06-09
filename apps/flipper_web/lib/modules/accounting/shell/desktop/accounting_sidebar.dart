import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/books_brand_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingSidebar extends ConsumerWidget {
  const AccountingSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(accountingViewProvider);
    final pending = pendingJournalCount();
    final business = ref.watch(selectedBusinessProvider);
    final entityName = business?.name ?? demoEntityName;

    return Container(
      width: AccountingTokens.sidebarWidth,
      color: AccountingTokens.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: BooksBrandRow(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AccountingTokens.sidebarBg2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: AccountingTokens.brandGradient,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      entityName.isNotEmpty ? entityName.substring(0, 1).toUpperCase() : 'D',
                      style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entityName, style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('$demoFiscalYear · $demoCurrency', style: AccountingTokens.sans(fontSize: 11.5, color: AccountingTokens.navMuted)),
                      ],
                    ),
                  ),
                  Icon(Icons.expand_more, color: Colors.white.withValues(alpha: 0.5), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                for (final group in accountingNavGroups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
                    child: Text(
                      group.section.toUpperCase(),
                      style: AccountingTokens.sans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AccountingTokens.navMuted, letterSpacing: 0.08 * 10.5),
                    ),
                  ),
                  for (final item in group.items)
                    _NavButton(
                      item: item,
                      selected: view == item.view,
                      badge: item.view == AccountingView.journal ? pending : null,
                      onTap: () => ref.read(accountingViewProvider.notifier).state = item.view,
                    ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Diane E.', style: AccountingTokens.sans(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('Owner · Bookkeeper', style: AccountingTokens.sans(fontSize: 11, color: AccountingTokens.navMuted)),
                    ],
                  ),
                ),
                Icon(Icons.settings_outlined, color: Colors.white.withValues(alpha: 0.6), size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, required this.onTap, this.badge});

  final AccountingNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AccountingTokens.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(item.icon, size: 19, color: selected ? Colors.white : Colors.white.withValues(alpha: 0.75)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.view.label,
                    style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.white.withValues(alpha: 0.85)),
                  ),
                ),
                if (badge != null && badge! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: AccountingTokens.warnTint, borderRadius: BorderRadius.circular(999)),
                    child: Text('$badge', style: AccountingTokens.mono(fontSize: 11, color: AccountingTokens.warnAmber, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
