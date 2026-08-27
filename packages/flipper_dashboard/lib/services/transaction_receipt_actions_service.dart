import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flipper_dashboard/services/sale_receipt_pdf.dart';
import 'package:flipper_dashboard/services/stored_receipt_loader.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/receipt_pdf_filename.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';

class TransactionReceiptException implements Exception {
  TransactionReceiptException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Builds a receipt PDF for a sale that has no stored EBM PDF.
typedef SaleReceiptFallbackBuilder = Future<Uint8List> Function(
  ITransaction transaction,
  List<TransactionItem>? items,
);

/// Share, download, print, and view the receipt for a sale.
///
/// Prefers the signed PDF stored at sale time. When there is none — credit
/// sales, VAT-disabled businesses, sales made before receipt upload, or an
/// upload that never finished — it builds a customer copy from local sale data
/// instead of failing, so these actions always produce a document.
class TransactionReceiptActionsService {
  TransactionReceiptActionsService({
    StoredReceiptLoader? loader,
    SaleReceiptFallbackBuilder? fallbackBuilder,
  })  : _loader = loader ?? StoredReceiptLoader(),
        _fallbackBuilder = fallbackBuilder ?? buildLocalSaleReceiptPdf;

  final StoredReceiptLoader _loader;
  final SaleReceiptFallbackBuilder _fallbackBuilder;

  /// Guards against a second tap while a PDF is still being resolved.
  bool _busy = false;

  Future<void> shareReceipt(
    BuildContext context,
    ITransaction transaction, {
    List<TransactionItem>? items,
  }) async {
    await _present(
      context,
      transaction,
      mode: _ReceiptPresentationMode.share,
      items: items,
    );
  }

  Future<void> downloadReceipt(
    BuildContext context,
    ITransaction transaction, {
    List<TransactionItem>? items,
  }) async {
    await _present(
      context,
      transaction,
      mode: _ReceiptPresentationMode.download,
      items: items,
    );
  }

  Future<void> printReceipt(
    BuildContext context,
    ITransaction transaction, {
    List<TransactionItem>? items,
  }) async {
    await _present(
      context,
      transaction,
      mode: _ReceiptPresentationMode.print,
      items: items,
    );
  }

  Future<void> viewInvoice(
    BuildContext context,
    ITransaction transaction, {
    List<TransactionItem>? items,
  }) async {
    await _present(
      context,
      transaction,
      mode: _ReceiptPresentationMode.view,
      items: items,
    );
  }

  Future<void> _present(
    BuildContext context,
    ITransaction transaction, {
    required _ReceiptPresentationMode mode,
    List<TransactionItem>? items,
  }) async {
    if (_busy) return;
    _busy = true;
    // Resolving can take seconds (S3 download, PDF build) — say so, otherwise
    // the button reads as broken.
    _showProgress(context, 'Preparing receipt…');
    try {
      validateCanPresent(transaction);

      final resolved = await resolveReceipt(transaction, items);
      _hideProgress(context);
      if (!context.mounted) return;

      final filename = _pdfFilename(transaction, fiscal: resolved.fiscal);

      switch (mode) {
        case _ReceiptPresentationMode.share:
          await Printing.sharePdf(
            bytes: resolved.bytes,
            filename: filename,
            bounds: _shareBounds(context),
            subject: 'Receipt · ${_referenceHint(transaction)}',
            body: 'Thank you for your purchase.',
          );
        case _ReceiptPresentationMode.download:
          await _download(context, resolved, filename);
        case _ReceiptPresentationMode.print:
          await _print(context, resolved, filename);
        case _ReceiptPresentationMode.view:
          await _view(context, resolved, filename);
      }
    } on TransactionReceiptException catch (e) {
      _hideProgress(context);
      if (context.mounted) _showSnack(context, e.message, isError: true);
    } catch (e) {
      _hideProgress(context);
      if (context.mounted) {
        _showSnack(context, _friendlyError(e), isError: true);
      }
    } finally {
      _busy = false;
    }
  }

