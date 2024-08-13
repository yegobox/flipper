// ignore_for_file: unused_result

import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/previewCart.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class CheckOut extends StatefulHookConsumerWidget {
  CheckOut({
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
        TransactionMixin,
        PreviewcartMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController tabController;
  final FocusNode keyPadFocusNode = FocusNode();

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
      // run the code in here only once.
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
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    final transactionAsyncValue = ref.watch(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

    return transactionAsyncValue.when(
      data: (transaction) => _buildDataWidget(transaction),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $stackTrace')),
    );
  }

  Widget _buildDataWidget(ITransaction transaction) {
    if (!transaction.isValid) {
      ref.refresh(pendingTransactionProvider(
          (mode: TransactionType.sale, isExpense: false)));
    }

    return widget.isBigScreen
        ? _buildBigScreenLayout(transaction,
            showCart: ref.watch(toggleBetweenProductViewAndQuickSale))
        : _buildSmallScreenLayout(transaction,
            showCart: ref.watch(toggleBetweenProductViewAndQuickSale));
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
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: FadeTransition(
                  opacity: _animation,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconRow(),
                        const SizedBox(height: 60.0),
                        if (ProxyService.box.isPosDefault()!)
                          _buildPosDefaultContent(transaction, model),
                        // Text('POS!'),
                        if (ProxyService.box.isOrdersDefault()!)
                          const IncomingOrdersWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 92.0,
              left: 5.0,
              right: 8.0,
              child: SearchInputWithDropdown(transaction: transaction),
            ),
          ],
        );
      },
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

  Widget _buildPosDefaultContent(
      ITransaction transaction, CoreViewModel model) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildQuickSellingView(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PayableView(
            mode: SellingMode.forSelling,
            completeTransaction: () =>
                handleCompleteTransaction(transaction, model),
            ref: ref,
            model: model,
            ticketHandler: () => handleTicketNavigation(transaction),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSellingView() {
    return QuickSellingView(
      formKey: formKey,
      discountController: discountController,
      receivedAmountController: receivedAmountController,
      customerPhoneNumberController: customerPhoneNumberController,
      paymentTypeController: paymentTypeController,
    );
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
                    MobileView(
                      widget: widget,
                      tabController: tabController,
                      textEditController: textEditController,
                      model: model,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: PayableView(
                          mode: SellingMode.forSelling,
                          wording: "Preview Cart (${getCartItemCount()})",
                          ref: ref,
                          model: model,
                          ticketHandler: () =>
                              handleTicketNavigation(transaction),
                          previewCart: () {
                            talker.warning("Show Quick Sell: ${showCart}");
                            previewCart(isShopingFromWareHouse: false);
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

class MobileView extends StatefulHookConsumerWidget {
  const MobileView({
    required this.widget,
    required this.tabController,
    required this.textEditController,
    required this.model,
    Key? key,
  }) : super(key: key);
  final CoreViewModel model;
  final CheckOut widget;
  final TabController tabController;
  final TextEditingController textEditController;

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final TextEditingController textEditController = TextEditingController();
  final TextEditingController searchContrroller = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(
                controller: searchContrroller,
                showAddButton: true,
                showDatePicker: false,
                showIncomingButton: true,
                showOrderButton: true,
              ),
            ),
            ProductView.normalMode(),
          ],
        ),
      ),
    );
  }
}
