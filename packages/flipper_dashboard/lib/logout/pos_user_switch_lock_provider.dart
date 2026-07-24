import 'package:flutter_riverpod/legacy.dart';

/// When true, POS sales UI is replaced by the staff + PIN lock screen
/// (bar-mode-style handoff). Cleared after a successful PIN login.
final posUserSwitchLockProvider = StateProvider<bool>((ref) => false);