  /// Stored EBM PDF when there is one, a locally built copy otherwise.
  @visibleForTesting
  Future<ResolvedReceipt> resolveReceipt(
    ITransaction transaction,
    List<TransactionItem>? items,
  ) async {
    final fileName = transaction.receiptFileName?.trim();
    if (fileName != null && fileName.isNotEmpty) {
      final stored = await _loader.load(transaction);
      if (stored != null) {
        return ResolvedReceipt(
          bytes: stored.bytes,
          localPath: stored.localPath,
          fiscal: true,
        );
      }
    }

    try {
      final bytes = await _fallbackBuilder(transaction, items);
      if (bytes.isEmpty) {
        throw TransactionReceiptException(_buildFailedMessage);
      }
      return ResolvedReceipt(bytes: bytes, localPath: null, fiscal: false);
    } on TransactionReceiptException {
      rethrow;
    } catch (_) {
      throw TransactionReceiptException(_buildFailedMessage);
    }
  }

  static const _buildFailedMessage =
      'Could not prepare a receipt for this sale. Check your connection and '
      'try again.';

  @visibleForTesting
  void validateCanPresent(ITransaction transaction) {
    // An RRA-signed *training* receipt must never leave the device looking
    // like a real one. A sale merely tagged TS with no signed PDF is not one:
    // Ditto carts used to be minted as "TS" regardless of mode, and those
    // sales can only ever produce the local fallback, which is stamped
    // "CUSTOMER COPY ... not an EBM fiscal receipt".
    final hasStoredFiscalPdf =
        (transaction.receiptFileName ?? '').trim().isNotEmpty;
    if (transaction.receiptType == 'TS' && hasStoredFiscalPdf) {
      throw TransactionReceiptException(
        'Training receipts cannot be shared or printed.',
      );
    }
  }

  Future<void> _download(
    BuildContext context,
    ResolvedReceipt resolved,
    String filename,
  ) async {
    if (kIsWeb) {
      await Printing.sharePdf(bytes: resolved.bytes, filename: filename);
      if (context.mounted) {
        _showSnack(context, 'Receipt ready to save or share.');
      }
      return;
    }

    if (UniversalPlatform.isDesktop) {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save receipt PDF',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: resolved.bytes,
      );
      if (savedPath == null || savedPath.isEmpty) return;
      final file = File(savedPath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(resolved.bytes, flush: true);
      await OpenFilex.open(savedPath);
      if (context.mounted) {
        _showSnack(context, 'Receipt saved to ${_baseName(savedPath)}.');
      }
      return;
    }

    final path = await _writeToDocuments(resolved, filename);
    final result = await OpenFilex.open(path);
    if (result.type == ResultType.done) {
      if (context.mounted) {
        _showSnack(
          context,
          resolved.fiscal
              ? 'Receipt saved on this device.'
              : 'Sale copy saved on this device.',
        );
      }
      return;
    }
    // No PDF viewer installed (or the OS refused the file): hand the PDF to the
    // share sheet so the customer can still save it to Files or Drive.
    await Printing.sharePdf(
      bytes: resolved.bytes,
      filename: filename,
      bounds: _shareBounds(context),
      subject: 'Receipt',
    );
    if (context.mounted) {
      _showSnack(context, 'Receipt ready — choose where to save it.');
    }
  }

  Future<void> _print(
    BuildContext context,
    ResolvedReceipt resolved,
    String filename,
  ) async {
    try {
      await Printing.layoutPdf(
        name: filename,
        onLayout: (_) async => resolved.bytes,
      );
    } catch (_) {
      if (!context.mounted) return;
      await Printing.sharePdf(
        bytes: resolved.bytes,
        filename: filename,
        bounds: _shareBounds(context),
        subject: 'Receipt',
      );
    }
  }

  Future<void> _view(
    BuildContext context,
    ResolvedReceipt resolved,
    String filename,
  ) async {
    if (kIsWeb || UniversalPlatform.isDesktop) {
      await Printing.layoutPdf(
        name: filename,
        onLayout: (_) async => resolved.bytes,
      );
      return;
    }

    final path = await _writeToDocuments(resolved, filename);
    final result = await OpenFilex.open(path);
    if (result.type == ResultType.done) return;

    if (!context.mounted) return;
    try {
      await Printing.layoutPdf(
        name: filename,
        onLayout: (_) async => resolved.bytes,
      );
    } catch (_) {
      if (!context.mounted) return;
      await Printing.sharePdf(
        bytes: resolved.bytes,
        filename: filename,
        bounds: _shareBounds(context),
        subject: 'Invoice',
      );
    }
  }

