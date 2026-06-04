import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:universal_platform/universal_platform.dart';

class TransactionReceiptException implements Exception {
  TransactionReceiptException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Share, download, print, and view invoice for a completed transaction.
class TransactionReceiptActionsService {
  TransactionReceiptActionsService();

  FilterType resolveCopyFilterType(ITransaction transaction) {
    final refunded = transaction.isRefunded == true;
    final receiptType = transaction.receiptType;

    if (receiptType == 'TS') {
      throw TransactionReceiptException(
        'Training receipts cannot be shared or printed.',
      );
    }
    if (receiptType == 'PS') {
      return refunded ? FilterType.CR : FilterType.PS;
    }
    return refunded ? FilterType.CR : FilterType.CS;
  }

  Future<void> shareReceipt(
    BuildContext context,
    ITransaction transaction,
  ) async {
    await _present(context, transaction, mode: _ReceiptPresentationMode.share);
  }

  Future<void> downloadReceipt(
    BuildContext context,
    ITransaction transaction,
  ) async {
    await _present(
      context,
      transaction,
      mode: _ReceiptPresentationMode.download,
    );
  }

  Future<void> printReceipt(
    BuildContext context,
    ITransaction transaction,
  ) async {
    await _present(context, transaction, mode: _ReceiptPresentationMode.print);
  }

  /// Footer "Invoice" — opens the signed receipt (copy) when available.
  Future<void> viewInvoice(
    BuildContext context,
    ITransaction transaction,
  ) async {
    await _present(context, transaction, mode: _ReceiptPresentationMode.view);
  }

  Future<void> _present(
    BuildContext context,
    ITransaction transaction, {
    required _ReceiptPresentationMode mode,
  }) async {
    try {
      await _validateCanPresent(transaction);
      if (!context.mounted) return;

      if (!await _ensurePurchaseCodeIfNeeded(context, transaction)) return;
      if (!context.mounted) return;

      final filterType = resolveCopyFilterType(transaction);

      if (mode == _ReceiptPresentationMode.view ||
          (mode == _ReceiptPresentationMode.print &&
              !UniversalPlatform.isDesktopOrWeb)) {
        final result = await TaxController(object: transaction).handleReceipt(
          filterType: filterType,
          persistReceiptTransactionFields: false,
        );
        if (result.response.resultCd != '000') {
          throw TransactionReceiptException(
            _messageFromResponse(result.response.resultMsg),
          );
        }
        return;
      }

      final skipPresentation = mode == _ReceiptPresentationMode.download;
      final result = await TaxController(object: transaction).handleReceipt(
        filterType: filterType,
        persistReceiptTransactionFields: false,
        skipPresentation: skipPresentation,
      );

      if (result.response.resultCd != '000') {
        throw TransactionReceiptException(
          _messageFromResponse(result.response.resultMsg),
        );
      }

      final bytes = result.bytes;
      if (!context.mounted) return;

      switch (mode) {
        case _ReceiptPresentationMode.download:
          _showSnack(context, 'Receipt saved on this device.');
        case _ReceiptPresentationMode.share:
          if (bytes == null) {
            throw TransactionReceiptException(
              'Receipt file was not generated.',
            );
          }
          await Printing.sharePdf(
            bytes: bytes,
            filename: _pdfFilename(transaction),
            subject: 'Receipt · ${_referenceHint(transaction)}',
            body: 'Thank you for your purchase.',
          );
        case _ReceiptPresentationMode.print:
          if (bytes == null) {
            throw TransactionReceiptException(
              'Receipt file was not generated.',
            );
          }
          await Printing.layoutPdf(
            name: _pdfFilename(transaction),
            onLayout: (_) async => bytes,
          );
        case _ReceiptPresentationMode.view:
          break;
      }
    } on TransactionReceiptException catch (e) {
      if (context.mounted) _showSnack(context, e.message, isError: true);
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, _friendlyError(e), isError: true);
      }
    }
  }

  Future<void> _validateCanPresent(ITransaction transaction) async {
    if (transaction.receiptType == 'TS') {
      throw TransactionReceiptException(
        'Training receipts cannot be shared or printed.',
      );
    }

    final receipt = await ProxyService.strategy.getReceipt(
      transactionId: transaction.id,
    );
    if (receipt == null) {
      throw TransactionReceiptException(
        'Receipt is not available yet. Wait for sync to finish, then try again.',
      );
    }
  }

  Future<bool> _ensurePurchaseCodeIfNeeded(
    BuildContext context,
    ITransaction transaction,
  ) async {
    final tin = transaction.customerTin?.trim() ?? '';
    if (tin.isEmpty) return true;
    return TransactionRefundService.showPurchaseCodeDialog(context);
  }

  String _pdfFilename(ITransaction transaction) {
    final ref = transaction.reference?.trim();
    if (ref != null && ref.isNotEmpty) {
      final safe = ref.replaceAll(RegExp(r'[^\w\-]+'), '_');
      return '$safe.pdf';
    }
    return 'receipt-${transaction.id}.pdf';
  }

  String _referenceHint(ITransaction transaction) {
    final ref = transaction.reference?.trim();
    if (ref != null && ref.isNotEmpty) return ref;
    return transaction.id;
  }

  String _messageFromResponse(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return 'Could not generate the receipt.';
    }
    final idx = raw.indexOf(': ');
    if (idx != -1) return raw.substring(idx + 2).trim();
    return raw.trim();
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    final idx = text.indexOf(': ');
    if (idx != -1 && idx < text.length - 2) {
      return text.substring(idx + 2).trim();
    }
    return 'Something went wrong. Please try again.';
  }

  void _showSnack(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: isError ? 4 : 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFB42318) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

enum _ReceiptPresentationMode { share, download, print, view }
