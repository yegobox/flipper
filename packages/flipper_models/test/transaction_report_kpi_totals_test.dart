import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Net Profit deducts expenses and adds Cash In', () {
    const kpi = TransactionReportKpiTotals(
      pluGrossProfit: 10000,
      pluLineTax: 1500,
      periodExpense: 2000,
      periodCashIn: 4000,
    );
    expect(kpi.netProfit, 10500);
  });

  test('an empty report has no Net Profit', () {
    expect(const TransactionReportKpiTotals().netProfit, 0);
  });
}