  Future<String> _writeToDocuments(
    ResolvedReceipt resolved,
    String filename,
  ) async {
    final existing = resolved.localPath;
    if (existing != null &&
        existing.isNotEmpty &&
        await File(existing).exists()) {
      return existing;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    await File(path).writeAsBytes(resolved.bytes, flush: true);
    return path;
  }

  /// iPad shows the share sheet in a popover anchored to these bounds; without
  /// them the sheet can fail to appear.
  Rect? _shareBounds(BuildContext context) {
    if (!context.mounted) return null;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    final origin = box.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      origin.dx,
      origin.dy,
      box.size.width,
      box.size.height,
    );
  }

  String _baseName(String path) {
    final parts = path.split(Platform.pathSeparator);
    return parts.isEmpty ? path : parts.last;
  }

  /// The stored name belongs to the EBM-signed PDF, so only a fiscal document
  /// may reuse it — a locally built copy under that name looks like the signed
  /// receipt on disk.
  String _pdfFilename(ITransaction transaction, {required bool fiscal}) {
    final stored = fiscal ? transaction.receiptFileName?.trim() : null;
    if (stored != null && stored.isNotEmpty) {
      return stored.toLowerCase().endsWith('.pdf') ? stored : '$stored.pdf';
    }
    final ref = transaction.reference?.trim();
    if (ref != null && ref.isNotEmpty) {
      final safe = ref.replaceAll(RegExp(r'[^\w\-]+'), '_');
      return '$safe.pdf';
    }
    return receiptPdfFilename(transaction);
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

  void _showProgress(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(minutes: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _hideProgress(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
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

/// Default fallback: build the receipt from what this device already knows
/// about the sale — no RRA call, no new signature.
Future<Uint8List> buildLocalSaleReceiptPdf(
  ITransaction transaction,
  List<TransactionItem>? items,
) async {
  final strategy = ProxyService.getStrategy(Strategy.capella);
  final branchId = transaction.branchId ?? ProxyService.box.getBranchId();

  var lineItems = items ?? const <TransactionItem>[];
  if (lineItems.isEmpty && branchId != null && branchId.isNotEmpty) {
    try {
      lineItems = await strategy.transactionItems(
        branchId: branchId,
        transactionId: transaction.id,
        fetchRemote: true,
      );
    } catch (_) {
      lineItems = const <TransactionItem>[];
    }
  }

  Business? business;
  try {
    business = await strategy.getBusiness(
      businessId: ProxyService.box.getBusinessId(),
    );
  } catch (_) {}

  String? branchName;
  if (branchId != null && branchId.isNotEmpty) {
    try {
      branchName = (await strategy.activeBranch(branchId: branchId)).name;
    } catch (_) {}
  }

  Receipt? fiscalReceipt;
  try {
    fiscalReceipt = await strategy.getReceipt(transactionId: transaction.id);
  } catch (_) {}

  return SaleReceiptPdf.build(
    transaction: transaction,
    items: lineItems,
    currency: ProxyService.box.defaultCurrency(),
    issuer: SaleReceiptIssuer(
      businessName: business?.name,
      branchName: branchName,
      tin: business?.tinNumber?.toString(),
      address: business?.adrs,
      phone: business?.phoneNumber,
    ),
    fiscalReceipt: fiscalReceipt,
  );
}

/// The PDF bytes behind a share/download/print/view action.
class ResolvedReceipt {
  const ResolvedReceipt({
    required this.bytes,
    required this.localPath,
    required this.fiscal,
  });

  final Uint8List bytes;
  final String? localPath;

  /// True when these bytes are the EBM-signed PDF stored at sale time.
  final bool fiscal;
}

enum _ReceiptPresentationMode { share, download, print, view }
