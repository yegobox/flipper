import 'dart:async';

import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

//
// Navigation state providers
final selectedMenuItemProvider = StateProvider<int>(
  (ref) => -1,
); // -1 represents the Apps screen
final defaultAppProvider = StateProvider<String?>((ref) => null);
final isDefaultAppLoadedProvider = StateProvider<bool>((ref) => false);

final featuresProvider = StreamProvider<List<String>>((ref) {
  final controller = StreamController<List<String>>();
  final appService = ProxyService.app;

  void listener() {
    controller.add(appService.features);
  }

  appService.addListener(listener);
  controller.add(appService.features);

  ref.onDispose(() {
    appService.removeListener(listener);
    controller.close();
  });

  return controller.stream;
});

final hasFeatureProvider = Provider.family<bool, String>((ref, featureName) {
  final featuresAsync = ref.watch(featuresProvider);
  return featuresAsync.when(
    data: (features) => features.contains(featureName),
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Write/admin access for the signed-in user (same rules as [featureAccessProvider]).
bool userHasFeatureWriteAccess(Ref ref, String featureName) {
  final uid = ProxyService.box.getUserId() ?? '';
  if (uid.isEmpty) return false;
  return ref.watch(
    featureAccessProvider(userId: uid, featureName: featureName),
  );
}

/// Branch has subscription capability **and** user has a matching module permission.
final sideMenuShowItemsProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('INVENTORY'))) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Reports) ||
      userHasFeatureWriteAccess(ref, AppFeature.Inventory);
});

final sideMenuShowKdsProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('KDS'))) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Tickets);
});

final sideMenuShowStockRecountProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('INVENTORY'))) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Stock);
});

final sideMenuShowDelegationsProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('PRINTING_DELEGATION'))) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Settings) ||
      userHasFeatureWriteAccess(ref, AppFeature.Sales);
});

final sideMenuShowIncomingOrdersProvider = Provider<bool>((ref) {
  final branchOk = ref.watch(hasFeatureProvider('ORDERING')) ||
      ref.watch(hasFeatureProvider('INVENTORY'));
  if (!branchOk) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Orders) ||
      userHasFeatureWriteAccess(ref, AppFeature.Sales) ||
      userHasFeatureWriteAccess(ref, AppFeature.Inventory);
});

final sideMenuShowProductionProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('MANUFACTURING'))) return false;
  return userHasFeatureWriteAccess(ref, AppFeature.Inventory) ||
      userHasFeatureWriteAccess(ref, AppFeature.Sales);
});

final sideMenuShowShiftHistoryProvider = Provider<bool>((ref) {
  if (!ref.watch(hasFeatureProvider('SHIFT_HISTORY'))) return false;
  final uid = ProxyService.box.getUserId() ?? '';
  if (uid.isEmpty) return false;
  final adminAsync = ref.watch(
    isAdminProvider(uid, featureName: AppFeature.ShiftHistory),
  );
  return adminAsync.maybeWhen(
    data: (v) => v == true,
    orElse: () => false,
  );
});
