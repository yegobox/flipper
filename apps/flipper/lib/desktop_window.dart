import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

/// The slice of the native desktop window that startup touches.
///
/// Kept behind an interface so [maximizeOnLaunch] can be unit tested with a
/// fake; the real window is checked by
/// `integration_test/desktop_window_maximized_test.dart`.
abstract class DesktopWindow {
  Future<void> ensureInitialized();
  Future<void> maximize();
  Future<bool> isMaximized();
}

class WindowManagerDesktopWindow implements DesktopWindow {
  const WindowManagerDesktopWindow();

  @override
  Future<void> ensureInitialized() => windowManager.ensureInitialized();

  @override
  Future<void> maximize() => windowManager.maximize();

  @override
  Future<bool> isMaximized() => windowManager.isMaximized();
}

bool get _isDesktop =>
    !kIsWeb &&
    (UniversalPlatform.isWindows ||
        UniversalPlatform.isMacOS ||
        UniversalPlatform.isLinux);

/// Opens the desktop app maximized (fills the screen, keeps the title bar and
/// taskbar / menu bar) instead of the runner's default 1280×720 window.
///
/// A no-op on mobile and web. Never throws: a window-plugin failure must not
/// block startup, the app just opens at its default size.
Future<void> maximizeOnLaunch({DesktopWindow? window, bool? isDesktop}) async {
  if (!(isDesktop ?? _isDesktop)) return;
  final target = window ?? const WindowManagerDesktopWindow();
  try {
    await target.ensureInitialized();
    await target.maximize();
  } catch (e) {
    debugPrint('⚠️ [window] could not maximize on launch: $e');
  }
}
