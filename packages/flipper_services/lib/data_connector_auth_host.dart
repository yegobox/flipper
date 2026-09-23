import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_services/data_connector_session_service.dart';

/// Lends `flipper_models` the token source only this app can supply.
///
/// Same shape as [registerFlipperPaymentsHost]: the models layer declares a
/// narrow interface, and the host registers an implementation that can reach
/// Firebase and the preference store.
///
/// Idempotent, and safe to call before login — [DataConnectorSessionService]
/// returns no headers until there is a signed-in user, and every client is
/// written to send the request anyway.
///
/// An app that never calls this sends unauthenticated requests, which is what
/// every caller did before this existed and what keeps working while the
/// server is in warn mode.
void registerDataConnectorAuthHost() {
  setDataConnectorAuth(_SessionServiceAuth());
}

/// Forwards the models-layer interface to the real session service.
class _SessionServiceAuth implements DataConnectorAuth {
  @override
  Future<Map<String, String>> authHeaders({required String baseUrl}) =>
      DataConnectorSessionService.authHeaders(baseUrl: baseUrl);

  @override
  Future<void> invalidateAccessToken() =>
      DataConnectorSessionService.invalidateAccessToken();
}
