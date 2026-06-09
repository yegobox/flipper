import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComposerLine {
  ComposerLine({this.ac = '', this.dr = '', this.cr = ''});

  String ac;
  String dr;
  String cr;
}

class JournalComposer extends StatefulWidget {
  const JournalComposer({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<JournalComposer> createState() => _JournalComposerState();
}

class _JournalComposerState extends State<JournalComposer> {
  final _memoCtrl = TextEditingController();
  final _refCtrl = TextEditingController(text: 'Auto · JE-1048');
  final _pickerLink = LayerLink();
  late final String _dateLabel;
  List<ComposerLine> _lines = [ComposerLine(), ComposerLine()];
  int? _pickerIndex;
  bool _posted = false;

  static const _templates = [
    (name: 'Record a sale', icon: Icons.shopping_cart_outlined, memo: 'Record a sale', codes: ['1010', '4010', '2100']),
    (name: 'Pay an expense', icon: Icons.account_balance_wallet_outlined, memo: 'Pay an expense', codes: ['6010', '1020']),
    (name: 'Receive payment', icon: Icons.arrow_downward, memo: 'Receive payment', codes: ['1020', '1100']),
    (name: 'Pay a bill', icon: Icons.receipt_long_outlined, memo: 'Pay a bill', codes: ['2010', '1020']),
  ];

  @override
  void initState() {
    super.initState();
    _dateLabel = DateFormat('d MMM y').format(DateTime.now());
  }

  @override
  void dispose() {
    _memoCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  int get _totDr => _lines.fold<int>(0, (s, l) => s + _parseInput(l.dr));
  int get _totCr => _lines.fold<int>(0, (s, l) => s + _parseInput(l.cr));
  int get _diff => _totDr - _totCr;
  bool get _balanced => _diff == 0 && _totDr > 0;
  bool get _canPost => _balanced && _lines.any((l) => l.ac.isNotEmpty);

  void _applyTemplate(({String name, IconData icon, String memo, List<String> codes}) t) {
    setState(() {
      _memoCtrl.text = t.memo;
      _lines = t.codes.map((c) => ComposerLine(ac: c)).toList();
      if (_lines.length < 2) _lines.add(ComposerLine());
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: Container(color: const Color(0x8C081216)),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 0,
            shadowColor: const Color(0x80080C16),
            child: AnimatedContainer(
              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 320),
              curve: const Cubic(0.22, 0.9, 0.3, 1),
              width: AccountingTokens.composerWidth.clamp(320, MediaQuery.sizeOf(context).width),
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AccountingTokens.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80080C16),
                    blurRadius: 60,
                    offset: Offset(-24, 0),
                    spreadRadius: -20,
                  ),
                ],
              ),
              child: _posted ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AccountingTokens.gain,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AccountingTokens.gain.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Entry posted & balanced',
              style: AccountingTokens.sans(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -0.02 * 23),
            ),
            const SizedBox(height: 8),
            Text(
              'Debits equal credits. The ledger, trial balance and statements have all been updated.',
              style: AccountingTokens.sans(fontSize: 14, color: AccountingTokens.ink3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AccountingButton(label: 'Done', primary: true, onPressed: widget.onClose),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _ComposerHeader(onClose: widget.onClose),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick start', style: _fieldLabel),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in _templates)
                          AccountingButton(
                            label: t.name,
                            icon: t.icon,
                            small: true,
                            onPressed: () => _applyTemplate(t),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Date',
                            child: _ComposerInput(
                              icon: Icons.calendar_today_outlined,
                              readOnly: true,
                              value: _dateLabel,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _LabeledField(
                            label: 'Reference',
                            child: _ComposerInput(
                              icon: Icons.tag,
                              controller: _refCtrl,
                              hint: 'Auto · JE-1048',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Memo / description',
                      child: _ComposerInput(
                        icon: Icons.receipt_long_outlined,
                        controller: _memoCtrl,
                        hint: 'What is this entry for?',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Lines', style: _fieldLabel.copyWith(fontSize: 12.5)),
                    const SizedBox(height: 10),
                    const _LinesHeader(),
                    for (var i = 0; i < _lines.length; i++)
                      _LineEditor(
                        key: ValueKey('line-$i-${_lines[i].ac}'),
                        line: _lines[i],
                        pickerLink: _pickerIndex == i ? _pickerLink : null,
                        onPick: () => setState(() => _pickerIndex = i),
                        onDr: (v) => setState(() {
                          _lines[i].dr = v;
                          _lines[i].cr = '';
                        }),
                        onCr: (v) => setState(() {
                          _lines[i].cr = v;
                          _lines[i].dr = '';
                        }),
                        onDelete: _lines.length > 2
                            ? () => setState(() {
                                if (_pickerIndex == i) _pickerIndex = null;
                                _lines.removeAt(i);
                              })
                            : null,
                      ),
                    _AddLineButton(onTap: () => setState(() => _lines.add(ComposerLine()))),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(Icons.info_outline, size: 15, color: AccountingTokens.accent),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink3, height: 1.4),
                              children: [
                                const TextSpan(text: 'Every entry has two sides. Money '),
                                TextSpan(
                                  text: 'into',
                                  style: AccountingTokens.sans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AccountingTokens.drInk,
                                  ),
                                ),
                                const TextSpan(text: ' an account is a debit; money '),
                                TextSpan(
                                  text: 'out',
                                  style: AccountingTokens.sans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AccountingTokens.crInk,
                                  ),
                                ),
                                const TextSpan(text: ' is a credit. They must add up to the same total.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_pickerIndex != null) ...[
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => _pickerIndex = null),
                    behavior: HitTestBehavior.opaque,
                    child: const ColoredBox(color: Color(0x080B1220)),
                  ),
                ),
                CompositedTransformFollower(
                  link: _pickerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 54),
                  child: _AccountPickerPopover(
                    onPick: (code) => setState(() {
                      _lines[_pickerIndex!].ac = code;
                      _pickerIndex = null;
                    }),
                    onClose: () => setState(() => _pickerIndex = null),
                  ),
                ),
              ],
            ],
          ),
        ),
        _ComposerFooter(
          balanced: _balanced,
          diff: _diff,
          totDr: _totDr,
          totCr: _totCr,
          canPost: _canPost,
          onSaveDraft: widget.onClose,
          onPost: () => setState(() => _posted = true),
        ),
      ],
    );
  }

  static int _parseInput(String s) => int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
}

