import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TransactionRefundRequest {
  const TransactionRefundRequest({
    required this.transaction,
    required this.refundAmount,
    required this.reason,
    required this.method,
    this.purchaseCode,
  });

  final ITransaction transaction;
  final double refundAmount;
  final String reason;
  final String method;
  final String? purchaseCode;
}

class TransactionRefundResult {
  const TransactionRefundResult({
    required this.transaction,
    required this.refundAmount,
    required this.partial,
  });

  final ITransaction transaction;
  final double refundAmount;
  final bool partial;
}

class TransactionRefundException implements Exception {
  TransactionRefundException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Shared refund execution for income detail and legacy [Refund] dialog.
class TransactionRefundService {
  TransactionRefundService({Talker? talker})
      : _talker = talker ?? TalkerFlutter.init();

  final Talker _talker;

  static Future<bool> showPurchaseCodeDialog(BuildContext context) async {
    var purchaseCodeReceived = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        var purchaseCode = '';
        return AlertDialog(
          title: const Text('Enter Purchase Code'),
          content: TextField(
            onChanged: (value) => purchaseCode = value,
            decoration: InputDecoration(
              hintText: 'Enter purchase code',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(dialogContext).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ProxyService.box.writeString(
                  key: 'purchaseCode',
                  value: purchaseCode,
                );
                purchaseCodeReceived = true;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    return purchaseCodeReceived;
  }

  void validateCanRefund(ITransaction transaction) {
    if (transaction.isRefunded == true) {
      throw TransactionRefundException('This transaction is already refunded');
    }
    if (transaction.receiptType == 'PS') {
      throw TransactionRefundException('Cannot refund a proforma receipt');
    }
  }

  Future<void> restoreStock({
    required String transactionId,
    required double refundAmount,
    required double originalTotal,
  }) async {
    final capella = ProxyService.getStrategy(Strategy.capella);
    final items = await capella.transactionItems(transactionId: transactionId);
    if (items.isEmpty) {
      throw TransactionRefundException(
        'No line items to refund for this transaction',
      );
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final variant = await capella.getVariant(id: item.variantId);
      if (variant == null || variant.itemTyCd == '3') continue;
      final stockId = variant.stockId;
      if (stockId == null || stockId.isEmpty) continue;

      final qty = stockRestoreQtyForLine(
        lineQty: item.qty.toInt(),
        refundAmount: refundAmount,
        originalTotal: originalTotal,
        lineIndex: i,
        lineCount: items.length,
      );
      if (qty <= 0) continue;

      await ProxyService.strategy.updateStock(
        stockId: stockId,
        currentStock: qty.toDouble(),
        appending: true,
      );
    }
  }

  Future<ITransaction> persistRefundMetadata({
    required ITransaction transaction,
    required double refundAmount,
    required String reason,
    required String method,
  }) async {
    final originalTotal = transaction.subTotal ?? 0;
    final status = refundStatusForAmount(refundAmount, originalTotal);

    await ProxyService.getStrategy(Strategy.capella).updateTransaction(
      transaction: transaction,
      isRefunded: true,
      status: status,
      refundedAmount: refundAmount,
      refundReason: reason,
      refundMethod: method,
      updatedAt: DateTime.now().toUtc(),
      lastTouched: DateTime.now().toUtc(),
    );

    try {
      await ProxyService.strategy.updateShiftTotals(
        transactionAmount: refundAmount,
        isRefund: true,
      );
    } catch (e) {
      _talker.warning('updateShiftTotals skipped or failed: $e');
    }

    return transaction.copyWith(
      isRefunded: true,
      status: status,
      refundedAmount: refundAmount,
      refundReason: reason,
      refundMethod: method,
    );
  }

  Future<TransactionRefundResult> execute({
    required TransactionRefundRequest request,
    required bool vatEnabled,
    BuildContext? context,
    Future<bool> Function()? requestPurchaseCode,
  }) async {
    final transaction = request.transaction;
    validateCanRefund(transaction);

    final originalTotal = transaction.subTotal ?? 0;
    if (request.refundAmount <= 0) {
      throw TransactionRefundException('Refund amount must be greater than zero');
    }
    if (request.refundAmount > originalTotal + 0.001) {
      throw TransactionRefundException(
        'Refund amount cannot exceed the original payment',
      );
    }

    if (vatEnabled) {
      if (isPartialRefund(request.refundAmount, originalTotal)) {
        throw TransactionRefundException(
          'Partial refunds with EBM/VAT are not supported yet. Use a full refund.',
        );
      }
      return _executeVatRefund(
        request: request,
        requestPurchaseCode: requestPurchaseCode,
        context: context,
      );
    }

    await restoreStock(
      transactionId: transaction.id,
      refundAmount: request.refundAmount,
      originalTotal: originalTotal,
    );

    final updated = await persistRefundMetadata(
      transaction: transaction,
      refundAmount: request.refundAmount,
      reason: request.reason,
      method: request.method,
    );

    return TransactionRefundResult(
      transaction: updated,
      refundAmount: request.refundAmount,
      partial: isPartialRefund(request.refundAmount, originalTotal),
    );
  }

  Future<TransactionRefundResult> _executeVatRefund({
    required TransactionRefundRequest request,
    Future<bool> Function()? requestPurchaseCode,
    BuildContext? context,
  }) async {
    final transaction = request.transaction;
    final needsPurchaseCode = transaction.customerTin != null &&
        transaction.customerTin!.isNotEmpty;

    if (needsPurchaseCode) {
      final gotCode = requestPurchaseCode != null
          ? await requestPurchaseCode()
          : (context != null
              ? await showPurchaseCodeDialog(context)
              : false);
      if (!gotCode) {
        throw TransactionRefundException('Purchase code is required');
      }
    }

    final receiptType = resolveVatRefundReceiptType(transaction);
    if (receiptType == null) {
      throw TransactionRefundException('Cannot refund this receipt type');
    }

    final originalTotal = transaction.subTotal ?? 0;
    final refundAmount = request.refundAmount;

    if (receiptType == 'NR') {
      await restoreStock(
        transactionId: transaction.id,
        refundAmount: refundAmount,
        originalTotal: originalTotal,
      );
    }

    final filterType = _filterTypeFromReceiptType(receiptType);
    await TaxController(object: transaction).handleReceipt(filterType: filterType);

    final updated = await persistRefundMetadata(
      transaction: transaction,
      refundAmount: refundAmount,
      reason: request.reason,
      method: request.method,
    );

    _talker.info('VAT refund completed for transaction ${transaction.id}');

    return TransactionRefundResult(
      transaction: updated,
      refundAmount: refundAmount,
      partial: false,
    );
  }

  FilterType _filterTypeFromReceiptType(String receiptType) {
    switch (receiptType) {
      case 'NR':
        return FilterType.NR;
      case 'CR':
        return FilterType.CR;
      case 'TR':
        return FilterType.TR;
      default:
        return FilterType.NR;
    }
  }

  /// Legacy full-refund path used by desktop [Refund] widget (always full amount).
  Future<void> executeLegacyFullRefund({
    required ITransaction transaction,
    required double refundAmount,
    required String receiptType,
  }) async {
    validateCanRefund(transaction);
    final originalTotal = transaction.subTotal ?? 0;

    if (receiptType == 'NR') {
      await restoreStock(
        transactionId: transaction.id,
        refundAmount: refundAmount,
        originalTotal: originalTotal,
      );
    }

    final filterType = _filterTypeFromReceiptType(receiptType);
    if (filterType == FilterType.CR ||
        filterType == FilterType.NR ||
        filterType == FilterType.TR) {
      await TaxController(object: transaction).handleReceipt(filterType: filterType);
      await persistRefundMetadata(
        transaction: transaction,
        refundAmount: refundAmount,
        reason: ProxyService.box.readString(key: 'getRefundReason') ?? '05',
        method: transaction.paymentType ?? 'cash',
      );
    } else {
      await TaxController(object: transaction).handleReceipt(filterType: filterType);
    }
  }

  Future<void> handleReceiptCopy({
    required ITransaction transaction,
    required FilterType filterType,
  }) async {
    await TaxController(object: transaction).handleReceipt(filterType: filterType);
  }
}
