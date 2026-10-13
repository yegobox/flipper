import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:http/http.dart' as http;

/// The movements `POST /api/cash-movements/reset` can clear.
enum CashMovementKind {
  cashIn('cash_in'),
  cashOut('cash_out');

  const CashMovementKind(this.wire);

  /// The value the connector expects in `kinds`.
  final String wire;
}

/// Count and total of one kind in a reset.
class CashResetKindTotals {
  const CashResetKindTotals({required this.count, required this.amount});

  final int count;
  final double amount;

  static const empty = CashResetKindTotals(count: 0, amount: 0);
}

/// What a reset would delete (`dryRun`) or did delete (`deleted`).
class CashResetSummary {
  const CashResetSummary({
    required this.businessName,
    required this.dryRun,
    required this.deleted,
    required this.transactions,
    required this.journalEntries,
    required this.totalAmount,
    required this.byKind,
  });

  /// What the user must type to confirm; the connector checks the same value.
  final String businessName;
  final bool dryRun;
  final bool deleted;
  final int transactions;
  final int journalEntries;
  final double totalAmount;
  final Map<CashMovementKind, CashResetKindTotals> byKind;

  CashResetKindTotals totalsFor(CashMovementKind kind) =>
      byKind[kind] ?? CashResetKindTotals.empty;

  factory CashResetSummary.fromJson(Map<String, dynamic> json) {
    final rawKinds = json['by_kind'];
    final byKind = <CashMovementKind, CashResetKindTotals>{};
    if (rawKinds is Map) {
      for (final kind in CashMovementKind.values) {
        final totals = rawKinds[kind.wire];
        if (totals is Map) {
          byKind[kind] = CashResetKindTotals(
            count: (totals['count'] as num?)?.toInt() ?? 0,
            amount: (totals['amount'] as num?)?.toDouble() ?? 0,
          );
        }
      }
    }
    return CashResetSummary(
      businessName: (json['business_name'] as String?)?.trim() ?? '',
      dryRun: json['dry_run'] == true,
      deleted: json['deleted'] == true,
      transactions: (json['transactions'] as num?)?.toInt() ?? 0,
      journalEntries: (json['journal_entries'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      byKind: byKind,
    );
  }
}

class CashResetException implements Exception {
  const CashResetException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Client for the connector's Cash Book reset (`data-connector/src/api/cash_reset.rs`).
///
/// The business is never sent: the connector takes it from this device's
/// token, so a device can only ever clear its own business.
class CashMovementResetClient {
  CashMovementResetClient({
    required Future<String> Function() baseUrl,
    http.Client? httpClient,
    Duration timeout = defaultTimeout,
  }) : _baseUrl = baseUrl,
       _http = httpClient,
       _timeout = timeout;

  final Future<String> Function() _baseUrl;
  final http.Client? _http;

  final Duration _timeout;

  /// The connector first pulls old movements back from the mesh (up to ~30s
  /// per step), so allow more than a normal request.
  static const Duration defaultTimeout = Duration(seconds: 120);

  /// Counts what [reset] would delete. Deletes nothing.
  Future<CashResetSummary> preview(Set<CashMovementKind> kinds) =>
      _post(kinds, dryRun: true);

  /// Deletes every movement of [kinds]. [confirm] must equal
  /// [CashResetSummary.businessName] from the preview.
  Future<CashResetSummary> reset(
    Set<CashMovementKind> kinds, {
    required String confirm,
  }) => _post(kinds, dryRun: false, confirm: confirm);

  Future<CashResetSummary> _post(
    Set<CashMovementKind> kinds, {
    required bool dryRun,
    String? confirm,
  }) async {
    if (kinds.isEmpty) {
      throw const CashResetException('Pick Cash In, Cash Out or both.');
    }
    final base = await _baseUrl();
    final normalized = base.endsWith('/') ? base : '$base/';
    final client = DataConnectorClient(baseUrl: normalized, inner: _http);
    final http.Response response;
    try {
      response = await client
          .post(
            Uri.parse('${normalized}api/cash-movements/reset'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'kinds': [for (final k in kinds) k.wire],
              'dry_run': dryRun,
              if (confirm != null) 'confirm': confirm.trim(),
            }),
          )
          .timeout(_timeout);
    } on TimeoutException {
      // A timeout only stops this client waiting; the connector may still
      // finish a real reset (and use up its single-use grant).
      throw CashResetException(
        dryRun
            ? 'The server took too long to answer. Try again; nothing was deleted.'
            : 'The server took too long to answer. The reset may still have '
                  'completed; check the Cash Book before trying again.',
      );
    } finally {
      // Closes only what the wrapper opened; an injected client stays open.
      client.close();
    }

    final body = decodeJsonObject(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = body?['error'];
      throw CashResetException(
        error is String && error.isNotEmpty
            ? error
            : 'Request failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    if (body == null) {
      throw const CashResetException('Unexpected response from the server.');
    }
    return CashResetSummary.fromJson(body);
  }
}
