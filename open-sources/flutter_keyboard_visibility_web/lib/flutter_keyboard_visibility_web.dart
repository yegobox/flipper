import 'package:flutter_keyboard_visibility_platform_interface/flutter_keyboard_visibility_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

/// The web implementation of the [FlutterKeyboardVisibilityPlatform] of the
/// FlutterKeyboardVisibility plugin.
///
/// This is a wasm-compatible reimplementation of the upstream
/// `flutter_keyboard_visibility_web` 2.0.0 package, which imports `dart:html`
/// and therefore fails to compile with `dart2wasm`. It uses `package:web`
/// instead. The behaviour is identical to upstream (web keyboard visibility is
/// not implemented, so `onChange` always emits `false`).
class FlutterKeyboardVisibilityPlugin
    extends FlutterKeyboardVisibilityPlatform {
  /// Constructs a [FlutterKeyboardVisibilityPlugin].
  FlutterKeyboardVisibilityPlugin(web.Navigator navigator);

  /// Factory method that initializes the FlutterKeyboardVisibility plugin
  /// platform with an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    FlutterKeyboardVisibilityPlatform.instance =
        FlutterKeyboardVisibilityPlugin(web.window.navigator);
  }

  /// Emits changes to keyboard visibility from the platform. Web is not
  /// implemented yet so false is returned.
  @override
  Stream<bool> get onChange async* {
    yield false;
  }
}
