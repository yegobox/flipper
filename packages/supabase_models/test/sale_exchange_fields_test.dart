import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/brick.g.dart';
import 'package:supabase_models/brick/db/schema.g.dart' as db;
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/sale_exchange_fields_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true

/// Answers the association lookups the generated `fromSqlite` makes (an
/// exchange leg has no Brick-side items or payments here).
class _Sqlite extends Fake implements SqliteProvider<SqliteModel> {
  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async =>
      const [];
}

void main() {
  final provider = _Sqlite();

  group('Setting.enableSaleExchange', () {
    test('round-trips through JSON', () {
      final setting = Setting(enableSaleExchange: true);
      final json = setting.toJson();
      expect(json['enableSaleExchange'], isTrue);
      expect(Setting.fromJson(json).enableSaleExchange, isTrue);
      expect(Setting.fromJson({'id': 's1'}).enableSaleExchange, isNull);
    });

    test('keeps both spellings of allowSellingBelowStock', () {
      expect(
        Setting.fromJson({'allowSellingBelowStock': true})
            .allowSellingBelowStock,
        isTrue,
      );
      expect(
        Setting.fromJson({'allow_selling_below_stock': true})
            .allowSellingBelowStock,
        isTrue,
      );
      expect(
        Setting.fromJson({'enableTicketReviewWorkflow': true})
            .enableTicketReviewWorkflow,
        isTrue,
      );
    });

    for (final value in [true, false, null]) {
      test('round-trips $value through SQLite', () async {
        final adapter = SettingAdapter();
        final row = await adapter.toSqlite(
          Setting(id: 's1', enableSaleExchange: value),
          provider: provider,
        );
        expect(
            row['enable_sale_exchange'],
            switch (value) {
              true => 1,
              false => 0,
              null => null,
            });
        final back = await adapter.fromSqlite(
          {...row, '_brick_id': 1},
          provider: provider,
        );
        expect(back.enableSaleExchange, value);
        expect(
          adapter.fieldsToSqliteColumns['enableSaleExchange']?.columnName,
          'enable_sale_exchange',
        );
      });
    }
  });

  group('ITransaction.exchangeId', () {
    ITransaction leg({String? exchangeId}) => ITransaction(
          id: 't1',
          branchId: 'b1',
          status: 'completed',
          transactionType: 'Sale',
          paymentType: 'CASH',
          subTotal: 100,
          cashReceived: 100,
          customerChangeDue: 0,
          updatedAt: DateTime.utc(2026, 10, 18),
          isIncome: true,
          isExpense: false,
          agentId: 'a1',
          exchangeId: exchangeId,
        );

    test('copyWith keeps or replaces it', () {
      final t = leg(exchangeId: 'x1')
        ..agentCommissionType = 'percent'
        ..agentCommissionValue = 5;
      final copy = t.copyWith();
      expect(copy.exchangeId, 'x1');
      expect(copy.agentCommissionType, 'percent');
      expect(copy.agentCommissionValue, 5);
      expect(t.copyWith(exchangeId: 'x2').exchangeId, 'x2');
    });

    for (final id in ['x1', null]) {
      test('round-trips $id through SQLite', () async {
        final adapter = ITransactionAdapter();
        final row = await adapter.toSqlite(
          leg(exchangeId: id),
          provider: provider,
        );
        expect(row['exchange_id'], id);
        final back = await adapter.fromSqlite(
          {...row, '_brick_id': 1},
          provider: provider,
        );
        expect(back.exchangeId, id);
        expect(
          adapter.fieldsToSqliteColumns['exchangeId']?.columnName,
          'exchange_id',
        );
      });
    }
  });

  // flipper_dashboard keeps unfinished exchanges under this key; a key missing
  // from the LocalStorage allowlist silently drops every write, and the
  // exchange could not be finished after a restart.
  test('saleExchangeIntents is a writable LocalStorage key', () async {
    final box = SharedPreferenceStorage();
    await box.initializePreferences();
    await box.clear();
    addTearDown(() async {
      await box.clear();
      box.dispose();
    });
    await box.writeString(key: 'saleExchangeIntents', value: '{"x1":{}}');
    expect(
      box.readString(key: 'saleExchangeIntents'),
      '{"x1":{}}',
      reason: 'saleExchangeIntents is missing from the LocalStorage allowlist',
    );
  });

  // attachDittoPersistence merges the background-flushed Ditto copy into
  // the local file; a removed intent must not come back from it.
  group('saleExchangeIntents stays with the local file', () {
    Map<String, dynamic> prefs(Map<String, dynamic> extra) => {
          '_preferencesVersion': 1,
          'dbVersion': 1,
          ...extra,
        };

    test('a removed intent is not merged back from Ditto', () {
      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: prefs({'autoPrint': true}),
        dittoMap: prefs({'saleExchangeIntents': '{"x1":{}}'}),
      );
      expect(merged.containsKey('saleExchangeIntents'), isFalse);
      expect(merged['autoPrint'], isTrue);
    });

    test('the local intents win over an older Ditto copy', () {
      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: prefs({'saleExchangeIntents': '{"x2":{}}'}),
        dittoMap: prefs({'saleExchangeIntents': '{"x1":{}}'}),
      );
      expect(merged['saleExchangeIntents'], '{"x2":{}}');
    });
  });

  test('the schema has both exchange columns', () {
    final settings = db.schema.tables.singleWhere((t) => t.name == 'Setting');
    final transactions =
        db.schema.tables.singleWhere((t) => t.name == 'ITransaction');
    expect(
      settings.columns.map((c) => c.name),
      contains('enable_sale_exchange'),
    );
    expect(
      transactions.columns.map((c) => c.name),
      contains('exchange_id'),
    );
    expect(
      db.migrations.map((m) => m.version),
      containsAll([20260922100014, 20261018173810]),
    );
  });
}
