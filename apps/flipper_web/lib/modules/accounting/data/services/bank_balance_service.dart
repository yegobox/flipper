import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

/// The newest balance one bank or wallet account stated in an SMS.
class SmsAccountBalance {
  const SmsAccountBalance({
    required this.bankAccountCode,
    required this.providerLabel,
    required this.balance,
    required this.observedAt,
    this.ownAccount,
    this.stale = false,
  });

  factory SmsAccountBalance.fromJson(Map<String, dynamic> json) {
    return SmsAccountBalance(
      bankAccountCode: json['bankAccountCode'] as String? ?? '',
      providerLabel: json['providerLabel'] as String? ?? '',
      ownAccount: json['ownAccount'] as String?,
      balance: (json['balance'] as num?)?.round() ?? 0,
      observedAt:
          DateTime.tryParse(json['observedAt'] as String? ?? '')?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      stale: json['stale'] as bool? ?? false,
    );
  }

  final String bankAccountCode;
  final String providerLabel;

  /// Masked by the server to the last 4 digits (`****0042`).
  final String? ownAccount;
  final int balance;
  final DateTime observedAt;

  /// No SMS for this account in over a week.
  final bool stale;

  String get label =>
      ownAccount == null ? providerLabel : '$providerLabel $ownAccount';
}

/// Bank (1020) or Mobile Money (1030) summed over its accounts.
class SmsBalanceTotal {
  const SmsBalanceTotal({
    required this.bankAccountCode,
    required this.balance,
    required this.observedAt,
    this.stale = false,
  });

  factory SmsBalanceTotal.fromJson(Map<String, dynamic> json) {
    return SmsBalanceTotal(
      bankAccountCode: json['bankAccountCode'] as String? ?? '',
      balance: (json['balance'] as num?)?.round() ?? 0,
      observedAt:
          DateTime.tryParse(json['observedAt'] as String? ?? '')?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      stale: json['stale'] as bool? ?? false,
    );
  }

  final String bankAccountCode;
  final int balance;
  final DateTime observedAt;
  final bool stale;
}

/// What `GET /api/bank-balances` returns: balances bank and MoMo SMS stated,
/// kept server-side. Only the business owner or an Admin may read them.
class SmsBalances {
  const SmsBalances({this.accounts = const [], this.totals = const []});

  factory SmsBalances.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(String key) =>
        ((json[key] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
    return SmsBalances(
      accounts: rows('accounts').map(SmsAccountBalance.fromJson).toList(),
      totals: rows('totals').map(SmsBalanceTotal.fromJson).toList(),
    );
  }

  final List<SmsAccountBalance> accounts;
  final List<SmsBalanceTotal> totals;

  SmsBalanceTotal? totalFor(String bankAccountCode) {
    for (final t in totals) {
      if (t.bankAccountCode == bankAccountCode) return t;
    }
    return null;
  }

  List<SmsAccountBalance> accountsFor(String bankAccountCode) =>
      accounts.where((a) => a.bankAccountCode == bankAccountCode).toList();
}

/// A low-balance alert level for Bank (1020) or Mobile Money (1030).
class SmsBalanceAlert {
  const SmsBalanceAlert({
    required this.bankAccountCode,
    required this.threshold,
    this.enabled = true,
  });

  factory SmsBalanceAlert.fromJson(Map<String, dynamic> json) {
    return SmsBalanceAlert(
      bankAccountCode: json['bankAccountCode'] as String? ?? '',
      threshold: (json['threshold'] as num?)?.round() ?? 0,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  final String bankAccountCode;
  final int threshold;
  final bool enabled;
}

class BankBalanceException implements Exception {
  BankBalanceException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Reads the balances bank and MoMo SMS state, and the owner's low-balance
/// alert levels, from the data-connector.
///
/// The connector answers only the business owner or an Admin (403 for anyone
/// else, 404 on a server that predates the route): both read as "nothing to
/// show", so the balance check simply does not appear for them.
class BankBalanceService {
  BankBalanceService({http.Client? client, String? baseUrl})
    : _baseUrl = baseUrl ?? _defaultBaseUrl,
      _client =
          client ?? DataConnectorClient(baseUrl: baseUrl ?? _defaultBaseUrl);

  static String get _defaultBaseUrl => kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';

  final String _baseUrl;
  final http.Client _client;

  static const _notShown = {401, 403, 404};

  Future<Map<String, dynamic>?> _get(String path) async {
    final response = await _client.get(Uri.parse('$_baseUrl$path'));
    if (_notShown.contains(response.statusCode)) return null;
    if (response.statusCode != 200) {
      throw BankBalanceException(
        'Reading $path failed (${response.statusCode})',
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// `null` when this user may not see balances.
  Future<SmsBalances?> balances() async {
    final json = await _get('/api/bank-balances');
    return json == null ? null : SmsBalances.fromJson(json);
  }

  /// Alert levels by account code; empty when none are set or the user may
  /// not see them.
  Future<Map<String, SmsBalanceAlert>> alerts() async {
    final json = await _get('/api/bank-balances/alerts');
    final rows = ((json?['alerts'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SmsBalanceAlert.fromJson);
    return {for (final a in rows) a.bankAccountCode: a};
  }

  Future<void> setAlert({
    required String bankAccountCode,
    required int threshold,
    bool enabled = true,
  }) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/api/bank-balances/alerts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'bankAccountCode': bankAccountCode,
        'threshold': threshold,
        'enabled': enabled,
      }),
    );
    if (response.statusCode != 200) {
      var message = 'Saving the alert level failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = (body['error'] as String?) ?? message;
      } catch (_) {}
      throw BankBalanceException(message);
    }
  }
}
