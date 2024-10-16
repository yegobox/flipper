import 'dart:typed_data';

import 'package:flipper_dashboard/add_discount.dart';
import 'package:flipper_models/realmExtension.dart';
import 'package:flipper_dashboard/RefundReasonForm.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
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
                    if (widget.transaction!.isRefunded) {
                      toast("This is already refunded");
                      return;
                    }

                    await handleReceipt(filterType: FilterType.NR);

                    talker.error(
                        "RefundableTransactionId: ${int.parse(widget.transactionId)}");
                    talker
                        .error("RefundableBranchId: ${widget.transaction?.id}");

                    /// add stock back to same item refunded
                    try {
                      List<TransactionItem> items = ProxyService.local
                          .transactionItems(
                              transactionId: int.parse(widget.transactionId),
                              doneWithTransaction: true,
                              branchId: widget.transaction!.branchId!,
                              active: true);
                      talker.error("Items to Refunds: ${items.length}");
                      // widget.transaction.isRefunded

                      /// get quantity sold to the same item
                      for (TransactionItem item in items) {
                        /// get variant
                        Variant? variant = ProxyService.local
                            .variant(variantId: item.variantId);
                        if (variant != null) {
                          talker.info(
                              "Refund Variant to refund ${variant.toEJson()}");

                          /// get the stock
                          Stock? stock = ProxyService.local.stockByVariantId(
                              variantId: variant.id!,
                              branchId: variant.branchId!);

                          /// add same stock sold back to the stock
                          if (stock != null) {
                            talker.info(
                                "Refund Stock to refund ${stock.toEJson()}");
                            ProxyService.local.realm!.writeN(
                                tableName: stocksTable,
                                writeCallback: () {
                                  stock.ebmSynced = false;
                                  stock.currentStock =
                                      stock.currentStock + item.qty;
                                  return stock;
                                });

                            ProxyService.local.realm!.writeN(
                                tableName: variantTable,
                                writeCallback: () {
                                  variant.ebmSynced = false;
                                  return variant;
                                });

                            ProxyService.local.realm!.writeN(
                                tableName: transactionTable,
                                writeCallback: () {
                                  widget.transaction!.isRefunded = true;
                                  return widget.transaction;
                                });
                          }
                        }
                      }
                    } catch (e) {
                      talker.error(e);
                    }
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

      await ProxyService.local.realm!.writeAsync(() {
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
