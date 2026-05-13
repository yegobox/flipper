import 'package:flipper_dashboard/features/personal_goals/personal_goals_data_source.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_screen.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

class FakePersonalGoalsDataSource implements PersonalGoalsDataSource {
  FakePersonalGoalsDataSource(this._goals);

  final List<PersonalGoal> _goals;

  @override
  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
  }) async {}

  @override
  Future<void> deletePersonalGoal({
    required String id,
    required String branchId,
  }) async {}

  @override
  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId}) {
    return Stream.value(List<PersonalGoal>.unmodifiable(_goals));
  }

  @override
  Future<void> upsertPersonalGoal(PersonalGoal goal) async {}
}

void main() {
  setUp(() async {
    await getIt.reset();
    final mockBox = MockBox();
    when(() => mockBox.getBranchId()).thenReturn('branch-test');
    getIt.registerSingleton<LocalStorage>(mockBox);
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('formatRwfCompact formats millions and thousands', () {
    expect(formatRwfCompact(2.9e6), contains('M'));
    expect(formatRwfCompact(480000), contains('K'));
    expect(formatRwfCompact(400), 'RWF 400');
  });

  testWidgets('PersonalGoalsScreen shows goals from data source', (
    WidgetTester tester,
  ) async {
    final goals = [
      PersonalGoal(
        id: 'g1',
        branchId: 'branch-test',
        name: 'Emergency Fund',
        savedAmount: 1.8e6,
        targetAmount: 3e6,
        isTopPriority: true,
      ),
      PersonalGoal(
        id: 'g2',
        branchId: 'branch-test',
        name: 'Tax Reserve',
        savedAmount: 8e5,
        targetAmount: 1e6,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          personalGoalsDataSourceProvider.overrideWithValue(
            FakePersonalGoalsDataSource(goals),
          ),
        ],
        child: const MaterialApp(home: PersonalGoalsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();

    expect(find.text('Emergency Fund'), findsWidgets);
    expect(find.text('Tax Reserve'), findsOneWidget);
    expect(find.text('All goals'), findsOneWidget);
  });
}
