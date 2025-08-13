import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/setup.dart';
// flutter test test/features/tickets/widgets/tickets_list_test.dart
class TestTicketsListWidget extends ConsumerStatefulWidget {
  const TestTicketsListWidget({super.key});

  @override
  ConsumerState<TestTicketsListWidget> createState() =>
      _TestTicketsListWidgetState();
}

class _TestTicketsListWidgetState extends ConsumerState<TestTicketsListWidget>
    with TicketsListMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTicketSection(context),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(DateTime.now());
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

  Widget buildTestWidget() {
    return ProviderScope(
      child: MaterialApp(
        home: const TestTicketsListWidget(),
      ),
    );
  }

  group('TicketsListMixin Tests', () {

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
              isSelected: false,
              onSelectionChanged: (selected) {},
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