final _fieldLabel = AccountingTokens.sans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AccountingTokens.ink2);

class _ComposerHeader extends StatelessWidget {
  const _ComposerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AccountingTokens.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New journal entry',
                  style: AccountingTokens.sans(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.02 * 19),
                ),
                const SizedBox(height: 3),
                Text(
                  'Pick the accounts and enter amounts — Flipper keeps it balanced.',
                  style: AccountingTokens.sans(fontSize: 13, color: AccountingTokens.ink3),
                ),
              ],
            ),
          ),
          Material(
            color: AccountingTokens.surface2,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(Icons.close, size: 18, color: AccountingTokens.ink2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabel),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}

class _ComposerInput extends StatelessWidget {
  const _ComposerInput({
    this.icon,
    this.controller,
    this.hint,
    this.value,
    this.readOnly = false,
  });

  final IconData? icon;
  final TextEditingController? controller;
  final String? hint;
  final String? value;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AccountingTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17, color: AccountingTokens.ink3),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: readOnly
                ? Text(
                    value ?? '',
                    style: AccountingTokens.sans(fontSize: 14.5, color: AccountingTokens.ink1),
                  )
                : TextField(
                    controller: controller,
                    readOnly: readOnly,
                    style: AccountingTokens.sans(fontSize: 14.5, color: AccountingTokens.ink1),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: AccountingTokens.sans(fontSize: 14.5, color: AccountingTokens.ink4),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LinesHeader extends StatelessWidget {
  const _LinesHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: Row(
        children: [
          Expanded(child: Text('ACCOUNT', style: AccountingTokens.tableHead)),
          const SizedBox(width: 10),
          SizedBox(width: 150, child: Text('DEBIT', style: AccountingTokens.tableHead, textAlign: TextAlign.right)),
          const SizedBox(width: 10),
          SizedBox(width: 150, child: Text('CREDIT', style: AccountingTokens.tableHead, textAlign: TextAlign.right)),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({
    super.key,
    required this.line,
    required this.onPick,
    required this.onDr,
    required this.onCr,
    this.pickerLink,
    this.onDelete,
  });

  final ComposerLine line;
  final VoidCallback onPick;
  final ValueChanged<String> onDr;
  final ValueChanged<String> onCr;
  final LayerLink? pickerLink;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final filled = line.ac.isNotEmpty;
    final account = filled ? demoAccountMap[line.ac] : null;

    Widget accountField = Material(
      color: filled ? AccountingTokens.accentTint : AccountingTokens.surface,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: filled ? AccountingTokens.accentTint2 : AccountingTokens.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (account != null) ...[
                Text(
                  account.code,
                  style: AccountingTokens.mono(fontSize: 12, fontWeight: FontWeight.w700, color: AccountingTokens.accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    account.name,
                    style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else
                Expanded(
                  child: Text(
                    'Select account…',
                    style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w500, color: AccountingTokens.ink4),
                  ),
                ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: AccountingTokens.ink4),
            ],
          ),
        ),
      ),
    );

    if (pickerLink != null) {
      accountField = CompositedTransformTarget(
        link: pickerLink!,
        child: accountField,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: accountField),
          const SizedBox(width: 10),
          SizedBox(
            width: 150,
            child: _AmountField(value: line.dr, isDebit: true, onChanged: onDr),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 150,
            child: _AmountField(value: line.cr, isDebit: false, onChanged: onCr),
          ),
          const SizedBox(width: 10),
          _LineDeleteButton(onPressed: onDelete),
        ],
      ),
    );
  }
}

