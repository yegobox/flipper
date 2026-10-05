import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

/// The operating system's on-screen keyboard.
abstract class TouchKeyboard {
  void show();
  void hide();
}

/// The part of the view the on-screen keyboard covers, in logical pixels, or
/// null while it is hidden. Only ever set on Windows; see [KeyboardPan].
final ValueNotifier<Rect?> keyboardOcclusion = ValueNotifier<Rect?>(null);

/// The Windows touch keyboard, driven by the runner
/// (`windows/runner/touch_keyboard.cpp`) over `flipper/touch_keyboard`.
class WindowsTouchKeyboard implements TouchKeyboard {
  static const _channel = MethodChannel('flipper/touch_keyboard');

  /// Call once the binding's messenger exists.
  void listen() => _channel.setMethodCallHandler(_handleCall);

  @override
  void show() => unawaited(_invoke('show'));

  @override
  void hide() => unawaited(_invoke('hide'));

  Future<void> _invoke(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } catch (e) {
      // Never let the keyboard hook get in the way of typing.
      debugPrint('Touch keyboard: $e');
    }
  }

  Future<void> _handleCall(MethodCall call) async {
    if (call.method != 'occluded') return;
    final rect = call.arguments;
    if (rect is! Map) {
      keyboardOcclusion.value = null;
      return;
    }
    // The runner reports physical pixels of the Flutter view.
    final ratio =
        PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 1;
    double side(String key) => ((rect[key] as num?) ?? 0).toDouble() / ratio;
    keyboardOcclusion.value = Rect.fromLTRB(
      side('left'),
      side('top'),
      side('right'),
      side('bottom'),
    );
  }
}

/// Decides when the on-screen keyboard should open, from the same
/// `flutter/textinput` calls the framework sends the engine.
///
/// The Windows engine treats `TextInput.show` and `TextInput.hide` as no-ops.
/// Windows opens its touch keyboard by itself only when a touch moves focus
/// *into* a text field, so tapping a field that already has focus (POS
/// Received Amount is focused on load) never raised it. This replays the two
/// calls against [TouchKeyboard], and only for show requests that follow a
/// finger or pen press, so mouse and keyboard users never see it.
class TouchKeyboardTextInputTracker {
  TouchKeyboardTextInputTracker(this._keyboard);

  final TouchKeyboard _keyboard;

  PointerDeviceKind? _lastPointerKind;
  bool _clientWantsKeyboard = false;
  bool _shown = false;

  void handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) _lastPointerKind = event.kind;
  }

  void handleTextInputCall(MethodCall call) {
    switch (call.method) {
      case 'TextInput.setClient':
        final args = call.arguments as List<dynamic>;
        _clientWantsKeyboard = _wantsKeyboard(args[1]);
      case 'TextInput.updateConfig':
        _clientWantsKeyboard = _wantsKeyboard(call.arguments);
      case 'TextInput.clearClient':
        _clientWantsKeyboard = false;
      case 'TextInput.show':
        if (_clientWantsKeyboard && _lastPressWasTouch) {
          _shown = true;
          _keyboard.show();
        }
      case 'TextInput.hide':
        // Leave a keyboard the user opened from the taskbar alone.
        if (_shown) {
          _shown = false;
          _keyboard.hide();
        }
    }
  }

  bool get _lastPressWasTouch => switch (_lastPointerKind) {
        PointerDeviceKind.touch ||
        PointerDeviceKind.stylus ||
        PointerDeviceKind.invertedStylus =>
          true,
        _ => false,
      };

  /// Read-only fields and [TextInputType.none] fields (which draw their own
  /// keypad, like PIN login) never get the system keyboard.
  static bool _wantsKeyboard(Object? configuration) {
    if (configuration is! Map) return false;
    if (configuration['readOnly'] == true) return false;
    final inputType = configuration['inputType'];
    final name = inputType is Map ? inputType['name'] : null;
    return name != 'TextInputType.none';
  }
}

/// Forwards everything to the engine's messenger, letting
/// [TouchKeyboardTextInputTracker] read text input calls on the way out.
class _TextInputSniffingMessenger implements BinaryMessenger {
  _TextInputSniffingMessenger(this._inner, this._tracker);

  final BinaryMessenger _inner;
  final TouchKeyboardTextInputTracker _tracker;

  static final String _channel = SystemChannels.textInput.name;
  static final MethodCodec _codec = SystemChannels.textInput.codec;

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    if (channel == _channel && message != null) {
      try {
        _tracker.handleTextInputCall(_codec.decodeMethodCall(message));
      } catch (e) {
        // Never let the keyboard hook get in the way of typing.
        debugPrint('Touch keyboard: $e');
      }
    }
    return _inner.send(channel, message);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) =>
      _inner.setMessageHandler(channel, handler);

  @override
  // ignore: deprecated_member_use
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? data,
    PlatformMessageResponseCallback? callback,
  ) =>
      // ignore: deprecated_member_use
      _inner.handlePlatformMessage(channel, data, callback);
}

/// [WidgetsFlutterBinding] plus the Windows touch keyboard hook.
class FlipperWidgetsBinding extends WidgetsFlutterBinding {
  FlipperWidgetsBinding._(this._keyboard)
      : _tracker = TouchKeyboardTextInputTracker(_keyboard);

  final WindowsTouchKeyboard _keyboard;
  final TouchKeyboardTextInputTracker _tracker;

  /// Use in place of [WidgetsFlutterBinding.ensureInitialized]. Installs the
  /// hook on Windows only, and only when no binding exists yet (integration
  /// tests bring their own).
  static WidgetsBinding ensureInitialized() {
    if (!kIsWeb && UniversalPlatform.isWindows && !_hasBinding) {
      FlipperWidgetsBinding._(WindowsTouchKeyboard());
    }
    return WidgetsFlutterBinding.ensureInitialized();
  }

  static bool get _hasBinding {
    try {
      WidgetsBinding.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void initInstances() {
    super.initInstances();
    pointerRouter.addGlobalRoute(_tracker.handlePointerEvent);
    _keyboard.listen();
  }

  @override
  BinaryMessenger createBinaryMessenger() =>
      _TextInputSniffingMessenger(super.createBinaryMessenger(), _tracker);
}
