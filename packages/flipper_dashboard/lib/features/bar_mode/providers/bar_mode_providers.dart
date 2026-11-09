import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, mapEquals;
import 'package:flutter/material.dart' show Color;
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_models/sync/utils/staff_roster_cache.dart'
    show staffRosterCachedPinsChanged, staffRosterChanged;
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show connectivityStreamProvider;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

enum BarScreen { lock, tables, pos, settle, credit }

class BarModeState {
  const BarModeState({
    this.screen = BarScreen.lock,
    this.activeCashier,
    this.activeTable,
    this.activeTab,
    this.toastMessage,
    this.showManagerModal = false,
    this.managerTarget = BarScreen.settle,
  });

  final BarScreen screen;
  final Tenant? activeCashier;
  final BarTable? activeTable;
  final ITransaction? activeTab;
  final String? toastMessage;
  final bool showManagerModal;

  /// Where a manager PIN leads once accepted: Settle, or the Credit list.
  final BarScreen managerTarget;

  BarModeState copyWith({
    BarScreen? screen,
    Tenant? activeCashier,
    bool clearCashier = false,
    BarTable? activeTable,
    bool clearTable = false,
    ITransaction? activeTab,
    bool clearTab = false,
    String? toastMessage,
    bool clearToast = false,
    bool? showManagerModal,
    BarScreen? managerTarget,
  }) {
    return BarModeState(
      screen: screen ?? this.screen,
      activeCashier: clearCashier
          ? null
          : (activeCashier ?? this.activeCashier),
      activeTable: clearTable ? null : (activeTable ?? this.activeTable),
      activeTab: clearTab ? null : (activeTab ?? this.activeTab),
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      showManagerModal: showManagerModal ?? this.showManagerModal,
      managerTarget: managerTarget ?? this.managerTarget,
    );
  }
}

class BarModeNotifier extends Notifier<BarModeState> {
  @override
  BarModeState build() {
    // activeTable is a copy taken when the table was opened. Follow the live
    // floor plan so a rename or seat change made on another device shows on
    // this one's POS and settle screens. A table deleted elsewhere keeps its
    // last copy: the open tab still needs a name.
    ref.listen(barTablesProvider, (_, next) {
      final active = state.activeTable;
      final tables = next.value;
      if (active == null || tables == null) return;
      for (final live in tables) {
        if (live.id != active.id) continue;
        if (!mapEquals(live.toJson(), active.toJson())) {
          state = state.copyWith(activeTable: live);
        }
        return;
      }
    });
    return const BarModeState();
  }

  void setScreen(BarScreen screen) {
    var next = state.copyWith(screen: screen);
    if (screen == BarScreen.lock ||
        screen == BarScreen.tables && state.activeCashier == null) {
      if (state.activeCashier == null &&
          screen != BarScreen.lock &&
          (screen == BarScreen.tables ||
              screen == BarScreen.pos ||
              screen == BarScreen.settle)) {
        next = next.copyWith(screen: BarScreen.lock);
      }
    }
    if ((screen == BarScreen.pos || screen == BarScreen.settle) &&
        state.activeTable == null) {
      next = next.copyWith(screen: BarScreen.tables);
    }
    if (screen == BarScreen.credit && state.activeCashier == null) {
      next = next.copyWith(screen: BarScreen.lock);
    }
    state = next;
  }

  void login(Tenant cashier) {
    state = state.copyWith(activeCashier: cashier, screen: BarScreen.tables);
  }

  void logout() {
    state = state.copyWith(
      clearCashier: true,
      clearTable: true,
      clearTab: true,
      screen: BarScreen.lock,
      showManagerModal: false,
    );
  }

  void bindTable(BarTable table, ITransaction tab) {
    state = state.copyWith(
      activeTable: table,
      activeTab: tab,
      screen: BarScreen.pos,
    );
  }

  void saveToTab({required bool autoLogout}) {
    if (autoLogout) {
      logout();
    } else {
      state = state.copyWith(
        clearTable: true,
        clearTab: true,
        screen: BarScreen.tables,
      );
    }
  }

