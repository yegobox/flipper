import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_card.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_interactions.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HotelRoomsMobileScreen extends ConsumerWidget {
  const HotelRoomsMobileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(hotelRoomsProvider);
    final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
    final counts = ref.watch(hotelOccupancyProvider);
    final grouped = ref.watch(hotelRoomsByFloorProvider);

    return Container(
      color: HotelTokens.posBg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            color: HotelTokens.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const HotelDeskBrand(logoSize: 24, wordmarkSize: 15),
                    const Spacer(),
                    Text(
                      '${counts.occupied}/${counts.total} occupied',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: HotelTokens.ink3,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hand over the desk',
                      onPressed: () =>
                          ref.read(hotelModeProvider.notifier).logout(),
                      icon: const Icon(
                        Icons.logout,
                        size: 18,
                        color: HotelTokens.lossInk,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const HotelDeskNav(compact: true),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                  ),
                ),
              ],
            ),
          ),
          _floorBar(ref, stays),
          Expanded(
            child: roomsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (_) => _list(context, ref, grouped, stays),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floorBar(WidgetRef ref, List<HotelStay> stays) {
    final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
    final selected = ref.watch(hotelModeProvider).floorFilter;

    final floors = <(String, String)>[];
    final seen = <String>{};
    final vacantByFloor = <String, int>{};
    for (final room in rooms) {
      if (seen.add(room.floorId)) floors.add((room.floorId, room.floorName));
      if (hotelRoomState(room: room, stay: hotelStayForRoom(room, stays)) ==
          HotelRoomState.vacant) {
        vacantByFloor[room.floorId] = (vacantByFloor[room.floorId] ?? 0) + 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: HotelFloorTabBar(
        floors: floors,
        selectedFloorId: selected,
        vacantCounts: vacantByFloor,
        onSelect: (id) =>
            ref.read(hotelModeProvider.notifier).setFloorFilter(id),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<HotelRoom>> grouped,
    List<HotelStay> stays,
  ) {
    if (grouped.isEmpty) {
      return Center(
        child: Text(
          'No rooms on this branch yet.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: HotelTokens.ink3,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        for (final floor in grouped.entries) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 10),
              child: Text(
                floor.key,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: HotelTokens.ink1,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: HotelTokens.mobileRoomCardMinHeight,
              ),
              delegate: SliverChildBuilderDelegate((context, i) {
                final room = floor.value[i];
                return HotelRoomCard(
                  key: ValueKey('hotel-room-m-${room.id}'),
                  room: room,
                  stay: hotelStayForRoom(room, stays),
                  compact: true,
                  onTap: () => hotelHandleRoomTap(
                    context: context,
                    ref: ref,
                    room: room,
                    stays: stays,
                    mobile: true,
                  ),
                  onLongPress: () => hotelShowHousekeepingMenu(
                    context: context,
                    room: room,
                    stay: hotelStayForRoom(room, stays),
                    mobile: true,
                  ),
                );
              }, childCount: floor.value.length),
            ),
          ),
        ],
      ],
    );
  }
}
