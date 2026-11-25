import 'package:flipper_dashboard/cashbook.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockBox extends Mock implements LocalStorage {}

/// [Cashbook] with the real [CashbookState] lifecycle (initState,
/// didChangeDependencies, dispose) but no screen, so only dispose is tested.
class _BareCashbook extends Cashbook {
  const _BareCashbook() : super(isBigScreen: false);

  @override
  CashbookState createState() => _BareCashbookState();
}

class _BareCashbookState extends CashbookState {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  setUp(() async {
    await getIt.reset();
    final box = _MockBox();
    // No branch: initState's cash-variant prefetch stays off.
    when(() => box.getBranchId()).thenReturn(null);
    getIt.registerSingleton<LocalStorage>(box);
  });

  tearDown(() => getIt.reset());

  const intent = PersonalGoalCashInIntent(goalId: 'goal-1', goalName: 'Rent');

  testWidgets('leaving the Cash Book clears the personal-goal cash-in intent', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    Widget app(Widget home) => UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: home),
    );

    await tester.pumpWidget(app(const _BareCashbook()));
    container.read(personalGoalCashInIntentProvider.notifier).setIntent(intent);

    await tester.pumpWidget(app(const SizedBox()));

    expect(container.read(personalGoalCashInIntentProvider), isNull);
  });

  testWidgets('app teardown with the Cash Book open reports no error', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: _BareCashbook())),
    );

    // Unmounting the root ProviderScope disposes its container in the same
    // frame, before the deferred clear runs.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
