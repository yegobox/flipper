// ignore_for_file: unused_result

import 'dart:developer';

import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class Payments extends StatefulHookConsumerWidget {
  Payments({Key? key, required this.transaction}) : super(key: key);

  final ITransaction transaction;

  @override
  PaymentsState createState() => PaymentsState();
}

class PaymentsState extends ConsumerState<Payments> {
  final _routerService = locator<RouterService>();
  final _formKey = GlobalKey<FormState>();
  final _customerKey = GlobalKey<FormState>();
  final TextEditingController _cash = TextEditingController();
  final TextEditingController _discount = TextEditingController();
  final TextEditingController _customer = TextEditingController();

  bool _busy = false;
  final TextEditingController _controller = TextEditingController();

  late Map<String, bool> isFocusedMap;
  late bool cashPayment;
  String? paymentType;
  bool showDiscountField = false;
  bool showCustomerField = false;

  @override
  void initState() {
    super.initState();
    isFocusedMap = {
      "Cash": false,
      "Card": false,
      "Mobile": false,
      "Bank": false,
      "Cheque": false,
      "Credit": false,
    };
    cashPayment = false;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: _buildCustomAppBar(),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 45),
                  _buildAmountSection(widget.transaction.subTotal),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: showDiscountField,
                    child: _buildDiscountField(),
                  ),
                  Visibility(
                    visible: showCustomerField,
                    child: _builCustomerField(),
                  ),
                  const SizedBox(height: 20),
                  _buildPaymentButtons(model),
                  const SizedBox(height: 20),
                  _buildConfirmButton(model),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
      onViewModelReady: (model) async {
        model.updatePayable();

        /// check if there is a full customer attached, because there is cases where we don't want to create a user in normal flow
        /// because it might be tedious to fill tin number,name and phone number etc... then it make sense if no customer attached to this transaction
        /// to add extra field to request phone number from a user completing this transaction for the tin to be used as placeholder in this case
        Customer? customer = ProxyService.realm
            .getCustomer(id: widget.transaction.customerId ?? 0);
        if (customer == null) {
          /// there is no customer attached to this transaction then enable extra field.
          showCustomerField = true;
        }
      },
      viewModelBuilder: () => CoreViewModel(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return CustomAppBar(
      onPop: () {
        ref.refresh(pendingTransactionProvider(TransactionType.sale));
        _routerService.back();
      },
      onActionButtonClicked: () {
        ref.refresh(pendingTransactionProvider(TransactionType.sale));
        _routerService.back();
      },
      rightActionButtonName: 'Split payment',
      icon: Icons.close,
      multi: 3,
      bottomSpacer: 52,
      title: 'Confirm Payment',
    );
  }

  Widget _buildAmountSection(double totalPayable) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Fix: Shrink-wrap Column
      children: [
        Text(
          'RWF ' + NumberFormat('#,###').format(totalPayable),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSendInvoiceButton(),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  showDiscountField = !showDiscountField;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  showDiscountField ? "Hide Discount" : "Add Discount",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: cashPayment,
          child:
              _buildCashReceivedFormField(totalTransactionAmount: totalPayable),
        ),
      ],
    );
  }

  Widget _buildSendInvoiceButton() {
    return SizedBox(
      width: 186,
      height: 70.63,
      child: OutlinedButton(
        style: primary3ButtonStyle.copyWith(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        onPressed: () async {
          final _routerService = locator<RouterService>();
          _routerService.clearStackAndShow(CountryPickerRoute());
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
    );
  }

  Widget _buildDiscountField() {
    return SizedBox(
      width: 280,
      child: Form(
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _discount,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter discount amount';
            }
            if (double.parse(value) > widget.transaction.subTotal) {
              return "Discount cannot exceed the total amount";
            }
            return null;
          },
          onFieldSubmitted: (value) {
            _discount.text = value;
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
            hintText: 'Discount',
          ),
        ),
      ),
    );
  }

  Widget _builCustomerField() {
    return SizedBox(
      width: 280,
      child: Form(
        key: _customerKey,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _customer,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Phone number without 0 e.g 783054874';
            }
            if (value.length > 9) {
              return 'Please enter Phone number without 0 e.g 783054874';
            }
            if (value.length < 9) {
              return 'Please enter Phone number without 0 e.g 783054874';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            _customer.text = value;
            ProxyService.box.writeString(
                key: 'currentSaleCustomerPhoneNumber', value: value);
          },
          onChanged: (value) {
            ProxyService.box.writeString(
                key: 'currentSaleCustomerPhoneNumber', value: value);
          },
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
            hintText: 'Customer Phone Number',
          ),
        ),
      ),
    );
  }

  Widget _buildCashReceivedFormField({required double totalTransactionAmount}) {
    return SizedBox(
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
            final amountReceived = double.parse(value);
            final discount =
                _discount.text.isEmpty ? 0.0 : double.parse(_discount.text);
            if (amountReceived < (totalTransactionAmount - discount)) {
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
    );
  }

  Widget _buildPaymentButtons(CoreViewModel model) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildPaymentButton(
          icon: FluentIcons.money_calculator_24_regular,
          type: "Cash",
        ),
        _buildPaymentButton(
          icon: Icons.payment,
          type: "Card",
        ),
        _buildPaymentButton(
          icon: FluentIcons.phone_28_regular,
          type: "Mobile",
        ),
        _buildPaymentButton(
          icon: FluentIcons.savings_24_regular,
          type: "Bank",
        ),
        _buildPaymentButton(
          icon: FluentIcons.checkmark_circle_24_regular,
          type: "Cheque",
        ),
        _buildPaymentButton(
          icon: FluentIcons.wallet_credit_card_20_regular,
          type: "Credit",
        ),
      ],
    );
  }

  Widget _buildPaymentButton({required IconData icon, required String type}) {
    final isFocused = isFocusedMap[type] ?? false;
    final textColor = isFocused ? Color(0xff006AFE) : Colors.black;

    return SizedBox(
      height: 96,
      width: 96,
      child: TextButton(
        onPressed: () {
          setState(() {
            paymentType = type;
            isFocusedMap.forEach((key, value) {
              if (value && key != type) {
                isFocusedMap[key] = false;
              }
            });
            isFocusedMap[type] = !(isFocusedMap[type] ?? false);

            if (type == "Cash" && isFocusedMap[type] == true) {
              cashPayment = true;
            } else {
              cashPayment = false;
            }
          });
        },
        style: primaryButtonStyle.copyWith(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (states) => BorderSide(
              color: Colors.black.withOpacity(0.25),
              width: 0.50,
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            TextStyle(color: Colors.white),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return Colors.white;
              }
              return null;
            },
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fix: Shrink-wrap Column
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
        ),
      ),
    );
  }

  Widget _buildConfirmButton(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.5),
      child: SizedBox(
        height: 60,
        child: BoxButton(
          busy: model.handlingConfirm,
          borderRadius: 4,
          onTap: () async {
            if (_customerKey.currentState!.validate()) {
              if (paymentType == "Cash") {
                if (_formKey.currentState!.validate()) {
                  await confirmPayment(model);
                }
              } else {
                if (paymentType == null) {
                  showSimpleNotification(
                    const Text("You need to choose a payment method"),
                    background: Colors.red,
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                await confirmPayment(model);
              }
            }
          },
          title: "Confirm Payment",
        ),
      ),
    );
  }

  Future<void> handleReceiptGeneration([String? purchaseCode]) async {
    try {
      await TaxController(object: widget.transaction).handleReceiptGeneration(
        transaction: widget.transaction,
        purchaseCode: purchaseCode,
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _busy = false);
      showSnackBar(context, e.toString().split(': ').last,
          textColor: Colors.white, backgroundColor: Colors.green);
    }
  }

  Future<void> confirmPayment(CoreViewModel model) async {
    model.handlingConfirm = true;
    double amount = _cash.text.isEmpty
        ? widget.transaction.subTotal
        : double.parse(_cash.text);
    // Parse discount ONLY if _discount.text is NOT empty
    double discount =
        _discount.text.isNotEmpty ? double.parse(_discount.text) : 0.0;
    await model.collectPayment(
        paymentType: paymentType!,
        transaction: widget.transaction,
        amountReceived: amount,
        discount: discount);

    await handleReceiptGeneration();

    if (widget.transaction.customerId != null) {
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
                      controller: _controller,
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
                    String purchaseCode = _controller.text;
                    log("received purchase code: ${purchaseCode}");
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
                      showSnackBar(context, errorMessage,
                          textColor: Colors.white,
                          backgroundColor: Colors.green);
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
                  await TaxController(object: widget.transaction)
                      .handleReceiptGeneration(
                    transaction: widget.transaction,
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
    _routerService.back;
    model.handlingConfirm = false;
  }
}
