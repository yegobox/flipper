import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flipper_models/data_connector_http_log.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:http/http.dart' as http;

/// Production data-connector base URL (same default as Flo / accounting clients).
const String kDataConnectorProdBaseUrl = 'https://data-connector.yegobox.com/';

/// Resolves data-connector URL for QR login relay.
///
/// Order: EBM `dataConnectorUrl` → release prod host → local dev default.
Future<String> resolveQrLoginDataConnectorUrl({String? dataConnectorUrl}) async {
  final configured = dataConnectorUrl?.trim();
  if (configured != null && configured.isNotEmpty) {
    return configured.endsWith('/') ? configured : '$configured/';
  }
  if (kReleaseMode) {
    return kDataConnectorProdBaseUrl;
  }
  return 'http://127.0.0.1:8084/';
}

/// Publishes a QR desktop-login event via data-connector so it reaches Ditto Cloud.
///
/// Phone → Ditto direct writes often stay on-device (different auth identity);
/// the connector upserts with a subscribed service peer — visible in Ditto Portal
/// and on desktop `login-*` channel observers.
Future<String> publishQrLoginEventViaDataConnector({
  required String baseUrl,
  required Map<String, dynamic> loginDetails,
  http.Client? client,
}) async {
  final channel = loginDetails['channel']?.toString().trim() ?? '';
  if (channel.isEmpty) {
    throw ArgumentError('loginDetails must include channel');
  }

  final eventId =
      '${channel}_${DateTime.now().millisecondsSinceEpoch}';
  final body = <String, dynamic>{
    ...loginDetails,
    '_id': eventId,
    'type': loginDetails['type'] ?? 'broadcast',
    'timestamp': DateTime.now().toIso8601String(),
  };

  final normalizedBase =
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  final uri = Uri.parse('${normalizedBase}api/events/qr-login');
  final encoded = jsonEncode(body);

  DataConnectorHttpLog.request(
    method: 'POST',
    uri: uri,
    body: encoded,
    operation: 'qr-login',
  );

  final response = await (client ?? http.Client())
      .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: encoded,
      )
      .timeout(const Duration(seconds: 30));

  DataConnectorHttpLog.response(
    method: 'POST',
    uri: uri,
    statusCode: response.statusCode,
    body: response.body,
    operation: 'qr-login',
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
      'QR login relay failed (${response.statusCode}): ${response.body}',
    );
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final id = data['id']?.toString() ?? eventId;
  talker.info('QR login event relayed via data-connector (id: $id, channel: $channel)');
  return id;
}