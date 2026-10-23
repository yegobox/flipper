import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/services/ditto_mixins/accounting_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records upserts instead of writing to Ditto.
class _RecordingStore extends DittoCore with AccountingMixin {
  _RecordingStore({this.ready = true});

  final bool ready;
  final upserts = <(String, String, Map<String, dynamic>)>[];

  @override
  bool isReady() => ready;

  @override
  Future<void> executeUpsert(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    upserts.add((collection, docId, data));
  }
}

const _cash = Account(
  code: '1010',
  name: 'Cash',
  type: AccountType.asset,
  sub: 'Current assets',
  normal: AccountNormal.debit,
  bal: 0,
);

/// The client seed must write the same `coa_<biz>_<code>` document the
/// data-connector seeds, or every account ends up in the chart twice.
void main() {
  test('seeds a chart account under the data-connector coa_ id', () async {
    final store = _RecordingStore();

    await store.upsertChartOfAccount('biz', _cash, openingBalance: 250);

    final (collection, docId, data) = store.upserts.single;
    expect(collection, 'chart_of_accounts');
    expect(docId, 'coa_biz_1010');
    expect(data['id'], 'coa_biz_1010');
    expect(data['code'], '1010');
    expect(data['businessId'], 'biz');
    expect(data['openingBalance'], 250);
  });

  test('an explicit id still wins', () async {
    final store = _RecordingStore();

    await store.upsertChartOfAccount('biz', _cash, id: 'custom-id');

    expect(store.upserts.single.$2, 'custom-id');
  });

  test('writes nothing before Ditto is ready', () async {
    final store = _RecordingStore(ready: false);

    await store.upsertChartOfAccount('biz', _cash);

    expect(store.upserts, isEmpty);
  });
}
