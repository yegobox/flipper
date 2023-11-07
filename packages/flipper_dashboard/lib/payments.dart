import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/receipt_types.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class Payments extends StatefulWidget {
  Payments({Key? key, required this.transaction}) : super(key: key);

  final ITransaction transaction;

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  final _routerService = locator<RouterService>();
  Map<String, bool> isFocusedMap = {};
  bool cashPayment = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cash = TextEditingController();

  String? paymentType;
  @override
  void initState() {
    super.initState();
    // Initialize the focused state for each button type
    isFocusedMap = {
      "Cash": false,
      "Card": false,
      "Mobile": false,
      "Bank": false,
      "Cheque": false,
      "Credit": false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                onActionButtonClicked: () {
                  _routerService.pop();
                },
                rightActionButtonName: 'Split payment',
                icon: Icons.arrow_back,
                multi: 3,
                bottomSpacer: 52,
                title: 'Confirm Payment',
              ),
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 145),
                  StreamBuilder<List<TransactionItem>>(
                    stream: model.transactionItemsStream(),
                    builder: (context, snapshot) {
                      final duePay = widget.transaction.subTotal;
                      return Column(
                        children: [
                          model.kTransaction != null
                              ? Text(
                                  'FRw ' + NumberFormat('#,###').format(duePay),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text('0.00'),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 186,
                            height: 70.63,
                            child: OutlinedButton(
                              style: primary3ButtonStyle.copyWith(
                                shape: MaterialStateProperty.resolveWith<
                                    OutlinedBorder>(
                                  (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final _routerService = locator<RouterService>();
                                _routerService
                                    .clearStackAndShow(CountryPickerRoute());
                              },
                              child: Text(
                                "Send Invoice",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Color(0xFF01B8E4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: cashPayment,
                            child: SizedBox(
                              width: 280,
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _cash,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Cash Received';
                                    }
                                    double totalTransactionAmount =
                                        model.totalPayable;
                                    if (double.parse(value) <
                                        totalTransactionAmount) {
                                      return "Amount is less than amount payable";
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    _cash.text = value;
                                  },
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1),
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: 'Amount Received',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 0, // Adjust the spacing as needed
                    children: [
                      buildButton(
                        icon: FluentIcons.money_calculator_24_regular,
                        type: "Cash",
                      ),
                      buildButton(
                        icon: Icons.payment,
                        type: "Card",
                      ),
                      buildButton(
                        icon: FluentIcons.phone_28_regular,
                        type: "Mobile",
                      ),
                      buildButton(
                        icon: FluentIcons.savings_24_regular,
                        type: "Bank",
                      ),
                      buildButton(
                        icon: FluentIcons.checkmark_circle_24_regular,
                        type: "Cheque",
                      ),
                      buildButton(
                        icon: FluentIcons.wallet_credit_card_20_regular,
                        type: "Credit",
                      ),
                      // Add more buttons as needed
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.5),
                    child: SizedBox(
                      height: 60,
                      child: BoxButton(
                        busy: model.handlingConfirm,
                        borderRadius: 4,
                        onTap: () async {
                          if (paymentType == "Cash") {
                            if (_formKey.currentState!.validate()) {
                              await confirmPayment(model);
                            }
                          } else {
                            if (paymentType == null) {
                              showSimpleNotification(
                                const Text(
                                    "You need to choose a payment method"),
                                background: Colors.red,
                                position: NotificationPosition.bottom,
                              );
                              return;
                            }
                            await confirmPayment(model);
                          }
                        },
                        title: "Confirm Payment",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          model.updatePayable();
        },
        viewModelBuilder: () => CoreViewModel());
  }

  Future<void> confirmPayment(CoreViewModel model) async {
    model.handlingConfirm = true;
    await model.collectPayment(paymentType: paymentType!);
    double amount = _cash.text.isEmpty
        ? model.kTransaction!.subTotal
        : double.parse(_cash.text);
    model.keypad.setCashReceived(amount: amount);
    String receiptType = "ns";
    if (ProxyService.box.isPoroformaMode()) {
      receiptType = ReceiptType.ps;
    }
    if (ProxyService.box.isTrainingMode()) {
      receiptType = ReceiptType.ts;
    }
    _routerService.navigateTo(PaymentConfirmationRoute(
        totalTransactionAmount: model.kTransaction!.subTotal,
        receiptType: receiptType,
        paymentType: paymentType!,
        transaction: model.kTransaction!));
  }

  Widget buildButton({required IconData icon, required String type}) {
    final isFocused = isFocusedMap[type] ?? false;
    final textColor = isFocused ? Color(0xff006AFE) : Colors.black;

    return SizedBox(
      height: 96,
      width: 136,
      child: TextButton(
          onPressed: () {
            setState(() {
              paymentType = type;
              // Reset the old button's state to false if it existed
              isFocusedMap.forEach((key, value) {
                if (value && key != type) {
                  isFocusedMap[key] = false;
                }
              });

              // Toggle the focused state for the current button type
              isFocusedMap[type] = !(isFocusedMap[type] ?? false);

              // Add any additional logic if needed
              if (type == "Cash" && isFocusedMap[type] == true) {
                cashPayment = true;
              } else {
                cashPayment = false;
              }
            });
          },
          style: primaryButtonStyle.copyWith(
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>((states) =>
                  BorderSide(
                      color: Colors.black.withOpacity(0.25), width: 0.50)),
              textStyle: MaterialStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.white)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white;
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.white;
                  }
                  return null;
                },
              )),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                width: 52,
                child: Icon(icon, color: Colors.black),
              ),
              Text(
                type,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textColor,
                ),
              )
            ],
          )),
    );
  }
}
