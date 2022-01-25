import 'package:flipper_web/web_view.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'package:system_theme/system_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:url_strategy/url_strategy.dart';

// import 'package:flipper_services/locator.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';

const String appTitle = '';

late bool darkMode;

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await GetStorage.init();
  // await Firebase.initializeApp();
  // done init in mobile.//done separation.
  // setupLocator();

  setPathUrlStrategy();

  // The platforms the plugin support (01/04/2021 - DD/MM/YYYY):
  //   - Windows
  //   - Web
  //   - Android
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  if (!kIsWeb &&
      [TargetPlatform.windows, TargetPlatform.linux]
          .contains(defaultTargetPlatform)) {
    await Window.initialize();
  }

  runApp(WebView(darkMode: darkMode));

  if (isDesktop) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = const Size(410, 540);
      win.size = const Size(755, 545);
      win.alignment = Alignment.center;
      win.title = appTitle;
      win.show();
    });
  }
}
