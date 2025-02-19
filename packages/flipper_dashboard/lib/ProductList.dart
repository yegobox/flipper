// ignore_for_file: unused_result
import 'package:flipper_dashboard/PaymentModeModal.dart';
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart' show locator;
import 'package:stacked_services/stacked_services.dart';

class ProductListScreen extends StatefulHookConsumerWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with
        Datamixer,
        TransactionMixin,
        TextEditingControllersMixin,
        PreviewCartMixin,
        Refresh {
  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering()!;
    final theme = Theme.of(context);

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: _buildAppBar(theme: theme),
          body: _buildBody(ref, model: model),
          floatingActionButton: _buildFloatingActionButton(ref, isOrdering),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar({required ThemeData theme}) {
    if (isIos || isAndroid) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => locator<RouterService>().back(),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      );
    }
    return null;
  }

  Widget _buildBody(WidgetRef ref, {required ProductViewModel model}) {
    final items = ref.watch(productFromSupplier);
    final isPreviewing = ref.watch(previewingCart);

    return items.when(
      data: (variants) => variants.isEmpty
          ? _buildEmptyProductList()
          : _buildProductView(variants, isPreviewing, model: model),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildEmptyProductList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a supplier to view products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductView(List<Variant> variants, bool isPreviewing,
      {required ProductViewModel model}) {
    return isPreviewing
        ? _buildQuickSellingView()
        : _buildProductGrid(variants, model: model);
  }

  Widget _buildProductGrid(List<Variant> variants,
      {required ProductViewModel model}) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        return buildVariantRow(
          forceRemoteUrl: true,
          context: context,
          model: model,
          variant: variants[index],
          isOrdering: true,
        );
      },
      shrinkWrap: true,
    );
  }

  Widget _buildQuickSellingView() {
    return QuickSellingView(
      deliveryNoteCotroller: deliveryNoteCotroller,
      formKey: formKey,
      discountController: discountController,
      receivedAmountController: receivedAmountController,
      customerPhoneNumberController: customerPhoneNumberController,
      customerNameController: customerNameController,
      paymentTypeController: paymentTypeController,
    );
  }

  Widget _buildFloatingActionButton(WidgetRef ref, bool isOrdering) {
    final transaction =
        ref.watch(pendingTransactionStreamProvider(isExpense: isOrdering));

    if (transaction.value == null) return const SizedBox.shrink();

    final orderCount = ref
            .watch(
                transactionItemsProvider(transactionId: transaction.value?.id))
            .valueOrNull
            ?.length ??
        0;

    return Consumer(
      builder: (context, ref, _) {
        final digitalPaymentEnabled =
            ref.watch(isDigialPaymentEnabledProvider).valueOrNull ?? false;

        return _buildPreviewSaleButton(
          ref,
          transaction.value!,
          orderCount,
          isOrdering,
          digitalPaymentEnabled,
        );
      },
    );
  }

  Widget _buildPreviewSaleButton(WidgetRef ref, ITransaction transaction,
      int orderCount, bool isOrdering, bool digitalPaymentEnabled) {
    final isPreviewing = ref.watch(previewingCart);
    final buttonText = isPreviewing
        ? "Place order"
        : orderCount > 0
            ? "Preview Cart ($orderCount)"
            : "Preview Cart";

    return SizedBox(
      width: 200,
      child: PreviewSaleButton(
        digitalPaymentEnabled: digitalPaymentEnabled,
        transactionId: transaction.id,
        wording: buttonText,
        mode: SellingMode.forOrdering,
        previewCart: () =>
            _handlePreviewCart(ref, orderCount, transaction, isOrdering),
      ),
    );
  }

  Future<void> _handlePreviewCart(WidgetRef ref, int orderCount,
      ITransaction transaction, bool isOrdering) async {
    if (orderCount > 0) {
      final isPreviewing = ref.read(previewingCart.notifier).state;
      if (!isPreviewing) {
        ref.read(previewingCart.notifier).state = true;
      } else {
        _showPaymentModeModal(ref, transaction, isOrdering);
      }
    } else {
      toast("The cart is empty");
    }
  }

  void _showPaymentModeModal(
      WidgetRef ref, ITransaction transaction, bool isOrdering) {
    showPaymentModeModal(context, (provider) async {
      await _handleOrderPlacement(ref, transaction, isOrdering, provider);
    });
  }

  Future<void> _handleOrderPlacement(WidgetRef ref, ITransaction transaction,
      bool isOrdering, FinanceProvider financeOption) async {
    try {
      await placeFinalOrder(
          transaction: transaction, financeOption: financeOption);
      ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));
      ref.read(previewingCart.notifier).state = false;

      ITransaction? newTransaction = await ProxyService.strategy
          .manageTransaction(
              transactionType: TransactionType.purchase,
              isExpense: isOrdering,
              branchId: ProxyService.box.getBranchId()!);
      refreshTransactionItems(transactionId: newTransaction!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order Placed successfully'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 350.0, // Adjust left margin
            right: 350.0, // Adjust right margin
            bottom: 20.0, // Adjust bottom margin if needed
          ),
        ),
      );
    } catch (e) {
      talker.error(e);
    }
  }
}