class _AmountField extends StatefulWidget {
  const _AmountField({required this.value, required this.isDebit, required this.onChanged});

  final String value;
  final bool isDebit;
  final ValueChanged<String> onChanged;

  @override
  State<_AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<_AmountField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
    _focus = FocusNode();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant _AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _ctrl.text && !_focus.hasFocus) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    final focusColor = widget.isDebit ? AccountingTokens.drInk : AccountingTokens.crInk;
    final focusTint = widget.isDebit
        ? AccountingTokens.drInk.withValues(alpha: 0.12)
        : AccountingTokens.crInk.withValues(alpha: 0.12);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: focused ? focusColor : AccountingTokens.line,
          width: 1.5,
        ),
        boxShadow: focused
            ? [BoxShadow(color: focusTint, blurRadius: 0, spreadRadius: 3)]
            : null,
      ),
      child: TextField(
        controller: _ctrl,
        focusNode: _focus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: AccountingTokens.mono(fontSize: 16, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: '0',
          hintStyle: AccountingTokens.mono(fontSize: 16, fontWeight: FontWeight.w500, color: AccountingTokens.ink4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: (raw) {
          final formatted = _fmtInput(raw);
          _ctrl.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
          widget.onChanged(formatted);
        },
      ),
    );
  }

  static String _fmtInput(String s) {
    final digits = s.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';
    return NumberFormat('#,###', 'en_US').format(int.parse(digits));
  }
}

class _LineDeleteButton extends StatelessWidget {
  const _LineDeleteButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            Icons.delete_outline,
            size: 16,
            color: onPressed == null ? AccountingTokens.ink4.withValues(alpha: 0.4) : AccountingTokens.ink4,
          ),
        ),
      ),
    );
  }
}

