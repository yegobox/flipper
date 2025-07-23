import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_services/proxy.dart';

/// A [StateNotifier] that manages the application's mode (e.g., whether it's in proforma or training mode).
/// It exposes a boolean state indicating if the app is in a "normal" operational mode (not proforma and not training).
class AppModeNotifier extends StateNotifier<bool> {
  late StreamSubscription<bool> _proformaModeSubscription;
  late StreamSubscription<bool> _trainingModeSubscription;

  AppModeNotifier() : super(_calculateCurrentMode()) {
    _proformaModeSubscription =
        ProxyService.box.onProformaModeChanged.listen((_) {
      updateMode();
    });
    _trainingModeSubscription =
        ProxyService.box.onTrainingModeChanged.listen((_) {
      updateMode();
    });
  }

  /// Calculates the current app mode based on ProxyService.box settings.
  /// Returns true if the app is NOT in proforma mode AND NOT in training mode.
  static bool _calculateCurrentMode() {
    return !ProxyService.box.isProformaMode() &&
        !ProxyService.box.isTrainingMode();
  }

  /// Updates the app mode. This method should be called whenever
  /// ProxyService.box.isProformaMode() or ProxyService.box.isTrainingMode() changes.
  void updateMode() {
    state = _calculateCurrentMode();
  }

  @override
  void dispose() {
    _proformaModeSubscription.cancel();
    _trainingModeSubscription.cancel();
    super.dispose();
  }
}

/// Provider for the AppModeNotifier.
/// Widgets can watch this provider to react to changes in the app's operational mode.
final appModeProvider = StateNotifierProvider<AppModeNotifier, bool>((ref) {
  return AppModeNotifier();
});
