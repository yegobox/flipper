import 'package:flutter/material.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show CLOSEBUTTON, CustomAppBar;
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
/// Desktop and mobile share one widget, so the settle logic, the one thing
/// that must not drift between them, is written once. The phone stacks
/// everything in one column. The desk puts the charges in a table beside a
/// summary panel that stays in view, rather than stretching phone cards
/// across a wide window.
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

    return Container(
      color: HotelTokens.posBg,
      child: Column(
        children: [
          _appBar(context, ref),
          Expanded(
            child: linesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (lines) => compact
                  ? _phoneBody(context, ref, lines)
                  : _deskBody(context, ref, lines),
            ),
          ),
        ],
      ),
    );
  }

  /// The shared navigation bar: back to rooms, the room and who opened the
  /// folio, and the guest's bill.
  Widget _appBar(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    return CustomAppBar(
      key: const ValueKey('hotel-folio-app-bar'),
      title: l10n.hotelRoomNamed(stay.roomName),
      subtitle: l10n.hotelFolioOpenedBy(
        stay.openedByName ?? l10n.hotelFrontDesk,
      ),
      closeButton: CLOSEBUTTON.ICON,
      icon: Icons.arrow_back,
      onPop: () => ref.read(hotelModeProvider.notifier).backToRooms(),
      barBackgroundColor: HotelTokens.surface,
      bottomSpacer: compact ? 64 : 72,
      // The guest's bill, any time before checkout: what they ask for
      // before paying, and what a company paying for a stay wants.
      customTrailingWidget: HotelFolioDocumentMenu(stay: stay),
    );
  }

  Widget _chargesTitle(
    FlipperAppLocalizations l10n,
    List<TransactionItem> lines,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
      ],
    );
  }

  HotelFolioLineTile _lineTile(
    WidgetRef ref,
    TransactionItem line, {
    bool flat = false,
  }) {
    return HotelFolioLineTile(
      key: ValueKey('hotel-folio-line-${line.id}'),
      line: line,
      flat: flat,
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
      onDelete: () =>
          HotelDeskActions.deleteLine(ref: ref, stay: stay, line: line),
    );
  }

  /// A phone: one scrolling column, with Check out pinned under the thumb.
  Widget _phoneBody(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
  ) {
    final l10n = context.flipperL10n;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              HotelFolioHeaderCard(
                stay: stay,
                compact: true,
                onChangeDeparture: () => _changeDeparture(context, ref),
              ),
              const SizedBox(height: 18),
              _chargesTitle(l10n, lines),
              // A phone has no room for both beside the title.
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
                  _lineTile(ref, line),
                  const SizedBox(height: 8),
                ],
              const SizedBox(height: 14),
              HotelFolioTotals(lines: lines, advance: stay.advanceHeld),
            ],
          ),
        ),
        // A phone keeps Check out under the thumb instead of below the fold,
        // as the bar's settle screen does.
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: HotelTokens.surface,
            border: Border(top: BorderSide(color: HotelTokens.line)),
          ),
          child: _actions(context, ref, lines),
        ),
      ],
    );
  }

  /// The desk: the guest and a charges table on the left, a summary panel
  /// with checkout on the right, capped in width so a wide monitor does not
  /// stretch a single row across the screen.
  Widget _deskBody(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
  ) {
    final l10n = context.flipperL10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _deskMaxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 28),
                  children: [
                    HotelFolioHeaderCard(
                      stay: stay,
                      onChangeDeparture: () => _changeDeparture(context, ref),
                    ),
                    const SizedBox(height: 20),
                    _deskChargesCard(context, ref, lines, l10n),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: _deskSummaryWidth,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: _deskSummary(context, ref, lines),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const double _deskMaxWidth = 1280;
  static const double _deskSummaryWidth = 360;
  static const double _deskButtonHeight = 48;

  Widget _deskChargesCard(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
    FlipperAppLocalizations l10n,
  ) {
    return Container(
      key: const ValueKey('hotel-folio-charges-card'),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
        boxShadow: HotelTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
            child: Row(
              children: [
                _chargesTitle(l10n, lines),
                const Spacer(),
                _advanceButton(context, ref),
                const SizedBox(width: 4),
                _roomChargeButton(context, ref),
              ],
            ),
          ),
          const Divider(height: 1, color: HotelTokens.line),
          if (lines.isEmpty)
            _deskEmptyCharges(l10n)
          else ...[
            const HotelFolioLineHeader(),
            for (final line in lines) ...[
              const Divider(height: 1, color: HotelTokens.line),
              _lineTile(ref, line, flat: true),
            ],
          ],
        ],
      ),
    );
  }

  Widget _deskEmptyCharges(FlipperAppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: HotelTokens.surface2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 22,
              color: HotelTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            // The reason belongs on screen, not only in a toast that has
            // already gone by the time anyone wonders why the folio is empty.
            HotelModeSettings.autoPostRoomCharge
                ? l10n.hotelNoChargesYet
                : l10n.hotelAutoRoomChargeOffHelp,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }

  /// Totals, then checkout, then the way out: the order the desk reads them.
  Widget _deskSummary(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines,
  ) {
    return Container(
      key: const ValueKey('hotel-folio-summary'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
        boxShadow: HotelTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HotelFolioTotals(
            lines: lines,
            advance: stay.advanceHeld,
            framed: false,
          ),
          const SizedBox(height: 20),
          _checkOutButton(context, ref, lines, height: _deskButtonHeight),
          const SizedBox(height: 10),
          _cancelStayButton(context, ref, lines, height: 44),
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
    return Row(
      children: [
        Expanded(
          child: _cancelStayButton(
            context,
            ref,
            lines,
            height: HotelTokens.mobilePrimaryButtonHeight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _checkOutButton(
            context,
            ref,
            lines,
            height: HotelTokens.mobilePrimaryButtonHeight,
          ),
        ),
      ],
    );
  }

  Widget _cancelStayButton(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines, {
    required double height,
  }) {
    final settling = ref.watch(
      hotelModeProvider.select((state) => state.checkOutInFlight),
    );
    return TextButton(
      // Always live: with the room charge auto-posted at check-in, a
      // button gated on an empty folio was dead for nearly every stay
      // while still looking tappable. Charges are confirmed instead.
      onPressed: settling ? null : () => _cancelStay(context, ref, lines),
      style: TextButton.styleFrom(
        minimumSize: Size.fromHeight(height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
          side: const BorderSide(color: HotelTokens.dangerBorder, width: 1.5),
        ),
      ),
      child: Text(
        context.flipperL10n.hotelCancelStay,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: HotelTokens.lossInk,
        ),
      ),
    );
  }

  Widget _checkOutButton(
    BuildContext context,
    WidgetRef ref,
    List<TransactionItem> lines, {
    required double height,
  }) {
    final total = hotelFolioTotal(lines);
    final settling = ref.watch(
      hotelModeProvider.select((state) => state.checkOutInFlight),
    );
    final l10n = context.flipperL10n;
    return Opacity(
      opacity: settling ? 0.6 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: HotelTokens.gradBtn,
          borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        ),
        child: TextButton(
          key: const ValueKey('hotel-folio-check-out'),
          onPressed: settling ? null : () => _checkOut(context, ref, total),
          style: TextButton.styleFrom(minimumSize: Size.fromHeight(height)),
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
      final message = e is StateError ? e.message : '$e';
      notifier.showToast(FlipperL10n.current.hotelCheckoutFailed(message));
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
