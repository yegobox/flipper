import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers/setup.dart';

// flutter test test/features/tickets/widgets/error_state_test.dart --dart-define=FLUTTER_TEST_ENV=true
class TestErrorStateWidget extends ConsumerStatefulWidget {
  const TestErrorStateWidget({super.key});

  @override
  ConsumerState<TestErrorStateWidget> createState() =>
      _TestErrorStateWidgetState();
}

class _TestErrorStateWidgetState extends ConsumerState<TestErrorStateWidget>
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

  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
  });

  group('TicketsListMixin State Tests', () {
    testWidgets('displays loading state initially', (tester) async {
      when(() => env.mockDbSync.transactionsStream(
                status: any(named: 'status'),
                removeAdjustmentTransactions:
                    any(named: 'removeAdjustmentTransactions'),
                forceRealData: any(named: 'forceRealData'),
                skipOriginalTransactionCheck:
                    any(named: 'skipOriginalTransactionCheck'),
              ))
          .thenAnswer((_) => Stream.fromFuture(
              Future.delayed(const Duration(milliseconds: 100), () => [])));

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const TestErrorStateWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading tickets...'), findsOneWidget);
    });

    testWidgets('shows empty state when no data', (tester) async {
      when(() => env.mockDbSync.transactionsStream(
            status: any(named: 'status'),
            removeAdjustmentTransactions:
                any(named: 'removeAdjustmentTransactions'),
            forceRealData: any(named: 'forceRealData'),
            skipOriginalTransactionCheck:
                any(named: 'skipOriginalTransactionCheck'),
          )).thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const TestErrorStateWidget(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 4));

      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.text('No open tickets'), findsOneWidget);
      expect(find.text('Create a new ticket to get started'), findsOneWidget);
    });

    // testWidgets('shows empty state when error is handled', (tester) async {
    //   when(() => env.mockDbSync.transactionsStream(
    //     status: any(named: 'status'),
    //     removeAdjustmentTransactions: any(named: 'removeAdjustmentTransactions'),
    //     forceRealData: any(named: 'forceRealData'),
    //     skipOriginalTransactionCheck: any(named: 'skipOriginalTransactionCheck'),
    //   )).thenAnswer((_) => Stream.error('Database timeout'));

    //   await tester.pumpWidget(
    //     ProviderScope(
    //       child: MaterialApp(
    //         home: const TestErrorStateWidget(),
    //       ),
    //     ),
    //   );

    //   await tester.pump(const Duration(seconds: 4));

    //   // Error is handled and returns empty list, so shows no tickets state
    //   expect(find.text('No open tickets'), findsOneWidget);
    // });
  });
}
