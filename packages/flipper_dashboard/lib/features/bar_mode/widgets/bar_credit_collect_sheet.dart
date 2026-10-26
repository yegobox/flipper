import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_split_tender.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Takes a payment on a loan: all of it, or part, by cash, MoMo or card.
class BarCreditCollectSheet extends ConsumerStatefulWidget {
  const BarCreditCollectSheet({super.key, required this.loan});

  final ITransaction loan;

  static Future<void> show(
    BuildContext context, {
    required ITransaction loan,
    required bool mobile,
  }) {
    final sheet = BarCreditCollectSheet(loan: loan);
    if (mobile) {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: sheet,
        ),
      );
    }
    return showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
          child: sheet,
        ),
      ),
    );
  }

  @override
  ConsumerState<BarCreditCollectSheet> createState() =>
      _BarCreditCollectSheetState();
}

class _BarCreditCollectSheetState extends ConsumerState<BarCreditCollectSheet> {
  late final TextEditingController _amount;
  String _method = kBarCash;
  bool _saving = false;

  double get _balance => barCreditBalance(widget.loan);

  double get _entered =>
      double.tryParse(_amount.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(
      text: NumberFormat('#,###').format(_balance.round()),
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _collect() async {
    if (_saving) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final after = await BarCredit.collect(
      context: context,
      ref: ref,
      loan: widget.loan,
      amount: _entered,
      method: _method,
    );
    if (!mounted) return;
    if (after == null) {
      setState(() => _saving = false);
      return;
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final loan = widget.loan;
    final name = barCreditDebtorName(loan);
    final balance = _balance;
    final entered = _entered;
    final tooHigh = entered > balance + 0.009;
    final canCollect = !_saving && entered > 0 && !tooHigh;
    final lines = ref.watch(barTabLinesProvider(loan.id)).value ?? const [];
    final due = loan.dueDate;

    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.barCreditCollectTitle(name),
                style: GoogleFonts.outfit(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: BarTokens.ink1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                [
                  l10n.barCreditPaidOf(
                    barCreditMoney(loan.cashReceived ?? 0),
                    barCreditMoney(loan.subTotal ?? 0),
                  ),
                  if (due != null)
                    barCreditIsOverdue(loan)
                        ? l10n.barCreditOverdue
                        : l10n.barCreditDue(barCreditDate(context, due)),
                ].join(' · '),
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: barCreditIsOverdue(loan)
                      ? BarTokens.lossInk
                      : BarTokens.ink3,
                ),
              ),
              if (lines.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: BarTokens.surface2,
                    borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                  ),
                  child: Column(
                    children: [
                      for (final line in lines)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${line.qty.toInt()} × ${line.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: BarTokens.ink2,
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat(
                                  '#,###',
                                ).format((line.price * line.qty).round()),
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12.5,
                                  color: BarTokens.ink2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                l10n.barCreditAmountLabel.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.55,
                  color: BarTokens.ink3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: tooHigh ? BarTokens.lossInk : BarTokens.blue,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('bar_credit_amount'),
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: BarTokens.ink1,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Text(
                      'RWF',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BarTokens.ink4,
                      ),
                    ),
                  ],
                ),
              ),
              if (tooHigh) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.barCreditAmountTooHigh(name, barCreditMoney(balance)),
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: BarTokens.lossInk,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  _methodChip(l10n.cash, kBarCash),
                  const SizedBox(width: 8),
                  _methodChip(l10n.barMobileMoney, kMobileMoney),
                  const SizedBox(width: 8),
                  _methodChip(l10n.barCard, kBarCard),
                ],
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const ValueKey('bar_credit_collect'),
                  onTap: canCollect ? _collect : null,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: canCollect || _saving
                          ? BarTokens.gradBtn
                          : null,
                      color: canCollect || _saving ? null : BarTokens.surface2,
                    ),
                    child: Center(
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.barCreditCollectButton(
                                barCreditMoney(entered),
                              ),
                              style: GoogleFonts.outfit(
                                color: canCollect
                                    ? Colors.white
                                    : BarTokens.ink4,
                                fontWeight: FontWeight.w800,
                                fontSize: 15.5,
                              ),
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

  Widget _methodChip(String label, String method) {
    final selected = _method == method;
    return Expanded(
      child: Material(
        color: selected ? BarTokens.blueTint : BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: InkWell(
          onTap: () => setState(() => _method = method),
          borderRadius: BorderRadius.circular(BarTokens.radiusMd),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BarTokens.radiusMd),
              border: Border.all(
                color: selected ? BarTokens.blue : BarTokens.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: selected ? BarTokens.blue : BarTokens.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
