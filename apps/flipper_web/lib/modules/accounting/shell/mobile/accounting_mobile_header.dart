import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/books_brand_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String accountingEntityInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

class AccountingMobileHeader extends ConsumerWidget {
  const AccountingMobileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(accountingMobileTabProvider);
    final showEntity = tab == AccountingMobileTab.snapshot;
    final pending = ref.watch(pendingCountProvider);
    final business = ref.watch(selectedBusinessProvider);
    final entityName = business?.name ?? 'Business';
    final initials = accountingEntityInitials(entityName);
    final fiscalYear = ref.watch(accountingFiscalYearLabelProvider);
    final currency = ref.watch(accountingCurrencyProvider);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(bottom: BorderSide(color: AccountingTokens.line)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            children: [
              Row(
                children: [
                  const BooksBrandRow(logoSize: 32, variant: BooksBrandVariant.mobile),
                  const Spacer(),
                  _HeaderIconButton(
                    onPressed: () {},
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications_outlined, size: 20, color: AccountingTokens.ink2),
                        if (pending > 0)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AccountingTokens.loss,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AccountingTokens.surface,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: AccountingTokens.brandGradient,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      initials,
                      style: AccountingTokens.sans(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (showEntity) ...[
                const SizedBox(height: 14),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AccountingTokens.accentTint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              initials,
                              style: AccountingTokens.sans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AccountingTokens.accent,
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AccountingTokens.ink1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '$fiscalYear · $currency',
                                  style: AccountingTokens.sans(
                                    fontSize: 12,
                                    color: AccountingTokens.ink3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: AccountingTokens.ink4,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AccountingTokens.surface2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: child),
        ),
      ),
    );
  }
}
