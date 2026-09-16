import 'package:flipper_dashboard/services/pdf_presentation_service.dart';
import 'package:flipper_dashboard/services/sale_receipt_pdf.dart';
import 'package:flipper_dashboard/services/stored_receipt_loader.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/receipt_pdf_filename.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  /// Every platform-specific path — the desktop save dialog, the print
  /// dialog, the share-sheet fallbacks — lives here, shared with the hotel
  /// quotation so the two documents behave identically.
  final PdfPresentationService _presenter = PdfPresentationService();

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
    // Captured by `filename` and `existingPath` below, which the presenter
    // calls only after `build` has run.
    ResolvedReceipt? resolved;

    await _presenter.present(
      context,
      mode: switch (mode) {
        _ReceiptPresentationMode.share => PdfPresentationMode.share,
        _ReceiptPresentationMode.download => PdfPresentationMode.download,
        _ReceiptPresentationMode.print => PdfPresentationMode.print,
        _ReceiptPresentationMode.view => PdfPresentationMode.view,
      },
      progressMessage: 'Preparing receipt…',
      build: () async {
        validateCanPresent(transaction);
        resolved = await resolveReceipt(transaction, items);
        return resolved!.bytes;
      },
      // Whether the document is fiscal decides whether it may reuse the
      // EBM-signed PDF's stored filename, so this can only be answered once
      // `build` has resolved it.
      filename: () => _pdfFilename(transaction, fiscal: resolved!.fiscal),
      label: 'Receipt',
      shareSubject: mode == _ReceiptPresentationMode.view
          ? 'Invoice'
          : 'Receipt · ${_referenceHint(transaction)}',
      shareBody: 'Thank you for your purchase.',
      existingPath: () => resolved?.localPath,
      // validateCanPresent throws messages written for the person holding the
      // device; the generic formatter would replace them with "Something went
      // wrong."
      errorMessage: (error) => error is TransactionReceiptException
          ? error.message
          : _presenter.friendlyError(error),
    );
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