  void goSettle() => setScreen(BarScreen.settle);

  void goCredit() => setScreen(BarScreen.credit);

  void elevateManager(Tenant manager) {
    state = state.copyWith(
      activeCashier: manager,
      showManagerModal: false,
      screen: state.managerTarget,
    );
  }

  /// [then] is where the accepted PIN leads: Settle for a tab, Credit for
  /// collecting a loan.
  void showManagerPin({BarScreen then = BarScreen.settle}) {
    state = state.copyWith(showManagerModal: true, managerTarget: then);
  }

  void hideManagerPin() {
    state = state.copyWith(showManagerModal: false);
  }

  void showToast(String message) {
    state = state.copyWith(toastMessage: message);
  }

  void clearToast() {
    state = state.copyWith(clearToast: true);
  }

  void afterSettle({required String tableName, required String message}) {
    state = state.copyWith(
      clearTable: true,
      clearTab: true,
      screen: BarScreen.tables,
      toastMessage: message,
    );
  }
}

final barModeProvider = NotifierProvider<BarModeNotifier, BarModeState>(
  BarModeNotifier.new,
);

/// Loads the shared-register roster for a business (the box business when
/// null). Tests override it; the app reads Supabase with an offline copy.
final staffRosterLoaderProvider =
    Provider<Future<StaffRoster> Function(String? businessId)>(
      (ref) =>
          (businessId) =>
              FlipperBaseModel.fetchStaffRoster(businessId: businessId),
    );

/// How long an empty roster waits before [barStaffProvider] reads it again.
const Duration staffRosterEmptyRetryDelay = Duration(seconds: 15);

/// How long the offline copy is shown before [barStaffProvider] asks
/// Supabase again for the live roster.
const Duration staffRosterCachedRefreshDelay = Duration(seconds: 60);

/// A roster [barStaffProvider] read in the background and hands to its own
/// next build, so that build does not read it again.
typedef _StaffRosterHandoff = ({
  String? businessId,
  StaffRoster roster,
  DateTime at,
});

/// Holds at most one [_StaffRosterHandoff] per container.
final _staffRosterHandoffProvider = Provider<List<_StaffRosterHandoff>>(
  (ref) => [],
);

