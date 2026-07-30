import 'package:flipper_dashboard/features/transaction_reports/transaction_report_density.dart';
import 'package:flipper_dashboard/providers/transaction_report_business_cashiers_provider.dart';
import 'package:flipper_dashboard/providers/transaction_report_chart_provider.dart';
import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/helperModels/transaction_report_kpi_totals.dart';
import 'package:flipper_models/helperModels/transaction_report_snapshot.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/supabase_models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'test_helpers/mocks.dart';

/// Transaction Reports must give the grid a usable number of rows on small
/// Windows laptops, not only on large Macs. See [ReportMetrics].
ITransaction _tx({required String id, required int receiptNumber}) {
  final now = DateTime(2026, 4, 25, 12);
  return ITransaction(
    id: id,
    agentId: 'alice@example.com',
    branchId: 'b1',
    status: 'COMPLETE',
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 20,
    customerChangeDue: 0,
    updatedAt: now,
    createdAt: now,
    isIncome: true,
    isExpense: false,
    receiptNumber: receiptNumber,
    subTotal: 20,
    receiptType: 'NS',
  );
}

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

void main() {
  group('TransactionList density', () {
    late MockBox box;

    setUpAll(() {
      box = TestBox();
      if (!getIt.isRegistered<LocalStorage>()) {
        getIt.registerSingleton<LocalStorage>(box);
      }
    });

    tearDownAll(() {
      if (getIt.isRegistered<LocalStorage>()) {
        getIt.unregister<LocalStorage>();
      }
    });

    final range = DateRangeModel(
      startDate: DateTime(2026, 4, 25),
      endDate: DateTime(2026, 4, 25, 23, 59, 59),
    );

    final txs = List.generate(
      12,
      (i) => _tx(id: 't$i', receiptNumber: 4300 + i),
    );

    final snap = TransactionReportSnapshot(
      transactions: txs,
      paymentSumsByTransactionId: {
        for (final t in txs)
          t.id.toString(): const TransactionPaymentSums(
            byHand: 20,
            credit: 0,
            hasAnyRecord: true,
          ),
      },
      totalRowCount: txs.length,
    );

    Future<void> pumpReport(WidgetTester tester, Size bodySize) async {
      await tester.binding.setSurfaceSize(bodySize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

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
            transactionItemListProvider.overrideWith(
              (ref) => Stream.value(const <TransactionItem>[]),
            ),
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
    }

    /// Rows the grid viewport can show without scrolling.
    double visibleRows(WidgetTester tester) {
      final grid = tester.widget<SfDataGrid>(find.byType(SfDataGrid));
      final height = tester.getSize(find.byType(SfDataGrid)).height;
      return (height - grid.headerRowHeight) / grid.rowHeight;
    }

    testWidgets('short window (1366x640 body) keeps ~8+ rows visible', (
      tester,
    ) async {
      await pumpReport(tester, const Size(1366, 640));

      final grid = tester.widget<SfDataGrid>(find.byType(SfDataGrid));
      expect(grid.rowHeight, ReportMetrics.compact.gridRowHeight);
      expect(visibleRows(tester), greaterThanOrEqualTo(8));

      // Footer already carries a pager in summary mode — no duplicate strip.
      expect(find.byType(SfDataPager), findsNothing);
      expect(find.textContaining('Page 1 of'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tall window (1512x945 body) keeps legacy sizing', (
      tester,
    ) async {
      await pumpReport(tester, const Size(1512, 945));

      final grid = tester.widget<SfDataGrid>(find.byType(SfDataGrid));
      expect(grid.rowHeight, ReportMetrics.comfortable.gridRowHeight);
      expect(
        grid.headerRowHeight,
        ReportMetrics.comfortable.gridHeaderRowHeight,
      );
      expect(find.byType(SfDataPager), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
