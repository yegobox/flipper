import 'package:flipper_web/features/module_launcher/all_apps_sheet.dart';
import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountingTopbar extends ConsumerWidget {
  const AccountingTopbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccountingView view = ref.watch(accountingViewProvider);

    return Container(
      height: AccountingTokens.topbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(bottom: BorderSide(color: AccountingTokens.line)),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '${view.section} › ${view.label}',
              style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w600, color: AccountingTokens.ink2),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: SizedBox(
                height: 36,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(color: AccountingTokens.surface2, borderRadius: BorderRadius.circular(6)),
                      child: Text('⌘K', style: AccountingTokens.mono(fontSize: 10, color: AccountingTokens.ink3)),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AccountingTokens.line)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () {}, child: Text(demoPeriod, style: AccountingTokens.sans(fontSize: 13))),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
              Positioned(right: 12, top: 12, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AccountingTokens.loss, shape: BoxShape.circle))),
            ],
          ),
          IconButton(
            onPressed: () => AllAppsSheet.show(context),
            icon: const Icon(Icons.apps),
            tooltip: 'All apps',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.smartphone_outlined),
            tooltip: 'Mobile companion',
          ),
        ],
      ),
    );
  }
}
