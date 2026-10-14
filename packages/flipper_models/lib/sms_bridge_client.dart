import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

/// A one-time code that pairs an SMS Bridge phone with this branch.
class SmsBridgePairing {
  const SmsBridgePairing({
    required this.code,
    required this.displayCode,
    required this.expiresAt,
    required this.qrPayload,
  });

  final String code;

  /// The code with a dash, for typing on the phone.
  final String displayCode;
  final DateTime expiresAt;

  /// What the QR encodes: the connector URL and the code
  /// (`apps/flipper_sms_bridge/core/.../PairingPayload.kt` parses it).
  final String qrPayload;
}

/// A paired phone, as listed in Settings → SMS Bridge.
class SmsBridgeDevice {
  const SmsBridgeDevice({
    required this.deviceId,
    this.label,
    this.branchId,
    this.createdAt,
    this.lastSeenAt,
  });

  final String deviceId;
  final String? label;
  final String? branchId;
  final DateTime? createdAt;

  /// Last time the phone uploaded (or tried to). Null before its first upload.
  final DateTime? lastSeenAt;

  factory SmsBridgeDevice.fromJson(Map<String, dynamic> json) =>
      SmsBridgeDevice(
        deviceId: json['deviceId'] as String? ?? '',
        label: json['label'] as String?,
        branchId: json['branchId'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
        lastSeenAt: DateTime.tryParse(json['lastSeenAt'] as String? ?? ''),
      );
}

class SmsBridgeException implements Exception {
  const SmsBridgeException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Builds the pairing QR payload. The phone talks to the same connector as
/// this Flipper install, so a staging Flipper pairs a phone with staging.
String smsBridgeQrPayload({required String baseUrl, required String code}) {
  final url = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  return 'flipper-sms-bridge://pair?v=1'
      '&url=${Uri.encodeComponent(url)}'
      '&code=${Uri.encodeComponent(code)}';
}

/// Client for the connector's SMS Bridge management routes
/// (`data-connector/src/api/sms_bridge.rs`).
///
/// The business and branch are never sent: the connector takes them from
/// this device's token, so a till can only pair phones with its own branch.
class SmsBridgeClient {
  SmsBridgeClient({
    required Future<String> Function() baseUrl,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 20),
  }) : _baseUrl = baseUrl,
       _http = httpClient,
       _timeout = timeout;

  final Future<String> Function() _baseUrl;
  final http.Client? _http;
  final Duration _timeout;

  Future<SmsBridgePairing> createPairing({String? label}) async {
    final base = await _normalizedBase();
    final body = await _send(
      base,
      (client) => client.post(
        Uri.parse('${base}api/sms-bridge/pairings'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (label != null && label.trim().isNotEmpty) 'label': label.trim(),
        }),
      ),
    );
    final code = body['code'] as String? ?? '';
    final expiresAt = DateTime.tryParse(body['expiresAt'] as String? ?? '');
    if (code.isEmpty || expiresAt == null) {
      throw const SmsBridgeException('Unexpected response from the server.');
    }
    return SmsBridgePairing(
      code: code,
      displayCode: body['displayCode'] as String? ?? code,
      expiresAt: expiresAt,
      qrPayload: smsBridgeQrPayload(baseUrl: base, code: code),
    );
  }

  Future<List<SmsBridgeDevice>> listDevices() async {
    final base = await _normalizedBase();
    final body = await _send(
      base,
      (client) => client.get(Uri.parse('${base}api/sms-bridge/devices')),
    );
    final devices = body['devices'];
    if (devices is! List) return const [];
    return [
      for (final d in devices)
        if (d is Map<String, dynamic>) SmsBridgeDevice.fromJson(d),
    ].where((d) => d.deviceId.isNotEmpty).toList();
  }

  Future<void> revoke(String deviceId) async {
    final base = await _normalizedBase();
    await _send(
      base,
      (client) => client.delete(
        Uri.parse(
          '${base}api/sms-bridge/devices/${Uri.encodeComponent(deviceId)}',
        ),
      ),
    );
  }

  Future<String> _normalizedBase() async {
    final base = await _baseUrl();
    return base.endsWith('/') ? base : '$base/';
  }

  Future<Map<String, dynamic>> _send(
    String base,
    Future<http.Response> Function(http.Client client) call,
  ) async {
    final client = DataConnectorClient(baseUrl: base, inner: _http);
    final http.Response response;
    try {
      response = await call(client).timeout(_timeout);
    } on TimeoutException {
      throw const SmsBridgeException(
        'The server took too long to answer. Check the connection and try again.',
      );
    } finally {
      client.close();
    }
    final body = decodeJsonObject(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = body?['error'];
      throw SmsBridgeException(
        error is String && error.isNotEmpty
            ? error
            : 'Request failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    return body ?? const {};
  }
}
