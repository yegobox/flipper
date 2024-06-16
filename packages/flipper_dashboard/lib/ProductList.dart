// ignore_for_file: unused_result
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flipper_models/states/productListProvider.dart';
import 'package:stacked/stacked.dart';
import 'preview_sale_button.dart';

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final itemOnCart = ref.watch(cartListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ref.watch(productFromSupplier).when(
            data: (products) {
              return ViewModelBuilder.reactive(
                  viewModelBuilder: () => ProductViewModel(),
                  builder: (context, model, child) {
                    return ListView.builder(
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        return RowItem(
                          variant: products[index],
                          color: products[index].color!,
                          productName: products[index].name!,
                          variantName: products[index].name!,
                          stock: 1,
                          model: model,
                          addToMenu: (item) async {
                            Variant variant = item as Variant;

                            /// get a cash out pending transaction
                            /// because after this is approved by supplier it will be in
                            /// cash out for retailer and cash in for supplier

                            ITransaction? iTransaction = ref
                                .read(pendingTransactionProvider(
                                    TransactionType.cashOut))
                                .value
                                ?.value;

                            ProxyService.realm.realm!.write(() {
                              iTransaction!.supplierId = variant.branchId;
                            });

                            // add item to cart
                            ref
                                .read(cartListProvider.notifier)
                                .addToCart(variant);
                            // add colors
                            ref
                                .read(productColorsProvider.notifier)
                                .fetchColors(itemOnCart);
                            await model.saveTransaction(
                                variation: variant,
                                currentStock: 1.0,
                                amountTotal: variant.retailPrice,
                                customItem: false,
                                pendingTransaction: iTransaction!);
                            ref.refresh(
                                transactionItemsProvider(iTransaction.id));
                          },
                        );
                      },
                    );
                  });
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
      floatingActionButton: SizedBox(
        width: 200,
        child: PreviewSaleButton(
          wording: "Preview Cart",
          mode: SellingMode.forOrdering,
          completeTransaction: () {},
        ),
      ),
    );
  }
}
