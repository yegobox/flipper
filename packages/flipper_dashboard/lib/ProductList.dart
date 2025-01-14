// ignore_for_file: unused_result
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
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
    final isOrdering = ProxyService.box.isOrdering()!;

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => ProductViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: Consumer(
            builder: (context, ref, child) {
              // Watch productFromSupplier and previewingCart states
              final items = ref.watch(productFromSupplier);
              final isPreviewing = ref.watch(previewingCart);

              return items.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text('No products available'));
                  }

                  // Check if we are previewing or showing the product list
                  if (!isPreviewing) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        if (index < 0 || index >= products.length) {
                          return const SizedBox.shrink();
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
                    );
                  } else {
                    return QuickSellingView(
                      deliveryNoteCotroller: deliveryNoteCotroller,
                      formKey: formKey,
                      discountController: discountController,
                      receivedAmountController: receivedAmountController,
                      customerPhoneNumberController:
                          customerPhoneNumberController,
                      customerNameController: customerNameController,
                      paymentTypeController: paymentTypeController,
                    );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
          ),
          floatingActionButton: Consumer(
            builder: (context, ref, child) {
              // Watch the transaction items provider to get the updated order count
              final orders = ref
                      .watch(transactionItemsProvider((isExpense: isOrdering)))
                      .value
                      ?.length ??
                  0;

              return SizedBox(
                width: 200,
                child: PreviewSaleButton(
                  wording: ref.watch(previewingCart)
                      ? "Place order"
                      : orders > 0
                          ? "Preview Cart ($orders)"
                          : "Preview Cart",
                  mode: SellingMode.forOrdering,
                  previewCart: () async {
                    if (orders > 0) {
                      if (!ref.read(previewingCart)) {
                        // Toggle to preview mode
                        ref.read(previewingCart.notifier).state = true;
                      } else {
                        // Place order
                        final transaction = ref.read(
                          pendingTransactionProviderNonStream((isOrdering
                              ? (mode: TransactionType.cashOut, isExpense: true)
                              : (
                                  mode: TransactionType.sale,
                                  isExpense: false
                                ))),
                        );

                        await previewOrOrder(transaction: transaction.value!);

                        await Future.delayed(const Duration(milliseconds: 600));

                        // Refresh transaction providers
                        ref.refresh(pendingTransactionProviderNonStream(
                            (isOrdering
                                ? (
                                    mode: TransactionType.cashOut,
                                    isExpense: true
                                  )
                                : (
                                    mode: TransactionType.sale,
                                    isExpense: false
                                  ))));
                        ref.refresh(
                            transactionItemsProvider((isExpense: isOrdering)));

                        // Exit preview mode after order placement
                        ref.read(previewingCart.notifier).state = false;
                      }
                    } else {
                      toast("The cart is empty");
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
