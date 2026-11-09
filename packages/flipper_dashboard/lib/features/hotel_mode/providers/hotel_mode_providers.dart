import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart' show Color;
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart'
    show barStaffProvider, barTenantIsAdmin, serviceModeGrantsProvider;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/services/hotel_room_rra_service.dart';
import 'package:flipper_models/sync/utils/hotel_dashboard_metrics.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Screens of the front-desk machine.
/// [starting] is the gate: the host cannot know whether this branch requires a
/// PIN until branch settings have hydrated, and showing the lock before that
/// makes a security gate flash up and then dismiss itself, which reads as the
/// desk letting anyone in.
enum HotelScreen {
  starting,
  lock,
  dashboard,
  rooms,
  calendar,
  quotes,
  folio,

  /// Credit to collect and invoices to reprint, once guests have left.
  billing,
}

/// The screen actually drawn for [screen].
///
/// The Today dashboard is a desk-terminal overview laid out for a wide
/// screen; on a phone it opens on Rooms instead. Presentation only — the
/// state keeps [HotelScreen.dashboard], so widening the window shows it again.
HotelScreen hotelVisibleScreen(HotelScreen screen, {required bool mobile}) =>
    mobile && screen == HotelScreen.dashboard ? HotelScreen.rooms : screen;

class HotelModeState {
  const HotelModeState({
    this.screen = HotelScreen.starting,
    this.activeClerk,
    this.activeRoom,
    this.activeStay,
    this.activeFolio,
    this.toastMessage,
    this.showManagerModal = false,
    this.checkOutInFlight = false,
    this.roomChargeInFlight = false,
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

  /// A checkout is being settled. The button stays disabled until it lands,
  /// because a second tap re-settles the same folio and overwrites the
  /// payment type, tender and checkout timestamps of the first.
  final bool checkOutInFlight;

  /// A room charge is being posted. Registering a room with RRA on first use
  /// is a multi-step network round trip, so without this the button sits there
  /// looking dead and the clerk taps it again — which posts a second night.
  final bool roomChargeInFlight;

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
    bool? checkOutInFlight,
    bool? roomChargeInFlight,
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
      checkOutInFlight: checkOutInFlight ?? this.checkOutInFlight,
      roomChargeInFlight: roomChargeInFlight ?? this.roomChargeInFlight,
      floorFilter: clearFloorFilter ? null : (floorFilter ?? this.floorFilter),
    );
  }
}

class HotelModeNotifier extends Notifier<HotelModeState> {
  @override
  HotelModeState build() {
    // activeRoom / activeStay are copies taken when a room or folio was
    // opened. Follow the live documents so a rename made on another device
    // shows here too. A room deleted elsewhere keeps its last copy.
    ref.listen(hotelRoomsProvider, (_, next) {
      final active = state.activeRoom;
      final rooms = next.value;
      if (active == null || rooms == null) return;
      for (final live in rooms) {
        if (live.id != active.id) continue;
        if (!mapEquals(live.toJson(), active.toJson())) {
          state = state.copyWith(activeRoom: live);
        }
        return;
      }
    });
    // The folio updates the stay optimistically, and a lagging stream copy
    // must not undo that — but an advance or a new departure saved on another
    // terminal must still reach this one. See hotelStayWithLiveDetails.
    ref.listen(hotelStaysProvider, (_, next) {
      final active = state.activeStay;
      final stays = next.value;
      if (active == null || stays == null) return;
      for (final live in stays) {
        if (live.id != active.id) continue;
        final merged = hotelStayWithLiveDetails(active, live);
        if (!identical(merged, active)) {
          state = state.copyWith(activeStay: merged);
        }
        return;
      }
    });
    return const HotelModeState();
  }

  /// Resolves the opening screen once branch settings are known.
  ///
  /// Fails safe: anything other than an explicit "this branch does not use a
  /// PIN, and the signed-in user is a known staff member" lands on the lock.
  void resolveEntry({required bool requirePin, Tenant? signedInClerk}) {
    if (!requirePin && signedInClerk != null) {
      login(signedInClerk);
      return;
    }
    state = state.copyWith(screen: HotelScreen.lock);
  }

  /// Signs [clerk] onto the shared register and opens the day's overview.
  void login(Tenant clerk) {
    state = state.copyWith(activeClerk: clerk, screen: HotelScreen.dashboard);
  }

