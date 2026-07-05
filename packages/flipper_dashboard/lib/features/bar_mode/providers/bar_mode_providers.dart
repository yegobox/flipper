import 'package:flutter/material.dart' show Color;
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

enum BarScreen { lock, tables, pos, settle }

class BarModeState {
  const BarModeState({
    this.screen = BarScreen.lock,
    this.activeCashier,
    this.activeTable,
    this.activeTab,
    this.toastMessage,
    this.showManagerModal = false,
  });

  final BarScreen screen;
  final Tenant? activeCashier;
  final BarTable? activeTable;
  final ITransaction? activeTab;
  final String? toastMessage;
  final bool showManagerModal;

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
    );
  }
}

class BarModeNotifier extends Notifier<BarModeState> {
  @override
  BarModeState build() => const BarModeState();

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

  void elevateManager(Tenant manager) {
    state = state.copyWith(
      activeCashier: manager,
      showManagerModal: false,
      screen: BarScreen.settle,
    );
  }

  void showManagerPin() {
    state = state.copyWith(showManagerModal: true);
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

final barTablesProvider = StreamProvider<List<BarTable>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value([]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).barTablesStream(branchId: branchId);
});

final barTabsProvider = StreamProvider<List<ITransaction>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return Stream.value([]);
  return ProxyService.getStrategy(
    Strategy.capella,
  ).barTabsStream(branchId: branchId);
});

final barTabLinesProvider =
    StreamProvider.family<List<TransactionItem>, String>((ref, txnId) async* {
      final sync = ProxyService.getStrategy(Strategy.capella);
      yield await sync.barTabLines(transactionId: txnId);
      yield* Stream.periodic(
        const Duration(seconds: 2),
        (_) => sync.barTabLines(transactionId: txnId),
      ).asyncMap((f) => f);
    });

bool barTenantIsManager(Tenant tenant) {
  final type = tenant.type?.toLowerCase() ?? '';
  return type.contains('admin') ||
      type.contains('owner') ||
      type.contains('manager');
}

int barColorIndexForTenant(String tenantId, List<Tenant> staff) {
  final idx = staff.indexWhere((t) => t.id == tenantId);
  return idx < 0 ? 0 : idx;
}

Color barColorForTenant(String tenantId, List<Tenant> staff) {
  return Color(barServerColorForIndex(barColorIndexForTenant(tenantId, staff)));
}
