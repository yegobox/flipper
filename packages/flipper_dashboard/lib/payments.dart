import 'package:flipper_models/realm_model_export.dart';
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
        Customer? customer = await ProxyService.realm
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
      onPop: _routerService.pop,
      onActionButtonClicked: _routerService.pop,
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
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
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
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (states) => BorderSide(
              color: Colors.black.withOpacity(0.25),
              width: 0.50,
            ),
          ),
          textStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(color: Colors.white),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed)) {
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
    _routerService.navigateTo(
      PaymentConfirmationRoute(
        transaction: widget.transaction,
      ),
    );
  }
}
