import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/setup.dart';

class TestSortingWidget extends ConsumerStatefulWidget {
  const TestSortingWidget({super.key});

  @override
  ConsumerState<TestSortingWidget> createState() => _TestSortingWidgetState();
}

class _TestSortingWidgetState extends ConsumerState<TestSortingWidget> with TicketsListMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTicketSection(context),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
    
    registerFallbackValue(ITransaction(
      branchId: 1,
      status: 'test',
      transactionType: 'test',
      paymentType: 'test',
      cashReceived: 0.0,
      customerChangeDue: 0.0,
      updatedAt: DateTime.now(),
      isIncome: true,
      isExpense: false,
    ));
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
  });

  group('Ticket Sorting Tests', () {
    testWidgets('separates loan and regular tickets', (tester) async {
      final tickets = [
        ITransaction(
          id: 'regular1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 1000.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          isLoan: false,
        ),
        ITransaction(
          id: 'loan1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 2000.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          isLoan: true,
        ),
      ];

      when(() => env.mockDbSync.transactionsStream(
        status: any(named: 'status'),
        removeAdjustmentTransactions: any(named: 'removeAdjustmentTransactions'),
        forceRealData: any(named: 'forceRealData'),
        skipOriginalTransactionCheck: any(named: 'skipOriginalTransactionCheck'),
      )).thenAnswer((invocation) {
        final status = invocation.namedArguments[#status] as String;
        final filteredTickets = tickets.where((t) => t.status == status).toList();
        return Stream.value(filteredTickets);
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const TestSortingWidget(),
          ),
        ),
      );
      
      await tester.pump(const Duration(seconds: 4));

      expect(find.text('Loan Tickets'), findsOneWidget);
      expect(find.text('Regular Tickets'), findsOneWidget);
      expect(find.byType(TicketCard), findsNWidgets(2));
    });

    testWidgets('shows only loan section when no regular tickets', (tester) async {
      final tickets = [
        ITransaction(
          id: 'loan1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 2000.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          isLoan: true,
        ),
      ];

      when(() => env.mockDbSync.transactionsStream(
        status: any(named: 'status'),
        removeAdjustmentTransactions: any(named: 'removeAdjustmentTransactions'),
        forceRealData: any(named: 'forceRealData'),
        skipOriginalTransactionCheck: any(named: 'skipOriginalTransactionCheck'),
      )).thenAnswer((invocation) {
        final status = invocation.namedArguments[#status] as String;
        final filteredTickets = tickets.where((t) => t.status == status).toList();
        return Stream.value(filteredTickets);
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const TestSortingWidget(),
          ),
        ),
      );
      
      await tester.pump(const Duration(seconds: 4));

      expect(find.text('Loan Tickets'), findsOneWidget);
      expect(find.text('Regular Tickets'), findsNothing);
      expect(find.byType(TicketCard), findsOneWidget);
    });
  });
}