// ignore_for_file: unused_result

import 'dart:math' as math;

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/CheckoutProductView.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_dashboard/controllers/checkout_controller.dart';
import 'package:flipper_dashboard/widgets/pos_default_view.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/navigation_guard_service.dart';

/// Customer search now lives inside [QuickSellingView] (cart column). No top
/// overlay inset on desktop checkout.
const double _kDesktopCheckoutBodyTopInset = 0.0;

enum OrderStatus { pending, approved }

class CheckOut extends StatefulHookConsumerWidget {
  const CheckOut({Key? key, required this.isBigScreen}) : super(key: key);

  final bool isBigScreen;

  @override
  CheckOutState createState() => CheckOutState();
}

class CheckOutState extends ConsumerState<CheckOut>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        TextEditingControllersMixin,
        TransactionMixinOld,
        PreviewCartMixin,
        Refresh {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    NavigationGuardService().startCriticalWorkflow();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();

    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      tabController = TabController(length: 3, vsync: this);
    }
  }

  @override
  void dispose() {
    NavigationGuardService().endCriticalWorkflow();
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    tabController.dispose();
    discountController.dispose();
    receivedAmountController.dispose();
    customerPhoneNumberController.dispose();
    paymentTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.white, child: _buildMainContent());
  }

  Widget _buildMainContent() {
    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );

    return transactionAsyncValue.when(
      // Keep last transaction visible when the stream reloads (e.g. dependency
      // change); only the initial load uses loading: below.
      skipLoadingOnReload: true,
      data: (transaction) => _buildDataWidget(transaction),
      // Show product grid / POS shell immediately; QuickSellingView and
      // PosDefaultView handle their own loading; footer waits for transaction id.
      loading: () => _buildDataWidget(null),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            color: Theme.of(
              context,
            ).colorScheme.errorContainer.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to Load Checkout',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      // ref.refresh forces an eager re-evaluation (unlike
                      // invalidate which is lazy and may not rebuild from
                      // an error state immediately).
                      ref.refresh(
                        pendingTransactionStreamProvider(isExpense: false),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataWidget(ITransaction? transaction) {
    final showCart = ref.watch(oldImplementationOfRiverpod.previewingCart);
    return widget.isBigScreen
        ? _buildBigScreenLayout(transaction, showCart: showCart)
        : _buildSmallScreenLayout(showCart: showCart);
  }

  Widget _buildBigScreenLayout(
    ITransaction? transaction, {
    required bool showCart,
  }) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return !showCart
            ? _buildBigScreenContent(transaction, model)
            : _buildQuickSellingView();
      },
    );
  }

  Widget _buildBigScreenContent(
    ITransaction? transaction,
    CoreViewModel model,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: math.max(
            0.0,
            constraints.maxHeight - _kDesktopCheckoutBodyTopInset,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: _kDesktopCheckoutBodyTopInset),
            child: FadeTransition(
              opacity: _animation,
              child: PosDefaultView(
                transaction: transaction,
                quickSellingView: _buildQuickSellingView(),
                onCompleteTransaction:
                    (
                      immediateCompletion, [
                      onPaymentConfirmed,
                      onPaymentFailed,
                    ]) async {
                      final txn = transaction;
                      if (txn == null) {
                        return false;
                      }
                      return await _handleCompleteTransaction(
                        txn,
                        immediateCompletion,
                        onPaymentConfirmed,
                        onPaymentFailed,
                      );
                    },
                onTicketNavigation: () {
                  final txn = transaction;
                  if (txn != null) {
                    handleTicketNavigation(txn);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSellingView() {
    return QuickSellingView(
      deliveryNoteCotroller: deliveryNoteCotroller,
      formKey: formKey,
      countryCodeController: countryCodeController,
      discountController: discountController,
      receivedAmountController: receivedAmountController,
      customerPhoneNumberController: customerPhoneNumberController,
      paymentTypeController: paymentTypeController,
    );
  }

  String getCartText({required String transactionId}) {
    // Get the latest count with a fresh watch to ensure reactivity
    final itemsAsync = ref.watch(
      transactionItemsStreamProvider(
        transactionId: transactionId,
        branchId: ProxyService.box.getBranchId() ?? '0',
      ),
    );

    // Get the count from the async value
    final count = itemsAsync.when(
      data: (items) => items.length,
      loading: () => int.parse(getCartItemCount(transactionId: transactionId)),
      error: (_, __) => 0,
    );

    return count > 0 ? 'Preview Cart ($count)' : 'Preview Cart';
  }

  Future<bool> _handleCompleteTransaction(
    ITransaction transaction,
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  ]) async {
    final controller = CheckoutController(ref: ref, context: context);

    final transactionItemsHint = ref
        .read(
          transactionItemsStreamProvider(
            transactionId: transaction.id,
            branchId: ProxyService.box.getBranchId() ?? '0',
          ),
        )
        .asData
        ?.value;

    return await controller.handleCompleteTransaction(
      transaction: transaction,
      immediateCompletion: immediateCompletion,
      startCompleteTransactionFlow: startCompleteTransactionFlow,
      applyDiscount: applyDiscount,
      refreshTransactionItems: refreshTransactionItems,
      discountController: discountController,
      transactionItemsHint: transactionItemsHint,
      onPaymentConfirmed: onPaymentConfirmed != null
          ? () {
              onPaymentConfirmed();
              newTransaction(typeOfThisTransactionIsExpense: false);
            }
          : null,
      onPaymentFailed: onPaymentFailed,
    );
  }

  Widget _buildSmallScreenLayout({required bool showCart}) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              onWillPop(
                context: context,
                navigationPurpose: NavigationPurpose.home,
                message: 'Do you want to go home?',
              );
            }
          },
          child: !showCart
              ? CheckoutProductView(
                  widget: widget,
                  tabController: tabController,
                  textEditController: textEditController,
                  model: model,
                  onCompleteTransaction:
                      (
                        transaction,
                        immediateCompletion, [
                        onPaymentConfirmed,
                        onPaymentFailed,
                      ]) async {
                        return await _handleCompleteTransaction(
                          transaction,
                          immediateCompletion,
                          onPaymentConfirmed,
                          onPaymentFailed,
                        );
                      },
                )
              : SafeArea(child: _buildQuickSellingView()),
        );
      },
    );
  }
}
