import 'package:tray_manager/tray_manager.dart';

import 'package:flipper_ui/window/window.dart';
import 'package:flipper_services/constants.dart';

/// Manages the system tray icon.
class SystemTrayManager {
  // final AppWindow _window;

  /// The singleton instance of this class.
  static late SystemTrayManager instance;

  SystemTrayManager() {
    instance = this;
  }

  Future<void> initialize() async {
    final String iconPath = (isWindows) //
        ? AppIcons.windowsSymbolic
        : AppIcons.linuxSymbolic;

    await trayManager.setIcon(iconPath);

    final Menu menu = Menu(
      items: [
        // MenuItem(label: 'Show', onClick: (menuItem) => _window.show()),
        // MenuItem(label: 'Hide', onClick: (menuItem) => _window.hide()),
        // MenuItem(label: 'Reset Window', onClick: (_) => _resetWindow()),
        // MenuItem(label: 'Exit', onClick: (menuItem) => _window.close()),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  /// Sets the system tray icon.
  Future<void> setIcon(String iconPath) async {
    await trayManager.setIcon(iconPath);
  }

  /// Reset the window size and position.
  ///
  /// In addition if the window is pinned, it will be unpinned.
  Future<void> _resetWindow() async {
    if (WindowCubit.instance.state.pinned) {
      await WindowCubit.instance.togglePinned();
    }

    // await _window.reset();
  }
}
