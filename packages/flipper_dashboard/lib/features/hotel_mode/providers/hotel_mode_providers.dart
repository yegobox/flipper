import 'package:flutter/material.dart' show Color;
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_dashboard_metrics.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Screens of the front-desk machine.
enum HotelScreen { lock, dashboard, rooms, calendar, quotes, folio }

class HotelModeState {
  const HotelModeState({
    this.screen = HotelScreen.lock,
    this.activeClerk,
    this.activeRoom,
    this.activeStay,
    this.activeFolio,
    this.toastMessage,
    this.showManagerModal = false,
    this.floorFilter,
  });

  final HotelScreen screen;
  final Tenant? activeClerk;
  final HotelRoom? activeRoom;
  final HotelStay? activeStay;
  final ITransaction? activeFolio;
  final String? toastMessage;

  /// Manager-approval keypad is up (checkout needs elevation).
  final bool showManagerModal;

  /// `null` = all floors.
  final String? floorFilter;

  HotelModeState copyWith({
    HotelScreen? screen,
    Tenant? activeClerk,
    bool clearClerk = false,
    HotelRoom? activeRoom,
    bool clearRoom = false,
    HotelStay? activeStay,
    bool clearStay = false,
    ITransaction? activeFolio,
    bool clearFolio = false,
    String? toastMessage,
    bool clearToast = false,
    bool? showManagerModal,
    String? floorFilter,
    bool clearFloorFilter = false,
  }) {
    return HotelModeState(
      screen: screen ?? this.screen,
      activeClerk: clearClerk ? null : (activeClerk ?? this.activeClerk),
      activeRoom: clearRoom ? null : (activeRoom ?? this.activeRoom),
      activeStay: clearStay ? null : (activeStay ?? this.activeStay),
      activeFolio: clearFolio ? null : (activeFolio ?? this.activeFolio),
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      showManagerModal: showManagerModal ?? this.showManagerModal,
      floorFilter: clearFloorFilter ? null : (floorFilter ?? this.floorFilter),
    );
  }
}

class HotelModeNotifier extends Notifier<HotelModeState> {
  @override
  HotelModeState build() => const HotelModeState();

  /// Signs [clerk] onto the shared register and opens the day's overview.
  void login(Tenant clerk) {
    state = state.copyWith(activeClerk: clerk, screen: HotelScreen.dashboard);
  }

  /// Hands the terminal back: clears the clerk and everything they had open.
  void logout() {
    state = state.copyWith(
      clearClerk: true,
      clearRoom: true,
      clearStay: true,
      clearFolio: true,
      screen: HotelScreen.lock,
      showManagerModal: false,
    );
  }

  /// Binds a clerk without leaving the lock screen — used when the branch has
  /// PIN entry switched off and the signed-in tenant runs the desk.
  void setClerk(Tenant clerk) {
    state = state.copyWith(activeClerk: clerk);
  }

  /// Guards the transitions that need a signed-in clerk or a bound stay.
  void setScreen(HotelScreen screen) {
    if (screen != HotelScreen.lock && state.activeClerk == null) {
      state = state.copyWith(screen: HotelScreen.lock);
      return;
    }
    if (screen == HotelScreen.folio && state.activeStay == null) {
      state = state.copyWith(screen: HotelScreen.rooms);
      return;
    }
    state = state.copyWith(screen: screen);
  }

  void showManagerPin() {
    state = state.copyWith(showManagerModal: true);
  }

  void hideManagerPin() {
    state = state.copyWith(showManagerModal: false);
  }

  /// A manager typed their PIN: they take over the register for the settle.
  void elevateManager(Tenant manager) {
    state = state.copyWith(
      activeClerk: manager,
      showManagerModal: false,
      toastMessage: 'Manager approved — tap Check out to settle',
    );
  }

  void openFolio({
    required HotelRoom room,
    required HotelStay stay,
    ITransaction? folio,
  }) {
    state = state.copyWith(
      activeRoom: room,
      activeStay: stay,
      activeFolio: folio,
      screen: HotelScreen.folio,
    );
  }

