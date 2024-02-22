import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'customappbar.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';

import 'package:flipper_ui/flipper_ui.dart';

class PaymentConfirmation extends StatefulHookConsumerWidget {
  const PaymentConfirmation({
    Key? key,
    required this.cashReceived,
    required this.transaction,
    required this.paymentType,
  }) : super(key: key);

  final double cashReceived;
  final ITransaction transaction;
  final String paymentType;

  @override
  PaymentConfirmationState createState() => PaymentConfirmationState();
}

class PaymentConfirmationState extends ConsumerState<PaymentConfirmation> {
  final _routerService = locator<RouterService>();
  bool canVigateBackHome = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: CustomAppBar(
              isDividerVisible: false,
              title: 'Payment: ${widget.paymentType}',
              icon: Icons.close,
              onPop: () {
                _routerService.clearStackAndShow(FlipperAppRoute());
              },
            ),
            body: buildBody(context, model, widget.transaction),
          ),
        );
      },
      onViewModelReady: (model) {},
      viewModelBuilder: () => CoreViewModel(),
    );
  }

  Widget buildBody(BuildContext context, CoreViewModel model,
      ITransaction currentTransaction) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Icon(
                    Icons.check,
                    size: 44,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 51),
                Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'RWF ' + NumberFormat('#,###').format(widget.cashReceived),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: StreamBuilder<Customer?>(
              stream: model.getCustomer(
                id: currentTransaction.customerId,
              ),
              builder: (context, snapshot) {
                /// TODO: the stream is not used. change the stream to be of transaction
                /// so that we keep listening to see if the ebmSync property of transaction is updated
                /// then we know we can generate the receipt
                return buildBottomButtons(context, model);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomButtons(BuildContext context, CoreViewModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildOutlinedButton(
              onPressed: () async {
                model.keyboardKeyPressed(key: 'C');
                if (await ProxyService.isar.isTaxEnabled()) {
                  if (model.receiptReady) {
                    await ProxyService.isar.transactionItems(
                      doneWithTransaction: false,
                      active: true,
                      transactionId: widget.transaction.id,
                    );
                  } else {
                    showSnackBar(context,
                        "We are generating receipt. Please wait and try again.");
                  }
                }
              },
              label: 'Receipt',
              color: Colors.green,
              sideColor: Colors.green,
            ),
            buildOutlinedButton(
              onPressed: () {},
              label: 'Add Note',
              color: Colors.black,
              sideColor: Color(0xFF4CAF50),
            ),
          ],
        ),
        SizedBox(height: 13),
        buildPoweredByRow(),
        SizedBox(height: 10),
        buildReturnToHomeButton(model),
      ],
    );
  }

  Widget buildOutlinedButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
    required Color sideColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        height: 60,
        width: 140,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: sideColor),
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return sideColor; // Defer to the widget's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPoweredByRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Powered By'),
        SizedBox(width: 30),
        SizedBox(
          height: 21,
          width: 21,
          child: Image.asset(
            "assets/logo.png",
            package: 'flipper_dashboard',
          ),
        )
      ],
    );
  }

  Widget buildReturnToHomeButton(CoreViewModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 19.0, right: 19),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: BoxButton(
          busy: model.handlingConfirm,
          onTap: () {
            // if (canVigateBackHome) {
            model.handlingConfirm = true;
            // ignore: unused_result
            ref.refresh(pendingTransactionProvider('custom'));
            _routerService.clearStackAndShow(FlipperAppRoute());
            // } else {
            //   showSnackBar(
            //       context, "Please wait for the transaction to be confirmed.");
            // }
          },
          title: "Return to Home",
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
