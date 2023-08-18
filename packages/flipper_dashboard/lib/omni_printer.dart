import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// [generateDoc] example
/// generateDoc(
///   header: [
///     pw.Text('K5 25 Ave', style: const pw.TextStyle(fontSize: 5)),
///     pw.Text('+250 788 888 888',
///         style: const pw.TextStyle(fontSize: 5)),
///   ],
///   subHeader: [
///     pw.Text('Cashier: John Doe',
///         style: const pw.TextStyle(fontSize: 5)),
///     pw.Container(width: 10),
///     pw.Column(
///       children: [
///         pw.Text('June 19,2021',
///             style: const pw.TextStyle(fontSize: 5)),
///         pw.Text('11:20 am', style: const pw.TextStyle(fontSize: 5)),
///       ],
///     )
///   ],
///   body: pw.Table(children: [
///     pw.TableRow(children: [
///       pw.Text('Qty', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('DESC', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('AMT', style: const pw.TextStyle(fontSize: 5)),
///     ]),
///     pw.TableRow(children: [
///       pw.Text('1', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('Coffee', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('\$1.00', style: const pw.TextStyle(fontSize: 5)),
///     ]),
///     pw.TableRow(children: [
///       pw.Text('1', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('Coffee', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('\$1.00', style: const pw.TextStyle(fontSize: 5)),
///     ]),
///     pw.TableRow(children: [
///       pw.Text('1', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('Coffee', style: const pw.TextStyle(fontSize: 5)),
///       pw.Text('\$1.00', style: const pw.TextStyle(fontSize: 5)),
///     ]),
///     /// show total
///     pw.TableRow(children: [
///       pw.Text(''),
///       pw.Text('Total', style: const pw.TextStyle(fontSize: 6)),
///       pw.Text('\$3.00', style: const pw.TextStyle(fontSize: 6)),
///     ]),
///   ]),
/// );
class OmniPrinter {
  final doc = pw.Document();

  Future<bool> autoPrint() async {
    Printing.layoutPdf(
      format: PdfPageFormat.roll80,
      onLayout: (PdfPageFormat format) async {
        return doc.save();
      },
      // this will use a default printer if it is set.
      usePrinterSettings: true,
    );
    return Future.value(false);
  }

  Future<bool> chosePrinter(BuildContext context) {
    // Printer? choosePriner = await Printing.pickPrinter(context: context);
    // if (choosePriner != null && choosePriner.isAvailable) {
    throw Exception('Not implemented');
  }

  Future<Uint8List> generateDoc({
    required List<pw.Widget> header,
    required List<pw.Widget> subHeader,
    required pw.Widget body,
  }) {
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(children: [
            ...header,
            pw.Row(
              children: subHeader,
            ),
            pw.Text('\n'),
            body,
          ]);
        },
      ),
    );
    return doc.save();
  }

  Future<void> shareDoc() async {
    /// try to print if does not work try to save
    /// Printing.directPrintPdf(printer: printer, onLayout: onLayout)
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'receipt.pdf',
      subject: "receipt",
      body: "Thank you for visinting us",

      /// list email of the customer who is paying
      emails: ["murag.richard@gmail.com"],
    );
  }
}
