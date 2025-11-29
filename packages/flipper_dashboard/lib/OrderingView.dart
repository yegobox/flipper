// OrderingView
import 'dart:io';

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/ordering/empty_product_view.dart';
import 'package:flipper_dashboard/ordering/ordering_app_bar.dart';
import 'package:flipper_dashboard/ordering/preview_sale_button_wrapper.dart';
import 'package:flipper_dashboard/ordering/product_grid_view.dart';
import 'package:flipper_dashboard/view_models/ordering_view_model.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class OrderingView extends HookConsumerWidget {
  const OrderingView(this.transaction, {Key? key}) : super(key: key);
  final ITransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrdering = ProxyService.box.isOrdering()!;

    // Watch the transaction items directly without intermediate state
    final transactionItems = ref.watch(
      transactionItemsStreamProvider(transactionId: transaction.id),
    );
    final orderCount = transactionItems.value?.length ?? 0;

    // Use useState to manage search text
    final searchText = useState('');

    return ViewModelBuilder<OrderingViewModel>.reactive(
      viewModelBuilder: () => OrderingViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: (Platform.isAndroid || Platform.isIOS)
              ? OrderingAppBar(isOrdering: isOrdering)
              : null,
          body: _buildBody(ref, model: model, searchText: searchText),
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

  Widget _buildBody(
    WidgetRef ref, {
    required OrderingViewModel model,
    required ValueNotifier<String> searchText,
  }) {
    final items = ref.watch(productFromSupplierWrapper);
    final isPreviewing = ref.watch(previewingCart);

    return Column(
      children: [
        if (!isPreviewing)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchText.value = '';
                          ref.read(searchStringProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                searchText.value = value;
                ref.read(searchStringProvider.notifier).state = value;
              },
            ),
          ),
        Expanded(
          child: items.when(
            data: (variants) => variants.isEmpty
                ? const EmptyProductView()
                : _buildProductView(variants, isPreviewing, model: model),
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading products...'),
                ],
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 8),
                  Text('Error loading products'),
                  SizedBox(height: 8),
                  Text('$error', style: TextStyle(fontSize: 12)),
                  ElevatedButton(
                    onPressed: () => ref.refresh(productFromSupplierWrapper),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
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
