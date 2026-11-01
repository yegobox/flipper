import 'package:flipper_ai_feature/src/services/flo_sales_context.dart';
import 'package:flutter_test/flutter_test.dart';

String _render(Map<String, dynamic> sales, {String currency = 'RWF'}) {
  final b = StringBuffer();
  writeDeviceSalesContext(b, sales, currency);
  return b.toString();
}

void main() {
  test('a period with no sales says so instead of listing figures', () {
    final out = _render({'period_label': 'yesterday', 'transaction_count': 0});

    expect(out, contains('Sales for yesterday (from this device):'));
    expect(out, contains('- No sales recorded for yesterday.'));
    expect(out, isNot(contains('Revenue')));
    expect(out, isNot(contains('Transactions')));
  });

  test('a missing or blank period label reads "this period"', () {
    expect(_render({'period_label': '  '}), contains('Sales for this period'));
    expect(_render(const {}), contains('No sales recorded for this period'));
  });

  test('totals and every item line carry the currency', () {
    final out = _render({
      'period_label': 'today',
      'transaction_count': 3,
      'total_revenue': 7500,
      'units_sold': 9,
      'top_items': [
        {'name': 'Bread', 'qty': 5, 'revenue': 5000},
        'not a map',
        {'revenue': 2500},
      ],
    });

    expect(out, contains('- Revenue: RWF 7500'));
    expect(out, contains('- Units sold: 9'));
    expect(out, contains('- Transactions: 3'));
    expect(out, contains('Items sold today (name — quantity, revenue):'));
    expect(out, contains('- Bread — 5 units, RWF 5000'));
    expect(out, contains('- Unnamed item — ? units, RWF 2500'));
    expect(out, isNot(contains('not a map')));
  });

  test('without a currency, amounts are bare numbers', () {
    final out = _render({
      'transaction_count': 1,
      'total_revenue': 100,
      'top_items': [
        {'name': 'Tea', 'qty': 1},
      ],
    }, currency: '');

    expect(out, contains('- Revenue: 100'));
    expect(out, contains('- Tea — 1 units, '));
    expect(out, isNot(contains('Units sold')));
  });

  test('no item breakdown tells the model not to invent items', () {
    final out = _render({'transaction_count': 2, 'top_items': const []});

    expect(out, contains('- Transactions: 2'));
    expect(out, contains('No item-level breakdown is available'));
  });
}
