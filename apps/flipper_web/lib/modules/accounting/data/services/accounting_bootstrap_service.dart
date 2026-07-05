import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Result of server-side accounting bootstrap via data-connector.
class BootstrapAccountingResult {
  const BootstrapAccountingResult({
    required this.seeded,
    required this.alreadyReady,
    this.coaCount = 0,
  });

  factory BootstrapAccountingResult.fromJson(Map<String, dynamic> json) {
    return BootstrapAccountingResult(
      seeded: json['seeded'] == true,
      alreadyReady: json['alreadyReady'] == true,
      coaCount: (json['coaCount'] as num?)?.toInt() ?? 0,
    );
  }

  final bool seeded;
  final bool alreadyReady;
  final int coaCount;
}

class AccountingBootstrapException implements Exception {
  AccountingBootstrapException(this.message, {this.isOffline = false});

  final String message;
  final bool isOffline;

  @override
  String toString() => message;
}

/// Ensures COA, journals, and settings exist server-side before Books opens.
class AccountingBootstrapService {
  AccountingBootstrapService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _defaultBaseUrl;

  static String get _defaultBaseUrl => kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';
 
  final http.Client _client;
  final String _baseUrl;

  Uri get _bootstrapUri => Uri.parse('$_baseUrl/accounting/bootstrap');

  /// Returns when the server reports bootstrap complete (or was already ready).
  Future<BootstrapAccountingResult> ensureBusinessReady(String businessId) async {
    final trimmed = businessId.trim();
    if (trimmed.isEmpty) {
      throw AccountingBootstrapException('businessId is required');
    }

    try {
      final response = await _client.post(
        _bootstrapUri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'businessId': trimmed}),
      );
      _throwIfError(response);
      return BootstrapAccountingResult.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } on AccountingBootstrapException {
      rethrow;
    } catch (e) {
      throw AccountingBootstrapException(
        'Could not reach data-connector at $_baseUrl: $e',
        isOffline: true,
      );
    }
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    String message =
        'Accounting bootstrap failed (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        message = (decoded['error'] as String?) ?? message;
      }
    } catch (_) {}
    throw AccountingBootstrapException(message);
  }
}
