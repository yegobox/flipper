// ignore_for_file: unused_result
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/previewCart.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flipper_models/states/productListProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with
        Datamixer,
        TransactionMixin,
        TextEditingControllersMixin,
        PreviewcartMixin {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(productFromSupplier);
    final isOrdering = ProxyService.box.isOrdering()!;
    talker.warning("ProductListScreen:isOrdering: ${isOrdering}");
    final orders = ref
        .watch(transactionItemsProvider((isExpense: isOrdering)))
        .value!
        .length;

    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => ProductViewModel(),
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            body: items.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(child: Text('No products available'));
                }
                return !ref.watch(previewingCart)
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 2.0,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          // Double-check the index before accessing the list
                          if (index < 0 || index >= products.length) {
                            return SizedBox.shrink();
                          }
                          return buildVariantRow(
                            forceRemoteUrl: true,
                            context: context,
                            model: model,
                            variant: products[index],
                            isOrdering: true,
                          );
                        },
                        shrinkWrap: true,
                      )
                    : QuickSellingView(
                        formKey: formKey,
                        discountController: discountController,
                        receivedAmountController: receivedAmountController,
                        customerPhoneNumberController:
                            customerPhoneNumberController,
                        paymentTypeController: paymentTypeController,
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $stack')),
            ),
            floatingActionButton: SizedBox(
              width: 200,
              child: PreviewSaleButton(
                wording: ref.watch(previewingCart)
                    ? "Place order"
                    : orders > 0
                        ? "Preview Cart (${orders})"
                        : "Preview Cart",
                mode: SellingMode.forOrdering,
                previewCart: () async {
                  if (orders > 0) {
                    final transaction = ref.watch(
                        pendingTransactionProviderNonStream((isOrdering
                            ? (mode: TransactionType.cashOut, isExpense: true)
                            : (mode: TransactionType.sale, isExpense: false))));

                    /// now if we are not previewing we can place order
                    await previewOrOrder(transaction: transaction);

                    await Future.delayed(Duration(microseconds: 600));

                    /// refresh
                    ref.refresh(pendingTransactionProviderNonStream((isOrdering
                        ? (mode: TransactionType.cashOut, isExpense: true)
                        : (mode: TransactionType.sale, isExpense: false))));
                    ref.refresh(
                        transactionItemsProvider((isExpense: isOrdering)));
                  } else {
                    toast("The cart is empty");
                  }
                },
              ),
            ),
          );
        });
  }
}
