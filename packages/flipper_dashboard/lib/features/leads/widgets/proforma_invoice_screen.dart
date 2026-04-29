import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../export/utils/file_utils.dart';

class ProformaInvoiceScreen extends ConsumerStatefulWidget {
  final Lead lead;
  const ProformaInvoiceScreen({super.key, required this.lead});

  @override
  ConsumerState<ProformaInvoiceScreen> createState() =>
      _ProformaInvoiceScreenState();
}

class _ProformaInvoiceScreenState extends ConsumerState<ProformaInvoiceScreen> {
  late final List<_ProformaLine> _lines;
  bool _isDownloading = false;
  bool _isSending = false;
  bool _isConverting = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _lines = _seedLines(widget.lead);
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final issueDate = DateTime.now();
    final validUntil = issueDate.add(const Duration(days: 7));

    final subTotal = _lines.fold<double>(
      0.0,
      (a, b) => a + (b.unitPrice * b.qty),
    );
    final vat = subTotal * 0.18;
    final grandTotal = subTotal + vat;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: _documentCard(
                        lead: lead,
                        issueDate: issueDate,
                        validUntil: validUntil,
                        subTotal: subTotal,
                        vat: vat,
                        grandTotal: grandTotal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _rightPanel(
                        lead: lead,
                        subTotal: subTotal,
                        vat: vat,
                        grandTotal: grandTotal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: SvgPicture.string(
              AdminDashboardSvgs.leadsBackChevronLeft,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Color(0xFF4B4E58),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proforma Invoice',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Lead: ${widget.lead.fullName} · AI draft — review before sending',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFF9499A5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _topAction(
            icon: AdminDashboardSvgs.leadsDownloadExport,
            label: 'Download PDF',
            onPressed: _isDownloading ? null : () => _downloadPdf(context),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _isSending ? null : () => _sendToCustomer(context),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            icon: SvgPicture.string(
              AdminDashboardSvgs.leadsSendPaperPlane,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              _isSending ? 'Sending…' : 'Send to customer',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _isConverting ? null : () => _convertToSale(context),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            icon: SvgPicture.string(
              AdminDashboardSvgs.leadsCheckmark,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              _isConverting ? 'Converting…' : 'Convert to sale',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topAction({
    required String icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF6F7FB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      icon: SvgPicture.string(
        icon,
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(Color(0xFF4B4E58), BlendMode.srcIn),
      ),
      label: Text(
        label,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w900,
          color: const Color(0xFF4B4E58),
        ),
      ),
    );
  }

  Widget _documentCard({
    required Lead lead,
    required DateTime issueDate,
    required DateTime validUntil,
    required double subTotal,
    required double vat,
    required double grandTotal,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.string(
                  AdminDashboardSvgs.leadsAiInfoCircle,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF7C3AED),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI drafted this proforma from the customer’s email',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF5B21B6),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'All fields editable',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6D28D9),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _docHeader(lead: lead),
                    const SizedBox(height: 14),
                    _metaGrid(
                      lead: lead,
                      issueDate: issueDate,
                      validUntil: validUntil,
                    ),
                    const SizedBox(height: 14),
                    _linesTable(),
                    const SizedBox(height: 16),
                    _totals(
                      subTotal: subTotal,
                      vat: vat,
                      grandTotal: grandTotal,
                    ),
                    const SizedBox(height: 16),
                    _terms(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docHeader({required Lead lead}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.string(
              AdminDashboardSvgs.leadsFlipperLogoLines,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flipper — Demo Shop',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                'Kigali, Rwanda',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF9499A5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Proforma Invoice',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'PF-2026-0042',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF9499A5),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    'Draft — not sent',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFB45309),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _metaGrid({
    required Lead lead,
    required DateTime issueDate,
    required DateTime validUntil,
  }) {
    Widget block(String title, Widget child) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEAECF0)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF9499A5),
                  fontSize: 11,
                  letterSpacing: 0.08 * 11,
                ),
              ),
              const SizedBox(height: 6),
              child,
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        block(
          'BILL TO',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lead.fullName,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                '${lead.emailAddress ?? ''} ${lead.phoneNumber ?? ''}'.trim(),
                style: GoogleFonts.outfit(
                  color: const Color(0xFF4B4E58),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        block(
          'ISSUE DATE',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(issueDate),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'VALID UNTIL',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF9499A5),
                  fontSize: 11,
                  letterSpacing: 0.08 * 11,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('dd MMM yyyy').format(validUntil),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        block(
          'LEAD SOURCE',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lead.source == LeadSource.gmail
                    ? 'Gmail enquiry'
                    : 'Manual entry',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                'AI matched items to catalogue',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF4B4E58),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Claude API',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF6D28D9),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _linesTable() {
    Widget header(String t, {int flex = 1, bool right = false}) {
      return Expanded(
        flex: flex,
        child: Align(
          alignment: right ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            t,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9499A5),
              fontSize: 11,
              letterSpacing: 0.08 * 11,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            color: const Color(0xFFFBFBFD),
            child: Row(
              children: [
                header('DESCRIPTION', flex: 5),
                header('UNIT PRICE', flex: 2, right: true),
                header('QTY', flex: 2, right: true),
                header('DISCOUNT', flex: 2, right: true),
                header('TOTAL', flex: 2, right: true),
              ],
            ),
          ),
          ..._lines.map((l) => _lineRow(l)).toList(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '+ Search product to add a line…',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFC5C8D0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _lines.add(
                        _ProformaLine(name: 'New item', unitPrice: 0, qty: 1),
                      );
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F7FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.string(
                        AdminDashboardSvgs.leadsPlusAdd,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2563EB),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add line',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineRow(_ProformaLine line) {
    final total = line.unitPrice * line.qty;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    line.name,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'AI',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6D28D9),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatNumber(line.unitPrice),
                style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _qtyBtn(
                    '-',
                    () =>
                        setState(() => line.qty = (line.qty - 1).clamp(1, 999)),
                  ),
                  Container(
                    width: 34,
                    alignment: Alignment.center,
                    child: Text(
                      '${line.qty}',
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _qtyBtn(
                    '+',
                    () =>
                        setState(() => line.qty = (line.qty + 1).clamp(1, 999)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '0',
                style: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF9499A5),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'RWF ${formatNumber(total)}',
                style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(String t, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEAECF0)),
        ),
        child: Center(
          child: Text(
            t,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF4B4E58),
            ),
          ),
        ),
      ),
    );
  }

  Widget _totals({
    required double subTotal,
    required double vat,
    required double grandTotal,
  }) {
    Widget row(String k, String v, {bool strong = false, Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                k,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF4B4E58),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              v,
              style: strong
                  ? GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: valueColor ?? Colors.black,
                    )
                  : GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w900,
                      color: valueColor ?? Colors.black,
                    ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 320,
        child: Column(
          children: [
            row('Subtotal', 'RWF ${formatNumber(subTotal)}'),
            row('VAT 18%', 'RWF ${formatNumber(vat)}'),
            row('Discount', 'RWF 0', valueColor: const Color(0xFF16A34A)),
            const SizedBox(height: 6),
            row(
              'Grand Total',
              'RWF ${formatNumber(grandTotal)}',
              strong: true,
              valueColor: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _terms() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTES / TERMS',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9499A5),
              fontSize: 11,
              letterSpacing: 0.08 * 11,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This proforma is valid for 7 days. Payment due upon delivery. Bank transfer or mobile money accepted.',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4B4E58),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightPanel({
    required Lead lead,
    required double subTotal,
    required double vat,
    required double grandTotal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sideCard(
          title: 'Actions',
          child: Column(
            children: [
              _sideBtn(
                color: const Color(0xFF2563EB),
                icon: AdminDashboardSvgs.leadsSendPaperPlane,
                label: 'Send to customer',
                onTap: _isSending ? () {} : () => _sendToCustomer(context),
              ),
              const SizedBox(height: 10),
              _sideBtn(
                color: const Color(0xFF16A34A),
                icon: AdminDashboardSvgs.leadsCheckmark,
                label: 'Convert to sale',
                onTap: _isConverting ? () {} : () => _convertToSale(context),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _isSharing ? null : () => _shareLink(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFEAECF0)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                icon: SvgPicture.string(
                  AdminDashboardSvgs.leadsShareExternalLink,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF4B4E58),
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  'Share link',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4B4E58),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sideCard(
          title: 'Summary',
          child: Column(
            children: [
              _kv('Lines', '${_lines.length} lines'),
              _kv('Subtotal', 'RWF ${formatNumber(subTotal)}'),
              _kv('VAT 18%', 'RWF ${formatNumber(vat)}'),
              _kv(
                'Grand total',
                'RWF ${formatNumber(grandTotal)}',
                strong: true,
              ),
              _kv('Status', 'Draft', valueColor: const Color(0xFFD97706)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _sideCard(
            title: 'History',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _historyDot(
                  const Color(0xFF7C3AED),
                  'AI drafted from Gmail email',
                  'Today · 09:17',
                ),
                const SizedBox(height: 10),
                _historyDot(
                  const Color(0xFF2563EB),
                  'Lead created, proforma generated',
                  'Today · 09:17',
                ),
                const SizedBox(height: 10),
                _historyDot(
                  const Color(0xFF9CA3AF),
                  'Awaiting user review',
                  'Now · Pending',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sideCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _sideBtn({
    required Color color,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        icon: SvgPicture.string(
          icon,
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        label: Text(
          label,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _kv(String k, String v, {bool strong = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: GoogleFonts.outfit(
                color: const Color(0xFF9499A5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            v,
            style: strong
                ? GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? Colors.black,
                  )
                : GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? Colors.black,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _historyDot(Color c, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF9499A5),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toast(
    BuildContext context,
    String msg, {
    NotificationType type = NotificationType.info,
  }) {
    showCustomSnackBarUtil(context, msg, type: type);
  }

  String _buildShareLink(Lead lead) {
    final branchId = lead.branchId;
    final encodedLeadId = Uri.encodeComponent(lead.id);
    return 'flipper://leads/proforma?leadId=$encodedLeadId&branchId=$branchId';
  }

  Future<PdfDocument> _buildPdfDocument({
    required Lead lead,
    required DateTime issueDate,
    required DateTime validUntil,
  }) async {
    final subTotal = _lines.fold<double>(
      0.0,
      (a, b) => a + (b.unitPrice * b.qty),
    );
    final vat = subTotal * 0.18;
    final grandTotal = subTotal + vat;

    final document = PdfDocument();
    final page = document.pages.add();
    final size = page.getClientSize();

    final titleFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      18,
      style: PdfFontStyle.bold,
    );
    final labelFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );
    final valueFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    double y = 0;
    page.graphics.drawString(
      'Proforma Invoice',
      titleFont,
      bounds: Rect.fromLTWH(0, y, size.width, 24),
    );
    y += 30;

    page.graphics.drawString(
      'Bill to:',
      labelFont,
      bounds: Rect.fromLTWH(0, y, 120, 16),
    );
    page.graphics.drawString(
      lead.fullName,
      valueFont,
      bounds: Rect.fromLTWH(70, y, size.width - 70, 16),
    );
    y += 16;

    final contact = [
      if ((lead.emailAddress ?? '').trim().isNotEmpty)
        lead.emailAddress!.trim(),
      if ((lead.phoneNumber ?? '').trim().isNotEmpty) lead.phoneNumber!.trim(),
    ].join('  ');
    if (contact.isNotEmpty) {
      page.graphics.drawString(
        'Contact:',
        labelFont,
        bounds: Rect.fromLTWH(0, y, 120, 16),
      );
      page.graphics.drawString(
        contact,
        valueFont,
        bounds: Rect.fromLTWH(70, y, size.width - 70, 16),
      );
      y += 16;
    }

    page.graphics.drawString(
      'Issue date:',
      labelFont,
      bounds: Rect.fromLTWH(0, y, 120, 16),
    );
    page.graphics.drawString(
      DateFormat('dd MMM yyyy').format(issueDate),
      valueFont,
      bounds: Rect.fromLTWH(70, y, 180, 16),
    );
    page.graphics.drawString(
      'Valid until:',
      labelFont,
      bounds: Rect.fromLTWH(260, y, 120, 16),
    );
    page.graphics.drawString(
      DateFormat('dd MMM yyyy').format(validUntil),
      valueFont,
      bounds: Rect.fromLTWH(330, y, size.width - 330, 16),
    );
    y += 22;

    final grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);
    final header = grid.headers[0];
    header.cells[0].value = 'Description';
    header.cells[1].value = 'Unit';
    header.cells[2].value = 'Qty';
    header.cells[3].value = 'Total';
    header.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );

    for (final l in _lines) {
      final row = grid.rows.add();
      row.cells[0].value = l.name;
      row.cells[1].value = formatNumber(l.unitPrice);
      row.cells[2].value = '${l.qty}';
      row.cells[3].value = formatNumber(l.unitPrice * l.qty);
    }
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10);
    grid.columns[0].width = size.width * 0.52;
    grid.columns[1].width = size.width * 0.16;
    grid.columns[2].width = size.width * 0.10;
    grid.columns[3].width = size.width * 0.18;

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, y, size.width, size.height - y - 80),
    );

    final totalsY = size.height - 70;
    page.graphics.drawString(
      'Subtotal:',
      labelFont,
      bounds: Rect.fromLTWH(size.width - 200, totalsY, 90, 14),
    );
    page.graphics.drawString(
      'RWF ${formatNumber(subTotal)}',
      valueFont,
      bounds: Rect.fromLTWH(size.width - 110, totalsY, 110, 14),
    );
    page.graphics.drawString(
      'VAT 18%:',
      labelFont,
      bounds: Rect.fromLTWH(size.width - 200, totalsY + 16, 90, 14),
    );
    page.graphics.drawString(
      'RWF ${formatNumber(vat)}',
      valueFont,
      bounds: Rect.fromLTWH(size.width - 110, totalsY + 16, 110, 14),
    );
    page.graphics.drawString(
      'Grand total:',
      labelFont,
      bounds: Rect.fromLTWH(size.width - 200, totalsY + 32, 90, 14),
    );
    page.graphics.drawString(
      'RWF ${formatNumber(grandTotal)}',
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(size.width - 110, totalsY + 32, 110, 14),
    );

    return document;
  }

  Future<void> _downloadPdf(BuildContext context) async {
    setState(() => _isDownloading = true);
    try {
      await FileUtils.requestPermissions();
      final issueDate = DateTime.now();
      final validUntil = issueDate.add(const Duration(days: 7));
      final document = await _buildPdfDocument(
        lead: widget.lead,
        issueDate: issueDate,
        validUntil: validUntil,
      );
      final filePath = await FileUtils.savePdfFile(document);
      document.dispose();
      await FileUtils.openOrShareFile(filePath);
      if (mounted) {
        _toast(context, 'Proforma PDF saved.', type: NotificationType.success);
      }
    } catch (e) {
      if (mounted) {
        _toast(
          context,
          'Failed to export PDF: $e',
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _sendToCustomer(BuildContext context) async {
    setState(() => _isSending = true);
    try {
      await FileUtils.requestPermissions();
      final issueDate = DateTime.now();
      final validUntil = issueDate.add(const Duration(days: 7));
      final document = await _buildPdfDocument(
        lead: widget.lead,
        issueDate: issueDate,
        validUntil: validUntil,
      );
      final filePath = await FileUtils.savePdfFile(document);
      document.dispose();

      final link = _buildShareLink(widget.lead);
      final message =
          'Proforma invoice for ${widget.lead.fullName}\n$link\n\nSent from Flipper.';

      final phone = (widget.lead.phoneNumber ?? '').trim();
      if (phone.isNotEmpty) {
        final wa = Uri.parse(
          'https://wa.me/${Uri.encodeComponent(phone)}?text=${Uri.encodeComponent(message)}',
        );
        if (await canLaunchUrl(wa)) {
          await launchUrl(wa, mode: LaunchMode.externalApplication);
        }
      } else {
        final email = (widget.lead.emailAddress ?? '').trim();
        if (email.isNotEmpty) {
          final mail = Uri(
            scheme: 'mailto',
            path: email,
            queryParameters: {'subject': 'Proforma invoice', 'body': message},
          );
          if (await canLaunchUrl(mail)) {
            await launchUrl(mail, mode: LaunchMode.externalApplication);
          }
        }
      }

      await FileUtils.shareFileAsAttachment(filePath);
      if (mounted) {
        _toast(
          context,
          'Ready to send: shared as attachment.',
          type: NotificationType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        _toast(
          context,
          'Failed to prepare send: $e',
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _shareLink(BuildContext context) async {
    setState(() => _isSharing = true);
    try {
      final link = _buildShareLink(widget.lead);
      final msg = 'Proforma invoice link for ${widget.lead.fullName}\n$link';
      ProxyService.share.share(msg);
    } catch (e) {
      if (mounted) {
        _toast(
          context,
          'Failed to share link: $e',
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _convertToSale(BuildContext context) async {
    setState(() => _isConverting = true);
    try {
      final upsert = ref.read(leadsUpsertProvider);
      await upsert(widget.lead.copyWith(status: LeadStatus.converted));
      if (mounted) {
        _toast(
          context,
          'Lead converted to sale.',
          type: NotificationType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        _toast(context, 'Failed to convert: $e', type: NotificationType.error);
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  static List<_ProformaLine> _seedLines(Lead lead) {
    final raw = (lead.productsInterestedIn ?? '').trim();
    if (raw.isEmpty) {
      return [_ProformaLine(name: 'Item', unitPrice: 0, qty: 1)];
    }
    final names = raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (names.isEmpty)
      return [_ProformaLine(name: 'Item', unitPrice: 0, qty: 1)];
    // Use estimatedValue as a hint to populate a reasonable unit price split.
    final total = (lead.estimatedValue ?? 0).toDouble();
    final per = names.isEmpty ? 0.0 : (total / names.length);
    return names
        .map((n) => _ProformaLine(name: n, unitPrice: per, qty: 1))
        .toList();
  }
}

class _ProformaLine {
  final String name;
  double unitPrice;
  int qty;
  _ProformaLine({
    required this.name,
    required this.unitPrice,
    required this.qty,
  });
}