class _AddLineButton extends StatelessWidget {
  const _AddLineButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.only(top: 6),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AccountingTokens.lineStrong, width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 15, color: AccountingTokens.ink2),
              const SizedBox(width: 7),
              Text('Add line', style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w600, color: AccountingTokens.ink2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComposerFooter extends StatelessWidget {
  const _ComposerFooter({
    required this.balanced,
    required this.diff,
    required this.totDr,
    required this.totCr,
    required this.canPost,
    required this.onSaveDraft,
    required this.onPost,
  });

  final bool balanced;
  final int diff;
  final int totDr;
  final int totCr;
  final bool canPost;
  final VoidCallback onSaveDraft;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final statusLabel = balanced
        ? 'Balanced'
        : totDr == 0
            ? 'Enter amounts'
            : 'Off by ${money(diff.abs())}';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: AccountingTokens.surface,
        border: Border(top: BorderSide(color: AccountingTokens.line)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: balanced ? AccountingTokens.gainTint : AccountingTokens.warnTint,
              borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
              border: Border.all(color: balanced ? const Color(0xFFBFE8CF) : const Color(0xFFF4D9AE)),
            ),
            child: Row(
              children: [
                _BalanceSide(label: 'Total debits', amount: money(totDr), color: AccountingTokens.drInk),
                const SizedBox(width: 16),
                Text('=', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w700, color: AccountingTokens.ink4)),
                const SizedBox(width: 16),
                _BalanceSide(label: 'Total credits', amount: money(totCr), color: AccountingTokens.crInk),
                const Spacer(),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: balanced ? AccountingTokens.gain : const Color(0xFFE89A2A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    balanced ? Icons.check : Icons.warning_amber_rounded,
                    size: balanced ? 15 : 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: AccountingTokens.sans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: balanced ? AccountingTokens.gainInk : AccountingTokens.warnAmber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: onSaveDraft,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AccountingTokens.ink1,
                      side: const BorderSide(color: AccountingTokens.lineStrong, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                    child: Text('Save draft', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: canPost ? onPost : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AccountingTokens.accent,
                      disabledBackgroundColor: AccountingTokens.accent.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Post entry', style: AccountingTokens.sans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceSide extends StatelessWidget {
  const _BalanceSide({required this.label, required this.amount, required this.color});

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AccountingTokens.sans(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.05 * 10.5, color: AccountingTokens.ink3),
        ),
        const SizedBox(height: 2),
        Text(amount, style: AccountingTokens.mono(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _AccountPickerPopover extends StatefulWidget {
  const _AccountPickerPopover({required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  State<_AccountPickerPopover> createState() => _AccountPickerPopoverState();
}

class _AccountPickerPopoverState extends State<_AccountPickerPopover> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _groups = [
    (AccountType.asset, 'Assets'),
    (AccountType.liability, 'Liabilities'),
    (AccountType.equity, 'Equity'),
    (AccountType.income, 'Income'),
    (AccountType.expense, 'Expenses'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matches(Account a) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return '${a.code} ${a.name}'.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AccountingTokens.surface,
      elevation: 12,
      shadowColor: const Color(0x400B1220),
      borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 360,
        height: 360,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: AccountingTokens.surface,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AccountingTokens.line, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 16, color: AccountingTokens.ink3),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        autofocus: true,
                        style: AccountingTokens.sans(fontSize: 14.5),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search accounts…',
                          hintStyle: AccountingTokens.sans(fontSize: 14.5, color: AccountingTokens.ink4),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AccountingTokens.line),
            Expanded(
              child: ColoredBox(
                color: AccountingTokens.surface,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  children: [
                    for (final (type, label) in _groups) ...[
                      Builder(
                        builder: (context) {
                          final rows = demoAccounts.where((a) => a.type == type && _matches(a)).toList();
                          if (rows.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  label.toUpperCase(),
                                  style: AccountingTokens.sans(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.06 * 10.5,
                                    color: AccountingTokens.ink4,
                                  ),
                                ),
                              ),
                              for (final a in rows)
                                Material(
                                  color: AccountingTokens.surface,
                                  child: InkWell(
                                    onTap: () => widget.onPick(a.code),
                                    borderRadius: BorderRadius.circular(9),
                                    hoverColor: AccountingTokens.accentTint,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 38,
                                            child: Text(
                                              a.code,
                                              style: AccountingTokens.mono(fontSize: 12, fontWeight: FontWeight.w700, color: AccountingTokens.accent),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              a.name,
                                              style: AccountingTokens.sans(fontSize: 13.5, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Text(money(a.bal), style: AccountingTokens.mono(fontSize: 12, color: AccountingTokens.ink3)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
