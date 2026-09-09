import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_interactions.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_card.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

/// Desktop room board.
///
/// Header, floor bar and grid each watch only what they draw. Sharing one
/// `Consumer` at the top meant a single stay changing rebuilt the occupancy
/// counters, the floor tabs and every card together.
class HotelRoomsDesktopScreen extends StatelessWidget {
  const HotelRoomsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelTokens.posBg,
      child: const Column(
        children: [
          _DesktopHeader(),
          _DesktopFloorBar(),
          Expanded(child: _DesktopBoard()),
        ],
      ),
    );
  }
}

/// Brand, title, nav, counters, clerk and the two desk buttons.
class _DesktopHeader extends ConsumerWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clerk = ref.watch(
      hotelModeProvider.select((state) => state.activeClerk),
    );
    final counts = ref.watch(hotelOccupancyProvider);

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        color: HotelTokens.surface,
        border: Border(bottom: BorderSide(color: HotelTokens.line)),
      ),
      // The header carries brand, title, nav, three counters, the clerk and
      // two buttons. Nothing in it may grow unbounded, so the title flexes and
      // the optional furniture drops out as the window narrows.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // The nav carries four tabs now, so the optional furniture yields
          // earlier. The counters are duplicated on the dashboard, which is
          // why they are the first thing to go.
          final showStats = width >= 1500;
          final showSubtitle = width >= 1000;
          final showClerk = width >= 1150;
          // Below this the labelled nav alone eats a third of the bar.
          final compactNav = width < 1320;

          return Row(
            children: [
              const HotelDeskBrand(),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Front Desk',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        color: HotelTokens.ink1,
                      ),
                    ),
                    if (showSubtitle)
                      Text(
                        '${counts.occupied}/${counts.total} occupied · '
                        'tap a room to check in or open its folio',
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
              ),
              const SizedBox(width: 20),
              HotelDeskNav(compact: compactNav),
              const Spacer(),
              if (showStats) ...[
                HotelStatChip(
                  label: 'Vacant',
                  value: counts.vacant,
                  ink: HotelTokens.vacantInk,
                  tint: HotelTokens.vacantTint,
                ),
                const SizedBox(width: 8),
                HotelStatChip(
                  label: 'Occupied',
                  value: counts.occupied,
                  ink: HotelTokens.occupiedInk,
                  tint: HotelTokens.occupiedTint,
                ),
                const SizedBox(width: 8),
                HotelStatChip(
                  label: 'Cleaning',
                  value: counts.dirty,
                  ink: HotelTokens.dirtyInk,
                  tint: HotelTokens.dirtyTint,
                ),
              ],
              if (clerk != null && showClerk) ...[
                const SizedBox(width: 18),
                HotelClerkChip(
                  name: clerk.name ?? 'Front desk',
                  role: '${clerk.type ?? 'Reception'} · on duty',
                  color: HotelTokens.occupiedInk,
                ),
              ],
              if (clerk != null && hotelTenantIsAdmin(clerk)) ...[
                const SizedBox(width: 12),
                _outlineButton(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => locator<RouterService>().navigateTo(
                    const AdminControlRoute(),
                  ),
                ),
              ],
              const SizedBox(width: 12),
              _outlineButton(
                icon: Icons.logout,
                label: 'Hand over',
                borderColor: HotelTokens.dangerBorder,
                foreground: HotelTokens.lossInk,
                onTap: () => ref.read(hotelModeProvider.notifier).logout(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _outlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color borderColor = HotelTokens.line,
    Color foreground = HotelTokens.ink2,
  }) {
    return Material(
      color: HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: HotelTokens.shadow1,
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floor tabs with their vacant counts.
class _DesktopFloorBar extends ConsumerWidget {
  const _DesktopFloorBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
    final stays = ref.watch(hotelStaysProvider).value;
    final selected = ref.watch(
      hotelModeProvider.select((state) => state.floorFilter),
    );

    final floors = <(String, String)>[];
    final seen = <String>{};
    final vacantByFloor = <String, int>{};
    for (final room in rooms) {
      if (seen.add(room.floorId)) {
        floors.add((room.floorId, room.floorName));
      }
      if (stays == null) continue;
      final state = hotelRoomState(
        room: room,
        stay: hotelStayForRoom(room, stays),
      );
      if (state == HotelRoomState.vacant) {
        vacantByFloor[room.floorId] = (vacantByFloor[room.floorId] ?? 0) + 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: HotelFloorTabBar(
        floors: floors,
        selectedFloorId: selected,
        vacantCounts: vacantByFloor,
        onSelect: (id) =>
            ref.read(hotelModeProvider.notifier).setFloorFilter(id),
      ),
    );
  }

}

/// The cards themselves, grouped by floor.
class _DesktopBoard extends ConsumerWidget {
  const _DesktopBoard();

  /// Height the room card's content actually needs: number row, type line,
  /// and a two-line footer, plus its own padding.
  static const _roomCardHeight = 142.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(hotelRoomsProvider);
    final staysAsync = ref.watch(hotelStaysProvider);

    // An empty fallback would show occupied rooms as vacant and offer
    // check-in on them, so a stays failure is surfaced instead.
    if (staysAsync.hasError) return _loadFailure(staysAsync.error!);

    return roomsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _loadFailure(e),
      data: (_) => staysAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _board(context, ref, staysAsync.value ?? const <HotelStay>[]),
    );
  }

  Widget _loadFailure(Object error) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        'Could not load the board.\n$error',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 13.5,
          color: HotelTokens.lossInk,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget _board(BuildContext context, WidgetRef ref, List<HotelStay> stays) {
    final grouped = ref.watch(hotelRoomsByFloorProvider);
    if (grouped.isEmpty) {
      return Center(
        child: Text(
          'No rooms on this branch yet.',
          style: GoogleFonts.outfit(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // A fixed column count plus an aspect ratio let the tile get shorter
        // than the card's content as the window narrows, which overflows it.
        // Fix the row height the card was designed for and drop columns
        // instead.
        final columns = ((constraints.maxWidth - 60) / 210).floor().clamp(2, 8);
        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          mainAxisExtent: _roomCardHeight,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 8, 30, 34),
          child: CustomScrollView(
            slivers: [
              for (final floor in grouped.entries) ...[
                SliverToBoxAdapter(
                  key: ValueKey('hotel-floor-header-${floor.key}'),
                  child: _floorHeader(floor.key, floor.value, stays),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 30),
                  sliver: SliverGrid(
                    gridDelegate: gridDelegate,
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final room = floor.value[i];
                      return HotelRoomCard(
                        key: ValueKey('hotel-room-${room.id}'),
                        room: room,
                        stay: hotelStayForRoom(room, stays),
                        onTap: () => _onRoomTap(context, ref, room, stays),
                        onLongPress: () => hotelShowHousekeepingMenu(
                          context: context,
                          room: room,
                          stay: hotelStayForRoom(room, stays),
                        ),
                      );
                    }, childCount: floor.value.length),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _floorHeader(
    String floorName,
    List<HotelRoom> rooms,
    List<HotelStay> stays,
  ) {
    final occupied = rooms
        .where(
          (r) =>
              hotelRoomState(room: r, stay: hotelStayForRoom(r, stays)) ==
              HotelRoomState.occupied,
        )
        .length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            floorName,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.15,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: HotelTokens.line)),
          const SizedBox(width: 12),
          Text(
            '$occupied/${rooms.length} occupied',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: HotelTokens.ink3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRoomTap(
    BuildContext context,
    WidgetRef ref,
    HotelRoom room,
    List<HotelStay> stays,
  ) => hotelHandleRoomTap(
    context: context,
    ref: ref,
    room: room,
    stays: stays,
    mobile: false,
  );
}
