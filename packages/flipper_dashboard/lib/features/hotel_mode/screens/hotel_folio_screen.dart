import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
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

    return Container(
      color: HotelTokens.posBg,
      child: Column(
        children: [
          _bar(context, ref),
          Expanded(
            child: linesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (lines) => ListView(
                padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 12),
                children: [
                  HotelFolioHeaderCard(stay: stay, compact: compact),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'Charges',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: HotelTokens.ink1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${hotelFolioItemCount(lines)} item'
                        '${hotelFolioItemCount(lines) == 1 ? '' : 's'}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: HotelTokens.ink3,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _postRoomCharge(context, ref),
                        icon: const Icon(Icons.add, size: 17),
                        label: Text(
                          'Room charge',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (lines.isEmpty)
                    _emptyCharges()
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
                  HotelFolioTotals(lines: lines),
                  const SizedBox(height: 18),
                  _actions(context, ref, lines),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, WidgetRef ref) {
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
            tooltip: 'Back to rooms',
          ),
          const SizedBox(width: 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room ${stay.roomName}',
                style: GoogleFonts.outfit(
                  fontSize: compact ? 17 : 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: HotelTokens.ink1,
                ),
              ),
              Text(
                'Folio · opened by ${stay.openedByName ?? 'front desk'}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyCharges() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Text(
        'No charges yet. Post the room charge to start this folio.',
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
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: lines.isEmpty ? () => _cancelStay(context, ref) : null,
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
              'Cancel stay',
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
                      ? 'Settling…'
                      : 'Check out · ${hotelMoney(total.round())}',
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

  Future<void> _postRoomCharge(BuildContext context, WidgetRef ref) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;
    try {
      await HotelDeskActions.postRoomCharge(ref: ref, stay: stay, clerk: clerk);
    } catch (e) {
      ref.read(hotelModeProvider.notifier).showToast('$e');
    }
  }

  Future<void> _cancelStay(BuildContext context, WidgetRef ref) async {
    await HotelDeskActions.cancelStay(ref: ref, stay: stay);
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

    final ITransaction? folio =
        ref.read(hotelModeProvider).activeFolio ??
        await ref.read(hotelFolioForStayProvider(stay.transactionId).future);
    if (folio == null) {
      notifier.showToast('Folio not found — reopen the room and retry');
      return;
    }

    if (!context.mounted) return;
    final result = await HotelCheckOutDialog.show(context, total: total);
    if (result == null) return;

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
      notifier.showToast('Checkout failed: $e');
    }
  }
}
