import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';

/// Hands a ticket PDF (bill or Order Form) to the user. Phones and the web
/// get the share sheet.
///
/// On desktop, [autoPrint] prints the way a sale receipt does — the till's
/// built-in printer (when the PDF carries an ESC/POS rendering), then the
/// saved default, then the one real attached printer — and shows the picker
/// only when none of those prints. Without it the picker always opens.
Future<void> presentTicketPdf(
  BuildContext context, {
  required Uint8List bytes,
  required ITransaction ticket,
  required List<TransactionItem> items,
  required String filename,
  bool autoPrint = false,
  String Function(String printerName)? notSentMessage,
}) async {
  if (UniversalPlatform.isDesktopOrWeb && !kIsWeb) {
    await CoreViewModel().printing(
      bytes,
      context,
      transaction: ticket,
      transactionItems: items,
      alwaysShowPicker: !autoPrint,
      pickerIfAutoFails: autoPrint,
      pdfFilename: filename,
      notSentMessage: notSentMessage,
    );
  } else {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }
}