  void bindFolio(ITransaction folio) {
    state = state.copyWith(activeFolio: folio);
  }

  void backToRooms() {
    state = state.copyWith(
      clearRoom: true,
      clearStay: true,
      clearFolio: true,
      screen: HotelScreen.rooms,
    );
  }

  void afterCheckOut({required String message, bool autoLogout = false}) {
    if (autoLogout) {
      logout();
      state = state.copyWith(toastMessage: message);
      return;
    }
    state = state.copyWith(
      clearRoom: true,
      clearStay: true,
      clearFolio: true,
      screen: HotelScreen.rooms,
      toastMessage: message,
    );
  }

  void setFloorFilter(String? floorId) {
    state = floorId == null
        ? state.copyWith(clearFloorFilter: true)
        : state.copyWith(floorFilter: floorId);
  }

  void showToast(String message) {
    state = state.copyWith(toastMessage: message);
  }

  void clearToast() {
    state = state.copyWith(clearToast: true);
  }
}

final hotelModeProvider = NotifierProvider<HotelModeNotifier, HotelModeState>(
  HotelModeNotifier.new,
);

final hotelRoomsProvider = StreamProvider<List<HotelRoom>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value(const <HotelRoom>[]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).hotelRoomsStream(branchId: branchId);
});

final hotelStaysProvider = StreamProvider<List<HotelStay>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value(const <HotelStay>[]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).hotelStaysStream(branchId: branchId);
});

final hotelBranchSettingsProvider = StreamProvider<HotelBranchSettings?>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value(null);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).hotelBranchSettingsStream(branchId: branchId);
});

/// Folio lines for a stay's transaction — a real Ditto observer, so a charge
/// posted from the bar or restaurant lands on the desk without polling.
final hotelFolioLinesProvider =
    StreamProvider.family<List<TransactionItem>, String>((ref, transactionId) {
      return ProxyService.getStrategy(
        Strategy.capella,
      ).hotelFolioLinesStream(transactionId: transactionId);
    });

/// Fallback folio lookup when the transaction was not carried in state
/// (a rebuild after the desk resumed a stay opened on another device).
final hotelFolioForStayProvider = FutureProvider.family<ITransaction?, String>((
  ref,
  transactionId,
) async {
  return await ProxyService.getStrategy(
    Strategy.capella,
  ).hotelFolio(transactionId: transactionId);
});


final hotelQuotationsProvider = StreamProvider<List<HotelQuotation>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value(const <HotelQuotation>[]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).hotelQuotationsStream(branchId: branchId);
});

/// Left-hand date of the availability calendar. Moving it is how the desk
/// pages through weeks, so it lives outside the screen's own state.
class HotelCalendarAnchor extends Notifier<DateTime> {
  @override
  DateTime build() => hotelDateOnly(DateTime.now());

  void shiftDays(int days) {
    state = hotelDateOnly(state.add(Duration(days: days)));
  }

  void jumpTo(DateTime day) => state = hotelDateOnly(day);

  void today() => state = hotelDateOnly(DateTime.now());
}

final hotelCalendarAnchorProvider =
    NotifierProvider<HotelCalendarAnchor, DateTime>(HotelCalendarAnchor.new);

/// Live quotations that still matter to the desk: newest first, with expired
/// and converted ones sunk to the bottom rather than hidden.
final hotelSortedQuotationsProvider = Provider<List<HotelQuotation>>((ref) {
  final quotes = [...?ref.watch(hotelQuotationsProvider).value];
  quotes.sort((a, b) {
    final aLive = hotelQuotationCanConvert(a) ? 0 : 1;
    final bLive = hotelQuotationCanConvert(b) ? 0 : 1;
    if (aLive != bLive) return aLive.compareTo(bLive);
    final aAt = a.createdAt ?? a.checkInAt;
    final bAt = b.createdAt ?? b.checkInAt;
    return bAt.compareTo(aAt);
  });
  return quotes;
});


