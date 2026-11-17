import 'dart:convert';
import 'dart:math' as math;

import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/pay_repository.dart';
import 'package:flipper_hr/features/pay/data/supabase_pay_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Map<String, dynamic> _payslip(int i) => {
  'id': 'slip-${i.toString().padLeft(5, '0')}',
  'employee_id': 'e-1',
  'period_start': '2026-11-01',
  'period_end': '2026-11-30',
  'gross': 1000,
  'net_pay': 1000,
  'status': 'paid',
  'created_at': '2026-11-20T08:00:00Z',
};

/// Given long before it was written off, so outside the Pay page's 400-day
/// window once it is no longer open.
Map<String, dynamic> _advance(int i) => {
  'id': 'adv-${i.toString().padLeft(5, '0')}',
  'employee_id': 'e-1',
  'amount': 10000,
  'given_on': '2026-11-20',
  'method': 'cash',
  'recovered': 0,
  'status': 'written_off',
  'written_off_at': '2028-01-01T08:00:00Z',
  'created_at': '2026-11-20T08:00:00Z',
};

/// A PostgREST stand-in: serves each table's rows by `offset` and `limit`,
/// returning at most [maxRows] per response like the server's max-rows.
class _FakePostgrest {
  _FakePostgrest(this.tables, {this.maxRows = 1000});

  final Map<String, List<Map<String, dynamic>>> tables;
  final int maxRows;
  final List<Uri> requests = [];

  SupabaseClient client() => SupabaseClient(
    'https://example.supabase.co',
    'anon-key',
    httpClient: MockClient((req) async {
      requests.add(req.url);
      final rows = tables[req.url.pathSegments.last] ?? const [];
      final offset = int.parse(req.url.queryParameters['offset'] ?? '0');
      final limit = int.parse(req.url.queryParameters['limit'] ?? '$maxRows');
      final start = math.min<int>(offset, rows.length);
      final end = math.min<int>(
        start + math.min<int>(limit, maxRows),
        rows.length,
      );
      return http.Response(
        jsonEncode(rows.sublist(start, end)),
        200,
        headers: {'content-type': 'application/json'},
        request: req,
      );
    }),
  );

  /// The offsets asked of [table], in order.
  List<int> offsets(String table) => [
    for (final u in requests)
      if (u.pathSegments.last == table) int.parse(u.queryParameters['offset']!),
  ];
}

Future<PayBook> _read(_FakePostgrest server) async {
  final client = server.client();
  addTearDown(client.dispose);
  return SupabasePayRepository(
    client,
  ).fetchForLedger(branchId: 'branch-1', createdSince: payrollLedgerStart);
}

void main() {
  group('fetchForLedger', () {
    test('reads by creation time, a stable page at a time, until all rows '
        'are in', () async {
      final server = _FakePostgrest({
        // Exactly one full page.
        'hr_payslips': [for (var i = 0; i < 500; i++) _payslip(i)],
        // More than two full pages.
        'hr_advances': [for (var i = 0; i < 1203; i++) _advance(i)],
      });
      final book = await _read(server);

      expect(book.payslips, hasLength(500));
      expect(book.payments, isEmpty);
      expect(book.advances, hasLength(1203));
      expect(book.advances.map((a) => a.id).toSet(), hasLength(1203));
      expect(book.advances.last.status, AdvanceStatus.writtenOff);
      expect(book.requests, isEmpty);

      expect(server.offsets('hr_payslips'), [0, 500]);
      expect(server.offsets('hr_payments'), [0]);
      expect(server.offsets('hr_advances'), [0, 500, 1000, 1203]);
      for (final u in server.requests) {
        final q = u.queryParameters;
        expect(q['branch_id'], 'eq.branch-1');
        expect(q['created_at'], 'gte.2026-11-16T22:00:00.000Z');
        expect(q['order'], 'created_at.asc.nullslast,id.asc.nullslast');
        expect(q['limit'], '${SupabasePayRepository.ledgerPageSize}');
        // No date window and no "open only" filter.
        for (final p in ['period_end', 'paid_on', 'given_on', 'or', 'status']) {
          expect(q.containsKey(p), isFalse, reason: p);
        }
      }
    });

    test('a server cap below the page size shortens pages but drops no '
        'rows', () async {
      final server = _FakePostgrest({
        'hr_advances': [for (var i = 0; i < 450; i++) _advance(i)],
      }, maxRows: 200);
      final book = await _read(server);

      expect(book.advances, hasLength(450));
      expect(server.offsets('hr_advances'), [0, 200, 400, 450]);
    });
  });
}
