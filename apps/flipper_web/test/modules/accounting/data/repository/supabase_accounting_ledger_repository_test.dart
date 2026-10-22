import 'dart:convert';

import 'package:flipper_web/modules/accounting/data/accounting_balances.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/repository/supabase_accounting_ledger_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../helpers/accounting_unit_test_overrides.dart';

/// One PostgREST call the repository made.
class _Call {
  _Call(this.request)
    : table = request.url.pathSegments.skip(2).join('/'),
      body = request.body.isEmpty ? null : jsonDecode(request.body);

  final http.Request request;

  /// Table (or `rpc/<fn>`) under `/rest/v1/`.
  final String table;
  final Object? body;

  String get method => request.method;
  String? param(String key) => request.url.queryParameters[key];
}

typedef _Handler = Object? Function(_Call call);

/// Serves PostgREST over a [MockClient]: canned JSON per `METHOD table`,
/// every call recorded. Unhandled reads answer `[]`, unhandled writes 204.
class _FakePostgrest {
  final calls = <_Call>[];
  final _handlers = <String, _Handler>{};

  void on(String method, String table, _Handler handler) =>
      _handlers['$method $table'] = handler;

  List<_Call> callsTo(String method, String table) =>
      calls.where((c) => c.method == method && c.table == table).toList();

  late final http.Client client = MockClient((request) async {
    final call = _Call(request);
    calls.add(call);
    final handler = _handlers['${call.method} ${call.table}'];
    if (handler == null) {
      return call.method == 'GET'
          ? _json(request, const [])
          : http.Response('', 204, request: request);
    }
    final result = handler(call);
    if (result is http.Response) return result;
    return _json(request, result);
  });

  static http.Response _json(http.Request request, Object? body) =>
      http.Response(
        jsonEncode(body),
        200,
        request: request,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
}

/// Realtime never connects in tests: a channel accepts the subscription and
/// stays silent, so every stream is just its initial PostgREST read.
class _SilentRealtime extends Fake implements RealtimeClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #channel) return _SilentChannel();
    if (invocation.memberName == #setAuth ||
        invocation.memberName == #disconnect ||
        invocation.memberName == #removeAllChannels) {
      return Future<void>.value();
    }
    return super.noSuchMethod(invocation);
  }
}

class _SilentChannel extends Fake implements RealtimeChannel {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #onPostgresChanges ||
        invocation.memberName == #subscribe) {
      return this;
    }
    if (invocation.memberName == #unsubscribe) return Future.value('ok');
    return super.noSuchMethod(invocation);
  }
}

/// A real [SupabaseClient] (real PostgREST query building and parsing) whose
/// HTTP goes to [_FakePostgrest] and whose realtime is [_SilentRealtime].
class _TestSupabaseClient extends SupabaseClient {
  _TestSupabaseClient(http.Client httpClient)
    : super(
        'https://ledger.test',
        'test-key',
        httpClient: httpClient,
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      );

  final _realtime = _SilentRealtime();

  @override
  RealtimeClient get realtime => _realtime;
}

Map<String, dynamic> _entryRow(
  String id,
  String? date, {
  String status = 'posted',
}) => {
  'id': id,
  'business_id': 'biz',
  'entry_number': 'JE-$id',
  'entry_date': date,
  'memo': 'memo $id',
  'reference': 'ref $id',
  'status': status,
  'source': 'POS',
};

Map<String, dynamic> _lineRow(
  String entryId,
  String ac, {
  int dr = 0,
  int cr = 0,
}) => {
  'journal_entry_id': entryId,
  'account_code': ac,
  'debit': dr,
  'credit': cr,
};

/// `in.(a,b,c)` → `[a, b, c]`.
List<String> _inIds(String? filter) {
  final inner = filter!.substring('in.('.length, filter.length - 1);
  return inner.split(',').map((s) => s.replaceAll('"', '')).toList();
}

