import 'dart:typed_data';

import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/widgets/pay_ui.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// A payslip as a one-page A5 PDF.
///
/// Carries what Law 66/2018 art. 71 asks a payslip to show — basic salary,
/// allowances and bonuses, every withholding, and net pay — plus the employer's
/// contributions, so the same page answers the employee's question ("why is
/// my pay this?") and the owner's ("what did this person cost?").
Future<Uint8List> buildPayslipPdf({
  required Payslip slip,
  required Employee employee,
  required String businessName,
  List<PayPayment> payments = const [],
}) async {
  final l10n = FlipperL10n.current;
  final doc = pw.Document(
    title:
        '${l10n.hrPayslip} ${formatPayPeriod(slip.periodStart, slip.periodEnd)}',
  );
  String m(double v) => formatMoney(v, slip.currency);

  pw.Widget row(String label, String value, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  pw.Widget heading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
    child: pw.Text(
      text.toUpperCase(),
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey700,
        letterSpacing: 0.6,
      ),
    ),
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      businessName,
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      l10n.hrPayslip,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Text(
                formatPayPeriod(slip.periodStart, slip.periodEnd),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Divider(color: PdfColors.grey400),
          row(l10n.hrPayEmployee, employee.fullName, bold: true),
          if (employee.jobTitle.isNotEmpty)
            row(l10n.hrJobTitle, employee.jobTitle),
          if (employee.nationalId.isNotEmpty)
            row(l10n.hrNationalId, employee.nationalId),
          if (employee.rssbNumber.isNotEmpty)
            row(l10n.hrRssbNumber, employee.rssbNumber),
          heading(l10n.hrPayEarnings),
          row(l10n.hrPayBasePay, m(slip.basePay)),
          if (slip.allowances > 0)
            row(l10n.hrPayAllowances, m(slip.allowances)),
          if (slip.extraEarnings > 0)
            row(l10n.hrPayBonus, m(slip.extraEarnings)),
          row(l10n.hrPayGross, m(slip.gross), bold: true),
          heading(l10n.hrPayDeductions),
          row(l10n.hrPayPaye, m(slip.paye)),
          if (slip.pensionEmployee > 0)
            row(l10n.hrPayPensionPlain, m(slip.pensionEmployee)),
          if (slip.maternityEmployee > 0)
            row(l10n.hrPayMaternity, m(slip.maternityEmployee)),
          row(l10n.hrPayCbhi, m(slip.cbhi)),
          if (slip.otherDeductions > 0)
            row(l10n.hrPayOtherDeductions, m(slip.otherDeductions)),
          if (slip.advanceRecovery > 0)
            row(l10n.hrPayAdvanceRecovered, m(slip.advanceRecovery)),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            color: PdfColors.blue50,
            child: row(l10n.hrPayNetPay, m(slip.netPay), bold: true),
          ),
          heading(l10n.hrPayEmployerContributions),
          if (slip.pensionEmployer > 0)
            row(l10n.hrPayPensionPlain, m(slip.pensionEmployer)),
          if (slip.maternityEmployer > 0)
            row(l10n.hrPayMaternity, m(slip.maternityEmployer)),
          if (slip.occupationalHazards > 0)
            row(l10n.hrPayOccupationalHazards, m(slip.occupationalHazards)),
          if (payments.isNotEmpty) ...[
            heading(l10n.hrPayPaymentsMade),
            for (final p in payments.where((p) => !p.voided))
              row(
                '${formatShortDate(p.paidOn)} · ${p.method.label}'
                '${p.reference == null ? '' : ' · ${p.reference}'}',
                m(p.amount),
              ),
          ],
          pw.Spacer(),
          pw.Text(
            l10n.hrPayslipFooter(slip.ratesVersion ?? '-'),
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
        ],
      ),
    ),
  );
  return doc.save();
}
