import 'package:flipper_dashboard/RefundReasonForm.dart';
import 'package:flipper_models/isolateHandelr.dart' show repository;
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Refund extends StatefulHookConsumerWidget {
  const Refund(
      {super.key,
      required this.refundAmount,
      required this.transactionId,
      required this.currency,
      this.transaction});
  final double refundAmount;
  final String transactionId;
  final String? currency;
  final ITransaction? transaction;

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends ConsumerState<Refund> {
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
                  color: widget.transaction?.isRefunded == true
                      ? Colors.red
                      : null,
                  busy: isRefundProcessing,
                  onTap: () async {
                    setState(() {
                      isRefundProcessing = true;
                    });

                    try {
                      if (widget.transaction!.isRefunded ?? false) {
                        setState(() {
                          isRefundProcessing = false;
                        });
                        toast("This is already refunded");
                        return;
                      }

                      if (widget.transaction!.customerId != null &&
                          widget.transaction!.customerId != 0) {
                        // Show modal to request purchase code
                        bool purchaseCodeReceived =
                            await showPurchaseCodeModal();
                        if (purchaseCodeReceived) {
                          // Proceed with refund
                          if (widget.transaction!.receiptType == "TS") {
                            await proceed(receiptType: "TR");
                            // toast("Can not refund a training receipt");
                            return;
                          }
                          if (widget.transaction!.receiptType == "PS") {
                            toast("Can not refund a proforma");
                            setState(() {
                              isRefundProcessing = false;
                            });
                            return;
                          } else if ((widget.transaction!.receiptType ==
                              "NS")) {
                            await proceed(receiptType: "NR");
                          } else if ((widget.transaction!.receiptType ==
                              "CS")) {
                            await proceed(receiptType: "CR");
                          }
                        }
                      } else {
                        if (widget.transaction!.receiptType == "TS") {
                          await proceed(receiptType: "TR");
                          // toast("Can not refund a training receipt");
                          return;
                        } else if (widget.transaction!.receiptType! == "CS") {
                          await proceed(receiptType: "CR");
                        } else if (widget.transaction!.receiptType == "PS") {
                          toast("Can not refund a proforma");
                          setState(() {
                            isRefundProcessing = false;
                          });
                          return;
                        } else if (widget.transaction!.receiptType == "PS") {
                          toast("Can not refund a proforma");
                          setState(() {
                            isRefundProcessing = false;
                          });
                          return;
                        } else if (widget.transaction!.receiptType == "NS") {
                          await proceed(receiptType: "NR");
                        }
                      }
                    } catch (e,s) {
                      toast(e.toString());
                      talker.error(s);
                    }
                  },
                ),
                const SizedBox(height: 16),
                BoxButton(
                  borderRadius: 1,
                  busy: isPrintingCopy,
                  title: "Print Copy Receipt",
                  onTap: () async {
                    if (widget.transaction!.receiptType == "TS" ||
                        widget.transaction!.receiptType == "PS") {
                      toast("This receipt does not have a copy to print");
                      return;
                    }
                    if (widget.transaction!.customerId != null &&
                        widget.transaction!.customerId != 0) {
                      bool purchaseCodeReceived = await showPurchaseCodeModal();
                      if (purchaseCodeReceived) {
                        if (widget.transaction!.receiptType == "PS") {
                          if (widget.transaction!.isRefunded ?? false) {
                            await handleReceipt(filterType: FilterType.CP);
                          } else {
                            await handleReceipt(filterType: FilterType.CP);
                          }
                        } else {
                          if (widget.transaction!.isRefunded ?? false) {
                            // I removed PR was await handleReceipt(filterType: FilterType.PR);
                            await handleReceipt(filterType: FilterType.CR);
                          } else {
                            await handleReceipt(filterType: FilterType.CS);
                          }
                        }
                      }
                    } else {
                      if (widget.transaction!.receiptType == "PS") {
                        if (widget.transaction!.isRefunded ?? false) {
                          await handleReceipt(filterType: FilterType.PR);
                        } else {
                          await handleReceipt(filterType: FilterType.CP);
                        }
                      } else {
                        if (widget.transaction!.isRefunded ?? false) {
                          await handleReceipt(filterType: FilterType.CR);
                        } else {
                          await handleReceipt(filterType: FilterType.CS);
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getStringReceiptType(FilterType filterType) {
    switch (filterType) {
      case FilterType.CS:
        return 'CS';
      case FilterType.NR:
        return 'NR';
      case FilterType.CR:
        return 'CR';
      case FilterType.PS:
        return 'PS';
      case FilterType.TS:
        return 'TS';
      case FilterType.NS:
        return 'NS';
      default:
        return 'CS';
    }
  }

  Future<bool> showPurchaseCodeModal() async {
    bool purchaseCodeReceived = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String purchaseCode = '';

        return AlertDialog(
          title: Text('Enter Purchase Code'),
          content: TextField(
            onChanged: (value) {
              purchaseCode = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter purchase code',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the purchase code and mark as received
                ProxyService.box
                    .writeString(key: 'purchaseCode', value: purchaseCode);
                purchaseCodeReceived = true;
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return purchaseCodeReceived;
  }

// Common refund logic
  Future<void> proceed({required String receiptType}) async {
    try {
      // Perform refund operations
      if (receiptType == "CR") {
        await handleReceipt(filterType: FilterType.CR);
      } else if (receiptType == "CS") {
        await handleReceipt(filterType: FilterType.CS);
      } else if (receiptType == "TR") {
        await handleReceipt(filterType: FilterType.TR);
      } else if (receiptType == "NR") {
        List<TransactionItem> items = await ProxyService.strategy
            .transactionItems(transactionId: widget.transactionId);
        talker.info("Items to Refund: ${items.length}");

        for (TransactionItem item in items) {
          Variant? variant =
              await ProxyService.strategy.getVariant(id: item.variantId);
          if (variant != null) {
            if (variant.stock != null) {
              // Mark the variant.ebmSynced to false (for re-sync if needed)
              ProxyService.strategy
                  .updateVariant(updatables: [variant], ebmSynced: false);
              // Update the stock
              ProxyService.strategy.updateStock(
                  stockId: variant.stock!.id,
                  currentStock: variant.stock!.currentStock! + item.qty,
                  ebmSynced: false);

              // Sync with EBM for stock return
              final ebmSyncService = TurboTaxService(repository);
              await ebmSyncService.syncTransactionWithEbm(
                instance: widget.transaction!,
                serverUrl: (await ProxyService.box.getServerUrl())!,
                sarTyCd: StockInOutType.returnIn,
              );

              // Since syncTransactionWithEbm calls the method for IO, we pass updateIo as false below
              ProxyService.strategy.updateVariant(
                  updateIo: false,
                  updatables: [variant],
                  variantId: variant.id,
                  ebmSynced: true);
            }
          }
        }
        // After all operations are successful, mark the original transaction as refunded
        // This will be handled in handleReceipt for refund types
        // await ProxyService.strategy.updateTransaction(
        //   transaction: widget.transaction!,
        //   isRefunded: true,
        // );
        await handleReceipt(filterType: FilterType.NR);
        talker.info(
            "Original transaction ${widget.transaction!.id} marked as refunded");
      }
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }

  Future<void> handleReceipt({required FilterType filterType}) async {
    try {
      setState(() {
        // Set the correct loading state based on the operation
        // For CS (Copy Sales) and CR (Copy Refund), we're printing a copy receipt
        // For all other filter types, we're processing a refund
        if (filterType == FilterType.CS ||
            filterType == FilterType.CR ||
            filterType == FilterType.CP) {
          isPrintingCopy = true;
          isRefundProcessing = false;
        } else {
          isRefundProcessing = true;
          isPrintingCopy = false;
        }
      });

      // Log the refund process start
      talker.info(
          "Processing ${filterType.toString()} for transaction ${widget.transaction!.id}");

      // For refund operations (NR, CR, TR), ensure we're creating a new transaction with correct properties
      if (filterType == FilterType.NR ||
          filterType == FilterType.CR ||
          filterType == FilterType.TR) {
        talker.info(
            "Creating refund transaction with receipt type: ${getStringReceiptType(filterType)}");
      }

      await TaxController(object: widget.transaction)
          .handleReceipt(filterType: filterType);

      // Only mark as refunded if it's a refund operation and successful
      if (filterType == FilterType.NR ||
          filterType == FilterType.CR ||
          filterType == FilterType.TR) {
        await ProxyService.strategy.updateTransaction(
          transaction: widget.transaction!,
          isRefunded: true,
        );
        talker.info(
            "Transaction ${widget.transaction!.id} marked as refunded after successful receipt handling.");
        await ProxyService.strategy.updateShiftTotals(
          transactionAmount: widget.refundAmount,
          isRefund: true,
        );
      }

      setState(() {
        // Reset the loading state when done
        if (filterType == FilterType.CS ||
            filterType == FilterType.CR ||
            filterType == FilterType.CP) {
          isPrintingCopy = false;
        } else {
          isRefundProcessing = false;
        }
      });
    } catch (e) {
      talker.critical(e);
      setState(() {
        // Reset loading states in case of error
        if (filterType == FilterType.CS ||
            filterType == FilterType.CR ||
            filterType == FilterType.CP) {
          isPrintingCopy = false;
        } else {
          isRefundProcessing = false;
        }
      });
      rethrow;
    }
  }
}
