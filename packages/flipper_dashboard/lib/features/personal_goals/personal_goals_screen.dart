import 'dart:async';

import 'package:flipper_dashboard/cashbook.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

String formatRwfCompact(double v) {
  if (v >= 1e9) return 'RWF ${(v / 1e9).toStringAsFixed(1)}B';
  if (v >= 1e6) {
    final x = v / 1e6;
    final s = x == x.roundToDouble() ? x.round().toString() : x.toStringAsFixed(1);
    return 'RWF ${s}M';
  }
  if (v >= 1e3) return 'RWF ${(v / 1e3).round()}K';
  return 'RWF ${v.round()}';
}

class PersonalGoalsScreen extends ConsumerStatefulWidget {
  const PersonalGoalsScreen({super.key});

  @override
  ConsumerState<PersonalGoalsScreen> createState() =>
      _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends ConsumerState<PersonalGoalsScreen> {
  static const _purple = Color(0xFF7C3AED);
  static const _pageBg = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Personal goals',
          barBackgroundColor: _pageBg,
          onPop: () => Navigator.of(context).maybePop(),
        ),
        body: const Center(child: Text('Select a branch to manage goals.')),
      );
    }

    final asyncGoals = ref.watch(personalGoalsStreamProvider(branchId));

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: CustomAppBar(
        title: 'Personal goals',
        barBackgroundColor: _pageBg,
        onPop: () => Navigator.of(context).maybePop(),
      ),
      body: asyncGoals.when(
        data: (goals) => _buildBody(context, branchId, goals),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load goals\n$e')),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    String branchId,
    List<PersonalGoal> goals,
  ) {
    final totalReserved = goals.fold<double>(0, (s, g) => s + g.savedAmount);
    final onTrack = goals.where((g) => g.progressRatio >= 0.5).length;
    final top =
        goals.cast<PersonalGoal?>().firstWhere(
              (g) => g?.isTopPriority == true,
              orElse: () => null,
            ) ??
        (goals.isNotEmpty ? goals.first : null);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(personalGoalsStreamProvider(branchId));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(
            'PERSONAL GOALS',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRwfCompact(totalReserved),
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total reserved across ${goals.length} goal${goals.length == 1 ? '' : 's'}',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          if (top != null) _TopPriorityCard(goal: top, branchId: branchId),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: formatRwfCompact(0),
                  titleColor: _purple,
                  subtitle: 'Saved this month',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  title: '$onTrack on track',
                  titleColor: Colors.black87,
                  subtitle: 'Goals progressing',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'All goals',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Flipper quietly grows each goal from your profits.',
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...goals.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GoalListCard(
                goal: g,
                branchId: branchId,
                onAddMoney: () => unawaited(_navigateCashInForGoal(context, g)),
                onEdit: () =>
                    unawaited(_openGoalEditor(context, branchId, g)),
              ),
            ),
          ),
          _DashedNewGoalCard(
            onTap: () => unawaited(_openGoalEditor(context, branchId, null)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateCashInForGoal(BuildContext context, PersonalGoal g) async {
    HapticFeedback.lightImpact();
    ref.read(personalGoalCashInIntentProvider.notifier).setIntent(
          PersonalGoalCashInIntent(goalId: g.id, goalName: g.name),
        );
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => const Cashbook(isBigScreen: false),
      ),
    );
  }

  Future<void> _openGoalEditor(
    BuildContext context,
    String branchId,
    PersonalGoal? existing,
  ) async {
    final result = await showDialog<_PersonalGoalEditorResult>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => _PersonalGoalEditorDialog(existing: existing),
    );

    if (result == null || !context.mounted) return;

    final isTopPriority = result.isTopPriority;

    final ds = ref.read(personalGoalsDataSourceProvider);
    final id = existing?.id ?? const Uuid().v4();
    final now = DateTime.now();
    if (isTopPriority) {
      final current = ref.read(personalGoalsStreamProvider(branchId)).value ??
          <PersonalGoal>[];
      for (final g in current) {
        if (g.id != id && g.isTopPriority) {
          await ds.upsertPersonalGoal(g.copyWith(isTopPriority: false));
        }
      }
    }

    final goal = PersonalGoal(
      id: id,
      branchId: branchId,
      name: result.name,
      savedAmount: result.savedAmount,
      targetAmount: result.targetAmount,
      isTopPriority: isTopPriority,
      autoAllocationPercent: result.autoAllocationPercent,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await ds.upsertPersonalGoal(goal);
    ref.invalidate(personalGoalsStreamProvider(branchId));
  }
}

class _TopPriorityCard extends ConsumerWidget {
  const _TopPriorityCard({
    required this.goal,
    required this.branchId,
  });

  final PersonalGoal goal;
  final String branchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoPct = goal.autoAllocationPercent;
    final ds = ref.watch(personalGoalsDataSourceProvider);

