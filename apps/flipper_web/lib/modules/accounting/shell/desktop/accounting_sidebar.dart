import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_header.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_toast.dart';
import 'package:flipper_web/modules/accounting/widgets/books_brand_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Light rail styling aligned with [EnhancedSideMenu] in flipper_dashboard.
class AccountingSidebar extends ConsumerWidget {
  const AccountingSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingView view = ref.watch(accountingViewProvider);
    final pending = ref.watch(pendingCountProvider);
    final business = ref.watch(selectedBusinessProvider);
    final entityName = business?.name ?? 'Business';
    final fiscalYear = ref.watch(accountingFiscalYearLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);
    final userName = ref.watch(accountingUserNameProvider);
    final userRole = ref.watch(accountingUserRoleProvider);

    return Container(
      width: AccountingTokens.sidebarWidth,
      decoration: const BoxDecoration(
        color: AccountingTokens.sidebarBg,
        border: Border(
          right: BorderSide(color: AccountingTokens.sidebarBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: BooksBrandRow(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Material(
              color: AccountingTokens.sidebarBg2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AccountingTokens.line),
              ),
              child: InkWell(
                onTap: () => context.goNamed(AppRoute.businessSelection.name),
                borderRadius: BorderRadius.circular(12),
                hoverColor: AccountingTokens.surface2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                          accountingEntityInitials(entityName),
                          style: AccountingTokens.sans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entityName,
                              style: AccountingTokens.sans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AccountingTokens.ink1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$fiscalYear · $currency',
                              style: AccountingTokens.sans(
                                fontSize: 11,
                                color: AccountingTokens.ink3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.expand_more, color: AccountingTokens.ink4, size: 18),
                    ],
                  ),
                ),
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
                      style: AccountingTokens.sans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AccountingTokens.ink3,
                        letterSpacing: 0.08 * 10.5,
                      ),
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
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => showAccountingToast(
                  context,
                  'Preferences',
                  icon: Icons.settings_outlined,
                ),
                borderRadius: BorderRadius.circular(10),
                hoverColor: AccountingTokens.surface2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: AccountingTokens.brandGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          accountingEntityInitials(
                            userName.isNotEmpty ? userName : entityName,
                          ),
                          style: AccountingTokens.sans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName.isNotEmpty ? userName : '—',
                              style: AccountingTokens.sans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AccountingTokens.ink1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (userRole.isNotEmpty)
                              Text(
                                userRole,
                                style: AccountingTokens.sans(
                                  fontSize: 11.5,
                                  color: AccountingTokens.ink3,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.settings_outlined,
                        color: AccountingTokens.ink3,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final AccountingNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? AccountingTokens.accent : AccountingTokens.ink3;
    final labelColor = selected ? AccountingTokens.accent : AccountingTokens.ink2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusSm),
        hoverColor: AccountingTokens.surface2,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.ease,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? AccountingTokens.accentTint : Colors.transparent,
            borderRadius: BorderRadius.circular(AccountingTokens.radiusSm),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 19, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.view.label,
                  style: AccountingTokens.sans(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
              if (badge != null && badge! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selected ? AccountingTokens.accent : AccountingTokens.warnTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$badge',
                    style: AccountingTokens.mono(
                      fontSize: 11,
                      color: selected ? Colors.white : AccountingTokens.warnAmber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
