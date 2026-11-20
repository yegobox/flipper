import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/exceptions.dart';

/// The localized sentence for a signup failure the user can act on, or null
/// when [error] is not one of them (callers keep their own fallback).
///
/// Kept free of widget and service imports so it stays unit-testable.
String? signupKnownErrorText(Object error, [FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  if (error is LoginLinkedToOtherAccountException) {
    return t.signupErrorLoginLinkedToOtherAccount;
  }
  return null;
}
