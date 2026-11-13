import 'dart:convert';

import 'package:flipper_models/data_connector_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// How close a business that is not registered for VAT is to RRA's
/// registration threshold.
enum VatThreshold { none, near, crossed }

/// What `GET /api/accounting/vat-position` returns (data-connector
/// `api::vat_position`).
///
/// A business is **registered** when it has an EBM branch with VAT on, or
/// when Books' "Registered for VAT" setting is on. Only a registered business
/// books VAT. One that is not owes none; the figures below are then an
/// estimate that never enters the ledger.
class BooksVatPosition {
  const BooksVatPosition({
    required this.registered,
    required this.hasEbmBranch,
    required this.settingRegistered,
    this.vatOwed = 0,
    this.monthEstimatedOutputVat = 0,
    this.monthPurchaseVat = 0,
    this.turnover12m = 0,
    this.turnoverQuarter = 0,
    this.threshold = VatThreshold.none,
    this.annualThreshold = 20000000,
    this.quarterThreshold = 5000000,
    this.hasEstimate = false,
  });

  factory BooksVatPosition.fromJson(Map<String, dynamic> json) {
    final p = json['position'];
    final pos = p is Map<String, dynamic> ? p : const <String, dynamic>{};
    int n(Object? v) => (v as num?)?.round() ?? 0;
    return BooksVatPosition(
      registered: json['registered'] == true,
      hasEbmBranch: json['hasEbmBranch'] == true,
      settingRegistered: json['settingRegistered'] == true,
      vatOwed: n(pos['vatOwed']),
      monthEstimatedOutputVat: n(pos['monthEstimatedOutputVat']),
      monthPurchaseVat: n(pos['monthPurchaseVat']),
      turnover12m: n(pos['turnover12m']),
      turnoverQuarter: n(pos['turnoverQuarter']),
      threshold: switch (pos['threshold']) {
        'near' => VatThreshold.near,
        'crossed' => VatThreshold.crossed,
        _ => VatThreshold.none,
      },
      annualThreshold: (json['annualThreshold'] as num?)?.round() ?? 20000000,
      quarterThreshold: (json['quarterThreshold'] as num?)?.round() ?? 5000000,
      hasEstimate: p is Map<String, dynamic>,
    );
  }

  final bool registered;
  final bool hasEbmBranch;
  final bool settingRegistered;

  /// Registered: net 2100 in the ledger (positive = owed to RRA).
  final int vatOwed;

  /// Not registered: estimate for the current month.
  final int monthEstimatedOutputVat;
  final int monthPurchaseVat;

  /// Not registered: turnover against the thresholds.
  final int turnover12m;
  final int turnoverQuarter;
  final VatThreshold threshold;
  final int annualThreshold;
  final int quarterThreshold;

  /// False when the server could not compute the figures (only the
  /// registered status is known).
  final bool hasEstimate;

  /// The purchase / bill VAT is part of what the stock cost: the business
  /// cannot reclaim it.
  bool get vatIsCost => !registered;
}

/// Reads [BooksVatPosition] from the data-connector.
class VatPositionService {
  VatPositionService({http.Client? client, String? baseUrl})
    : _baseUrl = baseUrl ?? _defaultBaseUrl,
      _client =
          client ?? DataConnectorClient(baseUrl: baseUrl ?? _defaultBaseUrl);

  static String get _defaultBaseUrl => kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';

  final String _baseUrl;
  final http.Client _client;

  /// `null` when the position cannot be read (signed out, an older server,
  /// a failure): callers then keep today's behaviour.
  Future<BooksVatPosition?> position() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/accounting/vat-position'),
    );
    if (response.statusCode != 200) return null;
    return BooksVatPosition.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
