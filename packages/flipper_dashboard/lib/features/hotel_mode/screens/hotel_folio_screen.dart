import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/services/hotel_folio_document_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_advance_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// The guest folio: every charge posted against a stay, and checkout.
///
/// Desktop and mobile share one body — the layouts differ only in density, so
/// splitting them into two files would duplicate the settle logic, which is
/// the one thing that must not drift between them.
class HotelFolioScreen extends ConsumerWidget {
  const HotelFolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stay = ref.watch(
      hotelModeProvider.select((state) => state.activeStay),
    );
    if (stay == null) {
      // Defensive: the notifier refuses this transition, but a rebuild
      // racing a checkout could still land here.
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = HotelLayoutBreakpoints.isHotelMobileLayout(
          constraints.maxWidth,
        );
        return _HotelFolioBody(stay: stay, compact: compact);
      },
    );
  }
}

class _HotelFolioBody extends ConsumerWidget {
  const _HotelFolioBody({required this.stay, required this.compact});

  final HotelStay stay;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linesAsync = ref.watch(hotelFolioLinesProvider(stay.transactionId));
    final pad = compact ? 16.0 : 30.0;
    final l10n = context.flipperL10n;

    return Container(
      color: HotelTokens.posBg,
      child: Column(
        children: [
          _bar(context, ref),
          Expanded(
            child: linesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (lines) => Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 12),
                      children: [
                        HotelFolioHeaderCard(
                          stay: stay,
                          compact: compact,
                          onChangeDeparture: () =>
                              _changeDeparture(context, ref),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              l10n.hotelCharges,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: HotelTokens.ink1,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.hotelItemsCount(hotelFolioItemCount(lines)),
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: HotelTokens.ink3,
                              ),
                            ),
                            const Spacer(),
                            if (!compact) ...[
                              _advanceButton(context, ref),
                              _roomChargeButton(context, ref),
                            ],
                          ],
                        ),
                        // A phone has no room for both beside the title.
                        if (compact)
                          Wrap(
                            alignment: WrapAlignment.end,
                            children: [
                              _advanceButton(context, ref),
                              _roomChargeButton(context, ref),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (lines.isEmpty)
                          _emptyCharges(l10n)
                        else
                          for (final line in lines) ...[
                            HotelFolioLineTile(
                              key: ValueKey('hotel-folio-line-${line.id}'),
                              line: line,
                              onIncrement: () => HotelDeskActions.changeQty(
                                ref: ref,
                                stay: stay,
                                line: line,
                                delta: 1,
                              ),
                              onDecrement: () => HotelDeskActions.changeQty(
                                ref: ref,
                                stay: stay,
                                line: line,
                                delta: -1,
                              ),
                              onDelete: () => HotelDeskActions.deleteLine(
                                ref: ref,
                                stay: stay,
                                line: line,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        const SizedBox(height: 14),
                        HotelFolioTotals(
                          lines: lines,
                          advance: stay.advanceHeld,
                        ),
                        if (!compact) ...[
                          const SizedBox(height: 18),
                          _actions(context, ref, lines),
                        ],
                      ],
                    ),
                  ),
                  // A phone keeps Check out under the thumb instead of below
                  // the fold, as the bar's settle screen does.
                  if (compact)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: const BoxDecoration(
                        color: HotelTokens.surface,
                        border: Border(
                          top: BorderSide(color: HotelTokens.line),
                        ),
                      ),
                      child: _actions(context, ref, lines),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    return Container(
      height: compact ? 62 : 76,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 24),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => ref.read(hotelModeProvider.notifier).backToRooms(),
            icon: const Icon(Icons.arrow_back, color: HotelTokens.ink2),
            tooltip: l10n.hotelBackToRooms,
          ),
          const SizedBox(width: 4),
          // Flexible + ellipsis: a long room or clerk name overflowed a phone.
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hotelRoomNamed(stay.roomName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: compact ? 17 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: HotelTokens.ink1,
                  ),
                ),
                Text(
                  l10n.hotelFolioOpenedBy(
                    stay.openedByName ?? l10n.hotelFrontDesk,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: HotelTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // The guest's bill, any time before checkout: what they ask for
          // before paying, and what a company paying for a stay wants.
          HotelFolioDocumentMenu(stay: stay),
        ],
      ),
    );
  }

  Widget _emptyCharges(FlipperAppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Text(
        // The reason belongs on screen, not only in a toast that has already
        // gone by the time anyone wonders why the folio is empty.
        HotelModeSettings.autoPostRoomCharge
            ? l10n.hotelNoChargesYet
            : l10n.hotelAutoRoomChargeOffHelp,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: HotelTokens.ink3,
        ),
      ),
    );
  }

  Widget _actions(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
  ) {
    final total = hotelFolioTotal(lines);
    final settling = ref.watch(
      hotelModeProvider.select((state) => state.checkOutInFlight),
    );
    final l10n = context.flipperL10n;
    return Row(
      children: [
        Expanded(
          child: TextButton(
            // Always live: with the room charge auto-posted at check-in, a
            // button gated on an empty folio was dead for nearly every stay
            // while still looking tappable. Charges are confirmed instead.
            onPressed: settling ? null : () => _cancelStay(context, ref, lines),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(
                HotelTokens.mobilePrimaryButtonHeight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                side: const BorderSide(
                  color: HotelTokens.dangerBorder,
                  width: 1.5,
                ),
              ),
            ),
            child: Text(
              l10n.hotelCancelStay,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: HotelTokens.lossInk,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Opacity(
            opacity: settling ? 0.6 : 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: HotelTokens.gradBtn,
                borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
              ),
              child: TextButton(
                onPressed: settling
                    ? null
                    : () => _checkOut(context, ref, total),
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    HotelTokens.mobilePrimaryButtonHeight,
                  ),
                ),
                child: Text(
                  settling
                      ? l10n.hotelSettling
                      : l10n.hotelCheckOutAmount(hotelMoney(total.round())),
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// "+ Room charge", with an honest in-flight state.
  ///
  /// The first charge against a room registers it with RRA — a network round
  /// trip of several seconds. Without visible feedback the button reads as
  /// broken, and the clerk taps it again, which bills a second night.
  Widget _roomChargeButton(BuildContext context, WidgetRef ref) {
    final inFlight = ref.watch(
      hotelModeProvider.select((state) => state.roomChargeInFlight),
    );

    return TextButton.icon(
      onPressed: inFlight ? null : () => _postRoomCharge(context, ref),
      icon: inFlight
          ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.add, size: 17),
      label: Text(
        inFlight
            ? context.flipperL10n.hotelPosting
            : context.flipperL10n.hotelRoomCharge,
        style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _advanceButton(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      key: const ValueKey('hotel-record-advance'),
      onPressed: () => _recordAdvance(context, ref),
      icon: const Icon(Icons.savings_outlined, size: 17),
      label: Text(
        context.flipperL10n.hotelAdvance,
        style: GoogleFonts.outfit(fontSize: 13.5, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _recordAdvance(BuildContext context, WidgetRef ref) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;
    final draft = await HotelAdvanceSheet.show(
      context,
      guestName: stay.guestName,
    );
    if (draft == null) return;
    await HotelDeskActions.recordAdvance(
      ref: ref,
      stay: stay,
      clerk: clerk,
      amount: draft.amount,
      paymentMethod: draft.paymentMethod,
    );
  }

  /// Extend (or shorten) the stay. The room-night line follows, so the guest
  /// still leaves with one invoice for every night.
  Future<void> _changeDeparture(BuildContext context, WidgetRef ref) async {
    final arrival = stay.checkInAt.toLocal();
    final current = stay.expectedCheckOutAt.toLocal();
    final first = DateTime(arrival.year, arrival.month, arrival.day + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: current.isBefore(first) ? first : current,
      firstDate: first,
      lastDate: first.add(const Duration(days: 365)),
      helpText: context.flipperL10n.hotelChangeDeparture,
    );
    if (picked == null) return;
    await HotelDeskActions.changeDeparture(
      ref: ref,
      stay: stay,
      checkOutAt: DateTime(
        picked.year,
        picked.month,
        picked.day,
        HotelModeSettings.checkOutHour,
      ),
    );
  }

  Future<void> _postRoomCharge(BuildContext context, WidgetRef ref) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;
    try {
      await HotelDeskActions.postRoomCharge(ref: ref, stay: stay, clerk: clerk);
    } catch (e) {
      ref.read(hotelModeProvider.notifier).showToast('$e');
    }
  }

  Future<void> _cancelStay(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
  ) async {
    if (stay.hasHeldAdvance) {
      final refund = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            dialogContext.flipperL10n.hotelCancelStayQuestion(stay.guestName),
            style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          ),
          content: Text(
            dialogContext.flipperL10n.hotelCancelRefundsAdvance(
              hotelMoney(stay.advanceHeld.round()),
            ),
            style: GoogleFonts.outfit(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.flipperL10n.hotelKeepStay),
            ),
            TextButton(
              key: const ValueKey('hotel-cancel-refund'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(dialogContext.flipperL10n.hotelRefundAndCancel),
            ),
          ],
        ),
      );
      if (refund != true) return;
    } else if (lines.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            dialogContext.flipperL10n.hotelCancelStayQuestion(stay.guestName),
            style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          ),
          content: Text(
            dialogContext.flipperL10n.hotelCancelStayChargesBody(
              hotelMoney(hotelFolioTotal(lines).round()),
            ),
            style: GoogleFonts.outfit(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.flipperL10n.hotelKeepStay),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(dialogContext.flipperL10n.hotelCancelStay),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    try {
      await HotelDeskActions.cancelStay(ref: ref, stay: stay);
    } catch (e) {
      ref.read(hotelModeProvider.notifier).showToast('$e');
    }
  }

  Future<void> _checkOut(
    BuildContext context,
    WidgetRef ref,
    double total,
  ) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    final clerk = ref.read(hotelModeProvider).activeClerk;

    if (HotelModeSettings.managerCheckout &&
        (clerk == null || !hotelTenantIsManager(clerk))) {
      // Hand the terminal to a manager rather than dead-ending the clerk.
      notifier.showManagerPin();
      return;
    }

    // The bound folio only if it is this stay's; otherwise ask the store again.
    // A stay older than the history window can be opened before its folio has
    // synced down, so a miss at open time is not a miss now.
    final bound = ref.read(hotelModeProvider).activeFolio;
    final ITransaction? folio = bound?.id == stay.transactionId
        ? bound
        : await HotelDeskActions.folio(stay);
    if (folio == null) {
      notifier.showToast(FlipperL10n.current.hotelFolioNotFound);
      return;
    }
    if (!identical(folio, bound)) notifier.bindFolio(folio);

    // A folio with no room nights settles as no sale at all: the room was
    // sold but never shows in the reports. Offer to post them first.
    var amountDue = total;
    final lines = await HotelDeskActions.folioLines(stay);
    if (!hotelFolioHasRoomCharge(stay, lines)) {
      if (!context.mounted) return;
      final choice = await HotelMissingRoomChargeDialog.show(
        context,
        stay: stay,
      );
      if (choice == null) return;
      if (choice == HotelMissingRoomChargeChoice.post) {
        if (clerk == null) return;
        await HotelDeskActions.postRoomCharge(
          ref: ref,
          stay: stay,
          clerk: clerk,
        );
        final posted = await HotelDeskActions.folioLines(stay);
        // Posting failed and the desk was already told why (toast).
        if (!hotelFolioHasRoomCharge(stay, posted)) return;
        amountDue = hotelFolioTotal(posted);
      }
    }

    if (!context.mounted) return;
    final result = await HotelCheckOutDialog.show(
      context,
      total: amountDue,
      advance: stay.advanceHeld,
      allowCredit: true,
    );
    if (result == null) return;

    if (result.paymentType == HotelCheckOutDialog.creditTender) {
      if (!context.mounted) return;
      await _checkOutOnCredit(context, ref, folio);
      return;
    }

    // Re-checked after the dialog: it is awaited, so another tap could have
    // started settling this same folio while it was open.
    if (ref.read(hotelModeProvider).checkOutInFlight) return;
    notifier.beginCheckOut();
    try {
      await HotelDeskActions.checkOut(
        ref: ref,
        stay: stay,
        folio: folio,
        paymentType: result.paymentType,
        cashReceived: result.cashReceived,
        customerChangeDue: result.changeDue,
      );
    } catch (e) {
      notifier.endCheckOut();
      notifier.showToast(FlipperL10n.current.hotelCheckoutFailed('$e'));
    }
  }

  /// The guest leaves owing the balance: who, and by when, then the folio
  /// becomes a loan collected from the Credit list.
  Future<void> _checkOutOnCredit(
    BuildContext context,
    WidgetRef ref,
    ITransaction folio,
  ) async {
    final notifier = ref.read(hotelModeProvider.notifier);
    final terms = await BarCredit.pickTerms(context, mobile: compact);
    if (terms == null) return;
    if (ref.read(hotelModeProvider).checkOutInFlight) return;
    notifier.beginCheckOut();
    try {
      await HotelDeskActions.checkOutOnCredit(
        ref: ref,
        stay: stay,
        folio: folio,
        terms: terms,
      );
    } catch (e) {
      notifier.endCheckOut();
      final message = e is StateError ? e.message : '$e';
      notifier.showToast(FlipperL10n.current.hotelCheckoutFailed(message));
    }
  }
}
