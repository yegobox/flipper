import 'package:flipper_models/notifications_client.dart';
import 'package:flipper_payments/flipper_payments.dart' show paymentsApiBaseUrl;

/// A [NotificationsClient] aimed at the connector the payment rails use.
///
/// `/api/notify/*` is served by the same data-connector as `/v2/api/*` and
/// `/api/dodo/*`, so it is resolved the same way: `paymentsApiBaseUrl()` reads
/// `Ebm.dataConnectorUrl` from the Capella replica and falls back to
/// [kPaymentsApiBaseUrl]. The old `resolveEbmDataConnectorUrl` lookup went
/// through the default strategy and the box cache instead, so a quotation
/// could be sent to a different (or no) host than the one this device enrolled
/// with — and the request left without the bearer token the connector
/// requires.
///
/// The client wraps `DataConnectorClient`, which attaches that token.
Future<NotificationsClient> createBranchNotificationsClient() async =>
    createNotificationsClient(dataConnectorUrl: await paymentsApiBaseUrl());
