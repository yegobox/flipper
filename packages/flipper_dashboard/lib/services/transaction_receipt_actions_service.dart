import 'dart:io';

import 'package:flipper_dashboard/services/stored_receipt_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:universal_platform/universal_platform.dart';

class TransactionReceiptException implements Exception {
  TransactionReceiptException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Share, download, print, and view invoice using the PDF already stored at sale time.
class TransactionReceiptActionsService {
  TransactionReceiptActionsService({StoredReceiptLoader? loader})
      : _loader = loader ?? StoredReceiptLoader();

  final StoredReceiptLoader _loader;

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
      _validateCanPresent(transaction);
      if (!context.mounted) return;

      final stored = await _loader.load(transaction);
      if (stored == null) {
        throw TransactionReceiptException(
          _missingFileMessage(transaction),
        );
      }
      if (!context.mounted) return;

      final filename = _pdfFilename(transaction);

      switch (mode) {
        case _ReceiptPresentationMode.share:
          await Printing.sharePdf(
            bytes: stored.bytes,
            filename: filename,
            subject: 'Receipt · ${_referenceHint(transaction)}',
            body: 'Thank you for your purchase.',
          );
        case _ReceiptPresentationMode.download:
          await _saveAndOpenDownload(context, stored, filename);
        case _ReceiptPresentationMode.print:
          if (UniversalPlatform.isDesktopOrWeb && !kIsWeb) {
            await Printing.layoutPdf(
              name: filename,
              onLayout: (_) async => stored.bytes,
            );
          } else if (stored.localPath != null && !kIsWeb) {
            await OpenFilex.open(stored.localPath!);
          } else {
            await Printing.sharePdf(
              bytes: stored.bytes,
              filename: filename,
              subject: 'Receipt',
            );
          }
        case _ReceiptPresentationMode.view:
          if (UniversalPlatform.isDesktopOrWeb && !kIsWeb) {
            await Printing.layoutPdf(
              name: filename,
              onLayout: (_) async => stored.bytes,
            );
          } else if (stored.localPath != null && !kIsWeb) {
            await OpenFilex.open(stored.localPath!);
          } else {
            await Printing.sharePdf(
              bytes: stored.bytes,
              filename: filename,
              subject: 'Invoice',
            );
          }
      }
    } on TransactionReceiptException catch (e) {
      if (context.mounted) _showSnack(context, e.message, isError: true);
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, _friendlyError(e), isError: true);
      }
    }
  }

  void _validateCanPresent(ITransaction transaction) {
    if (transaction.receiptType == 'TS') {
      throw TransactionReceiptException(
        'Training receipts cannot be shared or printed.',
      );
    }
    final fileName = transaction.receiptFileName?.trim();
    if (fileName == null || fileName.isEmpty) {
      throw TransactionReceiptException(_missingFileMessage(transaction));
    }
  }

  String _missingFileMessage(ITransaction transaction) {
    if (transaction.receiptFileName == null ||
        transaction.receiptFileName!.trim().isEmpty) {
      return 'Receipt PDF is not saved for this sale yet. '
          'Complete checkout with a receipt first.';
    }
    return 'Receipt PDF could not be loaded. '
        'Check your connection and try again.';
  }

  Future<void> _saveAndOpenDownload(
    BuildContext context,
    StoredReceipt stored,
    String filename,
  ) async {
    if (kIsWeb) {
      await Printing.sharePdf(bytes: stored.bytes, filename: filename);
      if (context.mounted) {
        _showSnack(context, 'Receipt ready to save or share.');
      }
      return;
    }

    String path = stored.localPath ?? '';
    if (path.isEmpty || !await File(path).exists()) {
      final dir = await getApplicationDocumentsDirectory();
      path = '${dir.path}/$filename';
      await File(path).writeAsBytes(stored.bytes, flush: true);
    }

    await OpenFilex.open(path);
    if (context.mounted) {
      _showSnack(context, 'Receipt saved on this device.');
    }
  }

  String _pdfFilename(ITransaction transaction) {
    final stored = transaction.receiptFileName?.trim();
    if (stored != null && stored.isNotEmpty) {
      return stored.toLowerCase().endsWith('.pdf') ? stored : '$stored.pdf';
    }
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
