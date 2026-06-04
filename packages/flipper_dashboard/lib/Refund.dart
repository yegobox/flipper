import 'package:flipper_dashboard/RefundReasonForm.dart';
import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Refund extends StatefulHookConsumerWidget {
  const Refund({
    super.key,
    required this.refundAmount,
    required this.transactionId,
    required this.currency,
    this.transaction,
  });
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
  late final _refundService = TransactionRefundService(talker: talker);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
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
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const RefundReasonForm(),
                const SizedBox(height: 32),
                BoxButton(
                  borderRadius: 1,
                  title: widget.transaction?.isRefunded == true
                      ? 'Refunded'
                      : 'Refund',
                  color: widget.transaction?.isRefunded == true
                      ? Colors.red
                      : null,
                  busy: isRefundProcessing,
                  onTap: () => _onRefundTap(context),
                ),
                const SizedBox(height: 16),
                BoxButton(
                  borderRadius: 1,
                  busy: isPrintingCopy,
                  title: 'Print Copy Receipt',
                  onTap: () => _onPrintCopyTap(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefundTap(BuildContext context) async {
    setState(() => isRefundProcessing = true);
    try {
      final tx = widget.transaction!;
      if (tx.isRefunded ?? false) {
        toast('This is already refunded');
        return;
      }

      final needsPurchaseCode =
          tx.customerTin != null && tx.customerTin!.isNotEmpty;
      if (needsPurchaseCode) {
        final ok = await TransactionRefundService.showPurchaseCodeDialog(context);
        if (!ok) return;
      }

      if (tx.receiptType == 'TS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'TR',
        );
        return;
      }
      if (tx.receiptType == 'PS') {
        toast('Can not refund a proforma');
        return;
      }
      if (tx.receiptType == 'NS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'NR',
        );
      } else if (tx.receiptType == 'CS') {
        await _refundService.executeLegacyFullRefund(
          transaction: tx,
          refundAmount: widget.refundAmount,
          receiptType: 'CR',
        );
      }
    } catch (e, s) {
      toast(e.toString());
      talker.error(s);
    } finally {
      if (mounted) setState(() => isRefundProcessing = false);
    }
  }

  Future<void> _onPrintCopyTap(BuildContext context) async {
    final tx = widget.transaction!;
    if (tx.receiptType == 'TS') {
      toast('This receipt does not have a copy to print');
      return;
    }

    final needsPurchaseCode =
        tx.customerTin != null && tx.customerTin!.isNotEmpty;
    if (needsPurchaseCode) {
      final ok = await TransactionRefundService.showPurchaseCodeDialog(context);
      if (!ok) return;
    }

    setState(() => isPrintingCopy = true);
    try {
      if (tx.receiptType == 'PS') {
        await _refundService.handleReceiptCopy(
          transaction: tx,
          filterType: (tx.isRefunded ?? false)
              ? FilterType.PR
              : FilterType.CP,
        );
      } else {
        await _refundService.handleReceiptCopy(
          transaction: tx,
          filterType: (tx.isRefunded ?? false)
              ? FilterType.CR
              : FilterType.CS,
        );
      }
    } catch (e, s) {
      toast(e.toString());
      talker.error(s);
    } finally {
      if (mounted) setState(() => isPrintingCopy = false);
    }
  }
}
