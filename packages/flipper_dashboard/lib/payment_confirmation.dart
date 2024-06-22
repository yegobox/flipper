import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'customappbar.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';
import 'package:flipper_ui/flipper_ui.dart';

class PaymentConfirmation extends StatefulHookConsumerWidget {
  const PaymentConfirmation({Key? key, required this.transaction})
      : super(key: key);
  final ITransaction transaction;

  @override
  PaymentConfirmationState createState() => PaymentConfirmationState();
}

class PaymentConfirmationState extends ConsumerState<PaymentConfirmation> {
  final _routerService = locator<RouterService>();
  bool _busy = false;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentTransaction =
        ref.watch(currentTransactionsByIdStream(widget.transaction.id!));
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: CustomAppBar(
              isDividerVisible: false,
              title: 'Payment: ${widget.transaction.paymentType}',
              icon: Icons.close,
              onPop: () => _routerService.clearStackAndShow(FlipperAppRoute()),
            ),
            body: buildBody(context, model, currentTransaction),
          ),
        );
      },
      onViewModelReady: (model) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => showDigitalReceiptDialog(context));
      },
    );
  }

  void showDigitalReceiptDialog(BuildContext context) {
    if (widget.transaction.customerId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height * 0.8;
          return AlertDialog(
            title: Text('Digital Receipt'),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Do you need a digital receipt?'),
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Purchase Code'),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a purchase code'
                          : null,
                      onFieldSubmitted: (value) {},
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
                    setState(() => _busy = true);
                    _formKey.currentState?.save();
                    await handleReceiptGeneration(_controller.text);
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () async {
                  await handleReceiptGeneration();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> handleReceiptGeneration([String? purchaseCode]) async {
    try {
      await TaxController(object: widget.transaction).handleReceiptGeneration(
          transaction: widget.transaction,
          purchaseCode: purchaseCode,
          handlePrint: (bytes) {});
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _busy = false);
      showSnackBar(context, e.toString().split(': ').last,
          textColor: Colors.white, backgroundColor: Colors.green);
    }
  }

  Widget buildBody(BuildContext context, CoreViewModel model,
      AsyncValue<List<ITransaction>> currentTransactionWatched) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Icon(Icons.check, size: 44, color: Color(0xFF4CAF50)),
                ),
                const SizedBox(height: 51),
                Text('Done',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.black)),
                const SizedBox(height: 40),
                Text(
                    'RWF ${NumberFormat('#,###').format(widget.transaction.cashReceived)}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.black)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child:
                buildBottomButtons(context, model, currentTransactionWatched),
          ),
        ],
      ),
    );
  }

  Widget buildBottomButtons(BuildContext context, CoreViewModel model,
      AsyncValue<List<ITransaction>> currentTransactionWatched) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildOutlinedButton(
              onPressed: () async {
                model.keyboardKeyPressed(key: 'C');
                final transaction =
                    currentTransactionWatched.asData?.value.first;
                if (transaction?.ebmSynced ?? false) {
                  await TaxController(object: transaction).handleReceipt(
                      skiGenerateRRAReceiptSignature: true,
                      handlePrint: (bytes) {});
                } else {
                  toast("Please wait we are generating the receipt");
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
        const SizedBox(height: 13),
        buildPoweredByRow(),
        const SizedBox(height: 10),
        buildReturnToHomeButton(model, currentTransactionWatched),
      ],
    );
  }

  Widget buildOutlinedButton(
      {required VoidCallback onPressed,
      required String label,
      required Color color,
      required Color sideColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        height: 60,
        width: 140,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: sideColor)),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) => sideColor),
          ),
          child: Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: color, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget buildPoweredByRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Powered By'),
        const SizedBox(width: 30),
        SizedBox(
            height: 21,
            width: 21,
            child:
                Image.asset("assets/logo.png", package: 'flipper_dashboard')),
      ],
    );
  }

  Widget buildReturnToHomeButton(CoreViewModel model,
      AsyncValue<List<ITransaction>> currentTransactionWatched) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: BoxButton(
          disabled: currentTransactionWatched.value?.first.ebmSynced != true,
          busy: model.handlingConfirm,
          onTap: () {
            model.handlingConfirm = true;
            _routerService.clearStackAndShow(FlipperAppRoute());
          },
          title: "Return to Home",
        ),
      ),
    );
  }
}