  /// Reopens the desk for the clerk still signed in from an earlier visit,
  /// and returns whether it did. Signs them out otherwise.
  ///
  /// A desk terminal keeps them across Bar → Hotel → Bar. A phone does not
  /// when the branch requires a PIN: it is closed to its home and reopened,
  /// often by whoever holds it next, so it goes back to the lock as Bar does.
  /// A clerk who may no longer run the desk ([mayRun] false) is signed out
  /// either way.
  bool resumeRetainedClerk({
    required bool mayRun,
    required bool requirePin,
    required bool isPhone,
  }) {
    if (state.activeClerk == null) return false;
    if (mayRun && !(isPhone && requirePin)) {
      setScreen(HotelScreen.dashboard);
      return true;
    }
    logout();
    return false;
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
      checkOutInFlight: false,
      roomChargeInFlight: false,
    );
  }

  /// Binds a clerk without leaving the lock screen — used when the branch has
  /// PIN entry switched off and the signed-in tenant runs the desk.
  void setClerk(Tenant clerk) {
    state = state.copyWith(activeClerk: clerk);
  }

  /// Guards the transitions that need a signed-in clerk or a bound stay.
  void setScreen(HotelScreen screen) {
    if (screen != HotelScreen.lock &&
        screen != HotelScreen.starting &&
        state.activeClerk == null) {
      state = state.copyWith(screen: HotelScreen.lock);
      return;
    }
    if (screen == HotelScreen.folio && state.activeStay == null) {
      state = state.copyWith(screen: HotelScreen.rooms);
      return;
    }
    state = state.copyWith(screen: screen);
  }

  void beginCheckOut() {
    state = state.copyWith(checkOutInFlight: true);
  }

  void endCheckOut() {
    state = state.copyWith(checkOutInFlight: false);
  }

  void beginRoomCharge() {
    state = state.copyWith(roomChargeInFlight: true);
  }

  void endRoomCharge() {
    state = state.copyWith(roomChargeInFlight: false);
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
      toastMessage: FlipperL10n.current.hotelManagerApprovedToast,
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
      // A miss must not leave the previous room's folio bound to this stay.
      clearFolio: folio == null,
      screen: HotelScreen.folio,
    );
  }

  /// Replaces the open stay with [stay] after the desk saved it (an advance,
  /// a new departure). Ignored when another stay is open by then.
  void updateActiveStay(HotelStay stay) {
    if (state.activeStay?.id != stay.id) return;
    state = state.copyWith(activeStay: stay);
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
      state = state.copyWith(toastMessage: message, checkOutInFlight: false);
      return;
    }
    state = state.copyWith(
      clearRoom: true,
      clearStay: true,
      clearFolio: true,
      screen: HotelScreen.rooms,
      toastMessage: message,
      checkOutInFlight: false,
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

/// In-house guests another outlet — the bar, the restaurant, the shop — can
/// post a tab to.
///
/// Deliberately independent of which service mode owns the POS pane: a branch
/// running Bar Mode still needs to see who is asleep upstairs.
final hotelChargeableStaysProvider = Provider<List<HotelStay>>((ref) {
  final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];
  return hotelChargeableStays(stays);
});

/// Whether the stay list is still being read, so a picker can say "looking up
/// guests" instead of "nobody is checked in". Separate from the list itself so
/// a screen can be driven entirely by overriding these two.
final hotelStaysLoadingProvider = Provider<bool>((ref) {
  return ref.watch(hotelStaysProvider).isLoading;
});

/// Whether another outlet should offer "charge to room" at all.
///
/// Rooms are consulted first and stays only when the branch has any: reading
/// stays registers branch-wide `transactions` / `transaction_items` sync
/// subscriptions, and a bar-only branch must not pay that cost just to render
/// a button it would never show.
final hotelRoomChargeAvailableProvider = Provider<bool>((ref) {
  final rooms = ref.watch(hotelRoomsProvider).value ?? const <HotelRoom>[];
  if (rooms.isEmpty) return false;
  return ref.watch(hotelChargeableStaysProvider).isNotEmpty;
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
    quotations:
        ref.watch(hotelQuotationsProvider).value ?? const <HotelQuotation>[],
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

/// Staff who may sign in to the desk: the business roster, narrowed to
/// [AppFeature.HotelMode] once anyone holds it.
final hotelStaffProvider = FutureProvider<List<Tenant>>((ref) async {
  final staff = ref.watch(barStaffProvider.future);
  final grants = await ref.watch(serviceModeGrantsProvider.future);
  return staffForServiceMode(
    await staff,
    grants,
    AppFeature.HotelMode,
    isAdminOrOwner: barTenantIsAdmin,
  );
});

/// Whether this branch files with RRA.
///
/// A property that is not on EBM has no tourism-tax items to register, so the
/// desk neither offers room registration nor reports it missing. Kept alive
/// because EBM configuration does not change while the desk is open.
final hotelRraSupportedProvider = FutureProvider<bool>((ref) async {
  ref.keepAlive();
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return false;
  return HotelRoomRraService.branchSupportsRra(branchId);
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

/// Guests who left in the last 30 days, newest first — the Billing screen's
/// reprint list — plus any older stay still holding an advance, so its Apply
/// action stays reachable. Re-read each time the screen opens (auto-disposed).
final hotelCheckedOutStaysProvider =
    FutureProvider.autoDispose<List<HotelStay>>((ref) {
      // Re-read when this terminal checks a guest out while the list is open.
      ref.watch(hotelStaysProvider);
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return Future.value(const <HotelStay>[]);
      return ProxyService.getStrategy(Strategy.capella).hotelCheckedOutStays(
        branchId: branchId,
        since: DateTime.now().subtract(const Duration(days: 30)),
      );
    });
