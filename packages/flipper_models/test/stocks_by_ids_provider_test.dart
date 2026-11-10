import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

Variant _v(String? stockId) =>
    Variant(name: 'v', branchId: '1', stockId: stockId);

/// The ordering grid and the Items dialog read every row's stock from one
/// observer keyed by [stockIdsKey], instead of one observer per row.
void main() {
  test('the key is the rows\' stock ids, sorted and without repeats', () {
    expect(
      stockIdsKey([_v('b'), _v(' a '), _v('b'), _v(null), _v('')]),
      'a,b',
    );
    expect(stockIdsKey([_v('a'), _v('b')]), stockIdsKey([_v('b'), _v('a')]));
  });

  test('rows without stock open no observer', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(stocksByIdsProvider(''), (_, _) {});
    addTearDown(sub.close);
    final stocks = await container.read(stocksByIdsProvider('').future);
    expect(stocks, isEmpty);
  });
}
