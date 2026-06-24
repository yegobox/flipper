import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// One transaction row parsed from a bank statement PDF.
class ParsedStatementLine {
  const ParsedStatementLine({
    this.date,
    this.description,
    this.debit,
    this.credit,
    this.balance,
  });

  factory ParsedStatementLine.fromJson(Map<String, dynamic> json) {
    return ParsedStatementLine(
      date: json['date'] as String?,
      description: json['description'] as String?,
      debit: (json['debit'] as num?)?.toDouble(),
      credit: (json['credit'] as num?)?.toDouble(),
      balance: (json['balance'] as num?)?.toDouble(),
    );
  }

  final String? date;
  final String? description;
  final double? debit;
  final double? credit;
  final double? balance;

  /// Signed amount: money in positive, money out negative.
  double get amount => (credit ?? 0) - (debit ?? 0);
}

/// Normalized bank statement returned by the data-connector parser.
class ParsedStatement {
  const ParsedStatement({
    this.bankName,
    this.accountNumber,
    this.currency,
    this.periodStart,
    this.periodEnd,
    this.openingBalance,
    this.closingBalance,
    this.lines = const [],
  });

  factory ParsedStatement.fromJson(Map<String, dynamic> json) {
    return ParsedStatement(
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      currency: json['currency'] as String?,
      periodStart: json['period_start'] as String?,
      periodEnd: json['period_end'] as String?,
      openingBalance: (json['opening_balance'] as num?)?.toDouble(),
      closingBalance: (json['closing_balance'] as num?)?.toDouble(),
      lines: ((json['lines'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ParsedStatementLine.fromJson)
          .toList(),
    );
  }

  final String? bankName;
  final String? accountNumber;
  final String? currency;
  final String? periodStart;
  final String? periodEnd;
  final double? openingBalance;
  final double? closingBalance;
  final List<ParsedStatementLine> lines;
}

class BankStatementParseException implements Exception {
  BankStatementParseException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Sends a bank statement PDF to the data-connector, which extracts the
/// transaction lines via the configured AI model.
///
/// Only the PDF is sent: the data-connector resolves the AI endpoint and key
/// server-side from the Supabase `ai_models` table (default active row, with
/// a Gemini-standard row as fallback for image-only statements), so no AI
/// credentials ever pass through the browser.
class BankStatementService {
  BankStatementService({http.Client? client})
      : _client = client ?? http.Client();

  static String get _baseUrl => kDebugMode
      ? 'http://localhost:8084'
      : 'https://data-connector.yegobox.com';

  final http.Client _client;

  Future<ParsedStatement> parse(Uint8List pdfBytes) async {
    final http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$_baseUrl/api/bank-statements/parse'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pdf_base64': base64Encode(pdfBytes)}),
      );
    } catch (e) {
      throw BankStatementParseException(
        'Could not reach the statement parser at $_baseUrl: $e',
      );
    }

    if (response.statusCode != 200) {
      String message = 'Statement parsing failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = (body['error'] as String?) ?? message;
      } catch (_) {}
      throw BankStatementParseException(message);
    }

    return ParsedStatement.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
