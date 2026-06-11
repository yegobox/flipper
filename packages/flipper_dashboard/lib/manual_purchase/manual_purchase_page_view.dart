import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_ui.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_form.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Full-page shell for [ManualPurchaseForm], shown as
/// [DashboardPage.recordPurchase].
class ManualPurchasePageView extends ConsumerWidget {
  const ManualPurchasePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final catalogVariants =
        ref.watch(outerVariantsProvider(branchId)).value ?? [];

    return IpmScreenBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: ImportPurchaseTokens.surface,
              border: Border(bottom: BorderSide(color: ImportPurchaseTokens.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: ImportPurchaseTokens.ink2),
                  tooltip: 'Back to Import & Purchase',
                  onPressed: () {
                    ref.read(selectedPageProvider.notifier).state =
                        DashboardPage.purchases;
                  },
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ImportPurchaseTokens.accentWash,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: ImportPurchaseTokens.accentStrong,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Record Purchase',
                      style: ImportPurchaseHelpers.text(
                        size: 19,
                        weight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Capture a supplier invoice and its line items',
                      style: ImportPurchaseHelpers.text(
                        size: 13,
                        weight: FontWeight.w500,
                        color: ImportPurchaseTokens.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ManualPurchaseForm(
              catalogVariants: catalogVariants,
              useImportPurchaseTheme: true,
            ),
          ),
        ],
      ),
    );
  }
}
