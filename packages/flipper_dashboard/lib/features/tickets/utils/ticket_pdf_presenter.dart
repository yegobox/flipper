import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';

/// Hands a ticket PDF (bill or Order Form) to the user: the branded printer
/// picker on desktop — always shown, never auto-skipped to the saved
/// default — and the share sheet everywhere else.
Future<void> presentTicketPdf(
  BuildContext context, {
  required Uint8List bytes,
  required ITransaction ticket,
  required List<TransactionItem> items,
  required String filename,
}) async {
  if (UniversalPlatform.isDesktopOrWeb && !kIsWeb) {
    await CoreViewModel().printing(
      bytes,
      context,
      transaction: ticket,
      transactionItems: items,
      alwaysShowPicker: true,
      pdfFilename: filename,
    );
  } else {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}
