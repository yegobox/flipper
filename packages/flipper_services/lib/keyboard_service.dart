import 'package:flutter/services.dart';

/// A service that listens for keyboard events and triggers actions based on key combinations.
class KeyboardService {
  static final Map<LogicalKeyboardKey, bool> _pressedKeys = {};

  /// Registers a key press event
  static void handleKeyDown(KeyEvent event) {
    _pressedKeys[event.logicalKey] = true;
  }

  /// Registers a key release event
  static void handleKeyUp(KeyEvent event) {
    _pressedKeys[event.logicalKey] = false;
  }

  /// Checks if a specific key is currently pressed
  static bool isKeyPressed(LogicalKeyboardKey key) {
    return _pressedKeys[key] ?? false;
  }

  /// Determines whether a specific key combination is pressed
  static bool isCombinationPressed({required List<LogicalKeyboardKey> keys}) {
    return keys.every((key) => isKeyPressed(key));
  }

  /// Determines if the Enter key should send a message
  static bool shouldSendMessage() {
    final isEnter = isKeyPressed(LogicalKeyboardKey.enter);
    final isCmdOrCtrl = isKeyPressed(LogicalKeyboardKey.metaLeft) ||
        isKeyPressed(LogicalKeyboardKey.controlLeft);
    return isEnter && isCmdOrCtrl;
  }
}
