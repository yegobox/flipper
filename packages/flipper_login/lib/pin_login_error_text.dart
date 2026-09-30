import 'dart:async';

import 'package:flipper_models/exceptions.dart';

/// Turns a PIN-login failure into a sentence the user can act on.
///
/// Every message ends with a short code (e.g. `NET`, `HTTP-503`) so a
/// screenshot sent to support says which step failed. Kept free of Flutter
/// and service imports so it stays unit-testable.
String pinLoginErrorText(Object error) {
  if (error is TimeoutException) {
    return 'The Flipper server took too long to answer. Your connection may '
        'be slow. Try again. (TIMEOUT)';
  }
  if (error is NeedSignUpException) {
    return _noAccountForPin;
  }
  if (error is SessionException) {
    return 'Your session expired. Enter your PIN again. (SESSION)';
  }
  if (error is PinError) {
    final status = _httpStatus(error.term);
    if (status != null) return _httpStatusText(status);
    return 'That PIN could not be checked. Try again. (PIN)';
  }

  final raw = error.toString();
  final text = raw.toLowerCase();

  if (text.contains('handshake') ||
      text.contains('certificate') ||
      text.contains('cert_')) {
    return 'Secure connection failed. Make sure your phone\'s date and time '
        'are set automatically, then try again. (TLS)';
  }
  if (text.contains('failed host lookup') ||
      text.contains('no address associated')) {
    return 'Can\'t find the Flipper server. Your internet may be off or '
        'limited. Check mobile data or Wi-Fi. (DNS)';
  }
  if (text.contains('timed out') || text.contains('timeout')) {
    return 'The Flipper server took too long to answer. Your connection may '
        'be slow. Try again. (TIMEOUT)';
  }
  if (text.contains('network is unreachable') ||
      text.contains('no route to host') ||
      text.contains('connection refused') ||
      text.contains('connection reset') ||
      text.contains('connection closed') ||
      text.contains('failed to connect') ||
      text.contains('socketexception') ||
      text.contains('clientexception')) {
    return 'Couldn\'t reach the Flipper server. Check your internet '
        'connection and try again. (NET)';
  }

  final status = _httpStatus(raw);
  if (status != null) return _httpStatusText(status);

  final detail = raw
      .replaceFirst(RegExp(r'^(Exception|Error):\s*'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (detail.isEmpty || detail.startsWith('Instance of')) {
    return 'Sign-in failed for an unknown reason. Try again. (UNKNOWN)';
  }
  final short = detail.length > 140 ? '${detail.substring(0, 140)}…' : detail;
  return 'Sign-in failed: $short';
}

const String _noAccountForPin =
    'No account uses this PIN. Check the PIN and try again. (PIN-404)';

int? _httpStatus(String text) {
  final match = RegExp(r'HTTP (\d{3})').firstMatch(text);
  return match == null ? null : int.parse(match.group(1)!);
}

String _httpStatusText(int status) {
  if (status == 404) return _noAccountForPin;
  if (status == 429) {
    return 'Too many attempts. Wait a minute, then try again. (HTTP-429)';
  }
  if (status == 401 || status == 403) {
    return 'The Flipper server refused this request. Update the app and try '
        'again. (HTTP-$status)';
  }
  if (status >= 500) {
    return 'Flipper servers are having trouble right now. Try again in a '
        'minute. (HTTP-$status)';
  }
  return 'The Flipper server could not check this PIN. Try again. '
      '(HTTP-$status)';
}