void main() {
  late _FakePostgrest server;
  late _TestSupabaseClient client;
  late SupabaseAccountingLedgerRepository repo;

  setUp(() {
    server = _FakePostgrest();
    client = _TestSupabaseClient(server.client);
    repo = SupabaseAccountingLedgerRepository(client);
  });

  tearDown(() => client.dispose());

  group('chart of accounts', () {
    test('seeding calls the seed RPC for the business', () async {
      await repo.ensureSeeded(businessId: 'biz');

      final call = server.callsTo('POST', 'rpc/seed_default_chart_of_accounts');
      expect(call.single.body, {'p_business_id': 'biz'});
    });

    test('a new account is inserted with Postgres columns only', () async {
      await repo.createChartOfAccount(
        businessId: 'biz',
        account: const Account(
          code: '1040',
          name: 'Petty cash',
          type: AccountType.asset,
          sub: 'Current',
          normal: AccountNormal.debit,
          bal: 0,
        ),
      );

      final lookup = server.callsTo('GET', 'chart_of_accounts').single;
      expect(lookup.param('business_id'), 'eq.biz');
      expect(lookup.param('code'), 'eq.1040');
      final row =
          server.callsTo('POST', 'chart_of_accounts').single.body!
              as Map<String, dynamic>;
      expect(row['business_id'], 'biz');
      expect(row['account_type'], 'asset');
      expect(row.containsKey('businessId'), isFalse);
      expect(row.containsKey('accountType'), isTrue);
    });

    test('an existing account code is refused, nothing inserted', () async {
      server.on(
        'GET',
        'chart_of_accounts',
        (_) => [
          {'id': 'coa-1'},
        ],
      );

      await expectLater(
        repo.createChartOfAccount(
          businessId: 'biz',
          account: const Account(
            code: '1010',
            name: 'Cash',
            type: AccountType.asset,
            sub: 'Current',
            normal: AccountNormal.debit,
            bal: 0,
          ),
        ),
        throwsA(isA<StateError>()),
      );
      expect(server.callsTo('POST', 'chart_of_accounts'), isEmpty);
    });

    test(
      'the chart streams active accounts by code with their opening balance',
      () async {
        server.on(
          'GET',
          'chart_of_accounts',
          (_) => [
            {
              'code': '4010',
              'name': 'Sales',
              'account_type': 'income',
              'normal': 'credit',
              'opening_balance': null,
            },
            {
              'code': '1010',
              'name': 'Cash',
              'account_type': 'asset',
              'normal': 'debit',
              'opening_balance': '2500',
            },
            {
              'code': '1020',
              'name': 'Bank',
              'account_type': 'asset',
              'normal': 'debit',
              'opening_balance': 1200.4,
            },
            {
              'code': '1000',
              'name': 'Retired',
              'account_type': 'asset',
              'normal': 'debit',
              'is_active': false,
            },
          ],
        );

        final accounts = await repo
            .watchChartOfAccounts(businessId: 'biz')
            .first;

        expect(accounts.map((a) => a.code), ['1010', '1020', '4010']);
        expect(accounts.map((a) => a.bal), [2500, 1200, 0]);
        expect(
          server
              .callsTo('GET', 'chart_of_accounts')
              .single
              .param('business_id'),
          'eq.biz',
        );
      },
    );
  });

  group('journal entries', () {
    void serveLines(List<Map<String, dynamic>> lines) {
      server.on('GET', 'journal_lines', (call) {
        final ids = _inIds(call.param('journal_entry_id')).toSet();
        return [
          for (final l in lines)
            if (ids.contains(l['journal_entry_id'])) l,
        ];
      });
    }

    test('entries in the range come newest first with their lines', () async {
      server.on(
        'GET',
        'journal_entries',
        (_) => [
          _entryRow('a', '2026-09-30'),
          _entryRow('b', '2026-10-01'),
          // The last day counts in full, whatever its time.
          _entryRow('c', '2026-10-31T18:30:00'),
          _entryRow('d', '2026-11-01'),
          _entryRow('e', '2026-10-15'),
          // No date: passes every range.
          _entryRow('f', null),
        ],
      );
      serveLines([
        _lineRow('b', '1010', dr: 500),
        _lineRow('b', '4010', cr: 500),
        _lineRow('e', '6000', dr: 90),
        _lineRow('e', '1010', cr: 90),
      ]);

      final entries = await repo
          .watchJournalEntries(
            businessId: 'biz',
            startDate: DateTime(2026, 10, 1),
            endDate: DateTime(2026, 10, 31),
          )
          .first;

      expect(entries.map((e) => e.uuid), ['c', 'e', 'b', 'f']);
      expect(entries.map((e) => e.id), ['JE-c', 'JE-e', 'JE-b', 'JE-f']);
      final b = entries.firstWhere((e) => e.uuid == 'b');
      expect(b.lines.map((l) => (l.ac, l.dr, l.cr)), [
        ('1010', 500, 0),
        ('4010', 0, 500),
      ]);
      expect(entries.firstWhere((e) => e.uuid == 'c').lines, isEmpty);
      expect(
        server.callsTo('GET', 'journal_entries').single.param('business_id'),
        'eq.biz',
      );
    });

    test('no entries in range skips the lines request', () async {
      server.on(
        'GET',
        'journal_entries',
        (_) => [_entryRow('old', '2025-01-01')],
      );

      final entries = await repo
          .watchJournalEntries(
            businessId: 'biz',
            startDate: DateTime(2026, 10, 1),
          )
          .first;

      expect(entries, isEmpty);
      expect(server.callsTo('GET', 'journal_lines'), isEmpty);
    });

    test(
      'an open start (opening balances) fetches lines in batches of 150',
      () async {
        final rows = [
          for (var i = 0; i < 320; i++)
            _entryRow(
              'e$i',
              DateTime(2026, 1, 1).add(Duration(hours: i)).toIso8601String(),
            ),
        ];
        server.on('GET', 'journal_entries', (_) => rows);
        serveLines([
          _lineRow('e0', '1010', dr: 100),
          _lineRow('e0', '3010', cr: 100),
          _lineRow('e319', '1010', dr: 7),
          _lineRow('e319', '4010', cr: 7),
        ]);

        final entries = await repo
            .watchJournalEntries(
              businessId: 'biz',
              endDate: DateTime(2026, 12, 31),
            )
            .first;

        expect(entries, hasLength(320));
        expect(entries.first.uuid, 'e319');
        expect(entries.first.lines, hasLength(2));
        expect(entries.last.uuid, 'e0');
        expect(entries.last.lines.first.dr, 100);

        final batches = server
            .callsTo('GET', 'journal_lines')
            .map((c) => _inIds(c.param('journal_entry_id')))
            .toList();
        expect(batches.map((b) => b.length), [150, 150, 20]);
        expect(batches.expand((b) => b).toSet(), hasLength(320));
      },
    );

    test('the transaction lookup returns the entry id or null', () async {
      server.on('GET', 'journal_entries', (call) {
        return call.param('transaction_id') == 'eq.txn-1'
            ? [
                {'id': 'je-1'},
              ]
            : const [];
      });

      expect(
        await repo.findEntryIdByTransactionId(
          businessId: 'biz',
          transactionId: 'txn-1',
        ),
        'je-1',
      );
      expect(
        await repo.findEntryIdByTransactionId(
          businessId: 'biz',
          transactionId: 'txn-2',
        ),
        isNull,
      );
    });

    test('entryExists is false for a missing or non-UUID id', () async {
      server.on('GET', 'journal_entries', (call) {
        final id = call.param('id');
        if (id == 'eq.je-1') {
          return [
            {'id': 'je-1'},
          ];
        }
        if (id == 'eq.je_biz_txn_sale') {
          return http.Response(
            jsonEncode({
              'code': '22P02',
              'message': 'invalid input syntax for type uuid',
            }),
            400,
            request: call.request,
          );
        }
        return const [];
      });

      expect(await repo.entryExists(businessId: 'biz', entryId: 'je-1'), true);
      expect(await repo.entryExists(businessId: 'biz', entryId: 'je-2'), false);
      expect(
        await repo.entryExists(businessId: 'biz', entryId: 'je_biz_txn_sale'),
        false,
      );
    });

    const entry = JournalEntry(
      id: 'JE-0042',
      date: '2026-10-05',
      memo: 'Owner cash in',
      ref: 'CI-1',
      status: JournalStatus.pending,
      src: 'Cash Book',
      lines: [
        JournalLine(ac: '1010', dr: 100000),
        JournalLine(ac: '3010', cr: 100000),
      ],
    );

    test(
      'a new entry links its journal and writes lines under the new id',
      () async {
        server.on(
          'GET',
          'accounting_journals',
          (_) => [
            {'id': 'jnl-gen'},
          ],
        );
        server.on('POST', 'journal_entries', (_) => {'id': 'je-new'});

        final id = await repo.createJournalEntry(
          businessId: 'biz',
          entry: entry,
          transactionId: 'txn-9',
          journalCode: 'GEN',
        );

        expect(id, 'je-new');
        final journal = server.callsTo('GET', 'accounting_journals').single;
        expect(journal.param('code'), 'eq.GEN');
        final header =
            server.callsTo('POST', 'journal_entries').single.body!
                as Map<String, dynamic>;
        expect(header['journal_id'], 'jnl-gen');
        expect(header['transaction_id'], 'txn-9');
        expect(header['entry_number'], 'JE-0042');
        expect(header['status'], 'pending');
        expect(header['entry_date'], startsWith('2026-10-05'));
        expect(header.keys.where((k) => k.contains(RegExp('[A-Z]'))), isEmpty);
        final lines =
            server.callsTo('POST', 'journal_lines').single.body!
                as List<dynamic>;
        expect(lines, [
          {
            'journal_entry_id': 'je-new',
            'account_code': '1010',
            'debit': 100000,
            'credit': 0,
          },
          {
            'journal_entry_id': 'je-new',
            'account_code': '3010',
            'debit': 0,
            'credit': 100000,
          },
        ]);
      },
    );

    test('an entry without journal or lines writes the header only', () async {
      server.on('POST', 'journal_entries', (_) => {'id': 'je-empty'});

      final id = await repo.createJournalEntry(
        businessId: 'biz',
        entry: const JournalEntry(
          id: 'JE-1',
          date: '2026-10-05',
          memo: '',
          ref: '',
          status: JournalStatus.draft,
          src: 'Manual',
          lines: [],
        ),
      );

      expect(id, 'je-empty');
      expect(server.callsTo('GET', 'accounting_journals'), isEmpty);
      final header =
          server.callsTo('POST', 'journal_entries').single.body!
              as Map<String, dynamic>;
      expect(header.containsKey('journal_id'), isFalse);
      expect(server.callsTo('POST', 'journal_lines'), isEmpty);
    });

    test(
      'a keyed entry upserts one row, so a retry rewrites it, not a second',
      () async {
        const key = 'je_bankrec_bal_1020_1760000000000';
        final rowId = journalEntryRowId(businessId: 'biz', entryId: key);
        expect(Uuid.isValidUUID(fromString: rowId), isTrue);
        // Scoped to the business: the same SMS key elsewhere is another row.
        expect(
          journalEntryRowId(businessId: 'other', entryId: key),
          isNot(rowId),
        );

        // The first attempt, then a retry after it failed half way.
        for (var attempt = 0; attempt < 2; attempt++) {
          final id = await repo.createJournalEntry(
            businessId: 'biz',
            entry: entry,
            entryId: key,
          );
          expect(id, rowId);
        }

        final headers = server.callsTo('POST', 'journal_entries');
        expect(headers, hasLength(2));
        for (final h in headers) {
          expect((h.body! as Map)['id'], rowId);
          expect(h.request.headers['Prefer'], contains('merge-duplicates'));
        }
        final deletes = server.callsTo('DELETE', 'journal_lines');
        expect(deletes.map((d) => d.param('journal_entry_id')), [
          'eq.$rowId',
          'eq.$rowId',
        ]);
        final lines = server.callsTo('POST', 'journal_lines').last.body!;
        expect((lines as List).map((l) => (l as Map)['journal_entry_id']), [
          rowId,
          rowId,
        ]);
      },
    );

    test('a key that is already a UUID is the row id as is', () {
      const uuid = '3f2504e0-4f89-41d3-9a0c-0305e82c3301';
      expect(journalEntryRowId(businessId: 'biz', entryId: uuid), uuid);
    });

    test('an update rewrites the header and replaces every line', () async {
      await repo.updateJournalEntry(
        businessId: 'biz',
        entryId: 'je-7',
        entry: entry,
      );

      final patch = server.callsTo('PATCH', 'journal_entries').single;
      expect(patch.param('id'), 'eq.je-7');
      expect(patch.param('business_id'), 'eq.biz');
      expect((patch.body! as Map)['memo'], 'Owner cash in');
      final delete = server.callsTo('DELETE', 'journal_lines').single;
      expect(delete.param('journal_entry_id'), 'eq.je-7');
      final lines =
          server.callsTo('POST', 'journal_lines').single.body! as List<dynamic>;
      expect(lines.map((l) => (l as Map)['journal_entry_id']), [
        'je-7',
        'je-7',
      ]);
      // Delete before insert, or the new lines would be wiped.
      expect(
        server.calls.indexOf(delete),
        lessThan(
          server.calls.indexWhere(
            (c) => c.table == 'journal_lines' && c.method == 'POST',
          ),
        ),
      );
    });

    test('an update to an entry with no lines inserts none', () async {
      await repo.updateJournalEntry(
        businessId: 'biz',
        entryId: 'je-7',
        entry: const JournalEntry(
          id: 'JE-7',
          date: '',
          memo: '',
          ref: '',
          status: JournalStatus.draft,
          src: 'Manual',
          lines: [],
        ),
      );

      expect(server.callsTo('DELETE', 'journal_lines'), hasLength(1));
      expect(server.callsTo('POST', 'journal_lines'), isEmpty);
    });

    test('posting reports whether a row changed', () async {
      server.on(
        'PATCH',
        'journal_entries',
        (call) => call.param('id') == 'eq.je-1'
            ? [
                {'id': 'je-1'},
              ]
            : const [],
      );

      expect(
        await repo.postJournalEntry(businessId: 'biz', entryId: 'je-1'),
        isTrue,
      );
      expect(
        await repo.postJournalEntry(
          businessId: 'biz',
          entryId: 'je-2',
          onlyIfPending: true,
        ),
        isFalse,
      );

      final patches = server.callsTo('PATCH', 'journal_entries');
      expect(patches.first.body, {'status': 'posted'});
      expect(patches.first.param('status'), isNull);
      expect(patches.last.param('status'), 'eq.pending');
    });
  });

  group('bank lines and settings', () {
    test(
      'bank lines stream for one account, unlabelled ones as 1020',
      () async {
        server.on(
          'GET',
          'bank_statement_lines',
          (_) => [
            {
              'id': 'b1',
              'line_date': '2026-10-02',
              'description': 'MTN deposit',
              'amount': 5000,
              'bank_account_code': '1030',
            },
            {
              'id': 'b2',
              'line_date': '2026-10-03',
              'description': 'Cheque',
              'amount': -1200,
              'matched_journal_entry_id': 'je-1',
              'matched_entry_number': 'JE-1',
            },
          ],
        );

        final bank = await repo.watchBankLines(businessId: 'biz').first;
        expect(bank.map((l) => (l.id, l.amt, l.matched, l.je)), [
          ('b2', -1200, true, 'JE-1'),
        ]);

        final momo = await repo
            .watchBankLines(businessId: 'biz', bankAccountCode: '1030')
            .first;
        expect(momo.single.desc, 'MTN deposit');
        expect(momo.single.matched, isFalse);
      },
    );

    const line = BankLine(
      date: '2026-10-02',
      desc: 'Deposit',
      amt: 5000,
      matched: false,
    );

    test('a bank line with an id upserts, without one inserts', () async {
      await repo.upsertBankLine(
        businessId: 'biz',
        line: line,
        id: 'b1',
        bankAccountCode: '1030',
        matchedJournalEntryId: 'je-1',
        matchedEntryNumber: 'JE-1',
      );
      await repo.upsertBankLine(businessId: 'biz', line: line);

      final posts = server.callsTo('POST', 'bank_statement_lines');
      expect(posts, hasLength(2));
      final upsert = posts.first;
      expect(upsert.request.headers['Prefer'], contains('merge-duplicates'));
      expect(upsert.body, {
        'id': 'b1',
        'business_id': 'biz',
        'bank_account_code': '1030',
        'line_date': '2026-10-02T00:00:00.000',
        'description': 'Deposit',
        'amount': 5000,
        'matched_journal_entry_id': 'je-1',
        'matched_entry_number': 'JE-1',
      });
      final insert = posts.last;
      expect(
        insert.request.headers['Prefer'] ?? '',
        isNot(contains('merge-duplicates')),
      );
      expect((insert.body! as Map)['bank_account_code'], '1020');
      expect((insert.body! as Map).containsKey('id'), isFalse);
    });

    test('clearing removes one account\'s statement lines', () async {
      await repo.clearBankStatementLines(
        businessId: 'biz',
        bankAccountCode: '1030',
      );

      final delete = server.callsTo('DELETE', 'bank_statement_lines').single;
      expect(delete.param('business_id'), 'eq.biz');
      expect(delete.param('bank_account_code'), 'eq.1030');
    });

    test('settings are the business row, or null when none', () async {
      server.on(
        'GET',
        'accounting_settings',
        (call) => call.param('business_id') == 'eq.biz'
            ? [
                {'business_id': 'biz', 'default_vat_rate': 0.18},
              ]
            : const [],
      );

      expect(await repo.fetchSettings(businessId: 'biz'), {
        'business_id': 'biz',
        'default_vat_rate': 0.18,
      });
      expect(await repo.fetchSettings(businessId: 'other'), isNull);
    });
  });

  group('inventory value', () {
    test('sums supply price times stock, skipping unlinked rows', () async {
      server.on(
        'GET',
        'stocks',
        (_) => [
          {'variant_id': 'v1', 'current_stock': 3},
          {'variant_id': 'v2', 'current_stock': '2'},
          {'variant_id': null, 'current_stock': 99},
          {'variant_id': 'gone', 'current_stock': 5},
        ],
      );
      server.on('GET', 'variants', (call) {
        return switch (call.param('id')) {
          'eq.v1' => [
            {'supply_price': 1000},
          ],
          'eq.v2' => [
            {'supply_price': 250.6},
          ],
          _ => const [],
        };
      });

      expect(await repo.fetchInventoryValue(branchId: '42'), 3000 + 251 * 2);
      expect(
        server.callsTo('GET', 'stocks').single.param('branch_id'),
        'eq.42',
      );
      expect(server.callsTo('GET', 'variants'), hasLength(3));
    });

    test('a failed read values the stock at zero', () async {
      expect(await repo.fetchInventoryValue(branchId: 'not-a-number'), 0);
      expect(server.calls, isEmpty);
    });
  });

  test(
    'Books reads money held per account through the Supabase ledger',
    () async {
      // September: owner puts 100,000 in, a 20,000 cash sale, 30,000 to bank.
      // October (the selected period): 15,000 rent from cash, a Cash In of
      // 5,000 to mobile money.
      server.on(
        'GET',
        'journal_entries',
        (_) => [
          _entryRow('cap', '2026-09-03'),
          _entryRow('sale', '2026-09-20'),
          _entryRow('dep', '2026-09-25'),
          _entryRow('rent', '2026-10-05'),
          _entryRow('momo', '2026-10-09'),
          // Pending entries never move a balance.
          _entryRow('draft', '2026-09-10', status: 'pending'),
          // After the period: in neither list.
          _entryRow('nov', '2026-11-02'),
        ],
      );
      server.on('GET', 'journal_lines', (call) {
        final ids = _inIds(call.param('journal_entry_id')).toSet();
        return [
          for (final l in [
            _lineRow('cap', '1010', dr: 100000),
            _lineRow('cap', '3010', cr: 100000),
            _lineRow('sale', '1010', dr: 20000),
            _lineRow('sale', '4010', cr: 20000),
            _lineRow('dep', '1020', dr: 30000),
            _lineRow('dep', '1010', cr: 30000),
            _lineRow('rent', '6000', dr: 15000),
            _lineRow('rent', '1010', cr: 15000),
            _lineRow('momo', '1030', dr: 5000),
            _lineRow('momo', '3010', cr: 5000),
            _lineRow('draft', '1010', dr: 999),
            _lineRow('draft', '4010', cr: 999),
            _lineRow('nov', '1010', dr: 1),
            _lineRow('nov', '4010', cr: 1),
          ])
            if (ids.contains(l['journal_entry_id'])) l,
        ];
      });

      final container = ProviderContainer(
        overrides: [
          ...accountingUnitTestOverrides(),
          accountingLedgerRepositoryProvider.overrideWithValue(repo),
          accountingBusinessIdProvider.overrideWithValue('biz'),
          accountingDateRangeProvider.overrideWith(
            (ref) => (DateTime(2026, 10, 1), DateTime(2026, 10, 31)),
          ),
          chartOfAccountsStreamProvider.overrideWith(
            (ref) => Stream.value(defaultChartOfAccountsSeed),
          ),
        ],
      );
      addTearDown(container.dispose);
      for (final p in [
        chartOfAccountsStreamProvider,
        journalEntriesStreamProvider,
        journalEntriesThroughPeriodEndProvider,
      ]) {
        container.listen(p, (_, _) {});
        await container.read(p.future);
      }

      expect(container.read(accountingOpeningBalancesProvider), {
        '1010': 90000,
        '1020': 30000,
        '3010': 100000,
        retainedEarningsCode: 20000,
      });
      expect(container.read(accountingLiquidBalancesProvider), [
        (code: '1010', bal: 75000),
        (code: '1030', bal: 5000),
        (code: '1020', bal: 30000),
      ]);
      expect(container.read(accountingCashBankTotalProvider), 110000);
      // October's P&L is the rent only: September's sale is carried in
      // Retained Earnings, and the Cash In is equity, not revenue.
      final pl = container.read(accountingIncomeStatementProvider);
      expect(pl.netIncome, -15000);
    },
  );
}
