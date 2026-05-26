import 'package:flipper_dashboard/providers/transaction_report_business_cashiers_provider.dart';
import 'package:flipper_dashboard/providers/transaction_report_chart_provider.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/supabase_models.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'test_helpers/mocks.dart';

ITransaction _tx({
  required String id,
  required String agentId,
  required int receiptNumber,
  required double subTotal,
  required double cashReceived,
  String status = 'COMPLETE',
  String receiptType = 'NS',
}) {
  final now = DateTime(2026, 4, 25, 12);
  return ITransaction(
    id: id,
    agentId: agentId,
    branchId: 'b1',
    status: status,
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: cashReceived,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: true,
    isExpense: false,
    receiptNumber: receiptNumber,
    subTotal: subTotal,
    receiptType: receiptType,
  );
}

// Deterministic LocalStorage for widget tests.
class TestBox extends MockBox {
  @override
  bool vatEnabled() => false;

  @override
  bool? enableDebug() => false;

  @override
  bool exportAsPdf() => false;

  @override
  String? getBranchId() => 'b1';

  @override
  String defaultCurrency() => 'RWF';

  @override
  String? getBusinessId() => 'test-business-id';
}

DateRangeModel _fixtureReportDateRange() => DateRangeModel(
  startDate: DateTime(2026, 4, 25),
  endDate: DateTime(2026, 4, 25, 23, 59, 59),
);

TransactionReportSnapshot _snapWithTotals(List<ITransaction> txs) {
  final sums = txs.length >= 2
      ? <String, TransactionPaymentSums>{
          txs[0].id.toString(): const TransactionPaymentSums(
            byHand: 20,
            credit: 0,
            hasAnyRecord: true,
          ),
          txs[1].id.toString(): const TransactionPaymentSums(
            byHand: 0,
            credit: 150,
            hasAnyRecord: true,
          ),
        }
      : <String, TransactionPaymentSums>{
          txs[0].id.toString(): const TransactionPaymentSums(
            byHand: 20,
            credit: 0,
            hasAnyRecord: true,
          ),
        };

  return TransactionReportSnapshot(
    transactions: txs,
    paymentSumsByTransactionId: sums,
    totalRowCount: txs.length,
  );
}

void main() {
  late MockBox box;

  setUpAll(() {
    box = TestBox();

    if (!getIt.isRegistered<LocalStorage>()) {
      getIt.registerSingleton<LocalStorage>(box);
    }
  });

  tearDownAll(() async {
    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
  });

  testWidgets('Graph icon toggles chart view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 900));
    final txs = [
      _tx(
        id: 't1',
        agentId: 'alice@example.com',
        receiptNumber: 4312,
        subTotal: 20,
        cashReceived: 20,
      ),
      _tx(
        id: 't2',
        agentId: 'bob@example.com',
        receiptNumber: 4313,
        subTotal: 150,
        cashReceived: 150,
      ),
    ];

    final snap = _snapWithTotals(txs);

    final range = _fixtureReportDateRange();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dateRangeProvider.overrideWithValue(range),
          expensesStreamProvider(
            startDate: range.startDate!,
            endDate: range.endDate!,
            branchId: 'b1',
            forceRealData: true,
          ).overrideWith((ref) => Stream.value([])),
          transactionReportSnapshotProvider(
            forceRealData: true,
          ).overrideWith((ref) async => snap),
          transactionReportSnapshotProvider(
            forceRealData: false,
          ).overrideWith((ref) async => snap),
          transactionReportChartSnapshotProvider(
            true,
          ).overrideWith((ref) => Future.value(snap)),
          transactionReportChartSnapshotProvider(
            false,
          ).overrideWith((ref) => Future.value(snap)),
          transactionItemListProvider.overrideWith((ref) async => []),
          transactionReportKpiTotalsProvider.overrideWith(
            (ref) async => const TransactionReportKpiTotals(),
          ),
          transactionReportBusinessCashiersProvider.overrideWith(
            (ref) async => const [],
          ),
        ],
        child: MaterialApp(home: Scaffold(body: TransactionList())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('SALES BY CASHIER'), findsNothing);

    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('SALES BY CASHIER'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.table_rows_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('SALES BY CASHIER'), findsNothing);
  });

  test(
    'transactionReportPageIndex resets to zero when notifier.reset runs',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(transactionReportPageIndexProvider.notifier).setPage(5);
      expect(container.read(transactionReportPageIndexProvider), 5);
      container.read(transactionReportPageIndexProvider.notifier).reset();
      expect(container.read(transactionReportPageIndexProvider), 0);
    },
  );
}
