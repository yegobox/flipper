import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the desktop sidebar is showing labels or just icons.
///
/// Collapsed by default. HR has four or five destinations and pages that want
/// the width — a rail names them on hover and gives the roster table back 170
/// pixels, which on a laptop is a column. Anyone who prefers the labels expands
/// it once and the choice sticks.
///
/// Persisted rather than held per-session because it is a preference about the
/// chrome, and a web app re-mounts its shell on every reload.
class HrSidebarCollapsed extends Notifier<bool> {
  static const prefKey = 'flipper_hr_sidebar_collapsed';

  /// Collapsed until storage says otherwise. Read synchronously as the default
  /// so the shell's first frame is never the wrong width — restoring an expanded
  /// sidebar a frame late is a visible jump.
  static const defaultCollapsed = true;

  @override
  bool build() {
    _restore();
    return defaultCollapsed;
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(prefKey);
      if (stored != null && stored != state) state = stored;
    } catch (e) {
      // A preference is not worth a crash: the default already works.
      debugPrint('[flipper_hr] could not read the sidebar preference: $e');
    }
  }

  void toggle() => set(!state);

  void set(bool collapsed) {
    if (collapsed == state) return;
    state = collapsed;
    _persist(collapsed);
  }

  Future<void> _persist(bool collapsed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(prefKey, collapsed);
    } catch (e) {
      debugPrint('[flipper_hr] could not save the sidebar preference: $e');
    }
  }
}

final hrSidebarCollapsedProvider =
    NotifierProvider<HrSidebarCollapsed, bool>(HrSidebarCollapsed.new);
