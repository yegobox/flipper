import 'dart:convert';

import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:http/http.dart' as http;

/// Holds Supabase writes on the device while [LocalMode] is on.
///
/// Pausing the offline queue is not enough: Brick's queue client logs a write
/// and then sends it at once, so every `optimisticLocal` upsert or delete
/// still reached PostgREST while the device was online. This client sits
/// inside the queue and answers those writes with a synthetic 503, which is
/// in the queue's `reattemptForStatusCodes`. The write therefore stays in the
/// queue and uploads when the owner opts in to cloud sync
/// (`Repository.resumeCloudSync`), and Brick keeps the local row.
///
/// Reads still go out, and so do calls made inside [LocalMode.allowCloud]
/// (the `businesses.sync_mode` record other devices rely on).
class LocalModeHoldClient extends http.BaseClient {
  /// Must be in the queue's `reattemptForStatusCodes`.
  static const int heldStatus = 503;

  static const _pushMethods = {'POST', 'PUT', 'PATCH', 'DELETE'};

  final http.Client _inner;
  final bool Function() _isLocal;

  LocalModeHoldClient(this._inner, {bool Function()? isLocal})
      : _isLocal = isLocal ?? (() => LocalMode.isOn);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!_holds(request)) return _inner.send(request);
    final body = utf8.encode(jsonEncode({
      'code': 'local_mode',
      'message': 'Local mode: kept on this device until cloud sync is on',
      'details': null,
      'hint': null,
    }));
    return http.StreamedResponse(
      Stream.value(body),
      heldStatus,
      request: request,
      headers: const {'content-type': 'application/json'},
    );
  }

  bool _holds(http.BaseRequest request) =>
      _isLocal() &&
      !LocalMode.cloudAllowedHere &&
      _pushMethods.contains(request.method) &&
      request.url.path.startsWith('/rest/v1/');

  @override
  void close() => _inner.close();
}
