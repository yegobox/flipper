import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
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
  final TextEditingController _cash = TextEditingController();

  late Map<String, bool> isFocusedMap;
  late bool cashPayment;
  String? paymentType;

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
            body: _buildBody(model),
          ),
        );
      },
      onViewModelReady: (model) => model.updatePayable(),
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

  Widget _buildBody(CoreViewModel model) {
    final totalPayable = widget.transaction.subTotal;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 145),
        _buildAmountSection(totalPayable),
        Spacer(),
        _buildPaymentButtons(model),
        const SizedBox(height: 10),
        _buildConfirmButton(model),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAmountSection(double totalPayable) {
    return Column(
      children: [
        Text(
          'RWF ' + NumberFormat('#,###').format(totalPayable),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 40),
        _buildSendInvoiceButton(),
        const SizedBox(height: 10),
        Visibility(
          visible: cashPayment,
          child: _buildCashReceivedFormField(totalPayable),
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

  Widget _buildCashReceivedFormField(double totalTransactionAmount) {
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
            if (double.parse(value) < totalTransactionAmount) {
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
      spacing: 0,
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
      width: 136,
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
    await model.collectPayment(
        paymentType: paymentType!,
        transaction: widget.transaction,
        amountReceived: amount);
    _routerService.navigateTo(
      PaymentConfirmationRoute(
        transaction: widget.transaction,
      ),
    );
  }
}
