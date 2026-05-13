import 'package:flipper_dashboard/features/personal_goals/personal_goals_data_source.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Override in tests with a fake implementation.
final personalGoalsDataSourceProvider = Provider<PersonalGoalsDataSource>(
  (ref) => StrategyPersonalGoalsDataSource(),
);

final personalGoalsStreamProvider =
    StreamProvider.autoDispose.family<List<PersonalGoal>, String>(
  (ref, branchId) {
    return ref
        .watch(personalGoalsDataSourceProvider)
        .personalGoalsStream(branchId: branchId);
  },
);

class PersonalGoalCashInIntent {
  const PersonalGoalCashInIntent({
    required this.goalId,
    required this.goalName,
  });

  final String goalId;
  final String goalName;
}

class PersonalGoalCashInIntentNotifier extends Notifier<PersonalGoalCashInIntent?> {
  @override
  PersonalGoalCashInIntent? build() => null;

  void setIntent(PersonalGoalCashInIntent intent) => state = intent;

  void clear() => state = null;
}

final personalGoalCashInIntentProvider =
    NotifierProvider<PersonalGoalCashInIntentNotifier, PersonalGoalCashInIntent?>(
  PersonalGoalCashInIntentNotifier.new,
);
