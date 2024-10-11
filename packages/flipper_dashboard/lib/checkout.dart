// ignore_for_file: unused_result

import 'dart:io';

import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/bottomSheet.dart';
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

enum OrderStatus { pending, approved }

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
            showCart: ref.watch(previewingCart))
        : _buildSmallScreenLayout(transaction,
            showCart: ref.watch(previewingCart));
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
                  child: (ProxyService.box.isPosDefault()!)
                      ? _buildPosDefaultContent(transaction, model)
                      : SizedBox.shrink(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: FadeTransition(
                opacity: _animation,
                child: (ProxyService.box.isOrdersDefault()!)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: SegmentedButton<OrderStatus>(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary;
                                    },
                                  ),
                                  side: WidgetStateProperty.all(
                                    BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                segments: const <ButtonSegment<OrderStatus>>[
                                  ButtonSegment<OrderStatus>(
                                    value: OrderStatus.pending,
                                    label: Text('Pending'),
                                    icon: Icon(Icons.hourglass_empty),
                                  ),
                                  ButtonSegment<OrderStatus>(
                                    value: OrderStatus.approved,
                                    label: Text('Approved'),
                                    icon: Icon(Icons.check_circle_outline),
                                  ),
                                ],
                                selected: <OrderStatus>{_selectedStatus},
                                onSelectionChanged:
                                    (Set<OrderStatus> newSelection) {
                                  setState(() {
                                    _selectedStatus = newSelection.first;
                                  });
                                  if (newSelection.first ==
                                      OrderStatus.approved) {
                                    ref
                                        .watch(stringProvider.notifier)
                                        .updateString(RequestStatus.approved);
                                  } else if (newSelection.first ==
                                      OrderStatus.pending) {
                                    ref
                                        .watch(stringProvider.notifier)
                                        .updateString(RequestStatus.pending);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: SingleChildScrollView(
                                child: const IncomingOrdersWidget(),
                              ),
                            ),
                          ],
                        ),
                      )
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
                    _buildIconRow(),
                    transaction.isValid
                        ? SearchInputWithDropdown(
                            transaction:
                                transaction.isValid ? transaction : null)
                        : SizedBox.shrink()
                  ],
                ),
              ),
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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildQuickSellingView(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PayableView(
            mode: SellingMode.forSelling,
            completeTransaction: () {
              if (customerNameController.text.isEmpty) {
                /// remove old customer added maybe from previous sale
                ProxyService.box.remove(key: 'customerName');
              }
              handleCompleteTransaction(
                  transaction: transaction,
                  paymentMethods: ref.watch(paymentMethodsProvider));
            },
            ref: ref,
            model: model,
            ticketHandler: () => handleTicketNavigation(transaction),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSellingView() {
    // return SizedBox.shrink();
    return QuickSellingView(
      deliveryNoteCotroller: deliveryNoteCotroller,
      formKey: formKey,
      discountController: discountController,
      receivedAmountController: receivedAmountController,
      customerPhoneNumberController: customerPhoneNumberController,
      paymentTypeController: paymentTypeController,
      customerNameController: customerNameController,
    );
  }

  String getCartText() {
    int count = int.parse(getCartItemCount());
    return count > 0 ? 'Preview Cart ($count)' : 'Preview Cart';
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
                          wording: getCartText(),
                          ref: ref,
                          model: model,
                          ticketHandler: () =>
                              handleTicketNavigation(transaction),
                          previewCart: () {
                            talker.warning("Show Quick Sell: ${showCart}");
                            if (Platform.isAndroid || Platform.isIOS) {
                              BottomSheets.showBottom(
                                  context: context,
                                  ref: ref,
                                  transactionId: transaction.id,
                                  onCharge: (transactionId, total) {
                                    try {
                                      handleCompleteTransaction(
                                          transaction: transaction,
                                          paymentMethods: ref
                                              .watch(paymentMethodsProvider));
                                      ref.read(loadingProvider.notifier).state =
                                          false;
                                      Navigator.of(context).pop();
                                    } catch (e, s) {
                                      talker.warning(e);
                                      talker.error(s);
                                    }
                                  },
                                  doneDelete: () {
                                    print("done delete");
                                    final isOrdering =
                                        ProxyService.box.isOrdering() ?? false;

                                    ref.refresh(transactionItemsProvider(
                                        (isExpense: isOrdering)));
                                    ref.refresh(transactionItemsStreamProvider(
                                        transaction.id));

                                    /// force closing the modal, this is because we have no way to update the item on bottomsheet
                                    /// since bottom sheet is called on button click and we have no way to update it without another trigger
                                    /// and bottomsheet is not a stateful widget
                                    Navigator.of(context).pop();
                                  });
                            } else {
                              previewOrOrder(
                                  isShopingFromWareHouse: false,
                                  transaction: transaction);
                            }
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
        child: SingleChildScrollView(
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
      ),
    );
  }
}
