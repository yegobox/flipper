import 'package:flipper_dashboard/features/leads/widgets/add_lead_sheet.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/leads_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LeadsMobileScreen extends ConsumerStatefulWidget {
  const LeadsMobileScreen({super.key});

  @override
  ConsumerState<LeadsMobileScreen> createState() => _LeadsMobileScreenState();
}

class _LeadsMobileScreenState extends ConsumerState<LeadsMobileScreen> {
  String _filter = 'All';
  String _search = '';

  static const Color _bg = Color(0xFFF4F6FB);
  static const Color _ink = Color(0xFF0D0E12);
  static const Color _ink2 = Color(0xFF4B4E58);
  static const Color _ink3 = Color(0xFF9499A5);
  static const Color _border = Color(0xFFEAECF0);
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
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(leadsStatsProvider);
    final leadsAsync = ref.watch(leadsStreamProvider);

    final filtered = leadsAsync.maybeWhen(
      data: (leads) {
        Iterable<Lead> items = leads;
        if (_filter != 'All') {
          items = items.where((l) => l.status == _filter.toLowerCase());
        }
        if (_search.trim().isNotEmpty) {
          final q = _search.trim().toLowerCase();
          items = items.where((l) {
            return l.fullName.toLowerCase().contains(q) ||
                (l.emailAddress ?? '').toLowerCase().contains(q) ||
                (l.productsInterestedIn ?? '').toLowerCase().contains(q);
          });
        }
        return items.toList();
      },
      orElse: () => const <Lead>[],
    );

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(leadsStreamProvider);
                  ref.invalidate(leadsStatsProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _statsCard(statsAsync),
                        const SizedBox(height: 14),
                        _gmailQueueCard(),
                        const SizedBox(height: 14),
                        _allLeadsCard(
                          context,
                          leadsAsync: leadsAsync,
                          leads: filtered,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 2,
        onPressed: () => _openAddLead(context),
        icon: SvgPicture.string(
          AdminDashboardSvgs.leadsPlusAdd,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 18,
          height: 18,
        ),
        label: Text(
          'Add lead',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
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
              colorFilter: const ColorFilter.mode(_ink2, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leads',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Track customers, enquiries and pipeline value',
                  style: GoogleFonts.outfit(fontSize: 12, color: _ink3),
                ),
              ],
            ),
          ),
          _topBarPill(
            icon: AdminDashboardSvgs.leadsEmailEnvelope,
            text: '0',
            bg: const Color(0xFFFFEEF1),
            fg: const Color(0xFFDC2626),
            onTap: () => _showEmailLeadsComingSoon(context),
          ),
          const SizedBox(width: 8),
          _topBarButton(
            icon: AdminDashboardSvgs.leadsFilter,
            label: 'Filter',
            onTap: () => _showFilterSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _topBarPill({
    required String icon,
    required String text,
    required Color bg,
    required Color fg,
    VoidCallback? onTap,
  }) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFF3D2D7)),
      ),
      child: Row(
        children: [
          SvgPicture.string(
            icon,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$text emails need review',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: child,
      ),
    );
  }

  Widget _topBarButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF6F7FB),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: SvgPicture.string(
        icon,
        colorFilter: const ColorFilter.mode(_ink2, BlendMode.srcIn),
        width: 16,
        height: 16,
      ),
      label: Text(
        label,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: _ink2),
      ),
    );
  }

  Widget _statsCard(AsyncValue<LeadsStats> statsAsync) {
    final stats = statsAsync.asData?.value;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statTile(
                title: 'TOTAL LEADS',
                value: '${stats?.totalLeads ?? 0}',
                subtitle: 'All sources',
                accent: const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statTile(
                title: 'PIPELINE VALUE',
                value: 'RWF ${formatNumber(stats?.pipelineValue ?? 0.0)}',
                subtitle: 'Active leads',
                accent: const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statTile(
                title: 'CONVERTED',
                value: '${stats?.converted ?? 0}',
                subtitle: 'Completed sales',
                accent: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statTile(
                title: 'FROM GMAIL',
                value: '${stats?.fromGmail ?? 0}',
                subtitle: 'Email enquiries',
                accent: const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statTile(
                title: 'CONVERSION RATE',
                value:
                    '${((stats?.conversionRate ?? 0) * 100).toStringAsFixed(0)}%',
                subtitle: 'This month',
                accent: const Color(0xFFD97706),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statTile({
    required String title,
    required String value,
    required String subtitle,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _gmailQueueCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _showEmailLeadsComingSoon(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SvgPicture.string(
                    AdminDashboardSvgs.leadsEmailEnvelope,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(_ink2, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gmail - AI flagged these as potential leads.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB42318),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFF3D2D7)),
                    ),
                    child: Text(
                      '0 pending',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB42318),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Gmail ingestion will be enabled later. For now, add leads manually.',
                style: GoogleFonts.outfit(fontSize: 12, color: _ink3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _allLeadsCard(
    BuildContext context, {
    required AsyncValue<List<Lead>> leadsAsync,
    required List<Lead> leads,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'All Leads',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          const SizedBox(height: 10),
          _searchBox(),
          const SizedBox(height: 10),
          _filterChips(),
          const SizedBox(height: 10),
          leadsAsync.when(
            data: (_) {
              if (leads.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'No leads yet.',
                    style: GoogleFonts.outfit(color: _ink3),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.separated(
                itemCount: leads.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.black.withValues(alpha: 0.06),
                ),
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return _leadRow(context, lead);
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(18),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                'Unable to load leads.',
                style: GoogleFonts.outfit(color: _ink3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        decoration: InputDecoration(
          hintText: 'Search name, email, product…',
          hintStyle: GoogleFonts.outfit(color: _ink3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
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

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _leadFilterOptions.map((c) {
          final selected = _filter == c;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
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
      ),
    );
  }

  Widget _leadRow(BuildContext context, Lead lead) {
    final initials = lead.fullName.trim().isEmpty
        ? '?'
        : lead.fullName
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e.isEmpty ? '' : e[0].toUpperCase())
              .join();

    final heatColors = switch (lead.heat) {
      LeadHeat.hot => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
      LeadHeat.warm => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
      _ => (const Color(0xFFE5E7EB), const Color(0xFF374151)),
    };

    final sourceBadge = lead.source == LeadSource.gmail
        ? _badge(
            icon: AdminDashboardSvgs.leadsEmailEnvelope,
            text: 'Gmail',
            bg: const Color(0xFFFFF3F0),
            fg: const Color(0xFFB42318),
          )
        : _badge(
            icon: AdminDashboardSvgs.leadsUserSingle,
            text: 'Walk-in',
            bg: const Color(0xFFEFFDFB),
            fg: const Color(0xFF0D9488),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFEFF2FF),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1D4ED8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    sourceBadge,
                    _pill(
                      text: lead.productsInterestedIn?.isNotEmpty == true
                          ? lead.productsInterestedIn!
                          : '—',
                      bg: const Color(0xFFF3F4F6),
                      fg: _ink2,
                    ),
                    _pill(
                      text: lead.heat == LeadHeat.hot
                          ? 'Hot lead'
                          : lead.heat == LeadHeat.warm
                          ? 'Warm lead'
                          : 'Cold lead',
                      bg: heatColors.$1,
                      fg: heatColors.$2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lead.estimatedValue == null
                    ? '—'
                    : 'RWF ${formatNumber(lead.estimatedValue!.toDouble())}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                lead.status.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _ink3,
                  letterSpacing: 0.08 * 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required String icon,
    required String text,
    required Color bg,
    required Color fg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg.withValues(alpha: 0.8)),
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
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({required String text, required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  void _openAddLead(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddLeadSheet(),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filter leads',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 8),
                ..._leadFilterOptions.map((filter) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _filter == filter
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _filter == filter ? _blue : _ink3,
                    ),
                    title: Text(
                      filter,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: _ink2,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(filter),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;
    setState(() => _filter = selected);
  }

  void _showEmailLeadsComingSoon(BuildContext context) {
    showInfoNotification(context, 'Email lead review is coming soon.');
  }
}
