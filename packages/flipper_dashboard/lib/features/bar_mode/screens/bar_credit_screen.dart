import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_collect_sheet.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Unpaid bills — tabs put on credit here, and POS loans — collected without
/// leaving Bar Mode.
class BarCreditScreen extends ConsumerStatefulWidget {
  const BarCreditScreen({super.key});

  @override
  ConsumerState<BarCreditScreen> createState() => _BarCreditScreenState();
}

class _BarCreditScreenState extends ConsumerState<BarCreditScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _back() =>
      ref.read(barModeProvider.notifier).setScreen(BarScreen.tables);

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(barCreditTabsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = BarLayoutBreakpoints.isBarMobileLayout(
          constraints.maxWidth,
        );
        final all = loans.value ?? const <ITransaction>[];
        final shown = all
            .where((l) => barCreditMatchesSearch(l, _search.text))
            .toList();
        final body = loans.isLoading && all.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _list(context, shown, mobile: mobile);

        if (mobile) {
          return BarMobileShell(
            header: _header(context, all, mobile: true),
            body: body,
          );
        }
        return ColoredBox(
          color: BarTokens.posBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context, all, mobile: false),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    List<ITransaction> all, {
    required bool mobile,
  }) {
    final l10n = context.flipperL10n;
    final owed = all.fold<double>(0, (s, l) => s + barCreditBalance(l));
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.barCredit,
          style: GoogleFonts.outfit(
            fontSize: mobile ? 22 : 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: BarTokens.ink1,
          ),
        ),
        Text(
          l10n.barCreditSummary(all.length, barCreditMoney(owed)),
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            color: BarTokens.ink3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    final back = IconButton(
      tooltip: l10n.barBackToTables,
      onPressed: _back,
      icon: const Icon(Icons.arrow_back, color: BarTokens.ink1),
      style: IconButton.styleFrom(
        backgroundColor: BarTokens.surface,
        side: const BorderSide(color: BarTokens.line),
      ),
    );
    final search = TextField(
      controller: _search,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: l10n.barCreditSearchHint,
        prefixIcon: const Icon(Icons.search, size: 20),
        isDense: true,
        filled: true,
        fillColor: BarTokens.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BarTokens.radiusMd),
          borderSide: BorderSide.none,
        ),
      ),
    );

    if (mobile) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
        decoration: const BoxDecoration(
          color: BarTokens.surface,
          border: Border(bottom: BorderSide(color: BarTokens.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                back,
                const SizedBox(width: 10),
                Expanded(child: title),
              ],
            ),
            const SizedBox(height: 10),
            search,
          ],
        ),
      );
    }

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          back,
          const SizedBox(width: 14),
          title,
          const Spacer(),
          SizedBox(width: 320, child: search),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    List<ITransaction> loans, {
    required bool mobile,
  }) {
    if (loans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            context.flipperL10n.barCreditEmpty,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: BarTokens.ink3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: mobile
          ? const EdgeInsets.fromLTRB(16, 12, 16, 24)
          : const EdgeInsets.fromLTRB(30, 20, 30, 30),
      itemCount: loans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _BarCreditRow(
        loan: loans[i],
        onTap: () =>
            BarCreditCollectSheet.show(context, loan: loans[i], mobile: mobile),
      ),
    );
  }
}

class _BarCreditRow extends StatelessWidget {
  const _BarCreditRow({required this.loan, required this.onTap});

  final ITransaction loan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final name = barCreditDebtorName(loan);
    final overdue = barCreditIsOverdue(loan);
    final due = loan.dueDate;
    final fromBar = barCreditIsFromBar(loan);
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BarTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusLg),
            border: Border.all(
              color: overdue ? BarTokens.dangerBorder : BarTokens.line,
            ),
            boxShadow: BarTokens.shadow1,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: BarTokens.blueTint,
                child: Text(
                  initial,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    color: BarTokens.blue,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: BarTokens.ink1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _chip(
                          fromBar
                              ? l10n.barCreditFromBar
                              : l10n.barCreditFromPos,
                          ink: BarTokens.ink2,
                          fill: BarTokens.surface2,
                        ),
                        if (overdue) ...[
                          const SizedBox(width: 6),
                          _chip(
                            l10n.barCreditOverdue,
                            ink: BarTokens.lossInk,
                            fill: BarTokens.lossTint,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        if (due != null)
                          l10n.barCreditDue(barCreditDate(context, due)),
                        l10n.barCreditPaidOf(
                          barCreditMoney(loan.cashReceived ?? 0),
                          barCreditMoney(loan.subTotal ?? 0),
                        ),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: overdue ? BarTokens.lossInk : BarTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                barCreditMoney(barCreditBalance(loan)),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: BarTokens.blue,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: BarTokens.ink3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, {required Color ink, required Color fill}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
      ),
    );
  }
}
