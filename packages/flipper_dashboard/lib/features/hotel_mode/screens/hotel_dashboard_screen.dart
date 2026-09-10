import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_kpi_card.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_dashboard_metrics.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final _money = NumberFormat('#,###');

/// Everything a hotel manager needs at a glance: how full the property is,
/// who is arriving and leaving today, and what money is still uncollected.
class HotelDashboardScreen extends ConsumerWidget {
  const HotelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(hotelMetricsProvider);
    final arrivals = ref.watch(hotelArrivalsTodayProvider);
    final departures = ref.watch(hotelDeparturesTodayProvider);
    final overdue = ref.watch(hotelOverdueStaysProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = HotelLayoutBreakpoints.isHotelMobileLayout(
          constraints.maxWidth,
        );
        final pad = compact ? 16.0 : 30.0;
        final columns = compact
            ? 2
            : ((constraints.maxWidth - pad * 2) / 250).floor().clamp(2, 6);

        return Container(
          color: HotelTokens.posBg,
          child: Column(
            children: [
              _header(ref, metrics, compact),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 12),
                  children: [
                    _occupancyBand(metrics, compact),
                    const SizedBox(height: 18),
                    _kpiGrid(metrics, columns, compact),
                    const SizedBox(height: 22),
                    if (overdue.isNotEmpty) ...[
                      _overdueBanner(context, ref, overdue),
                      const SizedBox(height: 18),
                    ],
                    _lists(context, ref, arrivals, departures, compact),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(WidgetRef ref, HotelDeskMetrics metrics, bool compact) {
    final clerk = ref.watch(hotelModeProvider).activeClerk;

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
              Text(
                DateFormat('EEEE d MMMM').format(DateTime.now()),
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            clerk == null
                ? 'Today at the property'
                : 'Good day, ${clerk.name ?? 'there'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: compact ? 17 : 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: HotelTokens.ink1,
            ),
          ),
          Text(
            '${metrics.occupied} of ${metrics.sellableRooms} sellable rooms '
            'occupied · ${metrics.inHouseGuests} guest'
            '${metrics.inHouseGuests == 1 ? '' : 's'} in house',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _occupancyBand(HotelDeskMetrics metrics, bool compact) {
    final pct = (metrics.occupancyRate * 100).round();

    return Container(
      padding: EdgeInsets.all(compact ? 16 : 22),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$pct%',
                style: GoogleFonts.outfit(
                  fontSize: compact ? 34 : 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  height: 1,
                  color: HotelTokens.ink1,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'occupancy',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HotelTokens.ink3,
                  ),
                ),
              ),
              const Spacer(),
              if (!compact) _rateStat('ADR', metrics.adr),
              if (!compact) const SizedBox(width: 26),
              if (!compact) _rateStat('RevPAR', metrics.revPar),
            ],
          ),
          const SizedBox(height: 14),
          _occupancyBar(metrics),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _legend('Occupied', metrics.occupied, HotelTokens.occupiedInk),
              _legend('Reserved', metrics.reserved, HotelTokens.reservedInk),
              _legend('Vacant', metrics.vacant, HotelTokens.vacantInk),
              _legend('Cleaning', metrics.cleaning, HotelTokens.dirtyInk),
              if (metrics.blocked > 0)
                _legend('Blocked', metrics.blocked, HotelTokens.blockedInk),
            ],
          ),
          if (compact) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                _rateStat('ADR', metrics.adr),
                const SizedBox(width: 26),
                _rateStat('RevPAR', metrics.revPar),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Proportional bar of the whole room stock, blocked rooms included so the
  /// segments always add up to the property.
  Widget _occupancyBar(HotelDeskMetrics metrics) {
    final total = metrics.totalRooms;
    if (total == 0) {
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: HotelTokens.surface2,
          borderRadius: BorderRadius.circular(999),
        ),
      );
    }

