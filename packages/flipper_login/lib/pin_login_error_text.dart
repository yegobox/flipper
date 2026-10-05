import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/exceptions.dart';

/// Turns a PIN-login failure into a sentence the user can act on.
///
/// Every message ends with a short code (e.g. `NET`, `HTTP-503`) so a
/// screenshot sent to support says which step failed. The codes stay the same
/// in every language. Matching happens on the raw exception text; only the
/// returned message is localized ([l10n] defaults to [FlipperL10n.current]).
/// Kept free of widget and service imports so it stays unit-testable.
String pinLoginErrorText(Object error, [FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  if (error is TimeoutException) {
    return t.loginErrorTimeout;
  }
  if (error is NeedSignUpException) {
    return t.loginErrorNoAccountForPin;
  }
  if (error is SessionException) {
    return t.loginErrorSessionExpired;
  }
  if (error is PinError) {
    final status = _httpStatus(error.term);
    if (status != null) return _httpStatusText(t, status, pinLookup: true);
    return t.loginErrorPinCheckFailed;
  }

  if (error is FormatException) {
    return t.loginErrorBadResponse;
  }

  final raw = error.toString();
  final text = raw.toLowerCase();

  // Only a certificate rejection can be the phone clock. The app's own
  // HttpClient accepts any certificate, so a bare handshake failure there is
  // the network dropping the connection before it was secured.
  if (text.contains('certificate') || text.contains('cert_')) {
    return t.loginErrorTls;
  }
  if (text.contains('handshake')) {
    return t.loginErrorTlsNetwork;
  }
  if (text.contains('failed host lookup') ||
      text.contains('no address associated')) {
    return t.loginErrorDns;
  }
  if (text.contains('timed out') || text.contains('timeout')) {
    return t.loginErrorTimeout;
  }
  if (text.contains('network is unreachable') ||
      text.contains('no route to host') ||
      text.contains('connection refused') ||
      text.contains('connection reset') ||
      text.contains('connection closed') ||
      text.contains('failed to connect') ||
      text.contains('socketexception') ||
      text.contains('clientexception')) {
    return t.loginErrorNetwork;
  }

  final status = _httpStatus(raw);
  if (status != null) {
    // The OTP request is keyed by PIN: the server 404s it only when no PIN
    // row matches, so that 404 does mean "unknown PIN".
    return _httpStatusText(
      t,
      status,
      pinLookup: raw.contains('Failed to request OTP'),
    );
  }

  if (text.contains('authenticate offline')) {
    return t.loginErrorOfflineFirst;
  }

  // Raw exception text can carry response bodies or internals; it is already
  // logged (GlobalErrorHandler + Sentry), so the user gets a stable message.
  return t.loginErrorUnknown;
}

int? _httpStatus(String text) {
  final match = RegExp(r'HTTP (\d{3})').firstMatch(text);
  return match == null ? null : int.parse(match.group(1)!);
}

/// [pinLookup] marks responses to a PIN-keyed request, where 404 means no
/// account has that PIN. Any other 404 gets a neutral message.
String _httpStatusText(
  FlipperAppLocalizations t,
  int status, {
  bool pinLookup = false,
}) {
  if (status == 404) {
    return pinLookup ? t.loginErrorNoAccountForPin : t.loginErrorHttp404;
  }
  if (status == 429) {
    return t.loginErrorHttp429;
  }
  if (status == 401 || status == 403) {
    return t.loginErrorHttpRefused('$status');
  }
  if (status >= 500) {
    return t.loginErrorHttpServer('$status');
  }
  return t.loginErrorHttpOther('$status');
}
