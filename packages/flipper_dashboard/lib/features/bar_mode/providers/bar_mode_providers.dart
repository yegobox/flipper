import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart' show Color;
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
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

final barStaffProvider = FutureProvider<List<Tenant>>((ref) async {
  return FlipperBaseModel.fetchBarStaffTenants();
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
