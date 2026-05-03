import 'package:flipper_dashboard/features/leads/widgets/add_lead_sheet.dart';
import 'package:flipper_dashboard/features/leads/widgets/lead_detail_dialog.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/leads_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class LeadsDesktopScreen extends ConsumerStatefulWidget {
  const LeadsDesktopScreen({super.key});

  @override
  ConsumerState<LeadsDesktopScreen> createState() => _LeadsDesktopScreenState();
}

class _LeadsDesktopScreenState extends ConsumerState<LeadsDesktopScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All';

  static const Color _bg = Color(0xFFF4F6FB);
  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFEAECF0);
  static const Color _ink = Color(0xFF0D0E12);
  static const Color _ink2 = Color(0xFF4B4E58);
  static const Color _ink3 = Color(0xFF9499A5);
  static const Color _blue = Color(0xFF2563EB);
  static const List<String> _leadFilterOptions = [
    'All',
    'New',
    'Contacted',
    'Quoted',
    'Converted',
    'Lost',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(leadsStatsProvider);
    final leadsAsync = ref.watch(leadsStreamProvider);

    final leads = leadsAsync.maybeWhen(
      data: (items) {
        Iterable<Lead> out = items;
        if (_filter != 'All') {
          out = out.where((l) => l.status == _filter.toLowerCase());
        }
        final q = _searchCtrl.text.trim().toLowerCase();
        if (q.isNotEmpty) {
          out = out.where((l) {
            return l.fullName.toLowerCase().contains(q) ||
                (l.emailAddress ?? '').toLowerCase().contains(q) ||
                (l.productsInterestedIn ?? '').toLowerCase().contains(q);
          });
        }
        return out.toList();
      },
      orElse: () => const <Lead>[],
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 12,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Leads',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              'Track customers, enquiries and pipeline value',
              style: GoogleFonts.outfit(fontSize: 13, color: _ink3),
            ),
          ],
        ),
        actions: [
          _pill(
            icon: AdminDashboardSvgs.leadsEmailEnvelope,
            text: '0 emails need review',
            bg: const Color(0xFFFFEEF1),
            fg: const Color(0xFFB42318),
            border: const Color(0xFFF3D2D7),
            onPressed: () => _showEmailLeadsComingSoon(context),
          ),
          const SizedBox(width: 10),
          Builder(
            builder: (buttonContext) => _ghostButton(
              icon: AdminDashboardSvgs.leadsFilter,
              label: 'Filter',
              onPressed: () => _showFilterMenu(buttonContext),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: () => _openAddLeadDialog(context),
            style: FilledButton.styleFrom(
              backgroundColor: _blue,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: SvgPicture.string(
              AdminDashboardSvgs.leadsPlusAdd,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            label: Text(
              'Add lead',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ColoredBox(
        color: _bg,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _statsRow(statsAsync),
              const SizedBox(height: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 7, child: _leadsTableCard(leadsAsync, leads)),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _pipelineCard(leads),
                          const SizedBox(height: 14),
                          _performanceCard(statsAsync),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsRow(AsyncValue<LeadsStats> statsAsync) {
    final s = statsAsync.asData?.value;
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'TOTAL LEADS',
            value: '${s?.totalLeads ?? 0}',
            subtitle: 'All sources',
            accent: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'PIPELINE VALUE',
            value: 'RWF ${formatNumber(s?.pipelineValue ?? 0.0)}',
            subtitle: 'Active leads',
            accent: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'CONVERTED',
            value: '${s?.converted ?? 0}',
            subtitle: 'Completed sales',
            accent: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'FROM GMAIL',
            value: '${s?.fromGmail ?? 0}',
            subtitle: 'Email enquiries',
            accent: const Color(0xFFDC2626),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            title: 'CONVERSION RATE',
            value: '${((s?.conversionRate ?? 0) * 100).toStringAsFixed(0)}%',
            subtitle: 'This month',
            accent: const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: _ink3,
              letterSpacing: 0.08 * 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: _ink3)),
        ],
      ),
    );
  }

  Widget _leadsTableCard(AsyncValue<List<Lead>> leadsAsync, List<Lead> leads) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.string(
                      AdminDashboardSvgs.leadsUsersMultiple,
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        _ink2,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'All Leads',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(child: _searchBox()),
                const SizedBox(width: 12),
                _chips(),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
          Expanded(
            child: leadsAsync.when(
              data: (_) => _leadsTable(leads),
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => Center(
                child: Text(
                  'Unable to load leads.',
                  style: GoogleFonts.outfit(color: _ink3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search name, email, product…',
          hintStyle: GoogleFonts.outfit(color: _ink3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.string(
              AdminDashboardSvgs.leadsSearch,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(_ink3, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chips() {
    return Row(
      children: _leadFilterOptions.map((c) {
        final selected = _filter == c;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ChoiceChip(
            label: Text(c),
            selected: selected,
            onSelected: (_) => setState(() => _filter = c),
            selectedColor: const Color(0xFFEEF2FF),
            labelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: selected ? const Color(0xFF3730A3) : _ink2,
            ),
            side: BorderSide(
              color: selected ? const Color(0xFFC7D2FE) : _border,
            ),
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }

  Widget _leadsTable(List<Lead> leads) {
    if (leads.isEmpty) {
      return Center(
        child: Text('No leads yet.', style: GoogleFonts.outfit(color: _ink3)),
      );
    }

    return Column(
      children: [
        _tableHeader(),
        Expanded(
          child: ListView.separated(
            itemCount: leads.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
            itemBuilder: (context, index) {
              return _tableRow(leads[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _tableHeader() {
    Widget header(String text, {int flex = 1, bool right = false}) {
      return Expanded(
        flex: flex,
        child: Align(
          alignment: right ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: _ink3,
              fontSize: 11,
              letterSpacing: 0.08 * 11,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: const Color(0xFFFBFBFD),
      child: Row(
        children: [
          header('CUSTOMER', flex: 4),
          header('SOURCE', flex: 2),
          header('INTERESTED IN', flex: 3),
          header('VALUE', flex: 2),
          header('STAGE', flex: 2),
          header('HEAT', flex: 2),
          header('DATE', flex: 1, right: true),
        ],
      ),
    );
  }

  Widget _tableRow(Lead lead) {
    final dateText = DateFormat('MMM d').format(lead.createdAt.toLocal());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (_) => LeadDetailDialog(lead: lead),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Expanded(flex: 4, child: _customerCell(lead)),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _sourceCell(lead),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  lead.productsInterestedIn?.isNotEmpty == true
                      ? lead.productsInterestedIn!
                      : '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    color: _ink2,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  lead.estimatedValue == null
                      ? '—'
                      : 'RWF ${formatNumber(lead.estimatedValue!.toDouble())}',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
              ),
              Expanded(flex: 2, child: _stagePill(lead.status)),
              Expanded(flex: 2, child: _heatCell(lead.heat)),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    dateText,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: _ink3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg.withValues(alpha: 0.9)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          color: fg,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _heatCell(String heat) {
    final normalized = heat.toLowerCase();
    final (dot, label) = switch (normalized) {
      LeadHeat.hot => (const Color(0xFFDC2626), 'Hot'),
      LeadHeat.warm => (const Color(0xFFD97706), 'Warm'),
      _ => (const Color(0xFF9CA3AF), 'Cold'),
    };

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dot,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: dot),
        ),
      ],
    );
  }

  Widget _customerCell(Lead l) {
    final initials = l.fullName.trim().isEmpty
        ? '?'
        : l.fullName
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e.isEmpty ? '' : e[0].toUpperCase())
              .join();
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFEFF2FF),
          child: Text(
            initials,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1D4ED8),
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l.fullName,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              (l.emailAddress ?? '').isNotEmpty ? l.emailAddress! : '—',
              style: GoogleFonts.outfit(color: _ink3, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sourceCell(Lead l) {
    final isGmail = l.source == LeadSource.gmail;
    final bg = isGmail ? const Color(0xFFFFF3F0) : const Color(0xFFEFFDFB);
    final fg = isGmail ? const Color(0xFFB42318) : const Color(0xFF0D9488);
    final icon = isGmail
        ? AdminDashboardSvgs.leadsEmailEnvelope
        : AdminDashboardSvgs.leadsUserSingle;
    final text = isGmail ? 'Gmail' : 'Walk-in';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            icon,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: fg,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pipelineCard(List<Lead> leads) {
    final counts = <String, int>{
      LeadStatus.newLead: 0,
      LeadStatus.contacted: 0,
      LeadStatus.quoted: 0,
      LeadStatus.converted: 0,
      LeadStatus.lost: 0,
    };
    var pipelineValue = 0.0;
    for (final l in leads) {
      counts[l.status] = (counts[l.status] ?? 0) + 1;
      if (l.status != LeadStatus.lost) {
        pipelineValue += (l.estimatedValue ?? 0).toDouble();
      }
    }

    Widget row(String label, String key, Color dot) {
      final v = counts[key] ?? 0;
      final bar = v == 0 ? 0.0 : (v / (leads.isEmpty ? 1 : leads.length));
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dot,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  color: _ink2,
                ),
              ),
            ),
            Text(
              '$v',
              style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: bar,
                  minHeight: 6,
                  backgroundColor: Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(dot),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pipeline',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 10),
            row('New', LeadStatus.newLead, const Color(0xFF2563EB)),
            row('Contacted', LeadStatus.contacted, const Color(0xFF7C3AED)),
            row('Quoted', LeadStatus.quoted, const Color(0xFFD97706)),
            row('Converted', LeadStatus.converted, const Color(0xFF16A34A)),
            row('Lost', LeadStatus.lost, const Color(0xFFDC2626)),
            const Spacer(),
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
            const SizedBox(height: 10),
            Text(
              'Pipeline value',
              style: GoogleFonts.outfit(color: _ink3, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'RWF ${formatNumber(pipelineValue)}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _performanceCard(AsyncValue<LeadsStats> statsAsync) {
    final s = statsAsync.asData?.value;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Performance',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '${((s?.conversionRate ?? 0) * 100).toStringAsFixed(0)}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF16A34A),
                letterSpacing: -1.2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Conversion rate this month',
              style: GoogleFonts.outfit(color: _ink3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
            const SizedBox(height: 14),
            _kv('Avg. time to convert', '4.2 days'),
            const SizedBox(height: 10),
            _kv(
              'Pipeline value',
              'RWF ${formatNumber(s?.pipelineValue ?? 0.0)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(
          child: Text(k, style: GoogleFonts.outfit(color: _ink3)),
        ),
        Text(v, style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _pill({
    required String icon,
    required String text,
    required Color bg,
    required Color fg,
    required Color border,
    VoidCallback? onPressed,
  }) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          SvgPicture.string(
            icon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
    if (onPressed == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: child,
      ),
    );
  }

  Widget _ghostButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF6F7FB),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: SvgPicture.string(
        icon,
        width: 16,
        height: 16,
        colorFilter: const ColorFilter.mode(_ink2, BlendMode.srcIn),
      ),
      label: Text(
        label,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: _ink2),
      ),
    );
  }

  void _openAddLeadDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 28,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SingleChildScrollView(child: const AddLeadSheet()),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFilterMenu(BuildContext buttonContext) async {
    final button = buttonContext.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox?;
    if (button == null || overlay == null) return;

    final selected = await showMenu<String>(
      context: buttonContext,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(Offset.zero, ancestor: overlay),
          button.localToGlobal(
            button.size.bottomRight(Offset.zero),
            ancestor: overlay,
          ),
        ),
        Offset.zero & overlay.size,
      ),
      items: _leadFilterOptions.map((filter) {
        return PopupMenuItem<String>(
          value: filter,
          child: Row(
            children: [
              Icon(
                _filter == filter
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: _filter == filter ? _blue : _ink3,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                filter,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: _ink2,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    if (selected == null || !mounted) return;
    setState(() => _filter = selected);
  }

  void _showEmailLeadsComingSoon(BuildContext context) {
    showInfoNotification(context, 'Email lead review is coming soon.');
  }
}
