import 'package:flipper_dashboard/ordering/ordering_cart_actions.dart';
import 'package:flipper_dashboard/ordering/ordering_cart_panel.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog_rail.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog_table.dart';
import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_supplier_picker.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_top_bar.dart';
import 'package:flipper_dashboard/view_models/ordering_view_model.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// Desktop purchase order: pick a supplier, then rail · catalogue · order.
///
/// Replaces the grid-then-preview flow. Everything a buying decision needs —
/// the supplier's stock, the cost, and the order so far — is on screen at once,
/// so adding a line never hides the total and reviewing the total never hides
/// the catalogue.
class OrderingDesktopView extends HookConsumerWidget {
  const OrderingDesktopView(this.transaction, {super.key});

  final ITransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Backstop for a mode flip that happened without a ref (cron_service
    // resets `isOrdering`), so the keepAlive cart providers follow this screen.
    syncPosCartIsExpenseWidget(ref);

    final supplier = ref.watch(selectedSupplierProvider);
    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();

    return ViewModelBuilder<OrderingViewModel>.reactive(
      viewModelBuilder: OrderingViewModel.new,
      builder: (context, model, child) {
        return ColoredBox(
          color: OrderingTokens.bg,
          child: Column(
            children: [
              OrderingTopBar(
                transaction: transaction,
                supplier: supplier,
                onBack: () => locator<RouterService>().back(),
                onClearSupplier: () => _clearSupplier(ref, searchController),
              ),
              Expanded(
                child: supplier == null
                    ? OrderingSupplierPicker(
                        onPicked: (picked) => _pickSupplier(ref, picked),
                      )
                    : _OrderingWorkspace(
                        transaction: transaction,
                        supplier: supplier,
                        model: model,
                        searchController: searchController,
                        searchFocusNode: searchFocusNode,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickSupplier(WidgetRef ref, Branch supplier) {
    ref.read(selectedSupplierProvider.notifier).setSupplier(supplier);
    _resetCatalogFilters(ref);
  }

  void _clearSupplier(WidgetRef ref, TextEditingController searchController) {
    ref.read(selectedSupplierProvider.notifier).clearSupplier();
    searchController.clear();
    _resetCatalogFilters(ref);
    ref.read(orderingPlacedProvider.notifier).state = null;
  }

  /// A new supplier means a new catalogue: keeping the previous category or
  /// search would filter against names that are no longer there.
  void _resetCatalogFilters(WidgetRef ref) {
    ref.read(orderingQueryProvider.notifier).state = '';
    ref.read(orderingCategoryProvider.notifier).state =
        kOrderingAllCategories;
    ref.read(supplierCatalogSearchProvider.notifier).state = '';
  }
}

class _OrderingWorkspace extends HookConsumerWidget {
  const _OrderingWorkspace({
    required this.transaction,
    required this.supplier,
    required this.model,
    required this.searchController,
    required this.searchFocusNode,
  });

  final ITransaction transaction;
  final Branch supplier;
  final OrderingViewModel model;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Enter in the search field adds the row at the top of the current result
    // set — the whole point of typing a name rather than hunting for it.
    void addTopMatch() {
      final top = ref.read(orderingCatalogProvider).value?.topMatch;
      if (top == null) return;
      ref
          .read(orderingCartActionsProvider)
          .addOne(context: context, variant: top);
      searchController.clear();
      ref.read(orderingQueryProvider.notifier).state = '';
    }

    Future<void> placeOrder() async {
      final finance = ref.read(orderingFinanceProvider);
      if (finance == null) {
        showErrorNotification(
          context,
          'Choose how you are paying before sending the order.',
        );
        return;
      }

      final summary = ref.read(posCartSummaryProvider);
      final placed = await model.handleOrderPlacement(
        ref,
        transaction,
        true,
        finance,
        context,
        showSuccessDialog: false,
      );
      if (!placed) return;

      // Read from the summary captured before placement: the cart is emptied
      // as part of sending, so afterwards there is nothing left to count.
      ref.read(orderingPlacedProvider.notifier).state = PlacedOrder(
        supplierName: supplier.name ?? 'the supplier',
        lineCount: summary.activeLineCount,
        unitCount: summary.unitQtyTotal,
        total: summary.lineSubtotal + summary.lineTax,
      );
    }

    void startAnother() {
      ref.read(orderingPlacedProvider.notifier).state = null;
      model.deliveryNoteCotroller.clear();
      searchController.clear();
      ref.read(orderingQueryProvider.notifier).state = '';
    }

    return CallbackShortcuts(
      bindings: {
        // `/` jumps to search from anywhere on the screen, as the top bar
        // advertises. Bound at the workspace so it cannot fire while the
        // operator is still choosing a supplier.
        const SingleActivator(LogicalKeyboardKey.slash): () {
          if (!searchFocusNode.hasFocus) searchFocusNode.requestFocus();
        },
        // Escape out of a search without reaching for the clear button.
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (!searchFocusNode.hasFocus) return;
          searchController.clear();
          ref.read(orderingQueryProvider.notifier).state = '';
        },
      },
      child: Focus(
        autofocus: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showRail =
                constraints.maxWidth >= OrderingTokens.desktopMinWidth;
            final cartWidth = (constraints.maxWidth * 0.3).clamp(
              OrderingTokens.cartMinWidth,
              OrderingTokens.cartMaxWidth,
            );
            // What the catalogue is actually left with, so the rail only
            // offers the margin toggle when the table can honour it.
            final catalogWidth =
                constraints.maxWidth -
                cartWidth -
                (showRail ? OrderingTokens.railWidth : 0);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showRail)
                  SizedBox(
                    width: OrderingTokens.railWidth,
                    child: OrderingCatalogRail(
                      supplierId: supplier.id,
                      marginColumnFits:
                          catalogWidth >=
                          OrderingTokens.marginColumnMinPaneWidth,
                    ),
                  ),
                Expanded(
                  child: OrderingCatalogTable(
                    searchController: searchController,
                    searchFocusNode: searchFocusNode,
                    onSubmitted: addTopMatch,
                  ),
                ),
                SizedBox(
                  width: cartWidth,
                  child: OrderingCartPanel(
                    supplierName: supplier.name ?? 'the supplier',
                    noteController: model.deliveryNoteCotroller,
                    isPlacing: model.isLoading,
                    onPlaceOrder: placeOrder,
                    onStartAnother: startAnother,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
