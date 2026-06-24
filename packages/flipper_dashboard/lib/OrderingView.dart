// OrderingView
import 'dart:io';

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/ordering/empty_product_view.dart';
import 'package:flipper_dashboard/ordering/ordering_app_bar.dart';
import 'package:flipper_dashboard/ordering/preview_sale_button_wrapper.dart';
import 'package:flipper_dashboard/ordering/product_grid_view.dart';
import 'package:flipper_dashboard/view_models/ordering_view_model.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';

class OrderingView extends HookConsumerWidget {
  const OrderingView(this.transaction, {Key? key}) : super(key: key);
  final ITransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrdering = ProxyService.box.isOrdering()!;

    // Watch the transaction items stream
    // Watch the transaction items stream
    final transactionItems = ref.watch(
      transactionItemsStreamProvider(transactionId: transaction.id),
    );
    // Calculate total quantity (handling both separate rows and aggregated quantities)
    final streamCount =
        transactionItems.value
            ?.fold<double>(0.0, (sum, item) => sum + (item.qty.toDouble()))
            .toInt() ??
        0;

    // Watch optimistic count for immediate UI updates
    final optimisticCount = ref.watch(optimisticOrderCountProvider);

    // Use the higher of optimistic or stream count to ensure we never show a lower count
    // This provides instant feedback while the stream catches up
    final orderCount = optimisticCount > streamCount
        ? optimisticCount
        : streamCount;

    // Sync optimistic count with actual stream count when stream updates
    ref.listen(transactionItemsStreamProvider(transactionId: transaction.id), (
      previous,
      next,
    ) {
      next.whenData((items) {
        // Sync with total quantity, not just list length
        final totalQty = items
            .fold<double>(0.0, (sum, item) => sum + (item.qty.toDouble()))
            .toInt();
        ref.read(optimisticOrderCountProvider.notifier).syncWith(totalQty);
      });
    });

    return ViewModelBuilder<OrderingViewModel>.reactive(
      viewModelBuilder: () => OrderingViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: (Platform.isAndroid || Platform.isIOS)
              ? OrderingAppBar(isOrdering: isOrdering)
              : null,
          body: _buildBody(ref, model: model),
          floatingActionButton: _buildFloatingActionButton(
            ref,
            isOrdering,
            orderCount,
            model,
          ),
        );
      },
    );
  }

  Widget _buildBody(WidgetRef ref, {required OrderingViewModel model}) {
    final items = ref.watch(productFromSupplierWrapper);
    final isPreviewing = ref.watch(previewingCart);

    return Column(
      children: [
        Expanded(
          child: items.when(
            data: (variants) => variants.isEmpty
                ? const EmptyProductView()
                : _buildProductView(variants, isPreviewing, model: model),
            loading: () {
              // Check if supplier is selected - only show loading if supplier exists
              final selectedSupplier = ref.watch(selectedSupplierProvider);
              if (selectedSupplier == null) {
                // No supplier selected, show empty view instead of loading
                return const EmptyProductView();
              }
              // Supplier is selected, show loading indicator
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading products...'),
                  ],
                ),
              );
            },
            error: (error, stack) {
              // Check if the error is "Select a supplier"
              final errorMessage = error.toString();
              if (errorMessage.contains('Select a supplier')) {
                return const EmptyProductView();
              }

              // Show actual error state with Builder to access context
              return Builder(
                builder: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Error loading products',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$error',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () =>
                              ref.refresh(productFromSupplierWrapper),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductView(
    List<Variant> variants,
    bool isPreviewing, {
    required OrderingViewModel model,
  }) {
    return isPreviewing
        ? _buildQuickSellingView(model)
        : ProductGridView(variants: variants, model: model, isOrdering: true);
  }

  Widget _buildQuickSellingView(OrderingViewModel model) {
    return QuickSellingView(
      deliveryNoteCotroller: model.deliveryNoteCotroller,
      formKey: model.formKey,
      discountController: model.discountController,
      receivedAmountController: model.receivedAmountController,
      customerPhoneNumberController: model.customerPhoneNumberController,
      paymentTypeController: model.paymentTypeController,
      countryCodeController: model.countryCodeController,
    );
  }

  Widget _buildFloatingActionButton(
    WidgetRef ref,
    bool isOrdering,
    int orderCount,
    OrderingViewModel model,
  ) {
    return PreviewSaleButtonWrapper(
      transaction: transaction,
      orderCount: orderCount,
      isOrdering: isOrdering,
      model: model,
    );
  }
}
