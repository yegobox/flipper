// ignore_for_file: unused_result

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/favorites.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'body.dart';
import 'keypad_view.dart';
import 'product_view.dart';

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
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  bool _busy = false;

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
      [String? purchaseCode, ITransaction? transaction]) async {
    try {
      // TaxController(object: transaction).handleReceipt(handlePrint: (bytes) {});
      final f = TaxController(object: transaction);
      final bytes = await f.printReceipt(
        receiptType: transaction!.receiptType!,
        transaction: transaction,
        purchaseCode: purchaseCode,
        skiGenerateRRAReceiptSignature: false,
      );
      talker.warning("received bytes $bytes");
      // Navigator.of(context).pop();
    } catch (e) {
      talker.error(e);
      // setState(() => _busy = false);
      // showSnackBar(context, e.toString().split(': ').last,
      //     textColor: Colors.white, backgroundColor: Colors.green);
    }
  }

  Future<void> confirmPayment(
      {required CoreViewModel model,
      required String paymentType,
      required double amount,
      required ITransaction transaction,
      required double discount}) async {
    model.handlingConfirm = true;

    // Parse discount ONLY if _discount.text is NOT empty

    await model.collectPayment(
      paymentType: paymentType,
      transaction: transaction,
      amountReceived: amount,
      discount: discount,
      directlyHandleReceipt: false,
    );

    /// now handle the receipt now!. manually
    await handleReceiptGeneration();

    if (transaction.customerId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height;
          final double adjustedHeight =
              height * 0.8; // Adjust the height to 80% of the screen height

          return AlertDialog(
            title: Text('Digital Receipt'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: adjustedHeight,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Do you need a digital receipt?'),
                    TextFormField(
                      controller: _purchasecodecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Purchase Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a purchase code';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {},
                      // Handle the purchase code input
                      onSaved: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              BoxButton(
                title: 'Submit',
                busy: _busy,
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() {
                      _busy = true;
                    });
                    _formKey.currentState?.save();
                    String purchaseCode = _purchasecodecontroller.text;
                    talker.warning("received purchase code: ${purchaseCode}");
                    try {
                      await handleReceiptGeneration(purchaseCode);
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        _busy = false;
                      });
                      String errorMessage = e.toString();
                      int startIndex = errorMessage.indexOf(': ');
                      if (startIndex != -1) {
                        errorMessage = errorMessage.substring(startIndex + 2);
                      }
                      // toast(errorMessage);
                      // showSnackBar(context, errorMessage,
                      //     textColor: Colors.white,
                      //     backgroundColor: Colors.green);
                      return;
                    }
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () async {
                  /// still print the purchase code without the customer information!
                  /// this is standard for non customer attached receipt
                  await TaxController(object: transaction).printReceipt(
                    receiptType: transaction.receiptType!,
                    transaction: transaction,
                  );
                  // Handle when the user doesn't need a digital receipt
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    /// refresh and go home
    ref.refresh(pendingTransactionProvider(TransactionType.sale));

    model.handlingConfirm = false;
  }

  @override
  Widget build(BuildContext context) {
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
                            // Placeholder for the SearchInputWithDropdown to maintain space
                            SizedBox(
                                height: 60.0), // Adjust the height as needed
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QuickSellingView(
                                formKey: _formKey,
                                discountController: discountController,
                                receivedAmountController:
                                    receivedAmountController,
                                customerPhoneNumberController:
                                    customerPhoneNumberController,
                                paymentTypeController: paymentTypeController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PaymentTicketManager(
                                context: context,
                                model: model,
                                controller: textEditController,
                                nodeDisabled: true,
                                completeTransaction: () {
                                  if (_formKey.currentState!.validate()) {
                                    ref.read(loadingProvider.notifier).state =
                                        true;
                                    ref.refresh(loadingProvider.notifier);

                                    confirmPayment(
                                      amount: double.tryParse(
                                              receivedAmountController.text) ??
                                          0,
                                      model: model,
                                      discount: double.tryParse(
                                              discountController.text) ??
                                          0,
                                      paymentType: paymentTypeController.text,
                                      transaction: ref
                                          .watch(pendingTransactionProvider(
                                              TransactionType.sale))
                                          .asData!
                                          .value
                                          .value!,
                                    );
                                    receivedAmountController.clear();
                                    ref.read(loadingProvider.notifier).state =
                                        false;
                                    ref.refresh(loadingProvider.notifier);
                                    showSnackBar(
                                        context, "Transaction completed",
                                        textColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 187, 255, 1));
                                  }
                                },
                              ),
                            ),
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
                  transaction: ref
                      .watch(pendingTransactionProvider(TransactionType.sale))
                      .asData
                      ?.value
                      .asData
                      ?.value,
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
  }
}

class MobileView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            ProxyService.status.statusText.value ?? "",
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: ProxyService.status.statusColor.value,
        automaticallyImplyLeading: false,
        toolbarHeight:
            ProxyService.status.statusText.value?.isNotEmpty == true ? 25 : 0,
      ),
      body: Column(
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xffE5E5E5),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: TabBar(
                  onTap: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  labelColor: Colors.black,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Keypad',
                      ),
                    ),

                    // second tab [you can add an icon using the icon property]
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Library',
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Tab(
                        text: 'Favorites',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Column(
                  children: [
                    KeyPadView(model: model),
                    SizedBox(
                      height: 110,
                    )
                  ],
                ),
                ProductView.normalMode(),
                Favorites(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
