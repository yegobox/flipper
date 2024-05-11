import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Refund extends StatefulWidget {
  const Refund(
      {super.key,
      required this.refundAmount,
      required this.transactionId,
      this.currency = "RWF",
      required this.transaction});
  final double refundAmount;
  final String transactionId;
  final String? currency;
  final ITransaction transaction;

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  final _formKey = GlobalKey<FormState>();

  bool isProcessing = false;
  final talker = TalkerFlutter.init();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.currency} ${widget.refundAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Transaction ID: ${widget.transactionId}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                BoxButton(
                  title: widget.transaction.isRefunded == true
                      ? "Refunded"
                      : "Refund",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isProcessing = true;
                      });
                      ProxyService.realm.realm!.write(() {
                        widget.transaction.transactionType =
                            TransactionReceptType.NR;
                      });
                      try {
                        await EBMHandler(object: widget.transaction)
                            .handleReceipt();
                      } catch (e) {
                        talker.critical(e);
                        setState(() {
                          isProcessing = true;
                        });
                      }
                    }
                  },
                  busy: isProcessing,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
