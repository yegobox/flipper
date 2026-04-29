import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/providers/leads_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

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
                _field(label: 'FULL NAME *', controller: _nameCtrl, hint: 'Full name'),
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
                _field(
                  label: 'PRODUCTS INTERESTED IN *',
                  controller: _productsCtrl,
                  hint: 'Type product name or BCD…',
                ),
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
                          disabledBackgroundColor:
                              _blue.withValues(alpha: 0.35),
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
    return _nameCtrl.text.trim().isNotEmpty &&
        _productsCtrl.text.trim().isNotEmpty;
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
                colorFilter:
                    const ColorFilter.mode(_blue, BlendMode.srcIn),
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
                onTap: () => setState(() => _heat = LeadHeat.hot),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _heatButton(
                label: 'Warm',
                emoji: '☀️',
                selected: _heat == LeadHeat.warm,
                onTap: () => setState(() => _heat = LeadHeat.warm),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _heatButton(
                label: 'Cold',
                emoji: '🧊',
                selected: _heat == LeadHeat.cold,
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
    required VoidCallback onTap,
  }) {
    final bg = selected ? const Color(0xFFFFEEF1) : const Color(0xFFF6F7FB);
    final border = selected ? const Color(0xFFF3D2D7) : _border;
    final fg = selected ? const Color(0xFFB42318) : _ink3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            '$emoji $label',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              color: fg,
            ),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

    final now = DateTime.now().toUtc();
    final id = const Uuid().v4();
    final value = num.tryParse(_valueCtrl.text.trim().replaceAll(',', ''));

    final lead = Lead(
      id: id,
      branchId: branchId,
      businessId: businessId,
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      fullName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      emailAddress: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      source: _source,
      status: LeadStatus.newLead,
      heat: _heat,
      productsInterestedIn: _productsCtrl.text.trim(),
      estimatedValue: value,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      externalThreadId: null,
      aiConfidence: null,
      aiExtracted: null,
    );

    final upsert = ref.read(leadsUpsertProvider);
    setState(() => _isSaving = true);
    try {
      await upsert(lead);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save lead. $e',
            style: GoogleFonts.outfit(),
          ),
        ),
      );
    }
  }
}

