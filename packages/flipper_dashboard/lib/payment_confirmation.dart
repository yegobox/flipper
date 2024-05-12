// ignore_for_file: unused_result

import 'dart:developer';

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
  const PaymentConfirmation({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final ITransaction transaction;

  @override
  PaymentConfirmationState createState() => PaymentConfirmationState();
}

class PaymentConfirmationState extends ConsumerState<PaymentConfirmation> {
  final _routerService = locator<RouterService>();
  bool canVigateBackHome = false;

  bool _busy = false;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction =
        ref.watch(currentTransactionsByIdStream(widget.transaction.id!));
    return ViewModelBuilder<CoreViewModel>.reactive(
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: CustomAppBar(
              isDividerVisible: false,
              title: 'Payment: ${widget.transaction.paymentType}',
              icon: Icons.close,
              onPop: () {
                ref.refresh(pendingTransactionProvider('custom'));
                _routerService.clearStackAndShow(FlipperAppRoute());
              },
            ),
            body: buildBody(
                context, model, widget.transaction, currentTransaction),
          ),
        );
      },
      onViewModelReady: (model) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.transaction.customerId != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final double height = MediaQuery.of(context).size.height;
                final double adjustedHeight = height *
                    0.8; // Adjust the height to 80% of the screen height

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
                            await TaxController(object: widget.transaction)
                                .handleReceiptGeneration(
                              transaction: widget.transaction,
                              purchaseCode: purchaseCode,
                            );
                          } catch (e) {
                            setState(() {
                              _busy = false;
                            });
                            String errorMessage = e.toString();
                            int startIndex = errorMessage.indexOf(': ');
                            if (startIndex != -1) {
                              errorMessage =
                                  errorMessage.substring(startIndex + 2);
                            }
                            // toast(errorMessage);
                            showSnackBar(context, errorMessage,
                                textColor: Colors.white,
                                backgroundColor: Colors.green);
                            return;
                          }

                          Navigator.of(context).pop();
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
        });
      },
      viewModelBuilder: () => CoreViewModel(),
    );
  }

  Widget buildBody(
      BuildContext context,
      CoreViewModel model,
      ITransaction currentTransaction,
      AsyncValue<List<ITransaction>> currentTransactionWatched) {
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
                  'RWF ' +
                      NumberFormat('#,###')
                          .format(widget.transaction.cashReceived),
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
            child: buildBottomButtons(
              context,
              model,
              currentTransactionWatched,
            ),
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
                if (currentTransactionWatched.asData?.value.first.ebmSynced ??
                    false) {
                  await TaxController(
                          object: currentTransactionWatched.asData!.value.first)
                      .handleReceipt(skiGenerateRRAReceiptSignature: true);
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
        SizedBox(height: 13),
        buildPoweredByRow(),
        SizedBox(height: 10),
        buildReturnToHomeButton(model, currentTransactionWatched),
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

  Widget buildReturnToHomeButton(CoreViewModel model,
      AsyncValue<List<ITransaction>> currentTransactionWatched) {
    return Padding(
      padding: EdgeInsets.only(left: 19.0, right: 19),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: BoxButton(
          disabled: currentTransactionWatched.value?.first.ebmSynced == true
              ? false
              : true,
          busy: model.handlingConfirm,
          onTap: () {
            model.handlingConfirm = true;
            ref.refresh(pendingTransactionProvider('custom'));
            _routerService.clearStackAndShow(FlipperAppRoute());
          },
          title: "Return to Home",
        ),
      ),
    );
  }
}