    Widget seg(int count, Color color) => count == 0
        ? const SizedBox.shrink()
        : Expanded(flex: count, child: ColoredBox(color: color));

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            seg(metrics.occupied, HotelTokens.occupiedInk),
            seg(metrics.reserved, HotelTokens.reservedInk),
            seg(metrics.cleaning, HotelTokens.dirtyInk),
            seg(metrics.vacant, HotelTokens.vacantInk),
            seg(metrics.blocked, HotelTokens.blockedInk),
          ],
        ),
      ),
    );
  }

  Widget _rateStat(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: HotelTokens.ink4,
          ),
        ),
        Text(
          'RWF ${_money.format(value.round())}',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: HotelTokens.ink1,
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label $value',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
      ],
    );
  }

  Widget _kpiGrid(HotelDeskMetrics metrics, int columns, bool compact) {
    final cards = <Widget>[
      HotelKpiCard(
        label: 'Arrivals today',
        value: '${metrics.arrivalsToday}',
        caption: '${metrics.arrivalsNextSevenDays} in the next 7 days',
        icon: Icons.login,
        ink: HotelTokens.reservedInk,
        tint: HotelTokens.reservedTint,
      ),
      HotelKpiCard(
        label: 'Departures today',
        value: '${metrics.departuresToday}',
        caption: metrics.dueOut > 0
            ? '${metrics.dueOut} overdue'
            : 'none overdue',
        emphasiseCaption: metrics.dueOut > 0,
        icon: Icons.logout,
        ink: HotelTokens.dirtyInk,
        tint: HotelTokens.dirtyTint,
      ),
      HotelKpiCard(
        label: 'Available rooms',
        value: '${metrics.vacant}',
        caption: '${metrics.cleaning} awaiting cleaning',
        icon: Icons.meeting_room_outlined,
        ink: HotelTokens.vacantInk,
        tint: HotelTokens.vacantTint,
      ),
      HotelKpiCard(
        label: 'Pending payments',
        value: 'RWF ${_money.format(metrics.openFolioValue.round())}',
        caption: '${metrics.openFolioCount} open folio'
            '${metrics.openFolioCount == 1 ? '' : 's'}',
        icon: Icons.account_balance_wallet_outlined,
        ink: HotelTokens.occupiedInk,
        tint: HotelTokens.occupiedTint,
        dense: true,
      ),
      HotelKpiCard(
        label: 'Room revenue tonight',
        value: 'RWF ${_money.format(metrics.roomRevenueToday.round())}',
        caption: 'contracted for in-house stays',
        icon: Icons.trending_up,
        ink: HotelTokens.vacantInk,
        tint: HotelTokens.vacantTint,
        dense: true,
      ),
      HotelKpiCard(
        label: 'Open quotations',
        value: '${metrics.liveQuotes}',
        caption: 'RWF ${_money.format(metrics.liveQuoteValue.round())} quoted',
        icon: Icons.request_quote_outlined,
        ink: HotelTokens.blockedInk,
        tint: HotelTokens.blockedTint,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      // A fixed tile height: deriving it from a changing width lets the card
      // content overflow as the window narrows.
      childAspectRatio: compact ? 1.15 : 1.55,
      children: cards,
    );
  }

  Widget _overdueBanner(
    BuildContext context,
    WidgetRef ref,
    List<HotelStay> overdue,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HotelTokens.dirtyTint,
        borderRadius: BorderRadius.circular(HotelTokens.radiusLg),
        border: Border.all(color: HotelTokens.dirtyInk.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule,
            size: 20,
            color: HotelTokens.dirtyInk,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${overdue.length} stay${overdue.length == 1 ? '' : 's'} past '
              'departure — ${overdue.map((s) => 'Room ${s.roomName}').take(4).join(', ')}'
              '${overdue.length > 4 ? '…' : ''}',
              style: GoogleFonts.outfit(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: HotelTokens.dirtyInk,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(hotelModeProvider.notifier).setScreen(HotelScreen.rooms),
            child: Text(
              'Open board',
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: HotelTokens.dirtyInk,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lists(
    BuildContext context,
    WidgetRef ref,
    List<HotelStay> arrivals,
    List<HotelStay> departures,
    bool compact,
  ) {
    final arrivalsPanel = _stayPanel(
      context,
      ref,
      title: 'Arriving today',
      emptyText: 'No arrivals booked for today.',
      stays: arrivals,
      isArrival: true,
    );
    final departuresPanel = _stayPanel(
      context,
      ref,
      title: 'Departing today',
      emptyText: 'Nobody is due to leave today.',
      stays: departures,
      isArrival: false,
    );

    if (compact) {
      return Column(
        children: [
          arrivalsPanel,
          const SizedBox(height: 14),
          departuresPanel,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: arrivalsPanel),
        const SizedBox(width: 14),
        Expanded(child: departuresPanel),
      ],
    );
  }

  Widget _stayPanel(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String emptyText,
    required List<HotelStay> stays,
    required bool isArrival,
  }) {
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
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: HotelTokens.ink1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${stays.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (stays.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                emptyText,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
            )
          else
            for (final stay in stays) _stayRow(ref, stay, isArrival),
        ],
      ),
    );
  }

  Widget _stayRow(WidgetRef ref, HotelStay stay, bool isArrival) {
    final time = isArrival ? stay.checkInAt : stay.expectedCheckOutAt;
    final overdue = !isArrival && hotelStayIsDue(stay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 46,
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: HotelTokens.surface2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              stay.roomName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: HotelTokens.ink1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stay.guestName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
                Text(
                  hotelStaySummary(stay),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: HotelTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            overdue
                ? 'overdue'
                : DateFormat('HH:mm').format(time.toLocal()),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: overdue ? HotelTokens.lossInk : HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