/// Open folios behind in-house stays — the money the desk has not collected.
final hotelOpenFoliosProvider = StreamProvider<List<ITransaction>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value(const <ITransaction>[]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).hotelOpenFoliosStream(branchId: branchId);
});

/// The manager dashboard, recomputed whenever any of its inputs move.
final hotelMetricsProvider = Provider<HotelDeskMetrics>((ref) {
  final rooms = ref.watch(hotelRoomsProvider).value;
  final stays = ref.watch(hotelStaysProvider).value;
  if (rooms == null || stays == null) return HotelDeskMetrics.empty;

  return hotelDeskMetrics(
    rooms: rooms,
    stays: stays,
    folios: ref.watch(hotelOpenFoliosProvider).value ?? const <ITransaction>[],
    quotations: ref.watch(hotelQuotationsProvider).value ??
        const <HotelQuotation>[],
  );
});

final hotelArrivalsTodayProvider = Provider<List<HotelStay>>((ref) {
  final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
  return hotelArrivalsForDay(stays: stays);
});

final hotelDeparturesTodayProvider = Provider<List<HotelStay>>((ref) {
  final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
  return hotelDeparturesForDay(stays: stays);
});

final hotelOverdueStaysProvider = Provider<List<HotelStay>>((ref) {
  final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
  return hotelOverdueStays(stays: stays);
});

final hotelStaffProvider = FutureProvider<List<Tenant>>((ref) async {
  return FlipperBaseModel.fetchBarStaffTenants();
});

/// Front-desk counters derived from the live room + stay streams.
final hotelOccupancyProvider = Provider((ref) {
  final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
  final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
  return hotelOccupancy(rooms: rooms, stays: stays);
});

/// Rooms grouped by floor, honouring the active floor filter, in ordinal order.
final hotelRoomsByFloorProvider = Provider<Map<String, List<HotelRoom>>>((ref) {
  final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
  final filter = ref.watch(hotelModeProvider).floorFilter;

  final grouped = <String, List<HotelRoom>>{};
  for (final room in rooms) {
    if (filter != null && room.floorId != filter) continue;
    grouped.putIfAbsent(room.floorName, () => <HotelRoom>[]).add(room);
  }
  return grouped;
});

/// Whether [tenant] may settle a folio at checkout.
bool hotelTenantIsManager(Tenant tenant) => tenantCanCollectPosPayment(tenant);

bool hotelTenantIsAdmin(Tenant tenant) {
  final type = tenant.type?.toLowerCase() ?? '';
  return type.contains('admin') || type.contains('owner');
}

({Color ink, Color tint}) hotelDayStateColors(HotelDayState state) {
  switch (state) {
    case HotelDayState.free:
      return (ink: HotelTokens.vacantInk, tint: HotelTokens.vacantTint);
    case HotelDayState.occupied:
      return (ink: HotelTokens.occupiedInk, tint: HotelTokens.occupiedTint);
    case HotelDayState.reserved:
      return (ink: HotelTokens.reservedInk, tint: HotelTokens.reservedTint);
    case HotelDayState.blocked:
      return (ink: HotelTokens.blockedInk, tint: HotelTokens.blockedTint);
  }
}

({Color ink, Color tint}) hotelRoomStateColors(HotelRoomState state) {
  switch (state) {
    case HotelRoomState.vacant:
      return (ink: HotelTokens.vacantInk, tint: HotelTokens.vacantTint);
    case HotelRoomState.occupied:
      return (ink: HotelTokens.occupiedInk, tint: HotelTokens.occupiedTint);
    case HotelRoomState.reserved:
      return (ink: HotelTokens.reservedInk, tint: HotelTokens.reservedTint);
    case HotelRoomState.dirty:
      return (ink: HotelTokens.dirtyInk, tint: HotelTokens.dirtyTint);
    case HotelRoomState.outOfOrder:
      return (ink: HotelTokens.blockedInk, tint: HotelTokens.blockedTint);
  }
}
