import 'dart:async';

import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/leads_provider.dart';
import 'package:flipper_models/repositories/ai_model_repository.dart';
import 'package:flipper_models/services/lead_ai_match_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/supabase_models.dart';
import 'package:uuid/uuid.dart';

class _CatalogPick {
  const _CatalogPick({
    required this.variantId,
    required this.name,
    this.sku,
    this.bcd,
    this.unitPrice,
  });

  final String variantId;
  final String name;
  final String? sku;
  final String? bcd;
  final double? unitPrice;

  factory _CatalogPick.fromVariant(Variant v) {
    return _CatalogPick(
      variantId: v.id,
      name: v.name,
      sku: v.sku,
      bcd: v.bcd,
      unitPrice: v.prc ?? v.retailPrice ?? v.dftPrc,
    );
  }
}

class AddLeadSheet extends ConsumerStatefulWidget {
  const AddLeadSheet({super.key});

  @override
  ConsumerState<AddLeadSheet> createState() => _AddLeadSheetState();
}

class _AddLeadSheetState extends ConsumerState<AddLeadSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _productsCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _source = LeadSource.walkIn;
  String _heat = LeadHeat.hot;
  bool _isSaving = false;
  final List<_CatalogPick> _catalogPicks = [];

  static const Color _ink = Color(0xFF0D0E12);
  static const Color _ink3 = Color(0xFF9499A5);
  static const Color _border = Color(0xFFEAECF0);
  static const Color _blue = Color(0xFF2563EB);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _productsCtrl.dispose();
    _valueCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sourceTabs(),
                const SizedBox(height: 14),
                _field(
                  label: 'FULL NAME *',
                  controller: _nameCtrl,
                  hint: 'Full name',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        label: 'PHONE NUMBER',
                        controller: _phoneCtrl,
                        hint: '+250 7xx xxx xxx',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        label: 'EMAIL ADDRESS',
                        controller: _emailCtrl,
                        hint: 'customer@email.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _productsInterestedSection(),
                const SizedBox(height: 12),
                _valueField(),
                const SizedBox(height: 12),
                _heatSelector(),
                const SizedBox(height: 12),
                _field(
                  label: 'NOTES (optional)',
                  controller: _notesCtrl,
                  hint: 'What did they ask for?',
                  maxLines: 4,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: const BorderSide(color: _border),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: (_saveEnabled && !_isSaving)
                            ? () => _save(context)
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: _blue,
                          disabledBackgroundColor: _blue.withValues(
                            alpha: 0.35,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Save lead',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _saveEnabled {
    final hasProducts =
        _catalogPicks.isNotEmpty || _productsCtrl.text.trim().isNotEmpty;
    return _nameCtrl.text.trim().isNotEmpty && hasProducts;
  }

  String _mergedProductsInterestedIn() {
    final chipNames = _catalogPicks.map((p) => p.name).join(', ');
    final typed = _productsCtrl.text.trim();
    if (chipNames.isEmpty) return typed;
    if (typed.isEmpty) return chipNames;
    return '$chipNames, $typed';
  }

  Map<String, dynamic>? _manualCatalogExtracted() {
    if (_catalogPicks.isEmpty) return null;
    final matchedAt = DateTime.now().toUtc().toIso8601String();
    return {
      'items': _catalogPicks.map((p) => p.name).toList(),
      'matches': _catalogPicks
          .map(
            (p) => <String, dynamic>{
              'query': p.name,
              'variantId': p.variantId,
              'variantName': p.name,
              'sku': p.sku,
              'bcd': p.bcd,
              'quantity': 1,
              'confidence': 1.0,
              if (p.unitPrice != null) 'unitPrice': p.unitPrice,
            },
          )
          .toList(),
      'source': 'manual_catalog',
      'model': 'manual',
      'matchedAt': matchedAt,
    };
  }

  Future<void> _openCatalogPicker() async {
    final branchId = ProxyService.box.getBranchId() ?? '';
    if (branchId.isEmpty || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _AddLeadCatalogPickerSheet(
          branchId: branchId,
          onPick: (pick) {
            setState(() {
              if (!_catalogPicks.any((e) => e.variantId == pick.variantId)) {
                _catalogPicks.add(pick);
              }
            });
          },
        ),
      ),
    );
  }

  Widget _productsInterestedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRODUCTS INTERESTED IN *',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink3,
            letterSpacing: 0.08 * 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_catalogPicks.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _catalogPicks.map((p) {
                    final sub = [
                      if (p.sku != null && p.sku!.trim().isNotEmpty)
                        'SKU ${p.sku}',
                    ].join(' · ');
                    return InputChip(
                      label: Text(
                        sub.isEmpty ? p.name : '${p.name} ($sub)',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      onDeleted: () {
                        setState(() {
                          _catalogPicks.removeWhere(
                            (e) => e.variantId == p.variantId,
                          );
                        });
                      },
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: _border),
                      deleteIconColor: _ink3,
                    );
                  }).toList(),
                ),
              if (_catalogPicks.isNotEmpty) const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _openCatalogPicker,
                  icon: Icon(Icons.inventory_2_outlined, color: _blue, size: 20),
                  label: Text(
                    'Browse catalogue',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      color: _blue,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _productsCtrl,
                maxLines: 1,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Or type product name, SKU, BCD…',
                  hintStyle: GoogleFonts.outfit(color: _ink3),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: SvgPicture.string(
                AdminDashboardSvgs.leadsUsersMultiple,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(_blue, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Lead',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                Text(
                  'Record a new customer or enquiry manually',
                  style: GoogleFonts.outfit(fontSize: 12, color: _ink3),
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

  Widget _sourceTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tab(
              selected: _source == LeadSource.walkIn,
              icon: AdminDashboardSvgs.leadsUserSingle,
              label: 'Walk-in customer',
              onTap: () => setState(() => _source = LeadSource.walkIn),
            ),
          ),
          Expanded(
            child: _tab(
              selected: _source == LeadSource.phoneReferral,
              icon: AdminDashboardSvgs.leadsPhoneCall,
              label: 'Phone / Referral',
              onTap: () => setState(() => _source = LeadSource.phoneReferral),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required bool selected,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: const Color(0xFFBFDBFE)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              icon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                selected ? _blue : _ink3,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected ? _blue : _ink3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESTIMATED VALUE',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink3,
            letterSpacing: 0.08 * 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'RWF',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w800,
                    color: _ink3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _valueCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: GoogleFonts.jetBrainsMono(color: _ink3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEAD HEAT',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink3,
            letterSpacing: 0.08 * 11,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _heatButton(
                label: 'Hot',
                emoji: '🔥',
                selected: _heat == LeadHeat.hot,
                selectedBg: const Color(0xFFFFE4E6),
                selectedBorder: const Color(0xFFE11D48),
                selectedFg: const Color(0xFF9F1239),
                checkColor: const Color(0xFFE11D48),
                onTap: () => setState(() => _heat = LeadHeat.hot),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _heatButton(
                label: 'Warm',
                emoji: '☀️',
                selected: _heat == LeadHeat.warm,
                selectedBg: const Color(0xFFFFFBEB),
                selectedBorder: const Color(0xFFD97706),
                selectedFg: const Color(0xFFB45309),
                checkColor: const Color(0xFFD97706),
                onTap: () => setState(() => _heat = LeadHeat.warm),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _heatButton(
                label: 'Cold',
                emoji: '🧊',
                selected: _heat == LeadHeat.cold,
                selectedBg: const Color(0xFFEFF6FF),
                selectedBorder: const Color(0xFF2563EB),
                selectedFg: const Color(0xFF1E3A8A),
                checkColor: const Color(0xFF2563EB),
                onTap: () => setState(() => _heat = LeadHeat.cold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heatButton({
    required String label,
    required String emoji,
    required bool selected,
    required Color selectedBg,
    required Color selectedBorder,
    required Color selectedFg,
    required Color checkColor,
    required VoidCallback onTap,
  }) {
    final bg = selected ? selectedBg : const Color(0xFFF6F7FB);
    final border = selected ? selectedBorder : _border;
    final fg = selected ? selectedFg : _ink3;
    final width = selected ? 2.0 : 1.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: width),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectedBorder.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check_rounded, size: 18, color: checkColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  '$emoji $label',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    color: fg,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _ink3,
            letterSpacing: 0.08 * 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(color: _ink3),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context) async {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final businessId = ProxyService.box.getBusinessId();
    if (branchId.isEmpty) return;
    if (_isSaving) return;

    final container = ProviderScope.containerOf(context);

    final now = DateTime.now().toUtc();
    final id = const Uuid().v4();
    final value = num.tryParse(_valueCtrl.text.trim().replaceAll(',', ''));
    final mergedProducts = _mergedProductsInterestedIn();
    final manualExtracted = _manualCatalogExtracted();
    final num? aiConf = manualExtracted != null ? 1.0 : null;

    final lead = Lead(
      id: id,
      branchId: branchId,
      businessId: businessId,
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      fullName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim().isEmpty
          ? null
          : _phoneCtrl.text.trim(),
      emailAddress: _emailCtrl.text.trim().isEmpty
          ? null
          : _emailCtrl.text.trim(),
      source: _source,
      status: LeadStatus.newLead,
      heat: _heat,
      productsInterestedIn: mergedProducts,
      estimatedValue: value,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      externalThreadId: null,
      aiConfidence: aiConf,
      aiExtracted: manualExtracted,
    );

    final upsert = ref.read(leadsUpsertProvider);
    setState(() => _isSaving = true);
    try {
      await upsert(lead);
      if (!mounted) return;
      Navigator.of(context).pop();
      unawaited(_enrichLeadAfterSave(container, lead));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      showErrorNotification(context, 'Failed to save lead. $e');
    }
  }
}

Future<void> _enrichLeadAfterSave(ProviderContainer container, Lead lead) async {
  try {
    final businessId = lead.businessId;
    if (businessId == null || businessId.isEmpty) {
      talker.info('Lead AI enrichment skipped: no businessId');
      return;
    }

    final repo = AIModelRepository();
    if (!await repo.isLeadsAiMatchEnabledForBusiness(businessId)) {
      talker.info('Lead AI enrichment disabled for business $businessId');
      return;
    }

    if (lead.aiExtracted?['source'] == 'manual_catalog') {
      talker.info(
        'Lead AI enrichment skipped: manual catalogue picks (${lead.id})',
      );
      return;
    }

    final enriched = await enrichLeadWithCatalogAi(
      container: container,
      lead: lead,
    );
    final upsert = container.read(leadsUpsertProvider);
    await upsert(enriched);
    talker.info('Lead AI enrichment saved for lead ${lead.id}');
  } catch (e, st) {
    talker.error('Lead AI enrichment failed: $e');
    talker.error(st);
  }
}

class _AddLeadCatalogPickerSheet extends StatefulWidget {
  const _AddLeadCatalogPickerSheet({
    required this.branchId,
    required this.onPick,
  });

  final String branchId;
  final void Function(_CatalogPick) onPick;

  @override
  State<_AddLeadCatalogPickerSheet> createState() =>
      _AddLeadCatalogPickerSheetState();
}

class _AddLeadCatalogPickerSheetState extends State<_AddLeadCatalogPickerSheet> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<Variant> _results = [];
  bool _loading = true;

  static const Color _ink = Color(0xFF0D0E12);
  static const Color _ink3 = Color(0xFF9499A5);
  static const Color _border = Color(0xFFEAECF0);

  @override
  void initState() {
    super.initState();
    unawaited(_fetch(''));
    _searchCtrl.addListener(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        unawaited(_fetch(_searchCtrl.text));
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetch(String q) async {
    setState(() => _loading = true);
    try {
      final vatEnabled = await getVatEnabledFromEbm();
      final taxTyCds = vatEnabled ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'];
      final paged = await ProxyService.getStrategy(Strategy.capella).variants(
        branchId: widget.branchId,
        name: q.trim().toLowerCase(),
        page: 0,
        itemsPerPage: 40,
        taxTyCds: taxTyCds,
        scanMode: false,
        fetchRemote: q.trim().isNotEmpty,
      );
      if (!mounted) return;
      setState(() {
        _results = List<Variant>.from(paged.variants as Iterable);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.72;
    return SafeArea(
      child: SizedBox(
        height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pick from catalogue',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _ink,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: _ink3),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search name, SKU, BCD…',
                  hintStyle: GoogleFonts.outfit(color: _ink3),
                  prefixIcon: const Icon(Icons.search_rounded, color: _ink3),
                  filled: true,
                  fillColor: const Color(0xFFF6F7FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? Center(
                      child: Text(
                        'No items found',
                        style: GoogleFonts.outfit(
                          color: _ink3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: _border.withValues(alpha: 0.8)),
                      itemBuilder: (context, i) {
                        final v = _results[i];
                        final sub = [
                          if (v.sku != null && v.sku!.trim().isNotEmpty)
                            'SKU ${v.sku}',
                          if (v.bcd != null && v.bcd!.trim().isNotEmpty)
                            'BCD ${v.bcd}',
                        ].join(' · ');
                        return ListTile(
                          onTap: () {
                            widget.onPick(_CatalogPick.fromVariant(v));
                            Navigator.of(context).pop();
                          },
                          title: Text(
                            v.name,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              color: _ink,
                            ),
                          ),
                          subtitle: sub.isEmpty
                              ? null
                              : Text(
                                  sub,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: _ink3,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
