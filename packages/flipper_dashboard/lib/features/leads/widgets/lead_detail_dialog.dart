import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_dashboard/features/leads/widgets/proforma_invoice_screen.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/leads_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class LeadDetailDialog extends ConsumerStatefulWidget {
  final Lead lead;
  const LeadDetailDialog({super.key, required this.lead});

  @override
  ConsumerState<LeadDetailDialog> createState() => _LeadDetailDialogState();
}

class _LeadDetailDialogState extends ConsumerState<LeadDetailDialog> {
  bool _isConverting = false;

  static const Color _ink = Color(0xFF0D0E12);
  static const Color _ink2 = Color(0xFF4B4E58);
  static const Color _ink3 = Color(0xFF9499A5);
  static const Color _border = Color(0xFFEAECF0);

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final dateText = DateFormat('MMM d').format(lead.createdAt.toLocal());
    final isGmail = lead.source == LeadSource.gmail;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740, maxHeight: 860),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              _header(context, dateText: dateText, isGmail: isGmail),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _contactDetails(),
                        const SizedBox(height: 14),
                        _aiExtractedCard(),
                        const SizedBox(height: 14),
                        _timeline(),
                      ],
                    ),
                  ),
                ),
              ),
              _bottomActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context, {
    required String dateText,
    required bool isGmail,
  }) {
    final lead = widget.lead;
    final initials = lead.fullName.trim().isEmpty
        ? '?'
        : lead.fullName
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e.isEmpty ? '' : e[0].toUpperCase())
              .join();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF0D9488),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead.fullName,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: _ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _stagePill(lead.status),
                    _heatPill(lead.heat),
                    _sourceMini(isGmail),
                    Text(
                      '· $dateText',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: _ink3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: SvgPicture.string(
              AdminDashboardSvgs.leadsCloseX,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(_ink3, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactDetails() {
    final lead = widget.lead;
    Widget row(String label, String value, {Widget? trailing}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: _ink3,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    trailing ??
                    Text(
                      value.isEmpty ? '—' : value,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        color: _ink2,
                      ),
                    ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Text(
              'CONTACT DETAILS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: _ink3,
                letterSpacing: 0.08 * 11,
              ),
            ),
          ),
          row('Email', lead.emailAddress ?? ''),
          row('Phone', lead.phoneNumber ?? ''),
          row(
            'Est. value',
            '',
            trailing: lead.estimatedValue == null
                ? Text(
                    '—',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      color: _ink2,
                    ),
                  )
                : Text(
                    'RWF ${formatNumber(lead.estimatedValue!.toDouble())}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
          ),
          row('Notes', lead.notes ?? ''),
        ],
      ),
    );
  }

  Widget _aiExtractedCard() {
    final items = _itemsOfInterest();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                SvgPicture.string(
                  AdminDashboardSvgs.leadsAiInfoCircle,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF7C3AED),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI extracted items of interest',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF5B21B6),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
          ...items.map((e) => _aiRow(e)).toList(),
        ],
      ),
    );
  }

  Widget _aiRow(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                color: _ink,
              ),
            ),
          ),
          Text(
            '×1',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: _ink3,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '94% match',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF6D28D9),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline() {
    final lead = widget.lead;
    const connectorColor = Color(0xFFEAECF0);
    Widget dot(Color c) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );

    Widget entry(
      Color c,
      String title,
      String subtitle, {
      required bool isLast,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 16,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    dot(c),
                    if (!isLast) ...[
                      const SizedBox(height: 2),
                      Expanded(
                        child: Center(
                          child: Container(width: 2, color: connectorColor),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        color: _ink3,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ACTIVITY TIMELINE',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: _ink3,
            letterSpacing: 0.08 * 11,
          ),
        ),
        const SizedBox(height: 10),
        entry(
          const Color(0xFF2563EB),
          lead.source == LeadSource.gmail
              ? 'Lead created — from Gmail email'
              : 'Lead created — manual entry',
          DateFormat('MMM d').format(lead.createdAt.toLocal()) + ' · Auto',
          isLast: false,
        ),
        entry(
          const Color(0xFF7C3AED),
          'AI extracted ${_itemsOfInterest().length} product(s) of interest',
          DateFormat('MMM d').format(lead.createdAt.toLocal()) +
              ' · Claude API',
          isLast: false,
        ),
        entry(
          const Color(0xFFD97706),
          'Proforma draft ready for review',
          DateFormat('MMM d').format(lead.createdAt.toLocal()) + ' · Pending',
          isLast: true,
        ),
      ],
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F7FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: _border),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: _ink2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 44,
                child: FilledButton.icon(
                  onPressed: () {
                    // Close detail dialog then open proforma screen.
                    Navigator.of(context).pop();
                    Future.microtask(() {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProformaInvoiceScreen(lead: widget.lead),
                        ),
                      );
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                  ),
                  icon: SvgPicture.string(
                    AdminDashboardSvgs.leadsDocumentProforma,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: Text(
                    'Review proforma',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 44,
                child: FilledButton.icon(
                  onPressed: _isConverting
                      ? null
                      : () => _convertToSale(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                  ),
                  icon: _isConverting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : SvgPicture.string(
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
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _convertToSale(BuildContext context) async {
    final lead = widget.lead;
    if (_isConverting) return;

    setState(() => _isConverting = true);
    try {
      final now = DateTime.now().toUtc();
      final updated = lead.copyWith(
        status: LeadStatus.converted,
        updatedAt: now,
        lastTouched: now,
      );
      final upsert = ref.read(leadsUpsertProvider);
      await upsert(updated);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isConverting = false);
      showErrorNotification(context, 'Failed to convert lead. $e');
    }
  }

  Widget _sourceMini(bool isGmail) {
    return Text(
      isGmail ? 'Gmail' : 'Walk-in',
      style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: _ink3),
    );
  }

  Widget _stagePill(String status) {
    final normalized = status.toLowerCase();
    final (bg, fg, label) = switch (normalized) {
      LeadStatus.newLead => (
        const Color(0xFFEFF6FF),
        const Color(0xFF1D4ED8),
        'New',
      ),
      LeadStatus.contacted => (
        const Color(0xFFF5F3FF),
        const Color(0xFF6D28D9),
        'Contacted',
      ),
      LeadStatus.quoted => (
        const Color(0xFFFFFBEB),
        const Color(0xFFB45309),
        'Quoted',
      ),
      LeadStatus.converted => (
        const Color(0xFFECFDF3),
        const Color(0xFF047857),
        'Converted',
      ),
      LeadStatus.lost => (
        const Color(0xFFFFF1F2),
        const Color(0xFFBE123C),
        'Lost',
      ),
      _ => (const Color(0xFFF3F4F6), const Color(0xFF374151), normalized),
    };
    return _pillText(label, fg, bg: bg);
  }

  Widget _heatPill(String heat) {
    final normalized = heat.toLowerCase();
    final (bg, fg, label) = switch (normalized) {
      LeadHeat.hot => (const Color(0xFFFEE2E2), const Color(0xFFDC2626), 'Hot'),
      LeadHeat.warm => (
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
        'Warm',
      ),
      _ => (const Color(0xFFF3F4F6), const Color(0xFF6B7280), 'Cold'),
    };
    return _pillText(label, fg, bg: bg);
  }

  Widget _pillText(String text, Color fg, {required Color bg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg.withValues(alpha: 0.9)),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w900,
          color: fg,
          fontSize: 12,
        ),
      ),
    );
  }

  List<String> _itemsOfInterest() {
    final extracted = widget.lead.aiExtracted;
    if (extracted != null && extracted['items'] is List) {
      final items = (extracted['items'] as List)
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
      if (items.isNotEmpty) return items;
    }
    final raw = widget.lead.productsInterestedIn ?? '';
    if (raw.trim().isEmpty) return const ['—'];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