/// The business roster behind every shared-register lock (Bar, Hotel, the
/// POS user switch).
///
/// A business always has at least its owner, so an empty roster means it
/// could not be read yet (slow or no network and no offline copy), never
/// "no staff". While it is empty or only the offline copy, it reads again in
/// the background (every [staffRosterEmptyRetryDelay] /
/// [staffRosterCachedRefreshDelay], and at once when the device comes back
/// online), so a desk never stays empty until someone taps Retry.
///
/// A background read only rebuilds this provider when the people changed:
/// a rebuild reloads the lock screens and drops a PIN being typed.
final barStaffProvider = FutureProvider<List<Tenant>>((ref) async {
  // Re-read on a business switch, as [serviceModeGrantsProvider] does: the
  // Bar and Hotel sign-in lists filter this roster with those grants.
  final businessId = ref.watch(
    activeBranchProvider.select((branch) => branch.value?.businessId),
  );
  final load = ref.read(staffRosterLoaderProvider);
  final handoffs = ref.read(_staffRosterHandoffProvider);

  // Registered before the first await: a business switch during the read
  // disposes this build, and a disposed ref may not be used.
  var disposed = false;
  var checking = false;
  Timer? timer;
  ref.onDispose(() {
    disposed = true;
    timer?.cancel();
  });

  /// What this build shows; null until the first read lands.
  StaffRoster? shown;
  late void Function(StaffRoster current) schedule;

  Future<void> recheck() async {
    final roster = shown;
    if (disposed || checking || roster == null) return;
    checking = true;
    StaffRoster? next;
    var changed = false;
    try {
      next = await load(businessId);
      changed =
          next.tenants.isNotEmpty &&
          (staffRosterChanged(
                roster.tenants,
                next.tenants,
                bothLive: roster.fresh && next.fresh,
              ) ||
              // The offline copy holds PIN verifiers, not PINs: a PIN
              // changed or removed since must not keep unlocking.
              await staffRosterCachedPinsChanged(roster.tenants, next.tenants));
    } catch (e) {
      debugPrint('barStaffProvider: background re-read failed: $e');
    } finally {
      checking = false;
    }
    if (disposed) return;
    if (changed) {
      handoffs
        ..clear()
        ..add((businessId: businessId, roster: next!, at: DateTime.now()));
      // The sign-in lists filter this roster with the grants. A desk that
      // could not read them fell back to "open to all", so read them again
      // with the roster rather than expose it under that fallback.
      ref.invalidate(serviceModeGrantsProvider);
      ref.invalidateSelf();
      return;
    }
    // Same people (or still nothing): keep the screen as it is and only
    // read again if this copy is still empty or offline.
    schedule(next != null && next.tenants.isNotEmpty ? next : roster);
  }

  schedule = (current) {
    timer?.cancel();
    timer = null;
    if (disposed) return;
    if (current.tenants.isEmpty) {
      debugPrint(
        'barStaffProvider: roster for ${businessId ?? 'box business'} is '
        'empty (not reachable, no offline copy) — reading again in '
        '${staffRosterEmptyRetryDelay.inSeconds}s',
      );
      timer = Timer(staffRosterEmptyRetryDelay, recheck);
    } else if (!current.fresh) {
      timer = Timer(staffRosterCachedRefreshDelay, recheck);
    }
  };

  ref.listen(connectivityStreamProvider, (previous, next) {
    if (previous?.value == false && next.value == true) unawaited(recheck());
  });

  final handoff = handoffs.isEmpty ? null : handoffs.removeLast();
  final roster =
      handoff != null &&
          handoff.businessId == businessId &&
          DateTime.now().difference(handoff.at) < staffRosterCachedRefreshDelay
      ? handoff.roster
      : await load(businessId);
  shown = roster;
  schedule(roster);
  return roster.tenants;
});

/// Who may run Bar Mode / Hotel Mode in this business (see [ServiceModeGrants]).
///
/// Invalidate after a permission change, and from a lock screen's retry. It
/// also re-reads itself on a business switch, when the device comes back
/// online, and when a grant it counted expires.
final serviceModeGrantsProvider = FutureProvider<ServiceModeGrants>((
  ref,
) async {
  final box = ref.watch(barServicesProvider).box;
  // A business switch replaces the active branch; the box alone would keep
  // serving the previous business's grants.
  final branchBusinessId = ref.watch(
    activeBranchProvider.select((branch) => branch.value?.businessId),
  );
  // Offline at the last read means it may be the open fallback: re-read.
  ref.listen(connectivityStreamProvider, (previous, next) {
    if (previous?.value == false && next.value == true) ref.invalidateSelf();
  });
  final businessId = branchBusinessId ?? box.getBusinessId();
  if (businessId == null || businessId.isEmpty) {
    return const ServiceModeGrants();
  }
  final grants = await fetchServiceModeGrants(
    businessId: businessId,
    box: box,
    timeout: FlipperBaseModel.staffRosterRemoteTimeout,
  );
  final expiry = grants.nextExpiry;
  if (expiry != null) {
    final timer = Timer(
      expiry.difference(DateTime.now()) + const Duration(seconds: 1),
      ref.invalidateSelf,
    );
    ref.onDispose(timer.cancel);
  }
  return grants;
});

/// Staff the bar lock screen and manager PIN modal offer: [barStaffProvider]
/// narrowed to [AppFeature.BarMode] once anyone holds it. The full roster
/// still names who logged each line, and drives the POS user switch.
final barSignInStaffProvider = FutureProvider<List<Tenant>>((ref) async {
  final staff = ref.watch(barStaffProvider.future);
  final grants = await ref.watch(serviceModeGrantsProvider.future);
  return staffForServiceMode(
    await staff,
    grants,
    AppFeature.BarMode,
    isAdminOrOwner: barTenantIsAdmin,
  );
});

