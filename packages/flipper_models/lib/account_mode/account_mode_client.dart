import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

class AccountModeException implements Exception {
  const AccountModeException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// What the connector reports after a read or a switch.
class AccountModeResult {
  const AccountModeResult({
    required this.mode,
    this.changedAt,
    this.cardSubscriptionPaused,
  });

  final AccountMode mode;
  final DateTime? changedAt;

  /// After a switch to personal with a live card subscription: whether the
  /// connector paused it. `false` means the user must pause it in Billing.
  final bool? cardSubscriptionPaused;

  factory AccountModeResult.fromJson(Map<String, dynamic> json) =>
      AccountModeResult(
        mode: parseAccountMode(json['mode']),
        changedAt: DateTime.tryParse(json['changed_at'] as String? ?? ''),
        cardSubscriptionPaused: json['card_subscription_paused'] as bool?,
      );
}

/// Client for `GET/POST /api/account-mode`
/// (`data-connector/src/api/account_mode.rs`).
///
/// The business is never sent: the connector takes it from this device's
/// token, so a device can only switch its own business.
class AccountModeClient {
  AccountModeClient({
    required Future<String> Function() baseUrl,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 20),
  }) : _baseUrl = baseUrl,
       _http = httpClient,
       _timeout = timeout;

  final Future<String> Function() _baseUrl;
  final http.Client? _http;
  final Duration _timeout;

  Future<AccountModeResult> read({Duration? timeout}) async {
    final base = await _normalizedBase();
    final body = await _send(
      base,
      (c) => c.get(Uri.parse('${base}api/account-mode')),
      timeout ?? _timeout,
    );
    return AccountModeResult.fromJson(body);
  }

  Future<AccountModeResult> switchTo(AccountMode mode) async {
    final base = await _normalizedBase();
    final body = await _send(
      base,
      (c) => c.post(
        Uri.parse('${base}api/account-mode'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'mode': mode.value}),
      ),
      _timeout,
    );
    final result = AccountModeResult.fromJson(body);
    if (result.mode != mode) {
      throw const AccountModeException(
        'The change could not be saved. Try again later.',
      );
    }
    return result;
  }

  Future<String> _normalizedBase() async {
    final base = await _baseUrl();
    return base.endsWith('/') ? base : '$base/';
  }

  Future<Map<String, dynamic>> _send(
    String base,
    Future<http.Response> Function(http.Client client) call,
    Duration timeout,
  ) async {
    final client = DataConnectorClient(baseUrl: base, inner: _http);
    final http.Response response;
    try {
      response = await call(client).timeout(timeout);
    } on TimeoutException {
      throw const AccountModeException(
        'The server took too long to answer. Check the connection and try again.',
      );
    } on http.ClientException {
      throw const AccountModeException(
        'Could not reach the server. Check the connection and try again.',
      );
    } finally {
      client.close();
    }
    final body = decodeJsonObject(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = body?['error'];
      throw AccountModeException(
        error is String && error.isNotEmpty
            ? error
            : 'Request failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    return body ?? const {};
  }
}
