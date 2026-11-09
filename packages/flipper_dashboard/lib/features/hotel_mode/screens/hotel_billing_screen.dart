import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_collect_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_folio_document_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Money after the guest has left: debts to collect (ideni) and the invoices
/// of recent stays to reprint.
///
/// Credit is every open loan in the branch — hotel, bar or POS — because a
/// debt is collected wherever the customer turns up, exactly as Bar Mode's
/// Credit list does. Collection reuses Bar's sheet.
class HotelBillingScreen extends ConsumerWidget {
  const HotelBillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bar's collect sheet reports through Bar's notifier, which has no toast
    // host inside Hotel Mode: hand its messages to the desk's own.
    ref.listen(barModeProvider.select((s) => s.toastMessage), (_, message) {
      if (message == null) return;
      ref.read(hotelModeProvider.notifier).showToast(message);
      ref.read(barModeProvider.notifier).clearToast();
    });

    final l10n = context.flipperL10n;
    final mobile =
        HotelLayoutScope.maybeMobileOf(context) ??
        HotelLayoutBreakpoints.isHotelMobileLayout(
          MediaQuery.sizeOf(context).width,
        );
    final loans = ref.watch(barCreditTabsProvider);
    final checkedOut = ref.watch(hotelCheckedOutStaysProvider);
    final pad = mobile ? 16.0 : 30.0;

    return ColoredBox(
      color: HotelTokens.posBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(pad, 14, pad, 14),
            decoration: const BoxDecoration(
              color: HotelTokens.surface,
              border: Border(bottom: BorderSide(color: HotelTokens.line)),
            ),
            child: mobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(l10n),
                      const SizedBox(height: 10),
                      const HotelDeskNav(compact: true),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _title(l10n)),
                      const HotelDeskNav(),
                    ],
                  ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(pad),
              children: [
                _sectionTitle(l10n.hotelCreditSection),
                const SizedBox(height: 8),
                ...loans.when(
                  loading: () => [const LinearProgressIndicator()],
                  error: (e, _) => [Text('$e')],
                  data: (all) => all.isEmpty
                      ? [_empty(l10n.hotelNoCredit)]
                      : [
                          for (final loan in all)
                            _LoanTile(loan: loan, mobile: mobile),
                        ],
                ),
                const SizedBox(height: 24),
                _sectionTitle(l10n.hotelCheckedOutSection),
                const SizedBox(height: 8),
                ...checkedOut.when(
                  loading: () => [const LinearProgressIndicator()],
                  error: (e, _) => [Text('$e')],
                  data: (stays) => stays.isEmpty
                      ? [_empty(l10n.hotelNoCheckouts)]
                      : [for (final stay in stays) _CheckedOutTile(stay: stay)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(FlipperAppLocalizations l10n) => Text(
    l10n.hotelNavBilling,
    style: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
      color: HotelTokens.ink1,
    ),
  );

  Widget _sectionTitle(String text) => Text(
    text,
    style: GoogleFonts.outfit(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: HotelTokens.ink1,
    ),
  );

  Widget _empty(String text) => Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
      border: Border.all(color: HotelTokens.line),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: HotelTokens.ink3,
      ),
    ),
  );
}

BoxDecoration _card() => BoxDecoration(
  color: HotelTokens.surface,
  borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
  border: Border.all(color: HotelTokens.line),
);

class _LoanTile extends StatelessWidget {
  const _LoanTile({required this.loan, required this.mobile});

  final ITransaction loan;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final overdue = barCreditIsOverdue(loan);
    final due = loan.dueDate;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barCreditDebtorName(loan),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
                Text(
                  [
                    if ((loan.note ?? '').isNotEmpty) loan.note!,
                    if (due != null)
                      l10n.hotelCreditDue(
                        DateFormat('d MMM').format(due.toLocal()),
                      ),
                  ].join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: overdue ? HotelTokens.lossInk : HotelTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            hotelMoney(barCreditBalance(loan).round()),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            key: ValueKey('hotel-collect-${loan.id}'),
            onPressed: () =>
                BarCreditCollectSheet.show(context, loan: loan, mobile: mobile),
            child: Text(l10n.hotelCollect),
          ),
        ],
      ),
    );
  }
}

class _CheckedOutTile extends ConsumerWidget {
  const _CheckedOutTile({required this.stay});

  final HotelStay stay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final day = DateFormat('d MMM');
    final left = stay.checkedOutAt ?? stay.expectedCheckOutAt;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      decoration: _card(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.hotelRoomNamed(stay.roomName)} · ${stay.guestName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
                Text(
                  '${day.format(stay.checkInAt.toLocal())} → '
                  '${day.format(left.toLocal())}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: HotelTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          // A checkout whose advances did not get applied (the write after the
          // sale failed) is healed from here.
          if (stay.hasHeldAdvance)
            TextButton(
              key: ValueKey('hotel-apply-advance-${stay.id}'),
              onPressed: () => _applyAdvance(ref),
              child: Text(l10n.hotelApplyAdvance),
            ),
          if (stay.hasFolio) HotelFolioDocumentMenu(stay: stay),
        ],
      ),
    );
  }

  Future<void> _applyAdvance(WidgetRef ref) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    try {
      final folio = await HotelDeskActions.folio(stay);
      if (folio == null) {
        notifier.showToast(FlipperL10n.current.hotelFolioNotFound);
        return;
      }
      await HotelDeskActions.settleHeldAdvances(
        stay: stay,
        total: (folio.subTotal ?? 0).toDouble(),
        // A loan's advances were written as payment rows in their own
        // methods; a paid folio's under the sale's tender.
        tender: HotelDeskActions.advanceTenderFor(folio),
      );
      ref.invalidate(hotelCheckedOutStaysProvider);
      notifier.showToast(
        FlipperL10n.current.hotelAdvanceAppliedToast(stay.guestName),
      );
    } catch (e) {
      notifier.showToast(FlipperL10n.current.hotelAdvanceFailed('$e'));
    }
  }
}
