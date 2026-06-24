import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/models/personal_goal.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';

/// Abstraction for personal goals persistence. Override in tests with a fake.
abstract class PersonalGoalsDataSource {
  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId});

  Future<void> upsertPersonalGoal(PersonalGoal goal);

  Future<void> deletePersonalGoal({required String id, required String branchId});

  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
  });
}

/// Default: always uses Capella + Ditto for goals (mobile often keeps
/// [ProxyService.strategy] on CoreSync; goals live only on Capella).
class StrategyPersonalGoalsDataSource implements PersonalGoalsDataSource {
  DatabaseSyncInterface get _goalsBackend =>
      ProxyService.strategyLink.getStrategy(Strategy.capella);

  @override
  Future<void> addToGoalSavedAmount({
    required String goalId,
    required String branchId,
    required double amount,
    String? transactionId,
  }) {
    return _goalsBackend.addToGoalSavedAmount(
      goalId: goalId,
      branchId: branchId,
      amount: amount,
      transactionId: transactionId,
    );
  }

  @override
  Future<void> deletePersonalGoal({
    required String id,
    required String branchId,
  }) {
    return _goalsBackend.deletePersonalGoal(
      id: id,
      branchId: branchId,
    );
  }

  @override
  Stream<List<PersonalGoal>> personalGoalsStream({required String branchId}) {
    return _goalsBackend.personalGoalsStream(branchId: branchId);
  }

  @override
  Future<void> upsertPersonalGoal(PersonalGoal goal) {
    return _goalsBackend.upsertPersonalGoal(goal);
  }
}
