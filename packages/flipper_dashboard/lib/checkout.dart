// ignore_for_file: unused_result

import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flutter/foundation.dart';

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'body.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TabController tabController;
  final FocusNode keyPadFocusNode = FocusNode();
  final TextEditingController textEditController = TextEditingController();
  final TextEditingController searchContrroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _purchaseCodeFormkey = GlobalKey<FormState>();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  final TextEditingController _purchasecodecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
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
    super.dispose();
  }

  Future<void> handleReceiptGeneration(
      {String? purchaseCode, ITransaction? transaction}) async {
    try {
      ITransaction? trans =
          await ProxyService.realm.getTransactionById(id: transaction!.id!);

      TaxController(object: trans).handleReceipt(
        purchaseCode: purchaseCode,
        printCallback: (Uint8List bytes) async {
          _formKey.currentState?.reset();
          ref.refresh(loadingProvider.notifier);

          // receivedAmountController.clear();
          ref.read(loadingProvider.notifier).state = false;
          ref.refresh(loadingProvider.notifier);
          ref.read(isProcessingProvider.notifier).stopProcessing();
          ref.refresh(pendingTransactionProvider(
              (mode: TransactionType.sale, isExpense: false)));

          await printing(bytes);
        },
      );
    } catch (e) {
      talker.error(e);
    }
  }

  Future<void> printing(Uint8List bytes) async {
    final printers = await Printing.listPrinters();

    if (printers.isNotEmpty) {
      Printer? pri = await Printing.pickPrinter(
          context: context, title: "List of printers");

      await Printing.directPrintPdf(
          printer: pri!, onLayout: (PdfPageFormat format) async => bytes);
    }
  }

  Future<void> confirmPayment(
      {required CoreViewModel model,
      required String paymentType,
      required double amount,
      required ITransaction transaction,
      required double discount}) async {
    if (transaction.customerId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height;
          final double adjustedHeight = height * 0.8;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.grey[100],
            title: Text(
              'Digital Receipt',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue[800]),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: adjustedHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _purchaseCodeFormkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Do you need a digital receipt?',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _purchasecodecontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Purchase Code',
                            // filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                Icon(Icons.receipt, color: Colors.blue[800]),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a purchase code';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {},
                          onSaved: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:
                    Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  ref.read(isProcessingProvider.notifier).stopProcessing();
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: ref.watch(isProcessingProvider)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () async {
                  if (_purchaseCodeFormkey.currentState?.validate() ?? false) {
                    ref.read(isProcessingProvider.notifier).toggleProcessing();
                    // _purchaseCodeFormkey.currentState?.save();
                    String purchaseCode = _purchasecodecontroller.text;
                    talker.warning("received purchase code: $purchaseCode");
                    await handlePayment(
                        model: model,
                        transactionType: TransactionType.sale,
                        categoryId: "0",
                        paymentType: paymentType,
                        transaction: transaction,
                        amount: amount,
                        discount: discount,
                        purchaseCode: purchaseCode);
                    ref.read(loadingProvider.notifier).state = false;
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    /// refresh and go home
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

    model.handlingConfirm = false;
  }

  Future<void> handlePayment(
      {String? purchaseCode,
      required CoreViewModel model,
      required String paymentType,
      required ITransaction transaction,
      String? categoryId,
      required String transactionType,
      required double amount,
      required double discount}) async {
    ITransaction trans = model.collectPayment(
      categoryId: categoryId,
      transactionType: transactionType,
      paymentType: paymentType,
      transaction: transaction,
      amountReceived: amount,
      discount: discount,
      isIncome: true,
      directlyHandleReceipt: false,
    );

    if (ProxyService.realm
            .isTaxEnabled(business: ProxyService.local.getBusiness()) &&
        ProxyService.box.getServerUrl() != null &&
        ProxyService.box.bhfId() != null) {
      await handleReceiptGeneration(
          transaction: trans, purchaseCode: purchaseCode);
    }
    ref.refresh(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));
    ref.read(loadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the pendingTransactionProvider and handle its states safely
    final transactionAsyncValue = ref.watch(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));

    return transactionAsyncValue.when(
      data: (transaction) {
        if (widget.isBigScreen) {
          return ViewModelBuilder<CoreViewModel>.reactive(
            viewModelBuilder: () => CoreViewModel(),
            builder: (context, model, child) {
              return Stack(
                children: [
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: FadeTransition(
                      opacity: _animation,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconRow(),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 60.0),
                                if (ProxyService.box.isPosDefault()!)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QuickSellingView(
                                      formKey: _formKey,
                                      discountController: discountController,
                                      receivedAmountController:
                                          receivedAmountController,
                                      customerPhoneNumberController:
                                          customerPhoneNumberController,
                                      paymentTypeController:
                                          paymentTypeController,
                                    ),
                                  ),
                                if (ProxyService.box.isPosDefault()!)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PaymentTicketManager(
                                      context: context,
                                      model: model,
                                      controller: textEditController,
                                      nodeDisabled: true,
                                      completeTransaction: () async {
                                        ref
                                            .read(loadingProvider.notifier)
                                            .state = true;
                                        Customer? customer = ProxyService.realm
                                            .getCustomer(
                                                id: transaction.customerId);

                                        final amount = double.tryParse(
                                                receivedAmountController
                                                    .text) ??
                                            0;
                                        final discount = double.tryParse(
                                                discountController.text) ??
                                            0;

                                        if (_formKey.currentState!.validate() &&
                                            customer == null) {
                                          handlePayment(
                                            model: model,
                                            paymentType: "Cash",
                                            transactionType:
                                                TransactionType.sale,
                                            transaction: transaction,
                                            amount: amount,
                                            discount: discount,
                                          );
                                        } else {
                                          confirmPayment(
                                            amount: amount,
                                            model: model,
                                            discount: discount,
                                            paymentType:
                                                paymentTypeController.text,
                                            transaction: transaction,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                if (ProxyService.box.isOrdersDefault()!)
                                  IncomingOrdersWidget()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 92.0,
                    left: 5.0,
                    right: 8.0,
                    child: SearchInputWithDropdown(
                      transaction: transaction,
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return ViewModelBuilder<CoreViewModel>.reactive(
            viewModelBuilder: () => CoreViewModel(),
            builder: (context, model, child) {
              return PopScope(
                canPop: false,
                onPopInvoked: (bool didPop) {
                  if (didPop) {
                    return;
                  }
                  onWillPop(
                    context: context,
                    navigationPurpose: NavigationPurpose.home,
                    message: 'Do you want to go home?',
                  );
                },
                child: Stack(
                  children: [
                    MobileView(
                        widget: widget,
                        tabController: tabController,
                        textEditController: textEditController,
                        model: model),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        child: PaymentTicketManager(
                          context: context,
                          model: model,
                          controller: textEditController,
                          nodeDisabled: true,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
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
