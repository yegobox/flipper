import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/setup.dart';

class TestTicketsListWidget extends ConsumerStatefulWidget {
  const TestTicketsListWidget({super.key});

  @override
  ConsumerState<TestTicketsListWidget> createState() => _TestTicketsListWidgetState();
}

class _TestTicketsListWidgetState extends ConsumerState<TestTicketsListWidget> with TicketsListMixin {
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

    when(() => env.mockDbSync.updateTransaction(
      transaction: any(named: 'transaction'),
      status: any(named: 'status'),
      updatedAt: any(named: 'updatedAt'),
    )).thenAnswer((_) async => true);

    when(() => env.mockDbSync.deleteTransaction(
      transaction: any(named: 'transaction'),
    )).thenAnswer((_) async => true);
  });

  Widget buildTestWidget() {
    return ProviderScope(
      child: MaterialApp(
        home: const TestTicketsListWidget(),
      ),
    );
  }

  group('TicketsListMixin Tests', () {
    testWidgets('renders no tickets state when empty', (tester) async {
      when(() => env.mockDbSync.transactionsStream(
        status: any(named: 'status'),
        removeAdjustmentTransactions: any(named: 'removeAdjustmentTransactions'),
        forceRealData: any(named: 'forceRealData'),
        skipOriginalTransactionCheck: any(named: 'skipOriginalTransactionCheck'),
      )).thenAnswer((_) => Stream.value(<ITransaction>[]));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.text('No open tickets'), findsOneWidget);
    });

    testWidgets('renders ticket cards when data available', (tester) async {
      final mockTickets = [
        ITransaction(
          id: 'ticket1',
          branchId: 1,
          status: PARKED,
          transactionType: 'sale',
          paymentType: 'cash',
          cashReceived: 1500.0,
          customerChangeDue: 0.0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          subTotal: 1500.0,
          createdAt: DateTime.now(),
          isLoan: false,
        ),
      ];

      when(() => env.mockDbSync.transactionsStream(
        status: any(named: 'status'),
        removeAdjustmentTransactions: any(named: 'removeAdjustmentTransactions'),
        forceRealData: any(named: 'forceRealData'),
        skipOriginalTransactionCheck: any(named: 'skipOriginalTransactionCheck'),
      )).thenAnswer((invocation) {
        final status = invocation.namedArguments[#status] as String;
        final filteredTickets = mockTickets.where((t) => t.status == status).toList();
        return Stream.value(filteredTickets);
      });

      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(TicketCard), findsOneWidget);
      expect(find.textContaining('Ticket #'), findsOneWidget);
    });

    testWidgets('TicketCard shows correct information', (tester) async {
      final ticket = ITransaction(
        id: 'test123',
        branchId: 1,
        status: PARKED,
        transactionType: 'sale',
        paymentType: 'cash',
        cashReceived: 1500.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now(),
        isIncome: true,
        isExpense: false,
        subTotal: 1500.0,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TicketCard(
              ticket: ticket,
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('Ticket #TEST12'), findsOneWidget);
      expect(find.textContaining('Total:'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
}