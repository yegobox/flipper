// ignore_for_file: unused_result
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

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

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with Datamixer {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  bool showCart = false;
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(productFromSupplier);
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => ProductViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Products'),
            ),
            body: items.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(child: Text('No products available'));
                }
                return !showCart
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
                            context: context,
                            model: model,
                            variant: products[index],
                            isOrdering: true,
                          );
                        },
                        shrinkWrap: true,
                      )
                    : QuickSellingView(
                        formKey: _formKey,
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
                wording: "Preview Cart",
                mode: SellingMode.forOrdering,
                previewCart: () {
                  setState(() {
                    showCart = !showCart;
                  });
                },
              ),
            ),
          );
        });
  }
}