/// What Bar Mode needs from the app. Getters resolve on every call because
/// the active strategy can change at runtime; tests override
/// [barServicesProvider] with a subclass.
class BarServices {
  const BarServices();

  LocalStorage get box => ProxyService.box;

  /// Bar Mode runs on Capella (Ditto) only.
  DatabaseSyncInterface get sync => ProxyService.getStrategy(Strategy.capella);

  String? get branchId => box.getBranchId();
}

final barServicesProvider = Provider<BarServices>((ref) => const BarServices());

final barTablesProvider = StreamProvider<List<BarTable>>((ref) {
  final services = ref.watch(barServicesProvider);
  final branchId = services.branchId;
  if (branchId == null) return Stream.value([]);
  return services.sync.barTablesStream(branchId: branchId);
});

final barTabsProvider = StreamProvider<List<ITransaction>>((ref) {
  final services = ref.watch(barServicesProvider);
  final branchId = services.branchId;
  if (branchId == null) return Stream.value([]);
  return services.sync.barTabsStream(branchId: branchId);
});

/// Open loans in the branch, bar and POS alike, overdue first.
final barCreditTabsProvider = StreamProvider<List<ITransaction>>((ref) {
  final services = ref.watch(barServicesProvider);
  final branchId = services.branchId;
  if (branchId == null) return Stream.value([]);
  return services.sync.barCreditTabsStream(branchId: branchId);
});

/// Auto-disposed: it polls every 2 s, and a kept-alive entry per tab ever
/// shown kept polling after the bar floor was left for another mode.
final barTabLinesProvider = StreamProvider.autoDispose
    .family<List<TransactionItem>, String>((ref, txnId) async* {
      final sync = ref.watch(barServicesProvider).sync;
      yield await sync.barTabLines(transactionId: txnId);
      yield* Stream.periodic(
        const Duration(seconds: 2),
        (_) => sync.barTabLines(transactionId: txnId),
      ).asyncMap((f) => f);
    });

bool barTenantIsManager(Tenant tenant) {
  return tenantCanCollectPosPayment(tenant);
}

/// Admin / owner — can manage staff roster (delete, etc.).
bool barTenantIsAdmin(Tenant tenant) {
  final type = tenant.type?.toLowerCase() ?? '';
  return type.contains('admin') || type.contains('owner');
}

/// Stable key for tracking in-flight staff delete on a roster row.
String barStaffDeleteKey(Tenant tenant) =>
    '${tenant.id}|${tenant.userId ?? ''}';

/// Whether [row] is the same staff member as [deleted] (id or user_id).
bool barStaffRowMatchesDeleted(Tenant row, Tenant deleted) {
  if (row.id == deleted.id) return true;
  final deletedUserId = deleted.userId?.trim();
  final rowUserId = row.userId?.trim();
  if (deletedUserId != null &&
      deletedUserId.isNotEmpty &&
      rowUserId == deletedUserId) {
    return true;
  }
  return false;
}

/// Whether [target] may be removed from the staff list (Management Dashboard).
///
/// Caller must already be on an admin-only screen. Blocks self-delete and
/// admin-role rows.
bool barStaffDeleteAllowed({required Tenant target, String? currentUserId}) {
  final targetUserId = target.userId?.trim();
  final viewerUserId = currentUserId?.trim();
  if (viewerUserId != null &&
      targetUserId != null &&
      viewerUserId == targetUserId) {
    return false;
  }
  return (target.type ?? '').trim().toLowerCase() != 'admin';
}

int barColorIndexForTenant(String tenantId, List<Tenant> staff) {
  final idx = staff.indexWhere((t) => t.id == tenantId);
  return idx < 0 ? 0 : idx;
}

Color barColorForTenant(String tenantId, List<Tenant> staff) {
  return Color(barServerColorForIndex(barColorIndexForTenant(tenantId, staff)));
}
