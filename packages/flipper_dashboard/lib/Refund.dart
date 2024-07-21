import 'dart:typed_data';

import 'package:flipper_dashboard/RefundReasonForm.dart';
import 'package:flipper_models/mixins/TaxController.dart';
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
      this.transaction});
  final double refundAmount;
  final String transactionId;
  final String? currency;
  final ITransaction? transaction;

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  bool isRefundProcessing = false;
  bool isPrintingCopy = false;
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
                RefundReasonForm(),
                const SizedBox(height: 32),
                BoxButton(
                  borderRadius: 1,
                  title: widget.transaction?.isRefunded == true
                      ? "Refunded"
                      : "Refund",
                  onTap: () async {
                    await handleReceipt(filterType: FilterType.NR);
                  },
                  busy: isRefundProcessing,
                ),
                const SizedBox(height: 16),
                BoxButton(
                  borderRadius: 1,
                  busy: isPrintingCopy,
                  title: "Print Copy Receipt",
                  onTap: () async {
                    await handleReceipt(filterType: FilterType.CS);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleReceipt({required FilterType filterType}) async {
    try {
      setState(() {
        if (filterType == FilterType.CS) {
          isPrintingCopy = true;
        } else {
          isRefundProcessing = true;
        }
      });

      await ProxyService.realm.realm!.writeAsync(() {
        widget.transaction?.receiptType = filterType == FilterType.NR
            ? TransactionReceptType.NR
            : TransactionReceptType.CS;
      });

      await TaxController(object: widget.transaction)
          .handleReceipt(printCallback: (Uint8List bytes) {});

      setState(() {
        if (filterType == FilterType.CS) {
          isPrintingCopy = false;
        } else {
          isRefundProcessing = false;
        }
      });
    } catch (e) {
      talker.critical(e);
      setState(() {
        if (filterType == FilterType.CS) {
          isPrintingCopy = false;
        } else {
          isRefundProcessing = false;
        }
      });
    }
  }
}
