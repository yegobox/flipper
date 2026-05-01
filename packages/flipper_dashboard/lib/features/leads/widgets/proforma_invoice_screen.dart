import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/leads/lead_ui_utils.dart';
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
    document.pageSettings.margins.all = 0;
    final page = document.pages.add();
    final size = page.getClientSize();

    PdfColor color(int hex) =>
        PdfColor((hex >> 16) & 0xFF, (hex >> 8) & 0xFF, hex & 0xFF);

    final bg = color(0xF4F6FB);
    final surface = color(0xFFFFFF);
    final border = color(0xEAECF0);
    final ink = color(0x0D0E12);
    final ink2 = color(0x4B4E58);
    final ink3 = color(0x9499A5);
    final blue = color(0x2563EB);
    final purple = color(0x7C3AED);
    final purpleSoft = color(0xF5F3FF);
    final purplePill = color(0xEDE9FE);
    final amberSoft = color(0xFFFBEB);
    final amber = color(0xB45309);
    final green = color(0x16A34A);

    final titleFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      20,
      style: PdfFontStyle.bold,
    );
    final labelFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      8,
      style: PdfFontStyle.bold,
    );
    final valueFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final valueBoldFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );
    final smallFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
    final smallBoldFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      8,
      style: PdfFontStyle.bold,
    );
    final monoBoldFont = PdfStandardFont(
      PdfFontFamily.courier,
      9,
      style: PdfFontStyle.bold,
    );

    void rect(
      Rect bounds, {
      PdfColor? fill,
      PdfColor? stroke,
      double strokeWidth = 0.8,
    }) {
      page.graphics.drawRectangle(
        brush: fill == null ? null : PdfSolidBrush(fill),
        pen: stroke == null ? null : PdfPen(stroke, width: strokeWidth),
        bounds: bounds,
      );
    }

    void text(
      String value,
      PdfFont font,
      Rect bounds, {
      PdfColor? fill,
      PdfTextAlignment alignment = PdfTextAlignment.left,
    }) {
      page.graphics.drawString(
        value,
        font,
        brush: PdfSolidBrush(fill ?? ink),
        bounds: bounds,
        format: PdfStringFormat(
          alignment: alignment,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );
    }

    void pill(
      String value,
      Rect bounds, {
      required PdfColor fill,
      required PdfColor foreground,
      PdfColor? stroke,
    }) {
      rect(bounds, fill: fill, stroke: stroke);
      text(
        value,
        smallBoldFont,
        bounds,
        fill: foreground,
        alignment: PdfTextAlignment.center,
      );
    }

    void card(Rect bounds) => rect(bounds, fill: surface, stroke: border);

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(bg),
      bounds: Rect.fromLTWH(0, 0, size.width, size.height),
    );

    const pageMargin = 34.0;
    final contentX = pageMargin;
    final contentW = size.width - (pageMargin * 2);
    double y = 26;

    final banner = Rect.fromLTWH(contentX, y, contentW, 34);
    rect(banner, fill: purpleSoft, stroke: color(0xDDD6FE));
    text(
      'AI drafted this proforma from the customer email',
      valueBoldFont,
      Rect.fromLTWH(
        banner.left + 16,
        banner.top,
        banner.width - 150,
        banner.height,
      ),
      fill: color(0x5B21B6),
    );
    pill(
      'All fields editable',
      Rect.fromLTWH(banner.right - 120, banner.top + 8, 96, 18),
      fill: purplePill,
      foreground: color(0x6D28D9),
    );
    y += 48;

    final docCard = Rect.fromLTWH(contentX, y, contentW, size.height - y - 28);
    card(docCard);
    y += 18;

    final headerX = docCard.left + 18;
    final headerW = docCard.width - 36;
    rect(Rect.fromLTWH(headerX, y + 2, 34, 34), fill: blue);
    text(
      'F',
      PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
      Rect.fromLTWH(headerX, y + 2, 34, 34),
      fill: surface,
      alignment: PdfTextAlignment.center,
    );
    text(
      'Flipper - Demo Shop',
      valueBoldFont,
      Rect.fromLTWH(headerX + 46, y, 180, 16),
    );
    text(
      'Kigali, Rwanda',
      smallFont,
      Rect.fromLTWH(headerX + 46, y + 17, 180, 14),
      fill: ink3,
    );
    text(
      'Proforma Invoice',
      titleFont,
      Rect.fromLTWH(headerX + headerW - 210, y - 2, 210, 24),
      fill: blue,
      alignment: PdfTextAlignment.right,
    );
    text(
      'PF-2026-0042',
      monoBoldFont,
      Rect.fromLTWH(headerX + headerW - 210, y + 24, 100, 16),
      fill: ink3,
      alignment: PdfTextAlignment.right,
    );
    pill(
      'Draft - not sent',
      Rect.fromLTWH(headerX + headerW - 96, y + 23, 96, 18),
      fill: amberSoft,
      foreground: amber,
      stroke: color(0xFDE68A),
    );
    y += 56;

    final contact = [
      if ((lead.emailAddress ?? '').trim().isNotEmpty)
        lead.emailAddress!.trim(),
      if ((lead.phoneNumber ?? '').trim().isNotEmpty) lead.phoneNumber!.trim(),
    ].join('  ');

    final gap = 10.0;
    final metaW = (headerW - (gap * 2)) / 3;
    void metaCard({
      required double x,
      required String title,
      required List<(String, PdfFont, PdfColor)> lines,
      String? badge,
    }) {
      final bounds = Rect.fromLTWH(x, y, metaW, 72);
      card(bounds);
      text(
        title,
        labelFont,
        Rect.fromLTWH(bounds.left + 10, bounds.top + 8, bounds.width - 20, 10),
        fill: ink3,
      );
      var lineY = bounds.top + 24;
      for (final line in lines) {
        text(
          line.$1,
          line.$2,
          Rect.fromLTWH(bounds.left + 10, lineY, bounds.width - 20, 13),
          fill: line.$3,
        );
        lineY += 13;
      }
      if (badge != null) {
        pill(
          badge,
          Rect.fromLTWH(bounds.left + 10, bounds.bottom - 24, 62, 16),
          fill: purplePill,
          foreground: color(0x6D28D9),
        );
      }
    }

    metaCard(
      x: headerX,
      title: 'BILL TO',
      lines: [
        (lead.fullName, valueBoldFont, ink),
        (contact.isEmpty ? 'No contact provided' : contact, smallFont, ink2),
      ],
    );
    metaCard(
      x: headerX + metaW + gap,
      title: 'ISSUE DATE',
      lines: [
        (DateFormat('dd MMM yyyy').format(issueDate), valueBoldFont, ink),
        ('VALID UNTIL', labelFont, ink3),
        (DateFormat('dd MMM yyyy').format(validUntil), valueBoldFont, ink),
      ],
    );
    metaCard(
      x: headerX + ((metaW + gap) * 2),
      title: 'LEAD SOURCE',
      lines: [
        (
          lead.source == LeadSource.gmail ? 'Gmail enquiry' : 'Manual entry',
          valueBoldFont,
          ink,
        ),
        ('AI matched items to catalogue', smallFont, ink2),
      ],
      badge: 'Claude API',
    );
    y += 90;

    final tableX = headerX;
    final tableW = headerW;
    final headerH = 28.0;
    final rowH = 30.0;
    final descW = tableW * 0.52;
    final unitW = tableW * 0.16;
    final qtyW = tableW * 0.10;
    final discountW = tableW * 0.10;
    final totalW = tableW - descW - unitW - qtyW - discountW;
    final tableH = headerH + (_lines.length * rowH);

    rect(
      Rect.fromLTWH(tableX, y, tableW, tableH),
      fill: surface,
      stroke: border,
    );
    rect(Rect.fromLTWH(tableX, y, tableW, headerH), fill: color(0xF8FAFC));
    text(
      'DESCRIPTION',
      labelFont,
      Rect.fromLTWH(tableX + 12, y, descW - 12, headerH),
      fill: ink3,
    );
    text(
      'UNIT PRICE',
      labelFont,
      Rect.fromLTWH(tableX + descW, y, unitW, headerH),
      fill: ink3,
      alignment: PdfTextAlignment.right,
    );
    text(
      'QTY',
      labelFont,
      Rect.fromLTWH(tableX + descW + unitW, y, qtyW, headerH),
      fill: ink3,
      alignment: PdfTextAlignment.center,
    );
    text(
      'DISCOUNT',
      labelFont,
      Rect.fromLTWH(tableX + descW + unitW + qtyW, y, discountW, headerH),
      fill: ink3,
      alignment: PdfTextAlignment.right,
    );
    text(
      'TOTAL',
      labelFont,
      Rect.fromLTWH(
        tableX + descW + unitW + qtyW + discountW,
        y,
        totalW - 12,
        headerH,
      ),
      fill: ink3,
      alignment: PdfTextAlignment.right,
    );
    y += headerH;

    for (final line in _lines) {
      rect(
        Rect.fromLTWH(tableX, y, tableW, rowH),
        stroke: border,
        strokeWidth: 0.4,
      );
      text(
        line.name,
        valueBoldFont,
        Rect.fromLTWH(tableX + 12, y, descW - 56, rowH),
      );
      pill(
        'AI',
        Rect.fromLTWH(tableX + descW - 38, y + 7, 24, 16),
        fill: purplePill,
        foreground: purple,
      );
      text(
        formatNumber(line.unitPrice),
        monoBoldFont,
        Rect.fromLTWH(tableX + descW, y, unitW, rowH),
        alignment: PdfTextAlignment.right,
      );
      text(
        '${line.qty}',
        monoBoldFont,
        Rect.fromLTWH(tableX + descW + unitW, y, qtyW, rowH),
        alignment: PdfTextAlignment.center,
      );
      text(
        '0',
        monoBoldFont,
        Rect.fromLTWH(tableX + descW + unitW + qtyW, y, discountW, rowH),
        fill: ink3,
        alignment: PdfTextAlignment.right,
      );
      text(
        'RWF ${formatNumber(line.unitPrice * line.qty)}',
        monoBoldFont,
        Rect.fromLTWH(
          tableX + descW + unitW + qtyW + discountW,
          y,
          totalW - 12,
          rowH,
        ),
        alignment: PdfTextAlignment.right,
      );
      y += rowH;
    }
    y += 16;

    final totalsX = headerX + headerW - 185;
    final totalsW = 185.0;
    final totalsH = 86.0;
    card(Rect.fromLTWH(totalsX, y, totalsW, totalsH));

    void totalRow(
      String label,
      String value,
      double rowY, {
      bool strong = false,
      PdfColor? valueColor,
    }) {
      text(
        label,
        strong ? valueBoldFont : valueFont,
        Rect.fromLTWH(totalsX + 12, rowY, 76, 16),
        fill: ink2,
      );
      text(
        value,
        strong ? monoBoldFont : smallBoldFont,
        Rect.fromLTWH(totalsX + 88, rowY, totalsW - 100, 16),
        fill: valueColor ?? ink,
        alignment: PdfTextAlignment.right,
      );
    }

    totalRow('Subtotal', 'RWF ${formatNumber(subTotal)}', y + 10);
    totalRow('VAT 18%', 'RWF ${formatNumber(vat)}', y + 28);
    totalRow('Discount', 'RWF 0', y + 46, valueColor: green);
    rect(Rect.fromLTWH(totalsX + 12, y + 64, totalsW - 24, 0.5), fill: border);
    totalRow(
      'Grand Total',
      'RWF ${formatNumber(grandTotal)}',
      y + 67,
      strong: true,
      valueColor: blue,
    );
    y += totalsH + 18;

    final termsBounds = Rect.fromLTWH(headerX, y, headerW, 54);
    rect(termsBounds, fill: color(0xF8FAFC), stroke: border);
    text(
      'NOTES / TERMS',
      labelFont,
      Rect.fromLTWH(
        termsBounds.left + 12,
        termsBounds.top + 9,
        termsBounds.width - 24,
        10,
      ),
      fill: ink3,
    );
    text(
      'This proforma is valid for 7 days. Payment due upon delivery. Bank transfer or mobile money accepted.',
      valueBoldFont,
      Rect.fromLTWH(
        termsBounds.left + 12,
        termsBounds.top + 26,
        termsBounds.width - 24,
        16,
      ),
      fill: ink2,
    );

    return document;
  }

  Future<void> _downloadPdf(BuildContext context) async {
    setState(() => _isDownloading = true);
    try {
      final issueDate = DateTime.now();
      final validUntil = issueDate.add(const Duration(days: 7));
      final document = await _buildPdfDocument(
        lead: widget.lead,
        issueDate: issueDate,
        validUntil: validUntil,
      );
      final filePath = await FileUtils.downloadPdfFile(
        document,
        fileName:
            '${DateFormat('yyyyMMdd_HHmmss').format(issueDate)}-Proforma-Invoice.pdf',
      );
      document.dispose();
      if (filePath == null) {
        return;
      }
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
    final seeds = proformaSeedsFromLead(lead);
    return seeds
        .map(
          (s) => _ProformaLine(
            name: s.name,
            unitPrice: s.unitPrice,
            qty: s.qty,
          ),
        )
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
