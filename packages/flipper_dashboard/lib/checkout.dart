// ignore_for_file: unused_result

import 'dart:io';

import 'package:flipper_dashboard/IncomingOrders.dart' hide OrderStatusSelector;
import 'package:flipper_dashboard/OrderStatusSelector.dart';
import 'package:flipper_dashboard/PaymentModeModal.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/bottomSheet.dart';
import 'package:flipper_dashboard/CheckoutProductView.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/posthog_service.dart';

enum OrderStatus { pending, approved }

class CheckOut extends StatefulHookConsumerWidget {
  const CheckOut({
    Key? key,
    required this.isBigScreen,
  }) : super(key: key);

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
  OrderStatus _selectedStatus = OrderStatus.pending;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      tabController = TabController(length: 3, vsync: this);
    }
  }

  @override
  void dispose() {
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
    return Scaffold(
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    final transactionAsyncValue =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    return transactionAsyncValue.when(
      data: (transaction) => _buildDataWidget(transaction),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $stackTrace')),
    );
  }

  Widget _buildDataWidget(ITransaction transaction) {
    return widget.isBigScreen
        ? _buildBigScreenLayout(transaction,
            showCart: ref.watch(oldImplementationOfRiverpod.previewingCart))
        : _buildSmallScreenLayout(transaction,
            showCart: ref.watch(oldImplementationOfRiverpod.previewingCart));
  }

  Widget _buildBigScreenLayout(ITransaction transaction,
      {required bool showCart}) {
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
              padding: const EdgeInsets.only(top: 160.0),
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FadeTransition(
                  opacity: _animation,
                  child: (ProxyService.box.isPosDefault() ?? true)
                      ? _buildPosDefaultContent(transaction, model)
                      : SizedBox.shrink(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: FadeTransition(
                opacity: _animation,
                child: (ProxyService.box.isOrdersDefault() ?? false)
                    ? _buildOrdersContent()
                    : SizedBox.shrink(),
              ),
            ),
            Positioned(
              top: 5.0,
              left: 5.0,
              right: 8.0,
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Column(
                  children: [
                    _buildIconRow()
                        .eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
                    SearchInputWithDropdown()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          OrderStatusSelector(
            selectedStatus: _selectedStatus,
            onStatusChanged: (newStatus) {
              setState(() {
                _selectedStatus = newStatus;
              });
              ref
                  .watch(oldImplementationOfRiverpod.stringProvider.notifier)
                  .updateString(newStatus == OrderStatus.approved
                      ? RequestStatus.approved
                      : RequestStatus.pending);
            },
          ),
          const SizedBox(height: 20),
          Flexible(
            child: SingleChildScrollView(
              child: const IncomingOrders(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosDefaultContent(
      ITransaction transaction, CoreViewModel model) {
    final branchAsync = ref.watch(activeBranchProvider);
    return branchAsync.when(
      data: (branch) {
        return FutureBuilder<bool>(
          future: ProxyService.strategy.isBranchEnableForPayment(
              currentBranchId: branch.id) as Future<bool>,
          builder: (context, snapshot) {
            final digitalPaymentEnabled = snapshot.data ?? false;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildQuickSellingView(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PayableView(
                    transactionId: transaction.id,
                    mode: oldImplementationOfRiverpod.SellingMode.forSelling,
                    completeTransaction: (immediateCompletion) async {
                      await _handleCompleteTransaction(
                          transaction, immediateCompletion);
                    },
                    model: model,
                    ticketHandler: () => handleTicketNavigation(transaction),
                    digitalPaymentEnabled: digitalPaymentEnabled,
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
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
      customerNameController: customerNameController,
    );
  }

  Widget _buildIconRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: IconRow(),
          );
        },
      ),
    );
  }

  String getCartText({required String transactionId}) {
    // Force a refresh of the transaction items provider to ensure we have the latest data
    ref.invalidate(
        transactionItemsStreamProvider(transactionId: transactionId));

    // Get the latest count with a fresh watch to ensure reactivity
    final itemsAsync =
        ref.watch(transactionItemsStreamProvider(transactionId: transactionId));

    // Get the count from the async value
    final count = itemsAsync.when(
      data: (items) => items.length,
      loading: () => int.parse(getCartItemCount(transactionId: transactionId)),
      error: (_, __) => 0,
    );

    return count > 0 ? 'Preview Cart ($count)' : 'Preview Cart';
  }

  Future<void> _handleCompleteTransaction(
      ITransaction transaction, bool immediateCompletion) async {
    final startTime = transaction.createdAt!;

    // Set flags to prevent UI flicker during transaction completion
    ProxyService.box.writeBool(key: 'transactionInProgress', value: true);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: true);

    if (customerNameController.text.isEmpty) {
      ProxyService.box.remove(key: 'customerName');
      ProxyService.box.remove(key: 'getRefundReason');
    }
    if (discountController.text.isEmpty) {
      ProxyService.box.remove(key: 'discountRate');
    }
    try {
      applyDiscount(transaction);
      await startCompleteTransactionFlow(
        transactionId: transaction.id,
        immediateCompletion: immediateCompletion,
        completeTransaction: () async {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          await newTransaction(typeOfThisTransactionIsExpense: false);
          final endTime = DateTime.now().toUtc();
          final duration = endTime.difference(startTime).inSeconds;

          ProxyService.box
              .writeBool(key: 'transactionInProgress', value: false);
          ProxyService.box
              .writeBool(key: 'transactionCompleting', value: false);
          PosthogService.instance.capture('transaction_completed', properties: {
            'transaction_id': transaction.id,
            'branch_id': transaction.branchId!,
            'business_id': ProxyService.box.getBusinessId()!,
            'created_at': startTime.toIso8601String(),
            'completed_at': endTime.toIso8601String(),
            'duration_seconds': duration,
            'source': 'checkout',
          });
        },
        paymentMethods:
            ref.watch(oldImplementationOfRiverpod.paymentMethodsProvider),
      );
      // No need to call newTransaction here as it's already called in the completeTransaction callback
      // This prevents creating a new transaction when there's an error in the flow
    } catch (e) {
      // Reset flags in case of error
      ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
      ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
      ref.read(payButtonStateProvider.notifier).stopLoading();
      await refreshTransactionItems(transactionId: transaction.id);
      rethrow;
    }
  }

  Widget _buildSmallScreenLayout(ITransaction transaction,
      {required bool showCart}) {
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
              ? Stack(
                  children: [
                    CheckoutProductView(
                      widget: widget,
                      tabController: tabController,
                      textEditController: textEditController,
                      model: model,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: Builder(
                          builder: (context) {
                            final branchAsync = ref.watch(activeBranchProvider);
                            return branchAsync.when(
                              data: (branch) {
                                return FutureBuilder<bool>(
                                  future: ProxyService.strategy
                                          .isBranchEnableForPayment(
                                              currentBranchId: branch.id)
                                      as Future<bool>,
                                  builder: (context, snapshot) {
                                    final digitalPaymentEnabled =
                                        snapshot.data ?? false;
                                    return PayableView(
                                      transactionId: transaction.id,
                                      mode: oldImplementationOfRiverpod
                                          .SellingMode.forOrdering,
                                      wording: getCartText(
                                          transactionId: transaction.id),
                                      model: model,
                                      completeTransaction:
                                          (immediateCompletion) async {
                                        await _handleCompleteTransaction(
                                            transaction, immediateCompletion);
                                      },
                                      ticketHandler: () =>
                                          handleTicketNavigation(transaction),
                                      previewCart: () {
                                        if (Platform.isAndroid ||
                                            Platform.isIOS) {
                                          BottomSheets.showBottom(
                                            context: context,
                                            ref: ref,
                                            transactionId: transaction.id,
                                            onCharge:
                                                (transactionId, total) async {
                                              await _handleCompleteTransaction(
                                                  transaction, false);
                                              Navigator.of(context).pop();
                                            },
                                            doneDelete: () {
                                              ref.refresh(
                                                  transactionItemsStreamProvider(
                                                      branchId: ProxyService.box
                                                          .branchIdString()!,
                                                      transactionId:
                                                          transaction.id));
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        } else {
                                          showPaymentModeModal(context,
                                              (provider) async {
                                            print(
                                                'User selected Finance Provider: ${provider.name}');
                                            placeFinalOrder(
                                                financeOption: provider,
                                                isShoppingFromWareHouse: false,
                                                transaction: transaction);
                                          });
                                        }
                                      },
                                      digitalPaymentEnabled:
                                          digitalPaymentEnabled,
                                    );
                                  },
                                );
                              },
                              loading: () =>
                                  const Center(child: Text("Loading...")),
                              error: (error, stack) =>
                                  Center(child: Text('Error: $error')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Scaffold(body: SafeArea(child: _buildQuickSellingView())),
        );
      },
    );
  }
}