    return Material(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOP PRIORITY',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.8,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          value: goal.progressRatio,
                          strokeWidth: 5,
                          backgroundColor: Colors.white24,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                      Text(
                        '${goal.progressPercent}%',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _darkRowItem(
                    'Saved',
                    formatRwfCompact(goal.savedAmount),
                  ),
                ),
                Expanded(
                  child: _darkRowItem(
                    'Target',
                    formatRwfCompact(goal.targetAmount),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto allocation',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        autoPct != null
                            ? '$autoPct% of profit reserved'
                            : 'Optional — set in edit',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: autoPct != null && autoPct > 0,
                  onChanged: (v) async {
                    final PersonalGoal next;
                    if (v) {
                      next = goal.copyWith(autoAllocationPercent: autoPct ?? 15);
                    } else {
                      next = goal.copyWith(clearAutoAllocationPercent: true);
                    }
                    await ds.upsertPersonalGoal(next);
                    ref.invalidate(personalGoalsStreamProvider(branchId));
                  },
                  activeThumbColor: const Color(0xFF34D399),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _darkRowItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.titleColor,
    required this.subtitle,
  });

  final String title;
  final Color titleColor;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalListCard extends StatelessWidget {
  const _GoalListCard({
    required this.goal,
    required this.branchId,
    required this.onAddMoney,
    required this.onEdit,
  });

  final PersonalGoal goal;
  final String branchId;
  final VoidCallback onAddMoney;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final accent = goal.isTopPriority
        ? const Color(0xFF7C3AED)
        : const Color(0xFF0D9488);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${goal.progressPercent}%',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${formatRwfCompact(goal.savedAmount)} of ${formatRwfCompact(goal.targetAmount).replaceFirst('RWF ', '')}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: goal.progressRatio,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  color: accent,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Updated from profits',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: accent,
                  borderRadius: BorderRadius.circular(14),
                  elevation: 0,
                  child: InkWell(
                    onTap: onAddMoney,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 22,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add money',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '· Cash in',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
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
      ),
    );
  }
}

class _DashedNewGoalCard extends StatelessWidget {
  const _DashedNewGoalCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF7C3AED)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New goal',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Equipment, rent, training…',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalGoalEditorResult {
  const _PersonalGoalEditorResult({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    this.autoAllocationPercent,
    required this.isTopPriority,
  });

  final String name;
  final double targetAmount;
  final double savedAmount;
  final int? autoAllocationPercent;
  final bool isTopPriority;
}

/// Polished goal create / edit sheet-style dialog (Outfit + soft fields).
class _PersonalGoalEditorDialog extends StatefulWidget {
  const _PersonalGoalEditorDialog({this.existing});

  final PersonalGoal? existing;

  @override
  State<_PersonalGoalEditorDialog> createState() =>
      _PersonalGoalEditorDialogState();
}

class _PersonalGoalEditorDialogState extends State<_PersonalGoalEditorDialog> {
  static const _accent = Color(0xFF7C3AED);
  static const _fieldFill = Color(0xFFF3F4F6);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _targetCtrl;
  late final TextEditingController _savedCtrl;
  late final TextEditingController _pctCtrl;
  bool _topPriority = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _targetCtrl = TextEditingController(
      text: e != null && e.targetAmount > 0
          ? _formatAmount(e.targetAmount)
          : '',
    );
    _savedCtrl = TextEditingController(
      text: e != null ? _formatAmount(e.savedAmount) : '',
    );
    _pctCtrl = TextEditingController(
      text: e?.autoAllocationPercent?.toString() ?? '',
    );
    _topPriority = e?.isTopPriority ?? false;
  }

  String _formatAmount(double v) {
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    _savedCtrl.dispose();
    _pctCtrl.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
      hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.85,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final target = double.tryParse(_targetCtrl.text.replaceAll(',', '')) ?? 0;
    final savedRaw = _savedCtrl.text.trim();
    final saved = savedRaw.isEmpty
        ? 0.0
        : (double.tryParse(savedRaw.replaceAll(',', '')) ?? 0);
    final pctRaw = _pctCtrl.text.trim();
    int? pct;
    if (pctRaw.isNotEmpty) {
      pct = int.tryParse(pctRaw);
      if (pct != null) pct = pct.clamp(0, 100);
    }
    if (pct != null && pct <= 0) pct = null;

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      _PersonalGoalEditorResult(
        name: _nameCtrl.text.trim(),
        targetAmount: target,
        savedAmount: saved < 0 ? 0 : saved,
        autoAllocationPercent: pct,
        isTopPriority: _topPriority,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Material(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420, maxHeight: maxH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.flag_rounded,
                        color: _accent,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing ? 'Edit goal' : 'New goal',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isEditing
                                ? 'Update amounts and settings for this goal.'
                                : 'Set a name and target. You can add money anytime from cash in.',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              height: 1.35,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, color: Colors.grey.shade600),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionLabel('GOAL NAME'),
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _fieldDecoration(
                            'What are you saving for?',
                            hint: 'e.g. Emergency fund, equipment',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter a goal name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        _sectionLabel('AMOUNTS (RWF)'),
                        TextFormField(
                          controller: _targetCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[\d.,]'),
                            ),
                          ],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _fieldDecoration(
                            'Target amount',
                            hint: '0',
                          ),
                          validator: (v) {
                            final t =
                                double.tryParse(
                                  (v ?? '').replaceAll(',', ''),
                                ) ??
                                0;
                            if (t <= 0) return 'Enter a target greater than 0';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _savedCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[\d.,]'),
                            ),
                          ],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _fieldDecoration(
                            'Already saved',
                            hint: '0 — optional',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            final s =
                                double.tryParse(v.replaceAll(',', '')) ?? 0;
                            if (s < 0) return 'Cannot be negative';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        _sectionLabel('OPTIONAL'),
                        TextFormField(
                          controller: _pctCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: _fieldDecoration(
                            'Auto allocation %',
                            hint: 'Leave empty if not used',
                          ).copyWith(suffixText: '%'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            final p = int.tryParse(v.trim());
                            if (p == null || p < 0 || p > 100) {
                              return 'Use 0–100';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        Material(
                          color: _fieldFill,
                          borderRadius: BorderRadius.circular(14),
                          child: SwitchListTile.adaptive(
                            value: _topPriority,
                            onChanged: (v) => setState(() => _topPriority = v),
                            activeThumbColor: _accent,
                            title: Text(
                              'Top priority',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              'Shown first on your dashboard',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade800,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isEditing ? 'Save changes' : 'Create goal',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
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
}
