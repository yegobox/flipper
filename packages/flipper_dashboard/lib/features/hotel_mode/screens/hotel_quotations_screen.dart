import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_quotation_sheet.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// Quotations: priced offers the desk sends, and turns into reservations.
class HotelQuotationsScreen extends ConsumerWidget {
  const HotelQuotationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(hotelSortedQuotationsProvider);
    final quotesAsync = ref.watch(hotelQuotationsProvider);
    final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
    final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = HotelLayoutBreakpoints.isHotelMobileLayout(
          constraints.maxWidth,
        );
        final pad = compact ? 16.0 : 30.0;

        return Container(
          color: HotelTokens.posBg,
          child: Column(
            children: [
              _header(context, ref, rooms, stays, quotes, compact),
              Expanded(
                child: quotesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (_) => quotes.isEmpty
                      ? _empty()
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 12),
                          itemCount: quotes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) => _quoteCard(
                            context,
                            ref,
                            quotes[i],
                            rooms,
                            stays,
                            compact,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    List<HotelQuotation> quotes,
    bool compact,
  ) {
    final live = quotes.where(hotelQuotationCanConvert).length;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 30,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HotelDeskNav(compact: compact),
              const Spacer(),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: HotelTokens.gradBtn,
                  borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
                ),
                child: TextButton.icon(
                  onPressed: () => _newQuote(context, ref, rooms, stays, compact),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: Text(
                    compact ? 'New' : 'New quotation',
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Quotations',
            style: GoogleFonts.outfit(
              fontSize: compact ? 16 : 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: HotelTokens.ink1,
            ),
          ),
          Text(
            '$live open · a quotation holds no room until it is accepted',
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
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          'No quotations yet.\nCreate one to price a stay for a guest before '
          'they commit.',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: HotelTokens.ink3,
          ),
        ),
      ),
    );
  }

  Widget _quoteCard(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) {
    final canConvert = hotelQuotationCanConvert(quote);
    final label = hotelQuotationStatusLabel(quote);
    final (ink, tint) = switch (label) {
      'Booked' => (HotelTokens.vacantInk, HotelTokens.vacantTint),
      'Expired' => (HotelTokens.blockedInk, HotelTokens.blockedTint),
      'Declined' => (HotelTokens.lossInk, HotelTokens.dirtyTint),
      'Accepted' => (HotelTokens.reservedInk, HotelTokens.reservedTint),
      _ => (HotelTokens.occupiedInk, HotelTokens.occupiedTint),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HotelTokens.surface,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.line),
        boxShadow: HotelTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            quote.guestName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: HotelTokens.ink1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          quote.reference,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: HotelTokens.ink4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Room ${quote.roomName} · ${quote.roomType} · '
                      '${DateFormat('d MMM').format(quote.checkInAt.toLocal())} → '
                      '${DateFormat('d MMM').format(quote.checkOutAt.toLocal())} · '
                      '${quote.nights} night${quote.nights == 1 ? '' : 's'}',
                      maxLines: 2,
                      style: GoogleFonts.outfit(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: HotelTokens.ink3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4.5,
                ),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'RWF ${NumberFormat('#,###').format(quote.total)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink1,
                ),
              ),
              if (quote.validUntil != null && canConvert) ...[
                const SizedBox(width: 10),
                Text(
                  'valid to ${DateFormat('d MMM').format(quote.validUntil!.toLocal())}',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: HotelTokens.ink3,
                  ),
                ),
              ],
              const Spacer(),
              if (canConvert) ...[
                TextButton(
                  onPressed: () =>
                      _editQuote(context, ref, quote, rooms, stays, compact),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.ink2,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _acceptButton(context, ref, quote, rooms),
              ] else
                TextButton(
                  onPressed: () => _confirmDelete(context, ref, quote),
                  child: Text(
                    'Remove',
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: HotelTokens.lossInk,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _acceptButton(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: HotelTokens.gradBtn,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      ),
      child: TextButton(
        onPressed: () => _accept(context, ref, quote, rooms),
        child: Text(
          'Accept & hold',
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _newQuote(
    BuildContext context,
    WidgetRef ref,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) async {
    final quote = await HotelQuotationSheet.show(
      context,
      rooms: rooms,
      stays: stays,
      mobile: compact,
    );
    if (quote == null) return;
    await HotelDeskActions.saveQuotation(quote);
  }

  Future<void> _editQuote(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
    bool compact,
  ) async {
    final updated = await HotelQuotationSheet.show(
      context,
      rooms: rooms,
      stays: stays,
      existing: quote,
      mobile: compact,
    );
    if (updated == null) return;
    await HotelDeskActions.saveQuotation(updated);
  }

  Future<void> _accept(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
    List<HotelRoom> rooms,
  ) async {
    final clerk = ref.read(hotelModeProvider).activeClerk;
    if (clerk == null) return;

    HotelRoom? room;
    for (final candidate in rooms) {
      if (candidate.id == quote.roomId) {
        room = candidate;
        break;
      }
    }
    if (room == null) {
      ref
          .read(hotelModeProvider.notifier)
          .showToast('Room ${quote.roomName} no longer exists on this branch');
      return;
    }

    await HotelDeskActions.convertQuotation(
      ref: ref,
      quotation: quote,
      room: room,
      clerk: clerk,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    HotelQuotation quote,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Remove ${quote.reference}?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This deletes the quotation for ${quote.guestName}. Any reservation '
          'it already created is untouched.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await HotelDeskActions.deleteQuotation(id: quote.id);
  }
}
