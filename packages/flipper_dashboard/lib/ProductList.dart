// ignore_for_file: unused_result
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flipper_models/states/productListProvider.dart';
import 'package:stacked/stacked.dart';
import 'Confirm.dart';
import 'preview_sale_button.dart';

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> {
  Color hexToColor(String code) {
    if (code.isNotEmpty) {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return Color(
          int.parse("#FF0000".substring(1, 7), radix: 16) + 0xFF000000);
    }
  }

  List<Color> extractColors(List<Variant> variants) {
    return variants.map((variant) => hexToColor(variant.color)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: ref.watch(productListProvider).when(
            data: (products) {
              return ViewModelBuilder.reactive(
                  viewModelBuilder: () => ProductViewModel(),
                  builder: (context, model, child) {
                    return ListView.builder(
                      itemCount: products!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Confirm(
                                  products: products,
                                  colors: extractColors(products),
                                ),
                              ),
                            );
                          },
                          child: RowItem(
                            variant: products[index],
                            color: products[index].color,
                            name: products[index].name,
                            stock: 1,
                            model: model,
                            addToMenu: (item) async {
                              Variant variant = item as Variant;
                              ITransaction? iTransaction = ref
                                  .read(pendingTransactionProvider(
                                      variant.branchId))
                                  .value
                                  ?.value;
                              await model.saveTransaction(
                                  variation: variant,
                                  currentStock: 1.0,
                                  amountTotal: variant.retailPrice,
                                  customItem: false,
                                  pendingTransaction: iTransaction!);
                              ref.refresh(transactionItemsProvider);
                            },
                          ),
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
        ),
      ),
    );
  }
}
