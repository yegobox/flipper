import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/OrderingView.dart';
import 'package:flipper_dashboard/ordering/ordering_desktop_view.dart';
import 'package:flipper_dashboard/ordering/unified_search_field.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:stacked_services/stacked_services.dart';

class Orders extends HookConsumerWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingTransaction = ref.watch(
      pendingTransactionStreamProvider(isExpense: true),
    );
    // The three-pane purchase order needs real desktop width; below that the
    // mobile flow (search, then grid) still applies.
    final isDesktop = MediaQuery.sizeOf(context).width > 600;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic other) {
        ProxyService.box.writeBool(key: 'isOrdering', value: false);
        if (!didPop) {
          ProxyService.box.writeBool(key: 'isOrdering', value: true);
        }
        // Hand the cart providers back to whichever mode the box now holds.
        syncPosCartIsExpenseWidget(ref);
        ref.read(previewingCart.notifier).state = false;
        onWillPop(
          context: context,
          navigationPurpose: NavigationPurpose.home,
          message: 'Done shopping?',
        );
      },
      // The desktop purchase order brings its own chrome — back, order
      // reference, supplier — so a second app bar above it would just repeat
      // the back button.
      child: Scaffold(
        appBar: isDesktop
            ? null
            : AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () => locator<RouterService>().back(),
                ),
                elevation: 0,
                backgroundColor: theme.colorScheme.surface,
              ),
        body: isDesktop
            ? _buildDesktopLayout(
                context,
                ref,
                transaction: pendingTransaction.value,
              )
            : _buildMobileLayout(
                context,
                ref,
                transaction: pendingTransaction.value,
              ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref, {
    ITransaction? transaction,
  }) {
    if (transaction == null) return const SizedBox.shrink();
    return OrderingDesktopView(transaction);
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref, {
    ITransaction? transaction,
  }) {
    if (transaction == null) return const SizedBox.shrink();

    final selectedSupplier = ref.watch(selectedSupplierProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order from Supplier',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            selectedSupplier == null
                ? 'Search and select a supplier to view their products'
                : 'Search products from ${selectedSupplier.name}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          const UnifiedSearchField(),
          const SizedBox(height: 32),
          if (selectedSupplier != null)
            Expanded(child: OrderingView(transaction)),
        ],
      ),
    );
  }
}
