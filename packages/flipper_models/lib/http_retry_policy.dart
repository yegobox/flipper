import 'dart:io';

/// Whether a request that threw [error] is worth sending again.
///
/// Mobile data drops connections mid-TLS-handshake often enough that a single
/// failed attempt must not fail a sign-in (RetryClient alone only retries 503
/// responses). A handshake failure means the request never left the phone, so
/// any [method] is safe to resend. Other socket errors can land after the body
/// was sent, so only reads retry on those.
bool isRetryableTransportError(Object error, {required String method}) {
  if (error is HandshakeException) return true;
  if (error is SocketException) return method == 'GET' || method == 'HEAD';
  return false;
}
