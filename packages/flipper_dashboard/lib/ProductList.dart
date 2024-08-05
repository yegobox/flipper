// ignore_for_file: unused_result
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flipper_models/states/productListProvider.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'preview_sale_button.dart';

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with Datamixer, TransactionMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  bool showCart = false;
  Future<void> previewCart() async {
    if (!showCart) {
      setState(() => showCart = true);
      return;
    }

    try {
      final isOrdering = ref.watch(isOrderingProvider);
      final transactionType =
          isOrdering ? TransactionType.cashOut : TransactionType.sale;
      final transaction = ref.watch(pendingTransactionProvider(
          (mode: transactionType, isExpense: isOrdering)));

      final items = ProxyService.realm.transactionItems(
        transactionId: transaction.value!.id!,
        doneWithTransaction: false,
        active: true,
      );

      if (items.isEmpty) {
        setState(() => showCart = false);
        return;
      }

      await _createStockRequest(items);
      await _markItemsAsDone(items, transaction.value!);
      _changeTransactionStatus(transaction: transaction.value!);
      await _refreshTransactionItems(transaction.value?.id);

      print("Order placed with ${items.length} items in basket");
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> _createStockRequest(List<TransactionItem> items) async {
    final realm = ProxyService.realm.realm!;
    realm.write(() {
      final stockRequest = StockRequest(
        ObjectId(),
        id: randomNumber(),
        mainBranchId: ref.read(selectedSupplierProvider).value!.serverId,
        subBranchId: ProxyService.box.getBranchId(),
        status: RequestStatus.pending,
        items: items,
        updatedAt: DateTime.now().toUtc().toLocal(),
        createdAt: DateTime.now().toUtc().toLocal(),
      );
      realm.add<StockRequest>(stockRequest);
    });
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems(int? transactionId) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    ref.refresh(transactionItemsProvider(transactionId));
    await Future.delayed(const Duration(milliseconds: 200));
    ref.refresh(transactionItemsProvider(transactionId));
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(productFromSupplier);
    final isOrdering = ref.watch(isOrderingProvider);
    final transaction = ref.watch(pendingTransactionProvider((isOrdering
        ? (mode: TransactionType.cashOut, isExpense: true)
        : (mode: TransactionType.sale, isExpense: false))));

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
                wording: showCart
                    ? "Place order"
                    : "Preview Cart (${ref.watch(transactionItemsProvider(transaction.value?.id)).value?.length})",
                mode: SellingMode.forOrdering,
                previewCart: () async {
                  previewCart();
                },
              ),
            ),
          );
        });
  }

  void _changeTransactionStatus({required ITransaction transaction}) {
    ProxyService.realm.realm!.write(() {
      /// we mark the status so next time we query pending transaction we don't
      /// accidently query this PENDING transaction and avoid mixxing things up
      transaction.status = ORDERING;
    });
  }
}
