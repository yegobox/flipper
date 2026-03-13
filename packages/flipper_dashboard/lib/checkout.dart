// ignore_for_file: unused_result

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/CheckoutProductView.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_dashboard/controllers/checkout_controller.dart';
import 'package:flipper_dashboard/widgets/pos_default_view.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
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
    return Material(
      color: Colors.white,
      child: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );

    return transactionAsyncValue.when(
      data: (transaction) => _buildDataWidget(transaction),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $stackTrace')),
    );
  }

  Widget _buildDataWidget(ITransaction transaction) {
    return widget.isBigScreen
        ? _buildBigScreenLayout(
            transaction,
            showCart: ref.watch(oldImplementationOfRiverpod.previewingCart),
          )
        : _buildSmallScreenLayout(
            transaction,
            showCart: ref.watch(oldImplementationOfRiverpod.previewingCart),
          );
  }

  Widget _buildBigScreenLayout(
    ITransaction transaction, {
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

  Widget _buildBigScreenContent(ITransaction transaction, CoreViewModel model) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FadeTransition(
                  opacity: _animation,
                  child: PosDefaultView(
                    transaction: transaction,
                    quickSellingView: _buildQuickSellingView(),
                    onCompleteTransaction: (immediateCompletion, [onPaymentConfirmed, onPaymentFailed]) async {
                      return await _handleCompleteTransaction(
                        transaction,
                        immediateCompletion,
                        onPaymentConfirmed,
                        onPaymentFailed,
                      );
                    },
                    onTicketNavigation: () => handleTicketNavigation(transaction),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5.0,
              left: 5.0,
              right: 5.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: (constraints.maxWidth - 10).clamp(200.0, 560.0),
                ),
                child: SearchInputWithDropdown(),
              ),
            ),
          ],
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
    
    return await controller.handleCompleteTransaction(
      transaction: transaction,
      immediateCompletion: immediateCompletion,
      startCompleteTransactionFlow: startCompleteTransactionFlow,
      applyDiscount: applyDiscount,
      refreshTransactionItems: refreshTransactionItems,
      discountController: discountController,
      onPaymentConfirmed: onPaymentConfirmed != null
          ? () {
              onPaymentConfirmed();
              newTransaction(typeOfThisTransactionIsExpense: false);
            }
          : null,
      onPaymentFailed: onPaymentFailed,
    );
  }

  Widget _buildSmallScreenLayout(
    ITransaction transaction, {
    required bool showCart,
  }) {
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
