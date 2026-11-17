import 'dart:convert';

import 'package:flipper_accounting/payroll_journal_poster.dart';
import 'package:flipper_hr/features/pay/data/pay_models.dart';
import 'package:flipper_hr/features/pay/data/supabase_pay_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('fetchForLedger', () {
    test(
      'reads by creation time, with no display window or status filter',
      () async {
        final requests = <Uri>[];
        final client = SupabaseClient(
          'https://example.supabase.co',
          'anon-key',
          httpClient: MockClient((req) async {
            requests.add(req.url);
            final table = req.url.pathSegments.last;
            final rows = switch (table) {
              // Given long before the write-off, so outside the Pay page's
              // 400-day window once it is no longer open.
              'hr_advances' => [
                {
                  'id': 'adv-1',
                  'employee_id': 'e-1',
                  'amount': 10000,
                  'given_on': '2026-11-20',
                  'method': 'cash',
                  'recovered': 0,
                  'status': 'written_off',
                  'written_off_at': '2028-01-01T08:00:00Z',
                  'created_at': '2026-11-20T08:00:00Z',
                },
              ],
              _ => <Map<String, dynamic>>[],
            };
            return http.Response(
              jsonEncode(rows),
              200,
              headers: {'content-type': 'application/json'},
              request: req,
            );
          }),
        );
        addTearDown(client.dispose);

        final book = await SupabasePayRepository(client).fetchForLedger(
          branchId: 'branch-1',
          createdSince: payrollLedgerStart,
        );

        expect(requests.map((u) => u.pathSegments.last).toSet(), {
          'hr_payslips',
          'hr_payments',
          'hr_advances',
        });
        for (final u in requests) {
          expect(u.queryParameters['branch_id'], 'eq.branch-1');
          expect(
            u.queryParameters['created_at'],
            'gte.2026-11-16T22:00:00.000Z',
          );
          // No date window and no "open only" filter.
          for (final p in [
            'period_end',
            'paid_on',
            'given_on',
            'or',
            'status',
          ]) {
            expect(u.queryParameters.containsKey(p), isFalse, reason: p);
          }
        }
        expect(book.advances.single.status, AdvanceStatus.writtenOff);
        expect(book.requests, isEmpty);
      },
    );
  });
}
