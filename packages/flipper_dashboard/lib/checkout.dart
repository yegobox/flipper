// ignore_for_file: unused_result

import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/CheckoutProductView.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_dashboard/controllers/checkout_controller.dart';
import 'package:flipper_dashboard/widgets/checkout_error_recovery_screen.dart';
import 'package:flipper_dashboard/widgets/pos_default_view.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/navigation_guard_service.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';

/// Customer search now lives inside [QuickSellingView] (cart column). No top
/// overlay inset on desktop checkout.
const double _kDesktopCheckoutBodyTopInset = 0.0;

enum OrderStatus { pending, approved }

class CheckOut extends StatefulHookConsumerWidget {
  const CheckOut({Key? key, this.isBigScreen = false}) : super(key: key);

  /// When omitted (e.g. web URL `/check-out`), layout follows viewport width.
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
  TabController? tabController;
  bool _attachCartReconciliation = false;
  bool _mobileFirstFrameReady = false;

  @override
  void initState() {
    super.initState();
    NavigationGuardService().startCriticalWorkflow();

    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      if (widget.isBigScreen) {
        tabController = TabController(length: 3, vsync: this);
        _attachCartReconciliation = true;
      } else {
        // [CheckoutProductView] requires a controller; mobile UI does not use tabs.
        tabController = TabController(length: 1, vsync: this);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _mobileFirstFrameReady = true;
            _attachCartReconciliation = true;
          });
        });
      }
    }

    if (widget.isBigScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _warmPendingCartAfterOpen();
      });
    }
  }

  void _warmPendingCartAfterOpen() {
    warmPosCartPendingTransactionCacheWidget(ref, isExpense: false);
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) return;
    unawaited(
      ProxyService.getStrategy(Strategy.capella)
          .pendingTransactionFuture(
            branchId: branchId,
            transactionType: TransactionType.sale,
            isExpense: false,
          )
          .then((txn) {
            scheduleWriteCachedPendingCartTransactionWidget(
              ref,
              isExpense: false,
              transaction: txn,
            );
          }),
    );
  }

  @override
  void dispose() {
    NavigationGuardService().endCriticalWorkflow();
    WidgetsBinding.instance.removeObserver(this);
    tabController?.dispose();
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
    if (!widget.isBigScreen && !_mobileFirstFrameReady) {
      return _buildMobileOpeningFrame();
    }

    if (_attachCartReconciliation) {
      ref.listen(posCartStreamReconciliationProvider, (_, __) {});
    }

    // Mobile POS: [CheckoutProductView] owns pending-txn + catalog streams; skip
    // an extra outer [when] so the route paints on the first frame.
    if (!widget.isBigScreen) {
      return _buildDataWidget(
        readCachedPendingCartTransactionWidget(ref, isExpense: false),
      );
    }

    // [_warmPendingCartAfterOpen] may resolve the pending cart before the Ditto
    // stream emits; watching the cache avoids a stuck "Preparing checkout…" footer.
    listenCachedPendingCartTransactionSyncWidget(ref, isExpense: false);

    final cachedTransaction = ref.watch(cachedPendingSaleTransactionProvider);
    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );
    final transaction = transactionAsyncValue.value ?? cachedTransaction;

    if (transactionAsyncValue.hasError && transaction == null) {
      return CheckoutErrorRecoveryScreen(
        error: transactionAsyncValue.error!,
        isExpense: false,
        onRecovered: () async {
          ref.refresh(
            pendingTransactionStreamProvider(isExpense: false),
          );
        },
        onClose: () {
          if (!mounted) return;
          onWillPop(
            context: context,
            navigationPurpose: NavigationPurpose.home,
            message: 'Do you want to go home?',
          );
        },
      );
    }

    return _buildDataWidget(transaction);
  }

  Widget _buildMobileOpeningFrame() {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildDataWidget(ITransaction? transaction) {
    final showCart = ref.watch(oldImplementationOfRiverpod.previewingCart);
    return LayoutBuilder(
      builder: (context, constraints) {
        final useDesktopLayout =
            widget.isBigScreen ||
            constraints.maxWidth >= PosLayoutBreakpoints.mobileLayoutMaxWidth;
        return useDesktopLayout
            ? _buildBigScreenLayout(transaction, showCart: showCart)
            : _buildSmallScreenLayout(showCart: showCart);
      },
    );
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
    final count = ref.watch(
      posCartDisplayItemsProvider.select(
        (items) =>
            posCartDisplayItemsForTransaction(items, transactionId).length,
      ),
    );
    return count > 0 ? 'Preview Cart ($count)' : 'Preview Cart';
  }

  Future<void> _resetCheckoutAfterSuccessfulSale(
    ITransaction transaction,
  ) async {
    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    // End any till-settling session so the operator's next cart is no longer
    // scoped to the collected ticket (posCartDisplayItemsProvider keys off it).
    ref.read(settlingTillTicketProvider.notifier).state = null;

    if (!mounted) return;

    final branchId = ProxyService.box.getBranchId() ?? '0';
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transaction.id,
        branchId: branchId,
      ),
    );
    ref.invalidate(oldImplementationOfRiverpod.paymentMethodsProvider);
    ref.read(optimisticOrderCountProvider.notifier).reset();

    discountController.clear();
    receivedAmountController.clear();
    customerPhoneNumberController.clear();
    deliveryNoteCotroller.clear();
    ref.read(customerNameControllerProvider).clear();

    await newTransaction(
      typeOfThisTransactionIsExpense: ProxyService.box.isOrdering() ?? false,
    );

    ref.invalidate(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
    );

    if (ref.read(oldImplementationOfRiverpod.previewingCart)) {
      ref.read(oldImplementationOfRiverpod.previewingCart.notifier).state =
          false;
    }
  }

  Future<bool> _handleCompleteTransaction(
    ITransaction transaction,
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
    double overrideAlreadyPaid = 0.0,
  ]) async {
    final controller = CheckoutController(ref: ref, context: context);

    final transactionItemsHint =
        ref.read(optimisticCartProvider.notifier).hasPendingFor(transaction.id)
        ? null
        : () {
            final lines = ref
                .read(posCartDisplayItemsProvider)
                .where((i) => !OptimisticCartIds.isOptimistic(i.id))
                .toList();
            return lines.isEmpty ? null : lines;
          }();

    return await controller.handleCompleteTransaction(
      transaction: transaction,
      immediateCompletion: immediateCompletion,
      startCompleteTransactionFlow: startCompleteTransactionFlow,
      applyDiscount: applyDiscount,
      refreshTransactionItems: refreshTransactionItems,
      discountController: discountController,
      afterCheckoutSaleCleanup: _resetCheckoutAfterSuccessfulSale,
      transactionItemsHint: transactionItemsHint,
      overrideAlreadyPaid: overrideAlreadyPaid,
      onPaymentConfirmed: onPaymentConfirmed != null
          ? () {
              onPaymentConfirmed();
              newTransaction(
                typeOfThisTransactionIsExpense:
                    ProxyService.box.isOrdering() ?? false,
              );
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
                  tabController: tabController!,
                  textEditController: textEditController,
                  model: model,
                  onCompleteTransaction:
                      (
                        transaction,
                        immediateCompletion, [
                        onPaymentConfirmed,
                        onPaymentFailed,
                        double overrideAlreadyPaid = 0.0,
                      ]) async {
                        return await _handleCompleteTransaction(
                          transaction,
                          immediateCompletion,
                          onPaymentConfirmed,
                          onPaymentFailed,
                          overrideAlreadyPaid,
                        );
                      },
                )
              : SafeArea(child: _buildQuickSellingView()),
        );
      },
    );
  }
}
