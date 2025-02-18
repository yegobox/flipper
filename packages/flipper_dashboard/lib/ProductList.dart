// ignore_for_file: unused_result
import 'package:flipper_dashboard/PaymentModeModal.dart';
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
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
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen>
    with
        Datamixer,
        TransactionMixin,
        TextEditingControllersMixin,
        PreviewCartMixin {
  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering()!;
    final theme = Theme.of(context);

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => ProductViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: (isIos || isAndroid)
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_outlined),
                    onPressed: () => locator<RouterService>().back(),
                  ),
                  elevation: 0,
                  backgroundColor: theme.colorScheme.surface,
                  actions: [
                    // You can add any actions here, such as a refresh button.
                  ],
                )
              : null,
          body: _buildBody(ref),
          floatingActionButton: _buildFloatingActionButton(ref, isOrdering),
        );
      },
    );
  }

  Widget _buildBody(WidgetRef ref) {
    final items = ref.watch(productFromSupplier);
    final isPreviewing = ref.watch(previewingCart);

    return items.when(
      data: (variants) {
        if (variants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_rounded,
                  size: 48,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .2),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a supplier to view products',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          );
        }

        return isPreviewing
            ? _buildQuickSellingView()
            : _buildProductGrid(variants);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildProductGrid(List<Variant> variants) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        if (index < 0 || index >= variants.length) {
          return const SizedBox.shrink();
        }
        return buildVariantRow(
          forceRemoteUrl: true,
          context: context,
          model: ProductViewModel(),
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

  Widget _buildFloatingActionButton(
    WidgetRef ref,
    bool isOrdering,
  ) {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: isOrdering),
    );

    final orders = ref
            .watch(
                transactionItemsProvider(transactionId: transaction.value?.id))
            .value
            ?.length ??
        0;

    // Watch the FutureProvider and handle its state
    final digitalPaymentEnabledAsync =
        ref.watch(isDigialPaymentEnabledProvider);

    return digitalPaymentEnabledAsync.when(
      data: (digitalPaymentEnabled) {
        return SizedBox(
          width: 200,
          child: PreviewSaleButton(
            digitalPaymentEnabled: digitalPaymentEnabled,
            transactionId: transaction.value?.id ?? "",
            wording: ref.watch(previewingCart)
                ? "Place order"
                : orders > 0
                    ? "Preview Cart ($orders)"
                    : "Preview Cart",
            mode: SellingMode.forOrdering,
            previewCart: () async {
              //
              // add a modal to prompt user to choose payment mode
              /// deal with a model, make sure we can have it shown
              if (orders > 0) {
                if (!ref.read(previewingCart)) {
                  // Toggle to preview mode
                  ref.read(previewingCart.notifier).state = true;
                } else {
                  showPaymentModeModal(context, (provider) async {
                    print('User selected Finance Provider: ${provider.name}');
                    await _handleOrderPlacement(
                        ref, transaction.value!, isOrdering,
                        financeOption: provider);
                  });
                }
              } else {
                toast("The cart is empty");
              }
            },
          ),
        );
      },
      loading: () =>
          const CircularProgressIndicator(), // Show a loader while waiting
      error: (error, stack) {
        // Handle the error (e.g., show an error message)
        toast("Error loading digital payment status: $error");
        return SizedBox(
          width: 200,
          child: PreviewSaleButton(
            digitalPaymentEnabled: false, // Fallback value
            transactionId: transaction.value?.id ?? "",
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
                  showPaymentModeModal(context, (provider) async {
                    print('User selected Finance Provider: ${provider.name}');
                    await _handleOrderPlacement(
                        ref, transaction.value!, isOrdering,
                        financeOption: provider);
                  });
                }
              } else {
                toast("The cart is empty");
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _handleOrderPlacement(
      WidgetRef ref, ITransaction transaction, bool isOrdering,
      {required FinanceProvider financeOption}) async {
    await placeFinalOrder(
        transaction: transaction, financeOption: financeOption);

    await Future.delayed(const Duration(milliseconds: 600));

    // Refresh transaction providers
    ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));
    ref.refresh(transactionItemsProvider(transactionId: transaction.id));

    // Exit preview mode after order placement
    ref.read(previewingCart.notifier).state = false;
  }
}
