import 'package:flipper_web/modules/accounting/data/accounting_demo_data.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';

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
  String _memo = '';
  List<ComposerLine> _lines = [ComposerLine(), ComposerLine()];
  int? _pickerIndex;
  bool _posted = false;

  static const _templates = [
    (name: 'Record a sale', memo: 'Record a sale', codes: ['1010', '4010', '2100']),
    (name: 'Pay an expense', memo: 'Pay an expense', codes: ['6010', '1020']),
    (name: 'Receive payment', memo: 'Receive payment', codes: ['1020', '1100']),
    (name: 'Pay a bill', memo: 'Pay a bill', codes: ['2010', '1020']),
  ];

  int get _totDr => _lines.fold<int>(0, (s, l) => s + _parseInput(l.dr));
  int get _totCr => _lines.fold<int>(0, (s, l) => s + _parseInput(l.cr));
  int get _diff => _totDr - _totCr;
  bool get _balanced => _diff == 0 && _totDr > 0;
  bool get _canPost => _balanced && _lines.any((l) => l.ac.isNotEmpty);

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
            elevation: 16,
            child: AnimatedContainer(
              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 320),
              curve: const Cubic(0.22, 0.9, 0.3, 1),
              width: AccountingTokens.composerWidth.clamp(320, MediaQuery.sizeOf(context).width),
              height: double.infinity,
              color: AccountingTokens.surface,
              child: _posted ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
        if (_pickerIndex != null) _AccountPickerOverlay(
          onPick: (code) {
            setState(() {
              _lines[_pickerIndex!].ac = code;
              _pickerIndex = null;
            });
          },
          onClose: () => setState(() => _pickerIndex = null),
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
                boxShadow: [BoxShadow(color: AccountingTokens.gain.withValues(alpha: 0.5), blurRadius: 40, offset: const Offset(0, 18))],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text('Entry posted & balanced', style: AccountingTokens.sans(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('The ledger, trial balance and statements have all been updated.', style: AccountingTokens.sans(fontSize: 14, color: AccountingTokens.ink3), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            AccountingButton(label: 'Close', onPressed: widget.onClose),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
          child: Row(
            children: [
              Expanded(child: Text('New journal entry', style: AccountingTokens.sans(fontSize: 20, fontWeight: FontWeight.w800))),
              IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pick the accounts and enter amounts…', style: AccountingTokens.sans(fontSize: 13.5, color: AccountingTokens.ink3)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in _templates)
                      ActionChip(
                        label: Text(t.name),
                        onPressed: () => setState(() {
                          _memo = t.memo;
                          _lines = t.codes.map((c) => ComposerLine(ac: c)).toList();
                          if (_lines.length < 2) _lines.add(ComposerLine());
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _memo,
                  decoration: const InputDecoration(labelText: 'Memo'),
                  onChanged: (v) => _memo = v,
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < _lines.length; i++) _LineEditor(
                  line: _lines[i],
                  onPick: () => setState(() => _pickerIndex = i),
                  onDr: (v) => setState(() { _lines[i].dr = v; _lines[i].cr = ''; }),
                  onCr: (v) => setState(() { _lines[i].cr = v; _lines[i].dr = ''; }),
                  onDelete: _lines.length > 2 ? () => setState(() => _lines.removeAt(i)) : null,
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _lines.add(ComposerLine())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add line'),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AccountingTokens.line))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL DEBITS = TOTAL CREDITS', style: AccountingTokens.sans(fontSize: 11, fontWeight: FontWeight.w700, color: AccountingTokens.ink3)),
                  _BalanceMeter(balanced: _balanced, diff: _diff, totDr: _totDr),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AccountingButton(label: 'Save draft', onPressed: widget.onClose)),
                  const SizedBox(width: 10),
                  Expanded(child: AccountingButton(label: 'Post entry', icon: Icons.check, primary: true, enabled: _canPost, onPressed: () => setState(() => _posted = true))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static int _parseInput(String s) => int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({required this.line, required this.onPick, required this.onDr, required this.onCr, this.onDelete});

  final ComposerLine line;
  final VoidCallback onPick;
  final ValueChanged<String> onDr;
  final ValueChanged<String> onCr;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: OutlinedButton(
              onPressed: onPick,
              child: Text(line.ac.isEmpty ? 'Select account' : '${line.ac} · ${acctName(line.ac)}', overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Debit'),
              keyboardType: TextInputType.number,
              onChanged: onDr,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Credit'),
              keyboardType: TextInputType.number,
              onChanged: onCr,
            ),
          ),
          if (onDelete != null)
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 20)),
        ],
      ),
    );
  }
}

class _BalanceMeter extends StatelessWidget {
  const _BalanceMeter({required this.balanced, required this.diff, required this.totDr});

  final bool balanced;
  final int diff;
  final int totDr;

  @override
  Widget build(BuildContext context) {
    final (label, color) = balanced
        ? ('Balanced', AccountingTokens.gainInk)
        : totDr == 0
            ? ('Enter amounts', AccountingTokens.warnAmber)
            : ('Off by ${money(diff.abs())}', AccountingTokens.warnAmber);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: balanced ? AccountingTokens.gainTint : AccountingTokens.warnTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: AccountingTokens.mono(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _AccountPickerOverlay extends StatelessWidget {
  const _AccountPickerOverlay({required this.onPick, required this.onClose});

  final ValueChanged<String> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: onClose, child: Container(color: Colors.black26)),
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 360,
              constraints: const BoxConstraints(maxHeight: 420),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final type in AccountType.values) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: Text(type.name, style: AccountingTokens.sans(fontSize: 11, fontWeight: FontWeight.w700, color: AccountingTokens.ink3)),
                    ),
                    for (final a in demoAccounts.where((x) => x.type == type))
                      ListTile(
                        dense: true,
                        title: Text('${a.code} · ${a.name}'),
                        trailing: Text(money(a.bal), style: AccountingTokens.mono(fontSize: 12)),
                        onTap: () => onPick(a.code),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
