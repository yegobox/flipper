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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class OrderingView extends StatefulHookConsumerWidget {
  const OrderingView(this.transaction, {Key? key}) : super(key: key);
  final ITransaction transaction;
  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<OrderingView> {
  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering()!;

    // Watch the transaction items directly without intermediate state
    final transactionItems = ref.watch(
        transactionItemsStreamProvider(transactionId: widget.transaction.id));
    final orderCount = transactionItems.value?.length ?? 0;

    return ViewModelBuilder<OrderingViewModel>.reactive(
      viewModelBuilder: () => OrderingViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: (Platform.isAndroid || Platform.isIOS)
              ? OrderingAppBar(isOrdering: isOrdering)
              : null,
          body: _buildBody(ref, model: model),
          floatingActionButton:
              _buildFloatingActionButton(ref, isOrdering, orderCount, model),
        );
      },
    );
  }

  Widget _buildBody(WidgetRef ref, {required OrderingViewModel model}) {
    final items = ref.watch(productFromSupplier);
    final isPreviewing = ref.watch(previewingCart);

    return items.when(
      data: (variants) => variants.isEmpty
          ? const EmptyProductView()
          : _buildProductView(variants, isPreviewing, model: model),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('$error')),
    );
  }

  Widget _buildProductView(List<Variant> variants, bool isPreviewing,
      {required OrderingViewModel model}) {
    return isPreviewing
        ? _buildQuickSellingView(model)
        : ProductGridView(
            variants: variants,
            model: model,
            isOrdering: true,
          );
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
      WidgetRef ref, bool isOrdering, int orderCount, OrderingViewModel model) {
    return PreviewSaleButtonWrapper(
      transaction: widget.transaction,
      orderCount: orderCount,
      isOrdering: isOrdering,
      model: model,
    );
  }
}
